# Sprint Handover Gate Checklists

Dùng cho projects có `Delivery Model: sprint-handover` — FE team làm độc lập theo timeline riêng,
sau đó bàn giao UI cho Scrum team tích hợp vào sprint của họ.

Accountability của FE team kết thúc tại **Gate C4**. Gate C5 chỉ theo dõi integration của Scrum team.

---

## Gate C1 — intake → design

| # | Điều kiện | Pass? | Sign-off |
|---|-----------|-------|----------|
| 1 | Requirement từ Scrum team / PO đã nhận bằng văn bản | ☐ | |
| 2 | Interface contract (API, component props, event schema) đã agreed | ☐ | |
| 3 | Phạm vi UI component đã xác định rõ (in scope / out of scope) | ☐ | |
| 4 | Target sprint của Scrum team để tích hợp đã biết | ☐ | |
| 5 | Approvers phía Scrum team đã được xác định (tên cụ thể) | ☐ | |
| 6 | Timeline handover của FE team đã cam kết (buffer ≥ 1 sprint trước target sprint) | ☐ | |

---

## Gate C2 — design → implementation

| # | Điều kiện | Pass? | Sign-off |
|---|-----------|-------|----------|
| 1 | Design handoff session đã diễn ra với Scrum team | ☐ | |
| 2 | Requirement đã frozen — Scrum team confirm không còn câu hỏi mở | ☐ | |
| 3 | Edge cases đã được raise và có design tương ứng | ☐ | |
| 4 | Scope freeze đã được ghi nhận (bất kỳ yêu cầu mới sau điểm này cần negotiation) | ☐ | |

---

## Gate C3 — implementation → review

| # | Điều kiện | Pass? | Sign-off |
|---|-----------|-------|----------|
| 1 | Code complete, PR đã raise | ☐ | |
| 2 | Code đã được review (không phải self-review) | ☐ | |
| 3 | Lint / unit test pass | ☐ | |
| 4 | Staging build đã reflect thay đổi | ☐ | |
| 5 | Smoke test cơ bản pass | ☐ | |

---

## Gate C4 — review → handover ✓ FE TEAM DONE

> Đây là điểm "Done by FE team". Sau gate này, FE team đã hoàn thành nghĩa vụ.

| # | Điều kiện | Pass? | Sign-off |
|---|-----------|-------|----------|
| 1 | Code đã merged vào nhánh integration được thống nhất | ☐ | |
| 2 | Tất cả approvers phía Scrum team đã sign-off (mỗi người 1 dòng) | ☐ | |
| 3 | Handover document đã nộp (component usage guide hoặc integration note) | ☐ | |
| 4 | Staging đã được Scrum team / PO confirm visually | ☐ | |

**Approvers sign-off** (điền tên + ngày):

| Approver | Role | Approved? | Date |
|----------|------|-----------|------|
| [Tên 1] | [Role] | ☐ | |
| [Tên 2] | [Role] | ☐ | |
| [Tên 3] | [Role] | ☐ | |

---

## Gate C5 — handover → sprint integration (monitor only)

> Gate này KHÔNG thuộc accountability của FE team. Chỉ theo dõi để biết downstream status.

| # | Điều kiện | Confirmed? | Date |
|---|-----------|------------|------|
| 1 | Scrum team đã pickup và bắt đầu tích hợp vào sprint | ☐ | |
| 2 | Integration pass trong sprint của Scrum team | ☐ | |
| 3 | Sprint release đã bao gồm component này | ☐ | |

---

## Cách dùng

1. Copy file này vào `input/[DOMAIN]/[PROJECT-CODE]/sprint-handover-gates.md` khi bắt đầu project
2. Xác định target sprint của Scrum team ngay tại C1 — đây là hard deadline ngược chiều
3. Scope freeze tại C2 — yêu cầu mới sau điểm này phải negotiate lại timeline
4. Gate C4 = FE team Done — sau khi pass, chuyển sang monitor mode
5. Nếu Scrum team raise bug sau C4: áp Bug Ownership Matrix (xem project-context)

_Version: 1.0 — 2026-05-09_
