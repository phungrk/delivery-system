# Sprint / Project: Multilang for Hayatoku
Project Code: HAYK
Period: 2026-03-16 → 2026-04-26

<!--
HƯỚNG DẪN:
- Đặt file này trong folder input/HAYK/ (VD: input/HAYK/sprint-16.md)
- Project Code phải khớp với tên folder (VD: folder HAYK → code HAYK)
- Task ID dùng format HAYK-T001, VD: HAYK-T001, HAYK-T003
- Transcript của cùng project đặt chung folder: input/HAYK/transcript-YYYY-MM-DD.vtt
- Status chỉ dùng: Done | In Progress | Not Started | Blocked
- Cập nhật file này hàng ngày hoặc mỗi khi có thay đổi
-->

## Tasks

| ID | Title | Owner | Status | Est.(hrs) | Due | Started | Last Updated | Notes |
|----|-------|-------|--------|-----------|-----|---------|--------------|-------|
| HAYK-T001 | | | In Progress | | | 2026-04-19 | 2026-04-19 | |
| HAYK-T002 | PO quyết định UX cho trang /en và / (tiếng Anh) | Nio | In Progress | | 2026-04-17 | 2026-04-19 | 2026-04-19 | from Teams |

## Blockers

- N/A

## Decisions

- N/A
- 2026-04-16: Chốt logic flow hiển thị page và modal khi vào trang tiếng Nhật (/) và trang tiếng Anh (/en) *(source: Teams)*
- 2026-04-16: Chốt — user vào trang tiếng Nhật tại / lần thứ 2 chưa đồng ý chính sách dịch thuật: nếu url_lang != ja thì giữ nguyên trang / và không hiển thị modal thông báo *(source: Teams)*

## Availability

-

## Team notes

- 2026-04-16 [RISK][Medium] Chưa có quyết định UX cho trường hợp user vào /en và vào / theo trang tiếng Anh — cần Product Owner confirm — raised via Teams

## Changelog

<!--
Audit trail tự động — intake-agent ghi vào đây mỗi khi có /capture.
Không cần chỉnh tay. Format: [YYYY-MM-DD] [[SOURCE]] [tóm tắt] — signal: [TYPE]
-->
- 2026-04-16 [Teams] Chốt logic flow hiển thị page và modal cho trang JP (/) và EN (/en) — signal: DECISION
- 2026-04-16 [Teams] Chốt logic url_lang != ja: giữ nguyên trang / không hiển thị modal — signal: DECISION
- 2026-04-16 [Teams] PO cần quyết định UX cho /en và / tiếng Anh — signal: ACTION_ITEM
- 2026-04-16 [Teams] Rủi ro chưa có quyết định UX cho trường hợp /en và / tiếng Anh — signal: RISK
