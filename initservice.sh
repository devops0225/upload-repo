[12:27 AM, 5/10/2025] Sravanthi Canada: #!/bin/bash

NEW_VALUE="$1"
CONFIG_FILE="$2"

ESCAPED_VALUE=$(printf '%s\n' "$NEW_VALUE" | sed -e 's/[&/\]/\\&/g')
sed -i "s|^dps\.endpoint=.*|dps.endpoint=${ESCAPED_VALUE}|" "$CONFIG_FILE"
[9:49 AM, 5/10/2025] Sravanthi Canada: #!/bin/bash

#!/bin/bash

SERVICE_NAME="wot-consumer-cif"
SERVER_NAME="wot-consumer-cif-server"
JAR_PATH="/opt/batch/$SERVER_NAME"
PID_PATH="/tmp/${SERVICE_NAME}.pid"
CONFIG_DIR="/usI/share/wcom/${SERVICE_NAME}/conf"
LOG_FILE="/td/logs/wot/${SERVICE_NAME}.log"
INIT_SCRIPT="/etc/init.d/$SERVICE_NAME"

echo "Stopping service if running..."
if [ -f "$PID_PATH" ]; then
  PID=$(cat "$PID_PATH")
  echo "Killing process $PID..."
  sudo kill -9 "$PID" && echo "Process $PID killed."
  sudo rm -f "$PID_PATH"
else
  echo "No PID file found at $PID_PATH. Service may not be running."
fi

echo "Disabling service and removing symlinks..."
# Disable the service using chkconfig
if command -v chkconfig >/dev/null 2>&1; then
  sudo chkconfig --del "$SERVICE_NAME"
  echo "Service $SERVICE_NAME disabled from runlevels."
else
  echo "chkconfig command not found. Skipping service removal from runlevels."
fi

# Remove symlinks from rc directories
echo "Removing symlinks from rc*.d directories..."
sudo find /etc/rc*.d/ -name "*$SERVICE_NAME" -exec rm -v {} \;

echo "Removing init script..."
if [ -f "$INIT_SCRIPT" ]; then
  sudo rm -f "$INIT_SCRIPT"
  echo "Init script $INIT_SCRIPT removed."
else
  echo "Init script not found at $INIT_SCRIPT"
fi

echo "Removing application files..."
sudo rm -rf "$JAR_PATH"
sudo rm -rf "$CONFIG_DIR"
sudo rm -f "$LOG_FILE"

echo "Final cleanup of stray PID files..."
sudo rm -f "$PID_PATH"

# Additional cleanup of known temporary files
EXTRA_TMP_FILES=("/tmp/latestpid.pod" "/tmp/${SERVICE_NAME}")
echo "Cleaning up extra temporary files..."
for file in "${EXTRA_TMP_FILES[@]}"; do
  if [ -e "$file" ]; then
    echo "Removing $file..."
    sudo rm -rf "$file"
  else
    echo "File $file does not exist, skipping."
  fi
done

echo "Service $SERVICE_NAME has been completely removed."

exit 0
