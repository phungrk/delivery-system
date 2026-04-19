Kiểm tra nhanh tình hình tất cả project trước standup.

## Các bước thực hiện

### Bước 1 — Xác định ngày hôm nay
Lấy ngày hôm nay từ context (`currentDate`). Nếu không có, dùng ngày thực tế.

### Bước 2 — Đọc tất cả tracking files
Quét toàn bộ `input/[Domain]/[PROJECT-CODE]/` để tìm tracking file theo thứ tự ưu tiên:
1. `project-tracking.md`
2. `sprint-*.md` (lấy file số lớn nhất)

Bỏ qua: `timelog.md`, `pipeline-gates.md`, `transcript-*`, `project-context.md`, `_*.md`

Nếu `$ARGUMENTS` có PROJECT-CODE cụ thể → chỉ đọc project đó.

### Bước 3 — Phân tích mỗi project

Đọc field `Type:` để xác định loại, sau đó phân tích:

**Waterfall / Kanban (`project-tracking.md`):**
- Phase hiện tại (`Current Phase`)
- Completion rate phase hiện tại: Done / Total tasks trong phase × 100%
- Completion rate toàn project
- PHASE_LEAK: có task phase trước chưa Done không?
- Tasks cần chú ý: Blocked, Overdue, sắp Due (≤ 2 ngày), stale (Last Updated > 7 ngày)

**Scrum / Scrum-P (`sprint-*.md`):**
- Sprint progress: (hôm nay - start) / (end - start) × 100%
- Completion rate: Done / Total × 100%
- Đang ahead / on-track / behind so với sprint progress
- Tasks cần chú ý: Blocked, Overdue, Not Started khi sprint > 50%, stale

**Phân loại mức độ:**
- 🔴 Blocked | Overdue | Not Started khi sprint > 50%
- 🟡 Due ≤ 2 ngày | stale > 7 ngày | owner gánh > 3 In Progress
- ✅ On-track, không có issue

### Bước 4 — Output

Nếu chỉ 1 project — output trực tiếp:

```
# Daily Check — [tên project] ([Type]) — [hôm nay]
[Waterfall/Kanban]: Phase hiện tại: [phase] | [N]/[Total] tasks Done ([X]%)
[Scrum/Scrum-P]:   Sprint [N]: ngày [X]/[Total] ([Y]%) | [N]/[Total] tasks Done ([Z]%) | [ahead/on-track/behind]

---

## 🔴 Cần xử lý ngay

| Task | Owner | Vấn đề | Due |
|------|-------|--------|-----|

<!-- Nếu không có → "Không có vấn đề khẩn cấp hôm nay ✓" -->

---

## 🟡 Theo dõi hôm nay

| Task | Owner | Lý do | Due |
|------|-------|-------|-----|

<!-- Bỏ section nếu không có -->

---

## Focus gợi ý

1. **[Hành động 1]** — [lý do từ data]
2. **[Hành động 2]** — [lý do từ data]
3. **[Hành động 3]** — [lý do từ data]

<!-- Tối đa 3. Cụ thể: ai làm gì -->

---

## Tín hiệu đáng chú ý

<!-- Chỉ ghi nếu có pattern rủi ro ẩn. Bỏ nếu không có -->

---
*Nguồn: [tên file] | [hôm nay]*
```

Nếu nhiều project — tạo Daily Check riêng cho từng project, sau đó thêm:

```
---
## Tổng hợp hôm nay — [N] projects

| Project | Domain | Type | 🔴 | 🟡 | Focus hôm nay |
|---------|--------|------|----|----|---------------|
| [CODE]  | [Domain] | Waterfall | N | N | [1 hành động] |
| [CODE]  | [Domain] | Scrum | 0 | 1 | — |

## Cần xử lý ngay (cross-project)
[Liệt kê các vấn đề 🔴 theo độ ưu tiên — tên project + task + hành động]
```

## Quy tắc

- Tối đa 3 focus items — không liệt kê tất cả task
- Hành động phải cụ thể: tên người + hành động, không phải lời khuyên chung
- Nếu tracking file không có đủ data → ghi rõ trường nào thiếu
- Nếu `input/` trống hoặc không tìm thấy project → thông báo và dừng
