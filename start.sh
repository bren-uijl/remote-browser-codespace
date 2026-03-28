#!/usr/bin/env bash
set -e

export DISPLAY=:99
CHROME_BIN="$(command -v google-chrome-stable || command -v google-chrome)"

echo "==> Cleaning up old processes..."
pkill -f "Xvfb :99" || true
pkill -f x11vnc || true
pkill -f xfce4-session || true
pkill -f xfwm4 || true
pkill -f websockify || true
pkill -f novnc_proxy || true
pkill -f google-chrome || true

sleep 1

echo "==> Starting virtual display..."
nohup Xvfb :99 -screen 0 1280x800x24 >/tmp/xvfb.log 2>&1 &

sleep 2

echo "==> Starting XFCE desktop..."
nohup startxfce4 >/tmp/xfce.log 2>&1 &

sleep 4

echo "==> Starting Google Chrome..."
nohup "$CHROME_BIN" \
    --no-sandbox \
    --disable-dev-shm-usage \
    --disable-gpu \
    --window-size=1280,800 \
    --start-maximized \
    "https://example.com" \
    >/tmp/chrome.log 2>&1 &

sleep 2

echo "==> Starting x11vnc..."
nohup x11vnc \
    -display :99 \
    -forever \
    -shared \
    -nopw \
    -rfbport 5900 \
    >/tmp/x11vnc.log 2>&1 &

sleep 2

echo "==> Starting noVNC on port 6080..."
# On Render, listen on 0.0.0.0 so the port is reachable externally
# On Codespaces, localhost is fine
if [ -n "$RENDER" ]; then
    LISTEN="0.0.0.0:6080"
else
    LISTEN="6080"
fi

if [ -f /usr/share/novnc/utils/novnc_proxy ]; then
    nohup /usr/share/novnc/utils/novnc_proxy \
        --vnc localhost:5900 \
        --listen $LISTEN \
        >/tmp/novnc.log 2>&1 &
else
    nohup websockify \
        --web /usr/share/novnc/ \
        $LISTEN \
        localhost:5900 \
        >/tmp/novnc.log 2>&1 &
fi

sleep 2

echo
echo "=============================="
echo " Vink🦉 — everything is up!"
echo "=============================="
echo " Open the PORTS tab and"
echo " click on port 6080"
echo "=============================="
echo
echo "Logs:"
echo "  /tmp/xvfb.log"
echo "  /tmp/xfce.log"
echo "  /tmp/chrome.log"
echo "  /tmp/x11vnc.log"
echo "  /tmp/novnc.log"

wait
