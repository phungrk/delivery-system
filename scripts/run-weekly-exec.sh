#!/bin/bash
# Weekly executive summary pipeline — gửi Stakeholder channel vào sáng thứ 2
# Trigger: cron "0 9 * * 1" (09:00 Monday)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
DATE=$(date +%Y-%m-%d)
LOG_FILE="$PROJECT_DIR/logs/run-weekly-exec-$DATE.log"

mkdir -p "$PROJECT_DIR/logs"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "=== Weekly Exec Pipeline START: $(date) ==="

# Load webhook URLs
ENV_FILE="$PROJECT_DIR/config/channels.env"
if [ ! -f "$ENV_FILE" ]; then
  echo "ERROR: $ENV_FILE không tồn tại. Chạy: cp config/channels.env.example config/channels.env"
  exit 1
fi
source "$ENV_FILE"

if [ -z "${TEAMS_WEBHOOK_STAKEHOLDER:-}" ] || [[ "$TEAMS_WEBHOOK_STAKEHOLDER" == *"URL_HERE"* ]]; then
  echo "ERROR: TEAMS_WEBHOOK_STAKEHOLDER chưa được cấu hình trong config/channels.env"
  exit 1
fi

cd "$PROJECT_DIR"

# Bước 1: Chạy pipeline — chỉ cần executive summary
echo "[1/3] Chạy Claude pipeline (executive summary for stakeholders)..."
claude --print "báo cáo sprint $DATE - tạo executive summary tổng hợp tất cả projects cho stakeholders, ngắn gọn, không technical details" \
  --allowedTools "Read,Write,Glob,Grep,Agent" 2>&1 || {
    echo "WARNING: Claude pipeline có lỗi, tiếp tục với file có sẵn"
  }

# Bước 2: Format Teams payload (executive format — ngắn nhất)
REPORT_FILE="$PROJECT_DIR/output/reports/$DATE-executive-summary.md"
if [ ! -f "$REPORT_FILE" ]; then
  REPORT_FILE=$(ls -t "$PROJECT_DIR/output/reports/"*executive-summary.md 2>/dev/null | head -1 || true)
fi

if [ -z "$REPORT_FILE" ] || [ ! -f "$REPORT_FILE" ]; then
  echo "ERROR: Không tìm thấy executive summary report"
  exit 1
fi
echo "[1/3] Report: $REPORT_FILE"

PAYLOAD_FILE="$PROJECT_DIR/processed/teams-payload-weekly-exec-$DATE.json"
echo "[2/3] Format Teams message (weekly_exec — stakeholder format)..."
claude --print "format file '$REPORT_FILE' thành Teams payload weekly_exec cho stakeholders, ghi ra '$PAYLOAD_FILE', ngày $DATE" \
  --allowedTools "Read,Write" 2>&1

if [ ! -f "$PAYLOAD_FILE" ]; then
  echo "ERROR: Không tạo được payload file"
  exit 1
fi

# Bước 3: POST lên Teams stakeholder channel
echo "[3/3] Gửi lên Teams (Stakeholder channel)..."
python3 "$SCRIPT_DIR/send-to-teams.py" "$PAYLOAD_FILE" "$TEAMS_WEBHOOK_STAKEHOLDER"

echo "=== Weekly Exec Pipeline DONE: $(date) ==="
