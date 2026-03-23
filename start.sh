#!/usr/bin/env bash
set -e

export DEBIAN_FRONTEND=noninteractive
export DISPLAY=:99

echo "==> Packages installeren..."
sudo apt-get update

sudo apt-get install -y \
    xvfb \
    x11vnc \
    novnc \
    websockify \
    fluxbox \
    xterm \
    wget \
    curl \
    ca-certificates \
    fonts-liberation \
    libnss3 \
    libatk-bridge2.0-0 \
    libxss1 \
    libasound2 \
    libgbm1

echo "==> Chromium installeren..."
if ! command -v chromium >/dev/null 2>&1 && ! command -v chromium-browser >/dev/null 2>&1; then
    sudo apt-get install -y chromium || sudo apt-get install -y chromium-browser
fi

CHROME_BIN="$(command -v chromium || command -v chromium-browser)"

echo "==> Oude processen opruimen..."
pkill -f "Xvfb :99" || true
pkill -f x11vnc || true
pkill -f fluxbox || true
pkill -f websockify || true
pkill -f novnc_proxy || true
pkill -f chromium || true
pkill -f chromium-browser || true

echo "==> Virtueel scherm starten..."
nohup Xvfb :99 -screen 0 1280x720x24 >/tmp/xvfb.log 2>&1 &

sleep 2

echo "==> Window manager starten..."
nohup fluxbox >/tmp/fluxbox.log 2>&1 &

sleep 2

echo "==> Chromium starten..."
nohup "$CHROME_BIN" \
    --no-sandbox \
    --disable-dev-shm-usage \
    --disable-gpu \
    --window-size=1280,720 \
    --start-maximized \
    "https://example.com" \
    >/tmp/chromium.log 2>&1 &

sleep 3

echo "==> x11vnc starten..."
nohup x11vnc \
    -display :99 \
    -forever \
    -shared \
    -nopw \
    -rfbport 5900 \
    >/tmp/x11vnc.log 2>&1 &

sleep 2

echo "==> noVNC starten op poort 6080..."
if [ -f /usr/share/novnc/utils/novnc_proxy ]; then
    nohup /usr/share/novnc/utils/novnc_proxy \
        --vnc localhost:5900 \
        --listen 6080 \
        >/tmp/novnc.log 2>&1 &
else
    nohup websockify \
        --web /usr/share/novnc/ \
        6080 \
        localhost:5900 \
        >/tmp/novnc.log 2>&1 &
fi

sleep 2

echo
echo "Klaar."
echo "Open in Codespaces het PORTS-tabblad en open poort 6080."
echo
echo "Logs:"
echo "  /tmp/xvfb.log"
echo "  /tmp/fluxbox.log"
echo "  /tmp/chromium.log"
echo "  /tmp/x11vnc.log"
echo "  /tmp/novnc.log"

# Handig: proces levend houden in de terminal
wait
