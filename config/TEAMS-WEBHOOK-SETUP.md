# Hướng dẫn tạo Teams Incoming Webhook

## Bước 1 — Tạo Webhook cho Team Channel

1. Mở **Microsoft Teams** → vào channel muốn nhận báo cáo (VD: `#delivery-updates`)
2. Click `···` (More options) bên cạnh tên channel → chọn **Connectors** hoặc **Manage channel**
3. Tìm **Incoming Webhook** → click **Configure** (hoặc **Add** nếu chưa có)
4. Đặt tên: `Delivery Bot`
5. (Tuỳ chọn) Upload ảnh icon cho bot
6. Click **Create**
7. **Copy URL** hiển thị — dạng:
   ```
   https://xxx.webhook.office.com/webhookb2/yyy@zzz/IncomingWebhook/aaa/bbb
   ```
8. Click **Done**

> **Lưu ý:** Nếu không thấy Connectors, admin Teams có thể đã tắt. Liên hệ IT admin để bật lại,
> hoặc dùng **Power Automate** như hướng dẫn bên dưới.

---

## Bước 2 — Tạo Webhook cho Stakeholder Channel

Lặp lại **Bước 1** cho channel stakeholders (VD: `#project-updates`).
Lưu URL thứ 2 riêng — đây là `TEAMS_WEBHOOK_STAKEHOLDER`.

---

## Bước 3 — Điền URL vào channels.env

```bash
cd /Users/phungnguyen/Downloads/delivery-system
cp config/channels.env.example config/channels.env
```

Mở `config/channels.env` và điền URL vừa copy:

```bash
TEAMS_WEBHOOK_TEAM=https://xxx.webhook.office.com/webhookb2/TEAM_URL
TEAMS_WEBHOOK_STAKEHOLDER=https://xxx.webhook.office.com/webhookb2/STAKEHOLDER_URL
TEAMS_BOT_NAME=Delivery Bot
DELIVERY_SYSTEM_DIR=/Users/phungnguyen/Downloads/delivery-system
```

---

## Bước 4 — Test webhook (không cần Claude)

```bash
# Test Team channel
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{"text": "✅ Test từ Delivery System — webhook hoạt động!"}' \
  "$(grep TEAMS_WEBHOOK_TEAM config/channels.env | cut -d= -f2)"

# Test Stakeholder channel
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{"text": "✅ Test từ Delivery System — webhook hoạt động!"}' \
  "$(grep TEAMS_WEBHOOK_STAKEHOLDER config/channels.env | cut -d= -f2)"
```

Nếu thấy tin nhắn xuất hiện trong Teams → webhook OK.

---

## Bước 5 — Test full pipeline

```bash
# Test daily report (chạy pipeline + gửi Teams)
bash scripts/run-daily.sh

# Xem log
tail -f logs/run-daily-$(date +%Y-%m-%d).log
```

---

## Bước 6 — Cài cron tự động

```bash
bash scripts/setup-cron.sh
```

Xác nhận crontab:

```bash
crontab -l | grep delivery-system
# Kết quả mong đợi:
# 30 8 * * 1-5 cd /path/... && bash scripts/run-daily.sh ... # delivery-system daily
# 0 17 * * 5  cd /path/... && bash scripts/run-weekly-team.sh ... # delivery-system weekly-team
# 0 9 * * 1   cd /path/... && bash scripts/run-weekly-exec.sh ... # delivery-system weekly-exec
```

---

## Nếu Teams admin đã tắt Connectors → Dùng Power Automate

1. Vào [make.powerautomate.com](https://make.powerautomate.com)
2. **Create** → **Instant cloud flow** → trigger: **When an HTTP request is received**
3. Thêm action: **Post message in a chat or channel** (Teams connector)
4. Lưu flow → copy **HTTP POST URL** → dùng URL này thay cho webhook URL
5. Format body: `{"text": "@{triggerBody()?['text']}"` }

---

## Troubleshooting

| Lỗi | Nguyên nhân | Fix |
|-----|-------------|-----|
| `HTTP 400` | JSON payload sai format | Kiểm tra `processed/teams-payload-*.json` |
| `HTTP 403` | Webhook URL sai hoặc hết hạn | Tạo lại webhook trong Teams |
| `Network error` | Máy không có internet | Kiểm tra kết nối |
| `Report not found` | Pipeline chưa tạo được report | Chạy tay `báo cáo sprint` trong Claude trước |
| Tin nhắn không hiện | Sai channel | Kiểm tra lại URL trong channels.env |
