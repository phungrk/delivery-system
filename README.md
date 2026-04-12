# Delivery Management System — Hướng dẫn sử dụng

Hệ thống quản lý software delivery dựa hoàn toàn trên markdown, chạy bằng Claude Code.

---

## Cài đặt

```bash
# 1. Cài Claude Code (nếu chưa có)
npm install -g @anthropic-ai/claude-code

# 2. Vào thư mục hệ thống
cd delivery-system

# 3. Chạy Claude Code
claude
```

Claude Code sẽ tự động đọc `CLAUDE.md` và load 4 subagents từ `.claude/agents/`.

---

## Cách team nhập liệu

```bash
# Copy template
cp input/_template.md input/sprint-15.md

# Mở và điền vào
# (dùng bất kỳ editor nào: VS Code, vim, Obsidian...)
```

Điền đầy đủ:
- Bảng Tasks với status chuẩn: `Done` / `In Progress` / `Not Started` / `Blocked`
- Section Blockers khi có vấn đề
- Section Decisions khi có quyết định quan trọng

---

## Các lệnh sử dụng

Sau khi chạy `claude` trong thư mục này, gõ tự nhiên:

```
"báo cáo sprint"
→ Tạo sprint report đầy đủ

"kiểm tra blocker"
→ Liệt kê và phân tích tất cả blockers

"ai đang overload?"
→ Phân tích workload theo từng người

"dự báo deadline"
→ Ước tính khả năng xong đúng hạn

"cập nhật input"
→ Hướng dẫn cách nhập data mới
```

---

## Cấu trúc thư mục

```
delivery-system/
│
├── CLAUDE.md                    # Orchestrator — não bộ hệ thống
│
├── .claude/agents/
│   ├── data-collector.md        # Đọc & chuẩn hóa input (model: haiku)
│   ├── metrics-analyzer.md      # Tính KPIs và risk score (model: sonnet)
│   ├── insight-generator.md     # Phân tích & đề xuất (model: sonnet)
│   └── reporter.md              # Tạo output markdown (model: haiku)
│
├── input/
│   ├── _template.md             # Template — team copy file này
│   └── sprint-15.md             # Ví dụ file team đã điền
│
├── processed/                   # Auto-generated — đừng chỉnh tay
│   ├── collected-2024-01-15.md
│   ├── metrics-2024-01-15.md
│   └── insights-2024-01-15.md
│
└── output/
    ├── reports/                 # Báo cáo tổng hợp
    │   └── 2024-01-15-sprint-report.md
    └── alerts/                  # Cảnh báo rủi ro
        └── 2024-01-15-alert.md
```

---

## Luồng xử lý tự động

```
Team nhập input/sprint-X.md
        ↓
[data-collector]  đọc & chuẩn hóa → processed/collected-*.md
        ↓
[metrics-analyzer] tính KPIs → processed/metrics-*.md
        ↓
[insight-generator] phân tích → processed/insights-*.md
        ↓
[reporter] tổng hợp → output/reports/*.md
                    → output/alerts/*.md (nếu risk >= 5)
```

---

## Mô hình được dùng

| Agent | Model | Lý do |
|-------|-------|-------|
| data-collector | haiku | Tác vụ đơn giản, cần nhanh |
| metrics-analyzer | sonnet | Tính toán phức tạp hơn |
| insight-generator | sonnet | Cần reasoning tốt |
| reporter | haiku | Format output, không cần reasoning sâu |

---

## Tips

- Cập nhật file input hàng ngày để báo cáo chính xác nhất
- Đừng chỉnh tay file trong `processed/` — sẽ bị ghi đè
- Commit toàn bộ thư mục vào Git để có lịch sử delivery theo thời gian
- Có thể chạy `claude --print "báo cáo sprint"` để lấy output không interactive
