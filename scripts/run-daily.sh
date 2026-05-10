=== Daily Pipeline START: Sat Apr 25 09:15:13 +07 2026 ===                                                                                         
ERROR: /Users/phungnguyen/Downloads/delivery-system/config/channels.env không tồn tại. Chạy: cp config/channels.env.example config/channels.env#!/bin/bash
# Daily report pipeline — chạy mỗi sáng, gửi Team channel
# Trigger: cron "30 8 * * 1-5" (08:30 Mon-Fri)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
DATE=$(date +%Y-%m-%d)
LOG_FILE="$PROJECT_DIR/logs/run-daily-$DATE.log"

mkdir -p "$PROJECT_DIR/logs"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "=== Daily Pipeline START: $(date) ==="

# Load webhook URLs
ENV_FILE="$PROJECT_DIR/config/channels.env"
if [ ! -f "$ENV_FILE" ]; then
  echo "ERROR: $ENV_FILE không tồn tại. Chạy: cp config/channels.env.example config/channels.env"
  exit 1
fi
source "$ENV_FILE"

# Kiểm tra webhook URL
if [ -z "${TEAMS_WEBHOOK_TEAM:-}" ] || [[ "$TEAMS_WEBHOOK_TEAM" == *"URL_HERE"* ]]; then
  echo "ERROR: TEAMS_WEBHOOK_TEAM chưa được cấu hình trong config/channels.env"
  exit 1
fi

cd "$PROJECT_DIR"

# Bước 1: Chạy pipeline tạo báo cáo
echo "[1/3] Chạy Claude pipeline (daily executive summary)..."
claude --print "báo cáo sprint daily $DATE - tạo executive summary ngắn gọn cho standup buổi sáng" \
  --allowedTools "Read,Write,Glob,Grep,Agent" 2>&1 || {
    echo "WARNING: Claude pipeline có lỗi, tiếp tục với file có sẵn nếu tồn tại"
  }

# Bước 2: Tìm file report vừa tạo
REPORT_FILE="$PROJECT_DIR/output/reports/$DATE-executive-summary.md"
if [ ! -f "$REPORT_FILE" ]; then
  # Thử tìm file gần nhất
  REPORT_FILE=$(ls -t "$PROJECT_DIR/output/reports/"*executive-summary.md 2>/dev/null | head -1 || true)
fi

if [ -z "$REPORT_FILE" ] || [ ! -f "$REPORT_FILE" ]; then
  echo "ERROR: Không tìm thấy executive summary report"
  exit 1
fi
echo "[1/3] Report: $REPORT_FILE"

# Bước 3: Format Teams payload
PAYLOAD_FILE="$PROJECT_DIR/processed/teams-payload-daily-$DATE.json"
echo "[2/3] Format Teams message (daily)..."
claude --print "format file '$REPORT_FILE' thành Teams payload daily, ghi ra '$PAYLOAD_FILE', ngày $DATE" \
  --allowedTools "Read,Write" 2>&1

if [ ! -f "$PAYLOAD_FILE" ]; then
  echo "ERROR: Không tạo được payload file"
  exit 1
fi

# Bước 4: POST lên Teams
echo "[3/3] Gửi lên Teams (Team channel)..."
python3 "$SCRIPT_DIR/send-to-teams.py" "$PAYLOAD_FILE" "$TEAMS_WEBHOOK_TEAM"

echo "=== Daily Pipeline DONE: $(date) ==="
