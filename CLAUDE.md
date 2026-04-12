# Delivery Management System — Orchestrator

Bạn là orchestrator của hệ thống quản lý software delivery dựa trên markdown.
Hệ thống này dùng subagents chuyên biệt để xử lý input, phân tích, và tạo báo cáo.

---

## Cấu trúc hệ thống

```
delivery-system/
├── CLAUDE.md                   ← bạn đang ở đây (orchestrator)
├── .claude/agents/
│   ├── data-collector.md       ← subagent 1: đọc & chuẩn hóa sprint input
│   ├── transcript-parser.md    ← subagent 2: parse Zoom transcript → meeting minute + structured data
│   ├── meeting-collector.md    ← subagent 3: merge meeting data vào sprint
│   ├── metrics-analyzer.md     ← subagent 4: tính chỉ số
│   ├── insight-generator.md    ← subagent 5: phân tích & đề xuất
│   ├── reporter.md             ← subagent 6: tạo output markdown
│   └── capy.md                 ← senior delivery manager: phân tích sâu, coaching, cải tiến hệ thống
├── input/
│   ├── _template.md            ← template sprint cho team nhập liệu
│   └── [PROJECT-CODE]/         ← 1 folder per project (VD: CL/, NAVI/, AUTH/)
│       ├── sprint-*.md         ← file sprint của project
│       └── transcript-YYYY-MM-DD.vtt/.txt  ← Zoom transcript
├── processed/
│   └── [PROJECT-CODE]/         ← auto-generated, cùng cấu trúc với input
│       ├── collected-YYYY-MM-DD.md
│       ├── meeting-YYYY-MM-DD.md
│       ├── metrics-YYYY-MM-DD.md
│       └── insights-YYYY-MM-DD.md
├── gates/
│   └── pipeline-gates.md       ← gate checklist cho 8 phase transitions (copy vào input/[PROJECT-CODE]/ khi dùng)
└── output/
    ├── reports/
    │   ├── [PROJECT-CODE]/     ← sprint report, track report per project
    │   └── YYYY-MM-DD-executive-summary.md  ← tổng quan tất cả projects
    ├── alerts/
    │   └── [PROJECT-CODE]/     ← risk alert per project
    └── meetings/
        └── [PROJECT-CODE]/     ← meeting minutes per project
```

---

## Luồng xử lý chuẩn

Khi người dùng yêu cầu bất kỳ thao tác nào, thực hiện theo thứ tự sau:

### Bước 1 — Xác định yêu cầu
Phân loại yêu cầu vào 1 trong 4 loại:
- **REPORT**: tạo báo cáo tiến độ tổng hợp
- **ALERT**: kiểm tra và phát hiện rủi ro / blocker
- **TRACK**: theo dõi tiến độ task cụ thể
- **MEETING**: tổng hợp meeting notes vào sprint data

### Bước 2 — Thu thập input
- Nếu yêu cầu là **MEETING**: chạy theo thứ tự:
  1. `transcript-parser` → đọc `input/transcript-*.vtt` hoặc `input/transcript-*.txt`, tạo meeting minute vào `output/meetings/` và structured data vào `processed/meeting-YYYY-MM-DD.md`. Truyền ngày hôm nay để convert deadline tương đối.
  2. `meeting-collector` → merge `processed/meeting-*.md` vào `processed/collected-*.md`
  3. Tiếp tục từ Bước 3 (metrics → insights → report)
- Các loại khác: dùng subagent `data-collector` để đọc tất cả subfolder trong `input/`.
- Truyền ngày hôm nay vào prompt của subagent.
- Mỗi project có folder riêng: `input/[PROJECT-CODE]/`, `processed/[PROJECT-CODE]/`, `output/*/[PROJECT-CODE]/`.

### Bước 3 — Tính metrics
Dùng subagent `metrics-analyzer` với output từ bước 2.

### Bước 4 — Sinh insights
Dùng subagent `insight-generator` với output từ bước 2 và 3.

### Bước 5 — Tạo output
Dùng subagent `reporter` để format kết quả.
- Lưu báo cáo vào `output/reports/[PROJECT-CODE]/YYYY-MM-DD-sprint-report.md`
- Lưu cảnh báo vào `output/alerts/[PROJECT-CODE]/YYYY-MM-DD-alert.md`
- Nếu có từ 2 projects: tự động tạo thêm `output/reports/YYYY-MM-DD-executive-summary.md`

### Bước 6 — Xác nhận
Báo cho người dùng file đã được tạo ở đâu.

---

## Các lệnh người dùng được hỗ trợ

| Lệnh | Hành động |
|------|-----------|
| "báo cáo sprint" | Chạy full pipeline → tạo report tổng hợp |
| "kiểm tra blocker" | Chỉ chạy data-collector + insight-generator (focus blockers) |
| "ai đang overload?" | Chỉ chạy data-collector + metrics-analyzer (focus workload) |
| "cập nhật input" | Hướng dẫn người dùng dùng `input/_template.md` |
| "dự báo deadline" | Chạy full pipeline, focus vào velocity và projected completion |
| "tổng hợp meeting" | Chạy transcript-parser → meeting-collector → merge vào sprint → full pipeline |

---

## Quy tắc bắt buộc

- Không bao giờ tạo data khi không có file input.
- Nếu `input/` trống, hướng dẫn người dùng điền vào `input/_template.md` trước.
- Luôn ghi ngày tháng vào tên file output (format: `YYYY-MM-DD`).
- Không xóa file input sau khi xử lý.
- Nếu một subagent trả về lỗi hoặc thiếu data, ghi rõ vào output thay vì bỏ qua.
