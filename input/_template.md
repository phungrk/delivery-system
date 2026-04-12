# Sprint / Project: [Tên sprint hoặc tên project]
Project Code: [Mã viết tắt, 2–5 ký tự, VD: CL, NAVI, AUTH]
Type: [Waterfall | Scrum | Kanban]
Period: YYYY-MM-DD → YYYY-MM-DD
Current Phase: [intake | kickoff | design | implementation | verification | approval | release | post-release]

<!--
HƯỚNG DẪN:
- Dùng /init-project để tạo file đúng loại tự động (waterfall/scrum/kanban)
- Tên file theo loại: project.md (waterfall) | sprint-N.md (scrum) | board.md (kanban)
- Đặt file trong folder input/[PROJECT-CODE]/ (VD: input/CL/sprint-16.md)
- Project Code phải khớp với tên folder (VD: folder CL → code CL)
- Task ID dùng format [PROJECT_CODE]-T001, VD: CL-T001, NAVI-T003
- Transcript của cùng project đặt chung folder: input/CL/transcript-YYYY-MM-DD.md
- Status chỉ dùng: Done | In Progress | Not Started | Blocked
- Cập nhật file này hàng ngày hoặc mỗi khi có thay đổi
-->

## Tasks

| ID | Title | Owner | Phase | Status | Due | Notes |
|----|-------|-------|-------|--------|-----|-------|
| [CODE]-T001 | [Tên task] | [Tên người] | design | Not Started | YYYY-MM-DD | |
| [CODE]-T002 | [Tên task] | [Tên người] | implementation | In Progress | YYYY-MM-DD | |
| [CODE]-T003 | [Tên task] | [Tên người] | verification | Done | YYYY-MM-DD | |
| [CODE]-T004 | [Tên task] | [Tên người] | implementation | Blocked | YYYY-MM-DD | Blocked by [lý do] |

## Blockers

<!--
Format: [Task ID] [Mô tả blocker] — [Người chịu trách nhiệm] — since YYYY-MM-DD
-->

- [T004] [Mô tả vấn đề đang block] — [Tên người] — since YYYY-MM-DD

## Decisions

<!--
Ghi lại các quyết định quan trọng đã đưa ra trong sprint này.
Format: YYYY-MM-DD: [Quyết định]
-->

- YYYY-MM-DD: [Quyết định đã đưa ra]

## Team notes

<!--
Ghi chú tự do — tình trạng team, rủi ro, context quan trọng.
Ví dụ: ai đang nghỉ phép, ai đang overload, sprint velocity tuần trước là bao nhiêu
-->

- [Ghi chú về tình trạng team]
- Sprint velocity tuần trước: [N] points

## Changelog

<!--
Audit trail tự động — intake-agent ghi vào đây mỗi khi có /capture.
Không cần chỉnh tay. Format: [YYYY-MM-DD] [[SOURCE]] [tóm tắt] — signal: [TYPE]
-->

