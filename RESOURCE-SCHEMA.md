# Resource Database — Schema Design

> Deprecated: tài liệu này mô tả hướng resource database bằng Markdown. Thiết kế hiện tại đã chuyển sang JSON business database cho `members`, `projects`, `allocations`, `capacity`, và Markdown chỉ còn là AI/project knowledge database.
> Xem spec mới tại `dashboard/docs/delivery-ai-data-design.md`.

> Tài liệu này định nghĩa cấu trúc dữ liệu Markdown cho hệ thống quản lý resource.
> Parser sẽ đọc các file này và tổng hợp thành dữ liệu hiển thị trong Resource Center UI.

---

## 1. Entity–Relationship Model

```
┌─────────────────────┐       ┌──────────────────────────┐
│       MEMBER        │       │        ALLOCATION         │
│─────────────────────│       │──────────────────────────│
│ member_code  (PK)   │──┐    │ allocation_id  (PK)       │
│ name                │  │    │ member_code    (FK→Member)│
│ role                │  └───<│ project_code   (FK→Proj)  │
│ department          │       │ from_date                 │
│ weekly_capacity     │       │ to_date                   │
│ status              │       │ pct              0–100    │
│ skills[]            │       │ est_hours                 │
│ avatar_color        │       │ actual_hours?             │
│ initials            │       │ notes?                    │
└─────────────────────┘       └──────────────────────────┘
          │
          │  1:N                ┌──────────────────────────┐
          │                     │   CAPACITY_EXCEPTION      │
          └────────────────────>│──────────────────────────│
                                │ member_code? (null=org)  │
                                │ from_date                 │
                                │ to_date                   │
                                │ type  holiday|leave|other │
                                │ label                     │
                                │ impact_pct  0–100        │
                                └──────────────────────────┘

PROJECT entity đã quản lý ở input/[Domain]/[CODE]/project-tracking.md
```

### Computed (derived at parse time, không lưu trong file):

```
weekly_util(member, week) =
    Σ allocation.pct
      where allocation.member_code = member
        AND allocation.from ≤ week_start
        AND allocation.to   ≥ week_end
        AND no CapacityException covers this week (impact=100%)

available_hours(member, week) =
    member.weekly_capacity × (1 – exception_impact)
    – Σ allocated_hours_that_week

overloaded(member, week) = weekly_util > 100%
```

---

## 2. Directory Structure

```
input/
├── members/
│   ├── _template.md              ← template (bắt buộc copy khi tạo member mới)
│   ├── alice-nguyen.md
│   ├── emily-ho.md
│   └── ...
│
├── allocations/
│   ├── _template.md              ← template
│   ├── P001.md                   ← allocation cho project P001
│   ├── P002.md
│   └── ...
│
└── capacity/
    ├── calendar-2026.md          ← lịch tổ chức (holiday, break) — 1 file/năm
    ├── calendar-2027.md
    └── leaves/
        ├── _template.md          ← template
        ├── alice-nguyen-2026.md  ← nghỉ phép của Alice năm 2026
        └── ...
```

---

## 3. File Formats

### 3.1 Member Profile (`input/members/[member-id].md`)

**Mục đích:** Source of truth về thông tin cá nhân, năng lực, và vai trò của từng thành viên.

**Naming convention:** `[tên-viết-thường-nối-gạch].md`
Ví dụ: `alice-nguyen.md`, `emily-ho.md`, `henry-dao.md`

**Format:**

```
# Member: [Tên đầy đủ]

Member Code:      [member-id]          ← phải khớp với tên file (không có .md)
Role:             [Chức danh]
Department:       [Phòng ban]
Email:            [email@company.com]
Start Date:       YYYY-MM-DD
Status:           Active | Inactive | On Leave
Avatar Color:     violet | sky | pink | orange | teal | blue | rose | amber | emerald
Initials:         [2 ký tự in hoa]
Weekly Capacity:  40                   ← giờ/tuần (mặc định 40)

## Skills

- Skill 1
- Skill 2
- Skill 3

## Notes

[Ghi chú tự do: background, chuyên môn, ràng buộc đặc biệt, v.v.]
```

**Ràng buộc:**
- `Member Code` phải unique toàn hệ thống
- `Initials` đúng 2 ký tự viết hoa
- `Avatar Color` chỉ nhận các giá trị trong danh sách màu định nghĩa
- `Weekly Capacity` ∈ [1, 80], thường là 40

---

### 3.2 Allocation (`input/allocations/[PROJECT-CODE].md`)

**Mục đích:** Khai báo ai làm dự án nào, khoảng thời gian nào, chiếm bao nhiêu % capacity.
Mỗi project có **1 file allocation riêng**.

**Naming convention:** `[PROJECT-CODE].md` (CODE viết hoa, ví dụ `P001.md`, `HAYK.md`)

**Format:**

```
# Allocations — [PROJECT-CODE] [Tên dự án]

Project Code:   [PROJECT-CODE]
Project Name:   [Tên dự án]
Project Color:  violet | sky | pink | orange | teal | blue
Status:         Active | Pipeline | On Hold | Complete

## Allocation Table

| Member Code   | From       | To         | Pct | Est Hours | Actual Hours | Notes                |
|---------------|------------|------------|-----|-----------|--------------|----------------------|
| alice-nguyen  | 2026-01-05 | 2026-07-31 |  70 |       240 |          182 | PM lead              |
| emily-ho      | 2026-01-05 | 2026-04-30 |  40 |       160 |          120 | Frontend lead        |

← Để trống Actual Hours nếu chưa có → parser hiểu là NULL / chưa ghi nhận

## Budget

Total:        $280,000
EAC:          $295,000
Actual Fees:  $148,000

## Changelog

YYYY-MM-DD: [Lý do thay đổi allocation — ai thêm/bớt/điều chỉnh]
```

**Ràng buộc:**
- `Member Code` phải tồn tại trong `input/members/`
- `Pct` ∈ [1, 100] cho mỗi entry
- `From` ≤ `To`
- **Warning** khi tổng `Pct` của 1 member trong 1 tuần > 100% (cross-project overload)
- Một member có thể xuất hiện nhiều lần trong cùng 1 file nếu % thay đổi theo giai đoạn:

```
| emily-ho | 2026-01-05 | 2026-04-30 |  40 | 160 | 120 | Phase 1: E-Commerce focus  |
| emily-ho | 2026-05-01 | 2026-06-30 |  20 |  60 |     | Phase 2: chuyển sang P003  |
```

---

### 3.3 Capacity Calendar (`input/capacity/calendar-YYYY.md`)

**Mục đích:** Khai báo lịch tổ chức — ngày lễ, ngày nghỉ bù, sprint break — áp dụng cho toàn bộ team.
1 file per năm.

**Format:**

```
# Capacity Calendar — YYYY

Year:      YYYY
Timezone:  Asia/Ho_Chi_Minh
Country:   VN

## Holidays

| Date       | Name                          | Type     | Impact | Scope |
|------------|-------------------------------|----------|--------|-------|
| YYYY-01-01 | New Year's Day                | holiday  |    100 | all   |
| YYYY-01-28 | Tết Nguyên Đán (ngày 1)       | holiday  |    100 | VN    |
| YYYY-01-29 | Tết Nguyên Đán (ngày 2)       | holiday  |    100 | VN    |
| YYYY-01-30 | Tết Nguyên Đán (ngày 3)       | holiday  |    100 | VN    |
| YYYY-01-31 | Tết Nguyên Đán (ngày 4)       | holiday  |    100 | VN    |
| YYYY-04-30 | Giải phóng miền Nam           | holiday  |    100 | VN    |
| YYYY-05-01 | Quốc tế Lao động              | holiday  |    100 | all   |
| YYYY-09-02 | Quốc khánh                    | holiday  |    100 | VN    |
| YYYY-12-25 | Giáng sinh                    | holiday  |     50 | opt   |

← Impact = phần trăm capacity bị mất trong ngày đó (100 = nghỉ hoàn toàn)
← Scope: all = áp dụng tất cả, VN = chỉ VN team, opt = tùy chọn

## Sprint Breaks

| From       | To         | Label             | Impact |
|------------|------------|-------------------|--------|
| YYYY-12-26 | YYYY-12-31 | Year-end freeze   |    100 |

## Notes

- Tuần nào có ít nhất 1 ngày holiday impact=100 → tuần đó đánh dấu `unavail: true` trên timeline
- Tuần có holiday impact < 100 (partial) → capacity giảm tương ứng
- Scrum team có thể override sprint break bằng cách ghi rõ trong project-tracking
```

**Ràng buộc:**
- `Impact` ∈ [1, 100]
- Dates không overlap trong cùng scope
- `Scope` nhận: `all`, `VN`, `JP`, `US`, `opt`

---

### 3.4 Leave File (`input/capacity/leaves/[member-id]-YYYY.md`)

**Mục đích:** Khai báo nghỉ phép, nghỉ bệnh, nghỉ không lương của từng cá nhân.
Tách khỏi capacity calendar vì chỉ ảnh hưởng 1 người.

**Naming convention:** `[member-id]-YYYY.md`
Ví dụ: `alice-nguyen-2026.md`

**Format:**

```
# Leave Schedule — [Tên] — YYYY

Member Code:  [member-id]
Year:         YYYY

## Leave Records

| From       | To         | Type    | Days | Status   | Notes                |
|------------|------------|---------|------|----------|----------------------|
| YYYY-MM-DD | YYYY-MM-DD | annual  |    5 | approved | Family trip          |
| YYYY-MM-DD | YYYY-MM-DD | sick    |    1 | approved |                      |
| YYYY-MM-DD | YYYY-MM-DD | unpaid  |    3 | pending  | Personal matter      |
| YYYY-MM-DD | YYYY-MM-DD | wfh     |    0 | approved | WFH không tính nghỉ  |

← Type: annual | sick | unpaid | compensatory | wfh
← Status: approved | pending | rejected
← Days = 0 cho WFH (không trừ capacity, chỉ ghi nhận)

## Summary

Annual Allowance:  14
Annual Taken:       5
Annual Remaining:   9
Sick Taken:         1
Unpaid Taken:       0
```

**Ràng buộc:**
- `Member Code` phải tồn tại trong `input/members/`
- Dates không overlap
- `Status: pending` → parser phát cảnh báo nhưng vẫn tính vào capacity
- `Type: wfh` → không trừ capacity, chỉ ghi nhận

---

## 4. Parser Specification

### 4.1 Input Resolution Order

```
1. Đọc tất cả input/members/*.md              → Map<MemberCode, Member>
2. Đọc input/capacity/calendar-YYYY.md         → List<OrgException>
3. Đọc tất cả input/capacity/leaves/*.md       → Map<MemberCode, List<Leave>>
4. Đọc tất cả input/allocations/*.md           → Map<ProjectCode, List<Allocation>>
```

### 4.2 Weekly Utilization Computation

```
for each (member, week):
  exceptions = OrgExceptions.filter(overlaps(week))
               + Leaves[member].filter(overlaps(week), status != 'rejected', type != 'wfh')

  if any exception has impact == 100 AND covers full week:
    → unavail = true, util_pct = 0, util_hours = 0
    continue

  capacity_factor = 1 - Σ(exception.impact × exception_days_in_week / 5) / 100
  base_capacity   = member.weekly_capacity × capacity_factor

  active_allocs = Allocations.filter(
    member_code == member AND
    from <= week_start AND
    to   >= week_end
  )

  util_pct   = Σ(alloc.pct for alloc in active_allocs)
  util_hours = member.weekly_capacity × util_pct / 100

  overloaded = util_pct > 100
```

### 4.3 Allocation Bar Computation

```
for each (member_proj_pair):
  bars = merge_contiguous_segments(
    alloc_records.filter(member, project).sort_by(from)
  )
  → AllocBar { startW, endW, pct, label }
  where startW/endW = index trong WEEKS array
        label = "Xh" (hours per week)
```

### 4.4 Output Mapping → ResourceCenter UI

| Computed field              | → UI element                       |
|-----------------------------|------------------------------------|
| `util_pct` per week         | `UtilCell` số giờ + màu sắc        |
| `overloaded == true`        | `UtilCell` màu `text-destructive`  |
| `unavail == true`           | `UtilCell` nền `bg-muted/15`       |
| `AllocBar[]`                | Allocation bars trên timeline      |
| `Σ estH` of member's allocs | Left panel: Est. Hours column      |
| `Σ actualH`                 | Left panel: Actual column          |
| `Project.budget`            | Projects tab: Budget column        |
| `Project.eac`               | FinancialBar text                  |

---

## 5. Validation Rules

| Rule | Severity | Mô tả |
|------|----------|-------|
| MEMBER_CODE_DUPLICATE | ERROR | Hai file member có cùng Member Code |
| ALLOCATION_MEMBER_UNKNOWN | ERROR | allocation.member_code không tồn tại trong members/ |
| ALLOCATION_DATE_INVALID | ERROR | from > to trong allocation record |
| OVERALLOCATION | WARNING | Tổng pct của 1 member trong 1 tuần > 100% |
| ACTUAL_EXCEEDS_EST | WARNING | actual_hours > est_hours (budget overrun signal) |
| LEAVE_OVERLAP | ERROR | Hai leave record của cùng member overlap dates |
| LEAVE_NO_MEMBER | ERROR | Leave file member_code không tồn tại |
| CALENDAR_DATE_OVERLAP | WARNING | Hai holiday cùng scope overlap |
| LEAVE_PENDING | INFO | Leave record có status: pending |
| MEMBER_INACTIVE_ALLOCATED | WARNING | Allocation trỏ đến member có Status: Inactive |
| ZERO_CAPACITY | ERROR | member.weekly_capacity = 0 hoặc trống |

---

## 6. File Naming Quick Reference

| Entity | Pattern | Ví dụ |
|--------|---------|-------|
| Member | `input/members/[firstname]-[lastname].md` | `emily-ho.md` |
| Allocation | `input/allocations/[PROJECT-CODE].md` | `P001.md` |
| Org Calendar | `input/capacity/calendar-[YYYY].md` | `calendar-2026.md` |
| Leave | `input/capacity/leaves/[member-id]-[YYYY].md` | `alice-nguyen-2026.md` |

### Member Code convention

`[firstname-lastname]` — lowercase, dấu gạch ngang, không dấu tiếng Việt.

| Tên đầy đủ | Member Code |
|-----------|-------------|
| Alice Nguyen | `alice-nguyen` |
| Nguyễn Phi Hoàng | `nguyen-phi-hoang` |
| Goto (Ayaka) | `goto-ayaka` |

---

## 7. Mở rộng trong tương lai (Backlog)

| Feature | File mới | Mô tả |
|---------|----------|-------|
| **Skill Matrix** | `input/members/skills-matrix.md` | Bảng member × skill × level (1–5) |
| **Role Definition** | `input/members/roles.md` | Định nghĩa role, career path, mức lương band |
| **Bench Tracking** | `input/capacity/bench-YYYY.md` | Thành viên chưa có dự án — forecast idle time |
| **Rate Card** | `input/allocations/_rates.md` | Cost/hour per role → tính EAC tự động |
| **Hiring Plan** | `input/members/hiring-plan.md` | Nhân sự dự kiến onboard — placeholder allocation |
| **Training** | `input/capacity/training-YYYY.md` | Các đợt training làm giảm capacity tạm thời |
