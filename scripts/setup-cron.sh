#!/bin/bash
# Cài đặt crontab cho delivery-system auto-reporting
# Usage: bash scripts/setup-cron.sh
# Chạy lại script này để cập nhật lịch sau khi sửa config/schedule.json
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# Đọc config từ schedule.json
CONFIG="$PROJECT_DIR/config/schedule.json"
if [ ! -f "$CONFIG" ]; then
  echo "ERROR: $CONFIG không tồn tại"
  exit 1
fi

# Lấy cron expressions từ config (dùng python3 để parse JSON)
DAILY_CRON=$(python3 -c "import json; c=json.load(open('$CONFIG')); print(c['daily']['cron'])")
WEEKLY_TEAM_CRON=$(python3 -c "import json; c=json.load(open('$CONFIG')); print(c['weekly_team']['cron'])")
WEEKLY_EXEC_CRON=$(python3 -c "import json; c=json.load(open('$CONFIG')); print(c['weekly_exec']['cron'])")

DAILY_ENABLED=$(python3 -c "import json; c=json.load(open('$CONFIG')); print(str(c['daily']['enabled']).lower())")
WEEKLY_TEAM_ENABLED=$(python3 -c "import json; c=json.load(open('$CONFIG')); print(str(c['weekly_team']['enabled']).lower())")
WEEKLY_EXEC_ENABLED=$(python3 -c "import json; c=json.load(open('$CONFIG')); print(str(c['weekly_exec']['enabled']).lower())")

CLAUDE_PATH=$(which claude 2>/dev/null || echo "/usr/local/bin/claude")
LOG_DIR="$PROJECT_DIR/logs"
mkdir -p "$LOG_DIR"

echo "=== Delivery System Cron Setup ==="
echo "Project dir : $PROJECT_DIR"
echo "Claude path : $CLAUDE_PATH"
echo ""
echo "Lịch gửi báo cáo:"
echo "  Daily     : $DAILY_CRON (enabled=$DAILY_ENABLED)"
echo "  Weekly Team: $WEEKLY_TEAM_CRON (enabled=$WEEKLY_TEAM_ENABLED)"
echo "  Weekly Exec: $WEEKLY_EXEC_CRON (enabled=$WEEKLY_EXEC_ENABLED)"
echo ""

# Backup crontab hiện tại
BACKUP_FILE="/tmp/crontab-backup-$(date +%Y%m%d%H%M%S).txt"
crontab -l > "$BACKUP_FILE" 2>/dev/null || echo "" > "$BACKUP_FILE"
echo "Backup crontab hiện tại: $BACKUP_FILE"

# Xóa các dòng cũ của delivery-system và tạo mới
EXISTING=$(crontab -l 2>/dev/null || echo "")
NEW_CRON=$(echo "$EXISTING" | grep -v "delivery-system" || true)

# Thêm cron jobs mới theo config
if [ "$DAILY_ENABLED" = "true" ]; then
  NEW_CRON="$NEW_CRON
$DAILY_CRON cd $PROJECT_DIR && bash scripts/run-daily.sh >> $LOG_DIR/cron-daily.log 2>&1 # delivery-system daily"
fi

if [ "$WEEKLY_TEAM_ENABLED" = "true" ]; then
  NEW_CRON="$NEW_CRON
$WEEKLY_TEAM_CRON cd $PROJECT_DIR && bash scripts/run-weekly-team.sh >> $LOG_DIR/cron-weekly-team.log 2>&1 # delivery-system weekly-team"
fi

if [ "$WEEKLY_EXEC_ENABLED" = "true" ]; then
  NEW_CRON="$NEW_CRON
$WEEKLY_EXEC_CRON cd $PROJECT_DIR && bash scripts/run-weekly-exec.sh >> $LOG_DIR/cron-weekly-exec.log 2>&1 # delivery-system weekly-exec"
fi

# Cài đặt crontab mới
echo "$NEW_CRON" | crontab -

echo ""
echo "✓ Crontab đã được cập nhật. Kiểm tra:"
crontab -l | grep "delivery-system"
echo ""
echo "Để gỡ bỏ: crontab -e → xóa các dòng có '# delivery-system'"
echo "Log files: $LOG_DIR/"
