# Pipeline Gate Checklists
Mỗi gate phải pass 100% trước khi move sang phase tiếp theo.
Người chịu trách nhiệm sign-off ghi tên và ngày vào cột cuối.

---

## Gate 1 — intake → kickoff

| # | Điều kiện | Pass? | Sign-off |
|---|-----------|-------|----------|
| 1 | Scope được mô tả bằng văn bản và client đã confirm | ☐ | |
| 2 | Non-scope (những gì KHÔNG làm) đã được list rõ | ☐ | |
| 3 | Stakeholder chính đã được xác định và có lịch tham dự kickoff | ☐ | |
| 4 | Timeline tổng thể có buffer tối thiểu 15% | ☐ | |
| 5 | Dependencies ngoài team đã được list (API, content, approval từ bên thứ 3...) | ☐ | |
| 6 | Budget / resource đã được confirm | ☐ | |

---

## Gate 2 — kickoff → design

| # | Điều kiện | Pass? | Sign-off |
|---|-----------|-------|----------|
| 1 | Project Brief đã được viết và distributed cho tất cả thành viên | ☐ | |
| 2 | Stakeholder map hoàn chỉnh (ai quyết định gì) | ☐ | |
| 3 | Timeline cứng (hard deadline) vs. mềm đã phân biệt rõ | ☐ | |
| 4 | Designer đã đọc Brief và không còn câu hỏi mở | ☐ | |
| 5 | Design tool / deliverable format đã thống nhất với client | ☐ | |

---

## Gate 3 — design → implementation

| # | Điều kiện | Pass? | Sign-off |
|---|-----------|-------|----------|
| 1 | Design handoff session đã diễn ra (không chỉ upload file) | ☐ | |
| 2 | Responsive / breakpoint đã defined đầy đủ | ☐ | |
| 3 | Error states, loading states, empty states đã có design | ☐ | |
| 4 | API contract đã agreed giữa frontend và backend | ☐ | |
| 5 | Edge cases đã được raise và có design tương ứng | ☐ | |
| 6 | Dev đã đọc design và không còn câu hỏi mở | ☐ | |
| 7 | Client đã approve design (nếu required) | ☐ | |

---

## Gate 4 — implementation → verification

| # | Điều kiện | Pass? | Sign-off |
|---|-----------|-------|----------|
| 1 | Tất cả tasks trong phase implementation ở trạng thái Done | ☐ | |
| 2 | Code đã được review (không phải self-review) | ☐ | |
| 3 | Staging environment đã deploy thành công | ☐ | |
| 4 | Test plan / test cases đã được viết trước khi bắt đầu verify | ☐ | |
| 5 | Smoke test cơ bản pass (không có P0 bug ngay lúc handoff) | ☐ | |
| 6 | Bug severity definition đã thống nhất (P0/P1/P2/P3) | ☐ | |

---

## Gate 5 — verification → approval

| # | Điều kiện | Pass? | Sign-off |
|---|-----------|-------|----------|
| 1 | Không còn P0 bug nào open | ☐ | |
| 2 | Không còn P1 bug nào open (hoặc đã được accept risk bằng văn bản) | ☐ | |
| 3 | Tất cả test cases đã pass | ☐ | |
| 4 | Client đã được demo ít nhất 1 lần trong quá trình implementation | ☐ | |
| 5 | Tài liệu hướng dẫn (nếu cần) đã hoàn thành | ☐ | |
| 6 | Người approve đã được confirm và có lịch review | ☐ | |

---

## Gate 6 — approval → release

| # | Điều kiện | Pass? | Sign-off |
|---|-----------|-------|----------|
| 1 | Approval document đã được sign-off bởi đúng stakeholder | ☐ | |
| 2 | Release checklist đã được chuẩn bị đầy đủ | ☐ | |
| 3 | Rollback plan đã được viết và tested | ☐ | |
| 4 | Go/no-go decision owner đã được xác định | ☐ | |
| 5 | Communication plan cho end user đã sẵn sàng | ☐ | |
| 6 | Monitoring / alerting đã setup cho 24h đầu sau release | ☐ | |
| 7 | Release window đã được confirm (giờ, ngày, ai có mặt) | ☐ | |

---

## Gate 7 — release → post-release

| # | Điều kiện | Pass? | Sign-off |
|---|-----------|-------|----------|
| 1 | Release đã thành công, không có P0 incident trong 24h đầu | ☐ | |
| 2 | Post-release monitoring window đã được định nghĩa (VD: 2 tuần) | ☐ | |
| 3 | Bug triage schedule đã setup (VD: daily trong tuần đầu) | ☐ | |
| 4 | Owner chịu trách nhiệm post-release support đã được assign | ☐ | |

---

## Gate 8 — post-release → close

| # | Điều kiện | Pass? | Sign-off |
|---|-----------|-------|----------|
| 1 | Không còn P0/P1 bug open sau post-release window | ☐ | |
| 2 | Retrospective đã được tổ chức | ☐ | |
| 3 | Lessons learned đã được ghi lại và shared | ☐ | |
| 4 | Project đã được archive (input, processed, output) | ☐ | |

---

## Cách dùng

1. Copy file này vào `input/[PROJECT-CODE]/gates.md` khi bắt đầu project
2. Điền Pass (✓) và Sign-off trước mỗi lần chuyển phase
3. Nếu có item chưa pass → ghi rõ lý do hoặc accepted risk vào cột Notes
4. Không được skip gate trừ khi có approval bằng văn bản từ Project Owner

_Version: 1.0 — 2026-04-12_
