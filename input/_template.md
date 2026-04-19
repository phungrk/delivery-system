# Sprint / Project: [Tên sprint hoặc tên project]
Project Code: [Mã viết tắt, 2–5 ký tự, VD: CL, NAVI, AUTH]
Type: [Waterfall | Scrum | Kanban]
Period: YYYY-MM-DD → YYYY-MM-DD
Current Phase: [intake | kickoff | design | implementation | verification | approval | release | post-release]

<!--
HƯỚNG DẪN:
- Dùng /init-project để tạo file đúng loại tự động (waterfall/scrum/kanban)
- Tên file: project-tracking.md (tất cả loại)
- Đặt file trong folder input/[PROJECT-CODE]/ (VD: input/CL/sprint-16.md)
- Project Code phải khớp với tên folder (VD: folder CL → code CL)
- Task ID dùng format [PROJECT_CODE]-T001, VD: CL-T001, NAVI-T003
- Transcript của cùng project đặt chung folder: input/CL/transcript-YYYY-MM-DD.md
- Status chỉ dùng: Done | In Progress | Not Started | Blocked
- Cập nhật file này hàng ngày hoặc mỗi khi có thay đổi
-->

## Tasks

<!--
Est.(hrs): số giờ dự kiến để hoàn thành task (VD: 4, 8, 16)
Started: ngày bắt đầu In Progress — để tính cycle time
Last Updated: ngày cập nhật task gần nhất — để phát hiện "silent stall" (không update > 7 ngày)
-->

| ID | Title | Owner | Phase | Status | Est.(hrs) | Due | Started | Last Updated | Notes |
|----|-------|-------|-------|--------|-----------|-----|---------|--------------|-------|
| [CODE]-T001 | [Tên task] | [Tên người] | design | Not Started | 8 | YYYY-MM-DD | | | |
| [CODE]-T002 | [Tên task] | [Tên người] | implementation | In Progress | 16 | YYYY-MM-DD | YYYY-MM-DD | YYYY-MM-DD | |
| [CODE]-T003 | [Tên task] | [Tên người] | verification | Done | 4 | YYYY-MM-DD | YYYY-MM-DD | YYYY-MM-DD | |
| [CODE]-T004 | [Tên task] | [Tên người] | implementation | Blocked | 8 | YYYY-MM-DD | YYYY-MM-DD | YYYY-MM-DD | Blocked by [lý do] |

## Blockers

<!--
Format: [Task ID] [Mô tả blocker] — [Người chịu trách nhiệm] — since YYYY-MM-DD — depends on [TASK-ID hoặc PROJECT-T00X]
Dùng "depends on" để track cross-project dependency (VD: depends on AUTH-T005)
-->

- [T004] [Mô tả vấn đề đang block] — [Tên người] — since YYYY-MM-DD

## Decisions

<!--
Ghi lại các quyết định quan trọng đã đưa ra trong sprint này.
Format: YYYY-MM-DD: [Quyết định]
-->

- YYYY-MM-DD: [Quyết định đã đưa ra]

## Availability

<!--
Khai báo nghỉ phép / giảm capacity trong sprint này.
Format: [Tên] — nghỉ YYYY-MM-DD → YYYY-MM-DD ([lý do nếu cần])
Để trống nếu không có ai nghỉ.
-->

- [Tên] — nghỉ YYYY-MM-DD → YYYY-MM-DD

## Team notes

<!--
Ghi chú tự do — tình trạng team, rủi ro, context quan trọng.
-->

- [Ghi chú về tình trạng team]

## Changelog

<!--
Audit trail tự động — intake-agent ghi vào đây mỗi khi có /capture.
Không cần chỉnh tay. Format: [YYYY-MM-DD] [[SOURCE]] [tóm tắt] — signal: [TYPE]
-->

