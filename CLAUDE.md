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
│   ├── teams-sender.md         ← subagent 7: format report → Teams MessageCard JSON
│   └── capy.md                 ← senior delivery manager: phân tích sâu, coaching, cải tiến hệ thống
├── config/
│   ├── schedule.json           ← lịch gửi báo cáo (cron expression, enable/disable)
│   ├── channels.env            ← Teams webhook URLs (KHÔNG commit — xem .gitignore)
│   └── channels.env.example    ← template để setup channels.env
├── scripts/
│   ├── run-daily.sh            ← pipeline daily report → Teams (Team channel)
│   ├── run-weekly-team.sh      ← pipeline weekly report → Teams (Team channel)
│   ├── run-weekly-exec.sh      ← pipeline executive summary → Teams (Stakeholder channel)
│   ├── send-to-teams.py        ← HTTP POST payload JSON lên Teams webhook
│   └── setup-cron.sh           ← cài đặt crontab từ schedule.json
├── logs/                       ← log files từ cron jobs (auto-created)
├── input/
│   ├── _template.md            ← template sprint cho team nhập liệu
│   └── [Domain]/               ← domain nhóm dự án (CA, eNV, Corp, Others)
│       └── [PROJECT-CODE]/     ← 1 folder per project (VD: eNV/CL/, Others/HAYK/)
│           ├── project-tracking.md  ← tracking file của project
│           ├── timelog.md      ← time log riêng biệt (auto-managed)
│           └── transcript-YYYY-MM-DD.vtt/.txt
├── processed/
│   └── [Domain]/               ← cùng cấu trúc với input
│       └── [PROJECT-CODE]/
│           ├── collected-YYYY-MM-DD.md
│           ├── meeting-YYYY-MM-DD.md
│           ├── metrics-YYYY-MM-DD.md
│           └── insights-YYYY-MM-DD.md
├── gates/
│   └── pipeline-gates.md       ← gate checklist cho 8 phase transitions
└── output/
    ├── reports/
    │   ├── [Domain]/
    │   │   └── [PROJECT-CODE]/ ← sprint report per project
    │   └── YYYY-MM-DD-executive-summary.md
    ├── alerts/
    │   └── [Domain]/
    │       └── [PROJECT-CODE]/ ← risk alert per project
    └── meetings/
        └── [Domain]/
            └── [PROJECT-CODE]/ ← meeting minutes per project
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
  1. `transcript-parser` → đọc `input/[Domain]/[CODE]/transcript-*.vtt/.txt`, tạo meeting minute vào `output/meetings/[Domain]/[CODE]/` và structured data vào `processed/[Domain]/[CODE]/meeting-YYYY-MM-DD.md`. Truyền ngày hôm nay để convert deadline tương đối.
  2. `meeting-collector` → merge `processed/[Domain]/[CODE]/meeting-*.md` vào `processed/[Domain]/[CODE]/collected-*.md`
  3. Tiếp tục từ Bước 3 (metrics → insights → report)
- Các loại khác: dùng subagent `data-collector` để đọc tất cả `input/[Domain]/[PROJECT-CODE]/`.
- Truyền ngày hôm nay vào prompt của subagent.
- Mỗi project có folder riêng: `input/[Domain]/[CODE]/`, `processed/[Domain]/[CODE]/`, `output/*/[Domain]/[CODE]/`.

### Bước 3 — Tính metrics
Dùng subagent `metrics-analyzer` với output từ bước 2.

### Bước 4 — Sinh insights
Dùng subagent `insight-generator` với output từ bước 2 và 3.

### Bước 5 — Tạo output
Dùng subagent `reporter` để format kết quả.
- Lưu báo cáo vào `output/reports/[Domain]/[CODE]/YYYY-MM-DD-sprint-report.md`
- Lưu cảnh báo vào `output/alerts/[Domain]/[CODE]/YYYY-MM-DD-alert.md`
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
| "gửi báo cáo Teams" | Chạy pipeline → teams-sender → POST lên Teams (cần channels.env) |
| "test gửi daily" | Chạy pipeline daily + format Teams payload + hỏi confirm trước khi POST |

---

## Luồng tự động gửi Teams

### Cấu trúc pipeline Teams

```
[cron / /schedule]
       │
       ▼
run-daily.sh / run-weekly-team.sh / run-weekly-exec.sh
       │
       ├─[1]─ claude --print "báo cáo sprint..." → tạo report files
       ├─[2]─ claude --print "format Teams payload..." → teams-sender agent
       │                                                  └─ ghi processed/teams-payload-*.json
       └─[3]─ python3 send-to-teams.py <payload> <webhook_url>
                └─ HTTP POST → Teams Incoming Webhook
```

### Cách bật/tắt từng loại báo cáo

Sửa `config/schedule.json` → đổi `"enabled": true/false` → chạy lại `bash scripts/setup-cron.sh`

### Cách thay đổi giờ gửi

Sửa `"cron"` trong `config/schedule.json` → chạy lại `bash scripts/setup-cron.sh`

Ví dụ cron:
- `"30 8 * * 1-5"` = 08:30 thứ 2–6
- `"0 9 * * 1"` = 09:00 thứ 2
- `"0 17 * * 5"` = 17:00 thứ 6

### Test nhanh trước khi cài cron

```bash
# Test gửi daily (1 lần)
bash scripts/run-daily.sh

# Test gửi weekly team
bash scripts/run-weekly-team.sh

# Test gửi weekly exec (stakeholders)
bash scripts/run-weekly-exec.sh
```

### Setup cron tự động

```bash
# Bước 1: Copy và điền webhook URLs
cp config/channels.env.example config/channels.env
# → Sửa TEAMS_WEBHOOK_TEAM và TEAMS_WEBHOOK_STAKEHOLDER

# Bước 2: Cài crontab
bash scripts/setup-cron.sh

# Xem cron jobs đã cài
crontab -l | grep delivery-system
```

---

## Quy tắc bắt buộc

- Không bao giờ tạo data khi không có file input.
- Nếu `input/` trống, hướng dẫn người dùng điền vào `input/_template.md` trước.
- Luôn ghi ngày tháng vào tên file output (format: `YYYY-MM-DD`).
- Không xóa file input sau khi xử lý.
- Nếu một subagent trả về lỗi hoặc thiếu data, ghi rõ vào output thay vì bỏ qua.
