# Sprint Collection: Multilang for Hayatoku
Project Code: HAYK
Period: 2026-03-16 → 2026-04-26
Collected: 2026-04-12

## Tasks (7 total)

| ID | Title | Owner | Status | Due | Notes |
|----|-------|-------|--------|-----|-------|
| HAYK-T001 | So sánh chi phí - hiệu năng giữa các API dịch thuật | Vương | Not Started | 2026-03-24 | [from meeting 2026-03-17] |
| HAYK-T002 | Đưa Cache layer vào bản thiết kế kiến trúc | Vương | Not Started | 2026-03-24 | [from meeting 2026-03-17] |
| HAYK-T003 | Làm rõ luồng cross-domain language preference, sync với Hoàng | Vương | Not Started | 2026-03-19 | [from meeting 2026-03-17] |
| HAYK-T004 | Dựng tài liệu kiến trúc tổng thể | Vương | Not Started | 2026-03-17 | [from meeting 2026-03-17] |
| HAYK-T005 | List UI component cần review và gửi team | Hoàng | Not Started | 2026-03-24 | [from meeting 2026-03-17] |
| HAYK-T006 | Phối hợp với team Design về điều chỉnh layout (padding/margin) | Hoàng | Not Started | — | [from meeting 2026-03-17] |
| HAYK-T007 | Sync ngắn cập nhật tình hình chọn API | Cả nhóm | Not Started | 2026-03-21 | [from meeting 2026-03-17] |

**Status summary:** Done: 0 | In Progress: 0 | Not Started: 7 | Blocked: 0

## Blockers (0 total)

- N/A

## Decisions

- [2026-03-17] Tiêu chí ưu tiên số 1: chất lượng bản dịch và tốc độ phản hồi
- [2026-03-17] Kiến trúc Cache layer được chấp thuận: static content lưu vào DB dạng JSON, dynamic content mới gọi API
- [2026-03-17] Language preference đồng bộ qua Cross-domain cookie hoặc user profile (nếu đăng nhập) — hướng được chốt, chi tiết Vương làm rõ
- [2026-03-17] Language Switcher phải hoạt động mượt trên Mobile

## Team notes

- [RISK from 2026-03-17] Chi phí API dịch thuật sẽ rất cao nếu gọi real-time mỗi lượt truy cập (đã có hướng giải quyết bằng Cache) — Medium risk, owner: Vương
- [RISK from 2026-03-17] UI layout vỡ khi text dịch sang ngôn ngữ có ký tự dài (tiếng Nhật, tiếng Đức) — ảnh hưởng buttons và navigation — Medium risk, owner: Hoàng

## Meeting log

- [2026-03-17] Merged from meeting transcript — 7 tasks added, 4 decisions, 0 blockers, 0 status updates
