# Co-Sprint Gate Checklists

Dùng cho projects có `Delivery Model: co-sprint` — FE team tham gia cùng Scrum team,
chạy cùng nhịp sprint (planning, daily, review, retro chung).

FE team chỉ own stories được assign trong sprint backlog. Scrum ceremony do SM/PO của Scrum team điều phối.

---

## Gate S1 — Sprint Planning intake (per sprint)

| # | Điều kiện | Pass? | Sign-off |
|---|-----------|-------|----------|
| 1 | Stories được assign cho FE team đã có ID và acceptance criteria rõ ràng | ☐ | |
| 2 | FE team đã re-estimate story points riêng (SP-FE, không dùng estimate của Scrum team) | ☐ | |
| 3 | Capacity FE team cho sprint đã khai báo (trừ leave, public holiday) | ☐ | |
| 4 | Dependencies: stories JP nào block/unblock stories FE đã được nhận diện | ☐ | |
| 5 | DoD cho từng story FE đã được confirm với PO (không dùng generic DoD) | ☐ | |

---

## Gate S2 — Story Done (per story)

> Áp dụng cho mỗi story được assign cho FE team.

| # | Điều kiện | Pass? | Sign-off |
|---|-----------|-------|----------|
| 1 | Code merged vào nhánh integration của project | ☐ | |
| 2 | Code review pass (cross-team review nếu shared component) | ☐ | |
| 3 | Deployed staging và verifiable bởi Scrum team / PO | ☐ | |
| 4 | PO của project chính accept story (ghi nhận ngày + cách accept) | ☐ | |

---

## Gate S3 — Sprint Review participation

| # | Điều kiện | Pass? | Sign-off |
|---|-----------|-------|----------|
| 1 | FE team đã demo phần của mình HOẶC confirm Scrum team đại diện demo đúng | ☐ | |
| 2 | Bug raised trong review đã được phân loại owner (FE / Scrum team / shared) | ☐ | |
| 3 | Bug của FE đã được log vào tracking với warranty period rõ ràng | ☐ | |

---

## Gate S4 — Sprint Retro contribution

| # | Điều kiện | Pass? | Sign-off |
|---|-----------|-------|----------|
| 1 | FE team đã raise ít nhất 1 observation trong retro chung | ☐ | |
| 2 | FE team đã tổ chức retro nội bộ riêng (15–30 phút) sau retro chung | ☐ | |
| 3 | Action items thuộc FE team đã được logged vào sprint tracking | ☐ | |

---

## Gate S5 — Post-sprint bug ownership

> Warranty period mặc định: 1 sprint sau khi story Done.

| # | Điều kiện | Status |
|---|-----------|--------|
| 1 | Bug từ stories FE trong warranty period đang được track | ☐ |
| 2 | Warranty period đã hết, bug còn lại đã handover cho maintain team | ☐ |

**Bug Ownership Matrix:**

| Loại bug | Owner | Triage SLA |
|----------|-------|-----------|
| Lỗi trong code FE | FE team | Immediate |
| Lỗi integration FE ↔ Backend | Shared — triage joint | 24h |
| Lỗi do spec/design gap | PdM / Designer của Scrum team | 48h |
| Bug sau warranty period | Maintain team của project chính | — |

---

## Cách dùng

1. Chạy Gate S1 trong mỗi sprint planning — không skip dù sprint đang ongoing
2. Gate S2 per story — không per sprint (story Done ngay khi pass, không chờ end of sprint)
3. Gate S4 bắt buộc có retro nội bộ FE — pain points FE không nên để lẫn trong retro chung
4. Sau warranty period (S5): FE team không còn owner bug từ stories đó

_Version: 1.0 — 2026-05-09_
