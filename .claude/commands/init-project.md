Khởi tạo một project mới trong delivery-system.

## Đầu vào từ người dùng

Lấy thông tin từ arguments: `$ARGUMENTS`

`$ARGUMENTS` có thể ở **2 dạng**:

**Dạng 1 — Structured args (nếu biết đủ thông tin):**
```
[PROJECT-CODE] "[Tên project]" [YYYY-MM-DD] [YYYY-MM-DD] [waterfall|scrum|kanban]
```
Ví dụ: `NAVI "eNAVI Redesign" 2026-04-14 2026-06-30 waterfall`

**Dạng 2 — Nội dung kickoff meeting (raw text, transcript, notes):**
```
[bất kỳ nội dung nào từ kickoff meeting — paste thẳng vào]
```
Agent sẽ tự trích xuất thông tin project từ nội dung này.

**Nếu `$ARGUMENTS` trống** → hỏi user chọn dạng input trước khi tiếp tục.

## Các bước thực hiện

### Bước 1 — Nhận diện dạng input và trích xuất thông tin

**Nếu là structured args:** parse trực tiếp → PROJECT-CODE, tên, start, end, type.

**Nếu là nội dung kickoff meeting:** đọc toàn bộ và trích xuất các trường sau:

| Trường | Dấu hiệu nhận biết trong meeting |
|--------|----------------------------------|
| Project Code | Mã viết tắt, tên viết tắt dự án |
| Tên project | Tên đầy đủ dự án được nhắc đến |
| Loại dự án | "sprint", "phase", "kanban", mô hình làm việc |
| Start date | Ngày bắt đầu, ngày kick-off |
| Target delivery | Deadline, ngày go-live, ngày bàn giao |
| Overview | Mô tả dự án, background, context |
| Goals | Mục tiêu, success criteria, KPIs |
| Deliverables | Những gì sẽ bàn giao, feature list, scope |
| Related links | URL, link tài liệu, repo, design, board |
| Team | Tên người + role + % thời gian nếu có |
| Milestones | Các mốc quan trọng được nhắc đến |
| Constraints | Dependency, risk, ràng buộc, nghỉ phép |

Sau khi trích xuất, liệt kê rõ những gì **tìm được** và những gì **không tìm thấy**.

### Bước 2 — Hỏi thông tin còn thiếu

**Thông tin bắt buộc** (không có không tạo được file):
- Project Code
- Tên project
- Ngày bắt đầu
- Target delivery
- Loại dự án (waterfall / scrum / kanban)

**Thông tin khuyến nghị** (nên có để pipeline phân tích đúng):
- Team (ít nhất 1 member)
- Deliverables (ít nhất 1 mục)

Với mỗi trường **bắt buộc** còn thiếu → hỏi user ngay, không tạo file cho đến khi có đủ.
Với trường **khuyến nghị** còn thiếu → hỏi gộp 1 lần, cho phép user bỏ qua (sẽ dùng placeholder).

**Format câu hỏi:**
```
Tôi cần thêm thông tin để tạo file:

[Bắt buộc — cần trả lời trước khi tiếp tục]
- Project Code là gì? (2–5 ký tự viết hoa)
- Loại dự án: waterfall / scrum / kanban?

[Khuyến nghị — có thể bỏ qua, sẽ điền sau]
- Team gồm những ai? (tên, role, % thời gian)
- Có milestones nào cần ghi lại không?
```

### Bước 3 — Validate

- Project Code chỉ gồm chữ cái in hoa và số, 2–5 ký tự
- Kiểm tra folder `input/[PROJECT-CODE]/` chưa tồn tại — nếu đã có thì báo lỗi và dừng
- Ngày kết thúc phải sau ngày bắt đầu
- Loại dự án phải là một trong: `waterfall`, `scrum`, `kanban`

### Bước 4 — Tạo folder

Tạo: `input/[PROJECT-CODE]/`

### Bước 5 — Tạo tracking file

Tên file và nội dung header thay đổi theo loại dự án:

---

#### Nếu là `waterfall` → tạo `project.md`

```markdown
# Project: [Tên project]
Project Code: [PROJECT-CODE]
Type: Waterfall
Period: [YYYY-MM-DD] → [YYYY-MM-DD]
Current Phase: intake

<!--
HƯỚNG DẪN:
- File này theo dõi toàn bộ vòng đời dự án (không tạo file mới khi đổi phase)
- Cập nhật Current Phase mỗi khi chuyển phase, sau khi gate checklist đã pass
- Task ID dùng format [PROJECT-CODE]-T001, VD: NAVI-T001
- Transcript đặt chung folder: input/[PROJECT-CODE]/transcript-YYYY-MM-DD.md
- Phase hợp lệ: intake | kickoff | design | implementation | verification | approval | release | post-release
- Status chỉ dùng: Done | In Progress | Not Started | Blocked
-->

## Tasks

| ID | Title | Owner | Phase | Status | Due | Notes |
|----|-------|-------|-------|--------|-----|-------|
| [PROJECT-CODE]-T001 | | | intake | Not Started | | |

## Blockers

- N/A

## Decisions

- N/A

## Team notes

- 

## Changelog

<!--
Audit trail tự động — intake-agent ghi vào đây mỗi khi có /capture.
Format: [YYYY-MM-DD] [[SOURCE]] [tóm tắt] — signal: [TYPE]
-->
```

---

#### Nếu là `scrum` → tạo `sprint-1.md`

```markdown
# Sprint 1: [Tên project]
Project Code: [PROJECT-CODE]
Type: Scrum
Period: [YYYY-MM-DD] → [YYYY-MM-DD]
Current Phase: intake

<!--
HƯỚNG DẪN:
- Tạo file sprint-2.md, sprint-3.md... cho các sprint tiếp theo
- Task ID dùng format [PROJECT-CODE]-T001, VD: AUTH-T001
- Transcript đặt chung folder: input/[PROJECT-CODE]/transcript-YYYY-MM-DD.md
- Status chỉ dùng: Done | In Progress | Not Started | Blocked
-->

## Tasks

| ID | Title | Owner | Phase | Status | Due | Notes |
|----|-------|-------|-------|--------|-----|-------|
| [PROJECT-CODE]-T001 | | | intake | Not Started | | |

## Blockers

- N/A

## Decisions

- N/A

## Team notes

- 

## Changelog

<!--
Audit trail tự động — intake-agent ghi vào đây mỗi khi có /capture.
Format: [YYYY-MM-DD] [[SOURCE]] [tóm tắt] — signal: [TYPE]
-->
```

---

#### Nếu là `kanban` → tạo `board.md`

```markdown
# Board: [Tên project]
Project Code: [PROJECT-CODE]
Type: Kanban
Started: [YYYY-MM-DD]
Review cadence: weekly

<!--
HƯỚNG DẪN:
- File này là rolling board — không có end date cứng
- Task ID dùng format [PROJECT-CODE]-T001, tăng dần không reset
- Transcript đặt chung folder: input/[PROJECT-CODE]/transcript-YYYY-MM-DD.md
- Status chỉ dùng: Done | In Progress | Not Started | Blocked
- Dọn task Done cũ hơn 30 ngày vào ## Archive mỗi tháng
-->

## Tasks

| ID | Title | Owner | Status | Due | Notes |
|----|-------|-------|--------|-----|-------|
| [PROJECT-CODE]-T001 | | | Not Started | | |

## Blockers

- N/A

## Decisions

- N/A

## Team notes

- 

## Changelog

<!--
Audit trail tự động — intake-agent ghi vào đây mỗi khi có /capture.
Format: [YYYY-MM-DD] [[SOURCE]] [tóm tắt] — signal: [TYPE]
-->

## Archive

<!-- Task Done cũ hơn 30 ngày được chuyển vào đây hàng tháng -->
```

---

### Bước 4 — Tạo project-context.md

Tạo file `input/[PROJECT-CODE]/project-context.md` với nội dung sau:

```markdown
# Project Context: [Tên project]
Project Code: [PROJECT-CODE]
Last updated: [YYYY-MM-DD — ngày tạo]

<!--
Điền file này sau kickoff meeting.
Pipeline dùng file này để tính deadline risk, phát hiện scope creep, và phân tích workload.
Cập nhật khi có re-plan lớn, thay đổi team, hoặc scope change.
-->

## Team

| Name | Role | Allocation | Also on projects |
|------|------|------------|-----------------|
| [Tên] | [Dev / PO / QA / DM / Designer] | [100% / 50% / ...] | [Tên project khác hoặc —] |

## Timeline

- Project start: [YYYY-MM-DD]
- Target delivery: [YYYY-MM-DD]
- Key milestones:
  - [Tên milestone 1]: YYYY-MM-DD
  - [Tên milestone 2]: YYYY-MM-DD

## Scope

- Total deliverables: [N]
- Original scope: [1–2 dòng mô tả phạm vi đã cam kết]
- Acceptance criteria: [tóm tắt hoặc link tài liệu]
- Out of scope: [những gì KHÔNG thuộc dự án này]

## Constraints

- [VD: dependency vào team X cho API — ETA: YYYY-MM-DD]
- [VD: cần approval từ stakeholder trước khi deploy]
```

Điền sẵn `Project start` và `Target delivery` từ arguments đã nhận.

### Bước 5 — Copy gate checklist

Đọc file `gates/pipeline-gates.md` và ghi nội dung đó vào `input/[PROJECT-CODE]/gates.md`.

Lưu ý theo loại dự án:
- **waterfall**: dùng đầy đủ tất cả 8 gates — đây là framework chính
- **scrum**: gates áp dụng per sprint hoặc per release, tùy team convention
- **kanban**: gates áp dụng cho release cycle, không phải sprint

### Bước 6 — Xác nhận

Báo cho người dùng theo loại dự án:

**Waterfall:**
- `input/[PROJECT-CODE]/project-context.md` — **điền sau kickoff meeting** (team, milestones, scope, constraints)
- `input/[PROJECT-CODE]/project.md` — cập nhật Current Phase mỗi khi chuyển phase
- `input/[PROJECT-CODE]/gates.md` — điền Pass ✓ và Sign-off trước mỗi lần chuyển phase
- Khi xong, chạy `báo cáo sprint` để pipeline xử lý

**Scrum:**
- `input/[PROJECT-CODE]/project-context.md` — **điền sau kickoff meeting** (team, milestones, scope, constraints)
- `input/[PROJECT-CODE]/sprint-1.md` — cập nhật hàng ngày trong sprint
- Tạo `sprint-2.md` khi bắt đầu sprint mới (copy từ template)
- `input/[PROJECT-CODE]/gates.md` — dùng cho release gates, không phải mỗi sprint
- Khi xong, chạy `báo cáo sprint` để pipeline xử lý

**Kanban:**
- `input/[PROJECT-CODE]/project-context.md` — **điền sau kickoff meeting** (team, milestones, scope, constraints)
- `input/[PROJECT-CODE]/board.md` — cập nhật liên tục khi có thay đổi
- `input/[PROJECT-CODE]/gates.md` — dùng trước mỗi release
- Khi xong, chạy `báo cáo sprint` để pipeline xử lý
