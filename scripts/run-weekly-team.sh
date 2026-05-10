#!/bin/bash
# Weekly sprint report pipeline — gửi Team channel vào chiều thứ 6
# Trigger: cron "0 17 * * 5" (17:00 Friday)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
DATE=$(date +%Y-%m-%d)
LOG_FILE="$PROJECT_DIR/logs/run-weekly-team-$DATE.log"

mkdir -p "$PROJECT_DIR/logs"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "=== Weekly Team Pipeline START: $(date) ==="

# Load webhook URLs
ENV_FILE="$PROJECT_DIR/config/channels.env"
if [ ! -f "$ENV_FILE" ]; then
  echo "ERROR: $ENV_FILE không tồn tại. Chạy: cp config/channels.env.example config/channels.env"
  exit 1
fi
source "$ENV_FILE"

if [ -z "${TEAMS_WEBHOOK_TEAM:-}" ] || [[ "$TEAMS_WEBHOOK_TEAM" == *"URL_HERE"* ]]; then
  echo "ERROR: TEAMS_WEBHOOK_TEAM chưa được cấu hình trong config/channels.env"
  exit 1
fi

cd "$PROJECT_DIR"

# Bước 1: Chạy full pipeline — sprint report từng project + executive summary
echo "[1/3] Chạy Claude pipeline (full weekly sprint report)..."
claude --print "báo cáo sprint tuần $DATE - tạo sprint report đầy đủ cho tất cả projects và executive summary" \
  --allowedTools "Read,Write,Glob,Grep,Agent" 2>&1 || {
    echo "WARNING: Claude pipeline có lỗi, tiếp tục với file có sẵn"
  }

# Bước 2: Format Teams payload (dùng executive summary làm base)
REPORT_FILE="$PROJECT_DIR/output/reports/$DATE-executive-summary.md"
if [ ! -f "$REPORT_FILE" ]; then
  REPORT_FILE=$(ls -t "$PROJECT_DIR/output/reports/"*executive-summary.md 2>/dev/null | head -1 || true)
fi

if [ -z "$REPORT_FILE" ] || [ ! -f "$REPORT_FILE" ]; then
  echo "ERROR: Không tìm thấy executive summary report"
  exit 1
fi
echo "[1/3] Report: $REPORT_FILE"

PAYLOAD_FILE="$PROJECT_DIR/processed/teams-payload-weekly-team-$DATE.json"
echo "[2/3] Format Teams message (weekly_team)..."
claude --print "format file '$REPORT_FILE' thành Teams payload weekly_team, ghi ra '$PAYLOAD_FILE', ngày $DATE" \
  --allowedTools "Read,Write" 2>&1

if [ ! -f "$PAYLOAD_FILE" ]; then
  echo "ERROR: Không tạo được payload file"
  exit 1
fi

# Bước 3: POST lên Teams
echo "[3/3] Gửi lên Teams (Team channel)..."
python3 "$SCRIPT_DIR/send-to-teams.py" "$PAYLOAD_FILE" "$TEAMS_WEBHOOK_TEAM"

echo "=== Weekly Team Pipeline DONE: $(date) ==="
