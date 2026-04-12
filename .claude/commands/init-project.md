Khởi tạo một project mới trong delivery-system.

## Đầu vào từ người dùng

Lấy thông tin từ arguments: `$ARGUMENTS`

Format: `[PROJECT-CODE] "[Tên project]" [YYYY-MM-DD] [YYYY-MM-DD] [waterfall|scrum|kanban]`

Ví dụ:
- `NAVI "eNAVI Redesign" 2026-04-14 2026-06-30 waterfall`
- `AUTH "Auth Refactor" 2026-04-14 2026-04-28 scrum`

Nếu `$ARGUMENTS` trống hoặc thiếu thông tin, hỏi người dùng lần lượt:
1. Project Code (2–5 ký tự viết hoa, VD: NAVI, AUTH, PAY)
2. Tên đầy đủ của project
3. Ngày bắt đầu (YYYY-MM-DD)
4. Ngày kết thúc (YYYY-MM-DD)
5. Loại dự án:
   - `waterfall` — phases tuần tự, 1 file `project.md` cho cả vòng đời
   - `scrum` — sprint time-boxed, 1 file `sprint-N.md` per sprint
   - `kanban` — ongoing, 1 file `board.md` rolling

## Các bước thực hiện

### Bước 1 — Validate input

- Project Code chỉ gồm chữ cái in hoa và số, 2–5 ký tự
- Kiểm tra folder `input/[PROJECT-CODE]/` chưa tồn tại — nếu đã có thì báo lỗi và dừng
- Ngày kết thúc phải sau ngày bắt đầu
- Loại dự án phải là một trong: `waterfall`, `scrum`, `kanban`

### Bước 2 — Tạo folder

Tạo: `input/[PROJECT-CODE]/`

### Bước 3 — Tạo tracking file

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

### Bước 4 — Copy gate checklist

Đọc file `gates/pipeline-gates.md` và ghi nội dung đó vào `input/[PROJECT-CODE]/gates.md`.

Lưu ý theo loại dự án:
- **waterfall**: dùng đầy đủ tất cả 8 gates — đây là framework chính
- **scrum**: gates áp dụng per sprint hoặc per release, tùy team convention
- **kanban**: gates áp dụng cho release cycle, không phải sprint

### Bước 5 — Xác nhận

Báo cho người dùng theo loại dự án:

**Waterfall:**
- `input/[PROJECT-CODE]/project.md` — cập nhật Current Phase mỗi khi chuyển phase
- `input/[PROJECT-CODE]/gates.md` — điền Pass ✓ và Sign-off trước mỗi lần chuyển phase
- Khi xong, chạy `báo cáo sprint` để pipeline xử lý

**Scrum:**
- `input/[PROJECT-CODE]/sprint-1.md` — cập nhật hàng ngày trong sprint
- Tạo `sprint-2.md` khi bắt đầu sprint mới (copy từ template)
- `input/[PROJECT-CODE]/gates.md` — dùng cho release gates, không phải mỗi sprint
- Khi xong, chạy `báo cáo sprint` để pipeline xử lý

**Kanban:**
- `input/[PROJECT-CODE]/board.md` — cập nhật liên tục khi có thay đổi
- `input/[PROJECT-CODE]/gates.md` — dùng trước mỗi release
- Khi xong, chạy `báo cáo sprint` để pipeline xử lý
