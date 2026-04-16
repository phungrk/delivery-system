# Prompt Cards — Hướng dẫn sử dụng

Bộ prompt dùng với chat AI có hỗ trợ file attachment (Rakuten AI, ChatGPT, Claude.ai...).
Không cần Claude Code, không cần tool use, không cần memory giữa các session.

---

## Bộ card hiện có

| Card | Dùng khi nào | Attach file |
|------|-------------|-------------|
| `init-project.md` | Khởi tạo project mới — tạo project-context.md + tracking file | *(không cần)* |
| `capture.md` | Có input mới từ Teams / Email / meeting cần lưu lại | tracking file |
| `daily-check.md` | Sáng sớm, trước standup, muốn biết hôm nay cần làm gì | tracking file(s) |
| `sprint-report.md` | Cuối tuần / cuối sprint, tạo báo cáo gửi stakeholder | tracking file(s) + project-context.md |
| `gate-check.md` | Trước khi chuyển phase, xem đã đủ điều kiện chưa | tracking file + gates.md |
| `capy.md` | Phân tích sâu, tìm root cause, đề xuất KPI, coaching delivery | tracking file + project-context.md (+ gates.md / transcript nếu có) |

> **Tracking file** = `project.md` (Waterfall) / `sprint-N.md` (Scrum) / `board.md` (Kanban)
> **Project context** = `project-context.md` — hồ sơ dự án, nhập 1 lần sau kickoff, dùng chung cho mọi card phân tích

---

## Cách dùng (3 bước)

```
1. Copy toàn bộ nội dung card → paste vào Rakuten AI
2. Attach file cần thiết
3. Nhập thêm thông tin nếu card yêu cầu (ngày hôm nay, raw input, phase...)
```

Output ra markdown → paste thẳng lên Confluence hoặc apply vào file local.

---

## Ví dụ thực tế theo kịch bản

---

### Kịch bản 0 — Kickoff project mới, tạo file khởi tạo

**Bối cảnh:** Anh vừa nhận dự án HAYK "Multilang for Hayatoku", Waterfall,
bắt đầu 2026-03-16, target delivery 2026-04-26. Team gồm Vương (Dev, 100%) và Hoàng (QA, 50%).
Muốn tạo file để đưa vào delivery-system trước kickoff meeting.

**Cách làm:**
1. Copy `init-project.md` → paste vào Rakuten AI
2. Không cần attach file
3. Gõ thêm:
```
Project Code: HAYK
Tên project: Multilang for Hayatoku
Loại: Waterfall
Bắt đầu: 2026-03-16
Target delivery: 2026-04-26
Team: Vương (Dev, 100%), Hoàng (QA, 50%)
```

**Output nhận được:** 2 file sẵn sàng copy-paste:
- `input/HAYK/project-context.md` — điền sẵn team + timeline, placeholder cho scope/milestones/constraints
- `input/HAYK/project.md` — tracking file Waterfall với header đầy đủ

**Sau kickoff meeting:** Mở `project-context.md`, điền vào các ô `[cần điền sau kickoff]`.

---

### Kịch bản 1 — Sáng thứ Hai, quản lý 2 dự án song song

**Bối cảnh:** Anh đang chạy HAYK (Waterfall, phase kickoff) và AUTH (Scrum, sprint 2 ngày 5/14).
Muốn biết hôm nay nên tập trung vào đâu trước khi họp standup 9h.

**Cách làm:**
1. Copy `daily-check.md` → paste vào Rakuten AI
2. Attach cả 2 file: `input/HAYK/project.md` và `input/AUTH/sprint-2.md`
3. Gõ thêm: `Hôm nay: 2026-04-14`

**Output nhận được:**
```
# Daily Check — HAYK (Waterfall) — 2026-04-14
Phase hiện tại: kickoff | 3/10 tasks Done (30%)

🔴 Cần xử lý ngay
| HAYK-T003 | Clarify cross-domain sync | Vương | Overdue 3 ngày | 2026-04-11 |

🟡 Theo dõi
| HAYK-T005 | API comparison table | Vương | Due ngày mai | 2026-04-15 |

Focus hôm nay:
1. Vương: unblock HAYK-T003 trước 12h — đang cản T001 và T002
2. Confirm lại deadline HAYK-T005 với Vương — due ngày mai chưa thấy progress
...

---
# Daily Check — AUTH (Scrum) Sprint 2 — 2026-04-14
Sprint: ngày 5/14 (35%) | 4/12 tasks Done (33%) | On-track ✓
...

---
## Tổng hợp
| HAYK | Waterfall | T003 overdue, blocking chain | Unblock Vương |
| AUTH | Scrum | Đang on-track | Giữ nhịp |
```

**Thời gian:** 5 phút → biết ngay HAYK cần attention, AUTH đang ổn.

---

### Kịch bản 2 — Trong ngày có meeting, cần capture vào sprint

**Bối cảnh:** 10h có sync call HAYK. Sakikawa chốt deadline dời sang 2026-05-03,
Vương báo T003 xong, Hoàng sẽ bắt đầu implement T001 từ ngày mai.
Anh ghi chú nhanh trên Teams, giờ muốn đưa vào file.

**Cách làm:**
1. Copy `capture.md` → paste vào Rakuten AI
2. Attach `input/HAYK/project.md`
3. Gõ thêm:
```
Nguồn: Discussion meeting
Ngày: 2026-04-14

Sakikawa chốt deadline toàn project dời sang 2026-05-03 do client cần thêm
thời gian approve design. Vương báo T003 (cross-domain sync clarification)
đã xong rồi. Hoàng sẽ bắt đầu implement T001 từ ngày mai.
```

**Output nhận được:**
```
## Kết quả capture
Nguồn: Discussion | Ngày: 2026-04-14 | Signals: 3

### Cập nhật trong bảng Tasks
- Dòng HAYK-T003 (Clarify cross-domain sync): cột Status → "Done"
- Dòng HAYK-T001 (Backend integration): cột Status → "In Progress"

### Thêm vào ## Decisions
- 2026-04-14: Deadline toàn project dời sang 2026-05-03 — Sakikawa
  *(nguồn: Discussion meeting)*

### Thêm vào ## Changelog
- 2026-04-14 [Discussion] T003 Done (Vương) — signal: STATUS_UPDATE
- 2026-04-14 [Discussion] T001 bắt đầu (Hoàng) — signal: STATUS_UPDATE
- 2026-04-14 [Discussion] Deadline dời 2026-05-03 — signal: DECISION

### Cần xác nhận
- [ ] Period trong file có cần update từ 2026-04-26 → 2026-05-03 không?
```

**Apply:** Copy từng phần vào `project.md`. Mất 3 phút.

---

### Kịch bản 3 — Capture email từ client

**Bối cảnh:** Client gửi email yêu cầu thêm tính năng export PDF,
chưa rõ ai sẽ làm và deadline chưa có.

**Cách làm:**
1. Copy `capture.md` → paste vào Rakuten AI
2. Attach tracking file
3. Gõ thêm:
```
Nguồn: Email
Ngày: 2026-04-14

From: client@company.jp
"Chúng tôi cần thêm tính năng export báo cáo sang PDF trước khi release.
Đây là yêu cầu từ phía legal team."
```

**Output nhận được:**
```
## Kết quả capture
Nguồn: Email | Ngày: 2026-04-14 | Signals: 1

### Thêm vào bảng Tasks
| HAYK-T012 | Export báo cáo sang PDF | [unclear] | implementation | Not Started | | from Email/client |

### Cần xác nhận
- [ ] Owner của T012 là ai? (yêu cầu từ client nhưng chưa assign)
- [ ] Deadline? Email không đề cập — cần confirm với client
- [ ] "Trước khi release" = trước Gate 6 hay trước Gate 7?
```

---

### Kịch bản 4 — Cuối sprint, tạo báo cáo gửi stakeholder

**Bối cảnh:** Cuối tuần, muốn gửi báo cáo tiến độ HAYK cho Sakikawa.
File đã được cập nhật trong tuần qua qua các lần capture.

**Cách làm:**
1. Copy `sprint-report.md` → paste vào Rakuten AI
2. Attach `input/HAYK/project.md`
3. Gõ thêm: `Hôm nay: 2026-04-19`

**Output nhận được:** Report đầy đủ dạng markdown → paste thẳng lên Confluence.

```
# Project Report — Multilang for Hayatoku (Waterfall)
Period: 2026-03-16 → 2026-05-03 | Báo cáo: 2026-04-19 | Phase: implementation
...
```

---

### Kịch bản 5 — Sắp chuyển từ kickoff sang design

**Bối cảnh:** HAYK đang ở phase kickoff, team nghĩ đã xong,
muốn kiểm tra trước khi chính thức move sang design.

**Cách làm:**
1. Copy `gate-check.md` → paste vào Rakuten AI
2. Attach `input/HAYK/project.md` VÀ `input/HAYK/gates.md`
3. Gõ thêm:
```
Hôm nay: 2026-04-19
Phase hiện tại: kickoff
Phase muốn chuyển sang: design
```

**Output nhận được:**
```
# Gate Check — HAYK (Waterfall)
Gate 2: kickoff → design
Kết luận: NO-GO ❌

| # | Điều kiện | Đánh giá | Evidence |
|---|-----------|---------|----------|
| 1 | Project Brief đã distributed cho team | ✅ | Decisions 2026-03-17: brief đã gửi |
| 2 | Stakeholder map hoàn chỉnh | ❓ | Không tìm thấy trong file |
| 3 | Timeline cứng vs mềm đã phân biệt | ⚠️ | Có deadline nhưng chưa label hard/soft |
| 4 | Designer đã đọc Brief | ❌ | Không có evidence |
| 5 | Design tool đã thống nhất | ❌ | Không có evidence |

❌ Phải hoàn thành:
1. Designer confirm đã đọc Brief — Owner: Hoàng (gần nhất với design)
2. Thống nhất design tool (Figma? Sketch?) với client — Owner: Sakikawa

⚠️ Cần acknowledge:
1. Hard deadline chưa label rõ — risk nếu client hiểu sai kỳ vọng
```

---

## Workflow thực tế theo ngày

```
Khi nhận dự án mới:
  └─ init-project.md (không cần attach) → tạo project-context.md + tracking file

Sau kickoff meeting:
  └─ Mở project-context.md → điền team, milestones, scope, constraints

Sáng (mỗi ngày):
  └─ daily-check.md + tracking file(s) → 5 phút biết focus hôm nay

Trong ngày (mỗi khi có input):
  └─ capture.md + tracking file → 3 phút capture Teams/Email/meeting

Cuối sprint / cuối tuần:
  └─ sprint-report.md + tracking file(s) + project-context.md → 10 phút tạo report Confluence

Trước khi chuyển phase:
  └─ gate-check.md + tracking file + gates.md → 10 phút verify gate
```

---

## Lưu ý khi dùng với Rakuten AI

- **Session mới cho mỗi tác vụ** — đừng mix nhiều card trong 1 chat dài
- **AI không tự sửa file** — output là hướng dẫn, bạn apply thủ công
- **Nếu AI hỏi lại nhiều** — thêm vào cuối prompt: *"Chỉ trả lời theo format output đã định, không hỏi thêm"*
- **Nếu output bị cắt** — gõ: *"Tiếp tục từ chỗ bị dừng"*
- **Output luôn là markdown** — paste thẳng vào Confluence Editor (chế độ markdown)
