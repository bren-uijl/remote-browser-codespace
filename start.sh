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
    xfce4 \
    xfce4-terminal \
    xfce4-goodies \
    xterm \
    wget \
    curl \
    ca-certificates \
    fonts-liberation \
    libnss3 \
    libatk-bridge2.0-0t64 \
    libxss1 \
    libasound2t64 \
    libgbm1 \
    dbus-x11

echo "==> Google Chrome installeren..."
if ! command -v google-chrome-stable >/dev/null 2>&1 && ! command -v google-chrome >/dev/null 2>&1; then
    wget -q -O /tmp/chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt-get install -y /tmp/chrome.deb
    rm /tmp/chrome.deb
fi

CHROME_BIN="$(command -v google-chrome-stable || command -v google-chrome)"

echo "==> Oude processen opruimen..."
pkill -f "Xvfb :99" || true
pkill -f x11vnc || true
pkill -f xfce4-session || true
pkill -f xfwm4 || true
pkill -f websockify || true
pkill -f novnc_proxy || true
pkill -f google-chrome || true

sleep 1

echo "==> Virtueel scherm starten..."
nohup Xvfb :99 -screen 0 1280x800x24 >/tmp/xvfb.log 2>&1 &

sleep 2

echo "==> XFCE desktop starten..."
nohup startxfce4 >/tmp/xfce.log 2>&1 &

sleep 5

echo "==> Google Chrome starten..."
nohup "$CHROME_BIN" \
    --no-sandbox \
    --disable-dev-shm-usage \
    --disable-gpu \
    --window-size=1280,800 \
    --start-maximized \
    "https://example.com" \
    >/tmp/chrome.log 2>&1 &

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
echo "=============================="
echo " Vink🦉 — alles draait!"
echo "=============================="
echo " Open het PORTS tabblad"
echo " en klik op poort 6080"
echo "=============================="
echo
echo "Logs:"
echo "  /tmp/xvfb.log"
echo "  /tmp/xfce.log"
echo "  /tmp/chrome.log"
echo "  /tmp/x11vnc.log"
echo "  /tmp/novnc.log"

wait
