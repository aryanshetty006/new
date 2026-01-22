#!/bin/bash
set -e

echo "🚀 Starting Kali with ttyd"

# 🔧 Configure terminal for proper key handling (backspace, arrow keys)
export TERM=xterm-256color
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
stty erase ^H 2>/dev/null || stty erase ^? 2>/dev/null || true

# ⏳ Brief delay to prevent ttyd race
sleep 2

# ✅ Verify that the port is available before starting ttyd
if lsof -i :"${HOST_PORT}" &>/dev/null; then
  echo "🛑 Port ${HOST_PORT} already in use, exiting."
  exit 1
fi

touch /home/kali/.hushlogin
chown kali:kali /home/kali/.hushlogin

# 🖥️ Launch ttyd
echo "🖥️  Launching ttyd on host port ${HOST_PORT}"
exec su - kali -c "ttyd -p ${HOST_PORT} \
  --base-path /ttyd \
  --url-arg \
  --writable \
  --client-option 'terminal=xterm-256color' \
  /bin/bash -l"