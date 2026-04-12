# Multi-Project Management — Phân tích vấn đề & Giải pháp
**Ngày:** 2026-04-12
**Tác giả:** capy (Senior Delivery Manager)
**Căn cứ:** Pipeline hiện tại của delivery-system + kinh nghiệm quản lý đa dự án

---

## Bức tranh hiện tại

Hệ thống đang vận hành tốt với 1 project (Sprint 16 — Cardless, 1 owner, 2 tasks). Pipeline rõ ràng: `input → processed → output`. Mọi thứ flat, dễ trace.

Khi scale lên N projects song song, 5 vấn đề cấu trúc sẽ nổi lên theo thứ tự nghiêm trọng giảm dần:

---

## Vấn đề 1 — Namespace collision (Nghiêm trọng nhất)

**Bản chất:** Hiện tại task ID chỉ là `T001`, `T002` — không có project prefix. Khi có 3 project cùng lúc, bạn sẽ có 3 file đều chứa `T001`. `processed/collected-*.md` sẽ merge tất cả vào 1 file mà không phân biệt được task nào thuộc project nào.

**Bằng chứng từ hệ thống:** `data-collector.md` ghi toàn bộ tasks vào một section `## Projects` duy nhất — không có isolation giữa các project trong cùng 1 collected file.

**Hậu quả:**
- `metrics-analyzer` tính completion rate trên tổng tất cả tasks → số bị pha loãng, mất ý nghĩa per-project
- `insight-generator` không biết blocker của project A có liên quan đến project B không
- Report cuối mất khả năng drill-down theo project

**Giải pháp A — Project prefix trong Task ID**
Đổi convention: `T001` → `[PROJECT_CODE]-T001` (ví dụ: `CL-T001` cho Cardless, `NAVI-T001` cho eNAVI)
- Cost: Thấp (chỉ sửa `_template.md` + cập nhật parsing rule trong `data-collector`)
- Time: 1 ngày
- Quality impact: +++ (giải quyết được root cause, không cần thay đổi kiến trúc)
- Phù hợp khi: Bắt đầu ngay, trước khi có project thứ 2

**Giải pháp B — Mỗi project một thư mục input riêng**
`input/cardless/sprint-16.md`, `input/enavi/sprint-3.md`
- Cost: Trung bình (cần sửa Glob pattern trong `data-collector`, `transcript-parser`)
- Time: 2–3 ngày
- Quality impact: ++++ (isolation hoàn toàn, dễ audit)
- Phù hợp khi: Có 5+ projects, team khác nhau quản lý file khác nhau

**Khuyến nghị:** Giải pháp A ngay bây giờ. Nếu vượt 5 projects thì migrate sang B — lúc đó đủ motivation để chịu chi phí refactor.

---

## Vấn đề 2 — Cross-project resource conflict không được phát hiện

**Bản chất:** Hiện tại `metrics-analyzer` tính workload per owner trong phạm vi 1 project. Nếu `capu` có mặt trong 3 project khác nhau, mỗi project đều thấy capu "bình thường" — nhưng thực tế capu đang bị overload toàn hệ thống.

**Bằng chứng từ hệ thống:** `metrics-analyzer.md` — flag `OVERLOADED` chỉ kích hoạt khi `In Progress > 3` trong 1 project. Không có cross-project aggregation.

**Hậu quả thực tế:**
- Project A thấy capu có 2 tasks → OK
- Project B thấy capu có 2 tasks → OK
- Project C thấy capu có 2 tasks → OK
- Thực tế capu có 6 tasks In Progress → burnout, chất lượng giảm, deadline miss

**Giải pháp A — Cross-project workload report (thêm vào metrics-analyzer)**
Sau khi tính per-project, aggregate theo owner across all projects và flag nếu tổng In Progress > ngưỡng (ví dụ: 4 tasks).
- Cost: Thấp
- Time: 1 ngày (chỉ sửa logic trong `metrics-analyzer.md`)
- Quality impact: +++ (phát hiện được vấn đề mà hiện tại vô hình)

**Giải pháp B — Capacity file riêng**
Tạo `input/team-capacity.md` khai báo capacity từng người (ví dụ: capu = 3 tasks max, 80% sprint), `metrics-analyzer` đọc file này để tính utilization rate thay vì chỉ đếm số tasks.
- Cost: Trung bình
- Time: 2–3 ngày
- Quality impact: ++++ (chính xác hơn vì tính đến capacity thực, không chỉ đếm đầu task)

**Khuyến nghị:** Giải pháp A trước để có visibility ngay. Giải pháp B khi team đủ discipline để maintain capacity file.

---

## Vấn đề 3 — Pipeline chạy tuần tự, không scale với N projects

**Bản chất:** Pipeline hiện tại: `data-collector` đọc tất cả file trong `input/` → ghi 1 file `collected-*.md` → `metrics-analyzer` đọc file đó. Linear và đơn giản.

Khi có 5 projects, có 2 hệ quả xấu:
1. `collected-*.md` trở thành 1 file khổng lồ chứa tất cả — khó đọc, dễ lỗi khi parse
2. Nếu 1 project có dữ liệu lỗi (owner trống, date sai), toàn bộ pipeline bị ảnh hưởng

**Bằng chứng từ hệ thống:** `data-collector.md` rule — "Không bỏ qua dòng nào" nhưng không có error isolation. 1 file lỗi → cả `collected-*.md` có thể bị corrupted.

**Giải pháp A — Collected file per project**
`processed/collected-cardless-2026-04-12.md`, `processed/collected-enavi-2026-04-12.md`
Sau đó thêm 1 bước aggregate: `collected-summary-2026-04-12.md` chỉ chứa cross-project metrics.
- Cost: Trung bình
- Time: 2–3 ngày (refactor data-collector + metrics-analyzer)
- Quality impact: ++++ (error isolation, dễ debug per project)

**Giải pháp B — Error boundary trong data-collector**
Giữ nguyên 1 collected file nhưng nếu 1 project có lỗi → ghi rõ `[ERROR: project X — lý do]` và tiếp tục xử lý project còn lại, không dừng toàn bộ pipeline.
- Cost: Thấp
- Time: Nửa ngày
- Quality impact: ++ (không giải quyết vấn đề file khổng lồ nhưng ngăn được cascade failure)

**Khuyến nghị:** Giải pháp B ngay, Giải pháp A khi bắt đầu có > 3 projects.

---

## Vấn đề 4 — Report bị pha loãng, mất tính actionable

**Bản chất:** Hiện tại `reporter` tạo 1 sprint report duy nhất. Với 5 projects, report sẽ dài 5x và người đọc không biết nên focus vào đâu.

**Hậu quả:** Report trở thành tài liệu lưu trữ thay vì công cụ ra quyết định. Manager đọc xong không biết ngày mai phải làm gì trước.

**Giải pháp A — Executive summary report (ưu tiên cao)**
Thêm 1 loại output mới: `output/reports/YYYY-MM-DD-executive-summary.md`
Chỉ chứa: top 3 risks toàn hệ thống + 1 action per project cần làm ngay + cross-project resource conflict.
Tối đa 1 trang.
- Cost: Thấp (thêm template vào `reporter.md`)
- Time: 1 ngày
- Quality impact: ++++ (đây là thứ manager thực sự cần mỗi sáng)

**Giải pháp B — Report riêng per project + 1 summary**
`output/reports/2026-04-12-cardless.md` + `output/reports/2026-04-12-enavi.md` + `output/reports/2026-04-12-summary.md`
- Cost: Trung bình
- Time: 2 ngày
- Quality impact: ++++ (cho phép stakeholder khác nhau chỉ đọc report liên quan đến mình)

**Khuyến nghị:** Giải pháp A ngay (executive summary), Giải pháp B khi có stakeholder khác nhau cần nhận report khác nhau.

---

## Vấn đề 5 — Input discipline sẽ giảm theo số lượng team member

**Bản chất:** Với 1 project và 1 người (capu), việc maintain `input/sprint-1.md` còn manageable. Khi có 5 projects và 10+ người, chất lượng data input sẽ giảm: notes trống, status không cập nhật, deadline để mặc định YYYY-MM-DD.

**Bằng chứng từ hệ thống:** Sprint 16 hiện tại đã có vấn đề — T001 "In Progress" không có notes nào, không rõ tiến độ thực tế. Và đây mới chỉ có 1 người.

**Giải pháp A — Validation layer trong data-collector**
Tự động flag file nào có > 20% rows thiếu data bắt buộc (owner, status, due date) và từ chối process cho đến khi được fix.
- Cost: Thấp
- Time: Nửa ngày
- Quality impact: +++ (garbage in → garbage out, phải ngăn từ đầu)

**Giải pháp B — Weekly input reminder tích hợp**
Dùng `schedule` feature của Claude Code để tự động nhắc team update file input mỗi thứ Hai sáng.
- Cost: Thấp
- Time: 1 giờ setup
- Quality impact: ++ (phòng ngừa, không phải fix)

**Khuyến nghị:** Cả hai — A để có hard gate, B để giảm friction cho team.

---

## Lộ trình đề xuất

### Tuần này (low effort, high impact)
1. Thêm project prefix vào Task ID convention trong `_template.md` _(Vấn đề 1 — Giải pháp A)_
2. Thêm error boundary vào `data-collector` _(Vấn đề 3 — Giải pháp B)_
3. Thêm executive summary template vào `reporter` _(Vấn đề 4 — Giải pháp A)_

### Khi có project thứ 2
4. Thêm cross-project workload aggregation vào `metrics-analyzer` _(Vấn đề 2 — Giải pháp A)_
5. Thêm validation layer vào `data-collector` _(Vấn đề 5 — Giải pháp A)_

### Khi có 5+ projects
6. Migrate sang per-project collected files _(Vấn đề 3 — Giải pháp A)_
7. Tạo `input/team-capacity.md` _(Vấn đề 2 — Giải pháp B)_
8. Per-project reports + stakeholder routing _(Vấn đề 4 — Giải pháp B)_

---

## Câu hỏi cần trả lời trước khi implement

1. Bao nhiêu projects anh dự kiến quản lý đồng thời? (2–3 hay 10+?) → ảnh hưởng lớn đến lựa chọn kiến trúc
2. Các project có chung team member không, hay mỗi project có team riêng? → quyết định có cần cross-project workload không
3. Ai là người nhận report cuối — chỉ anh hay có stakeholder khác? → quyết định có cần per-project report routing không

---

_Generated by capy — 2026-04-12_
