# 🦉 Remote Browser Codespace

A full **Ubuntu XFCE desktop** with Google Chrome — running inside your browser via GitHub Codespaces and noVNC. No installation required.

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/bren-uijl/remote-browser-codespace)

---

## 🚀 Quick start

1. Click the button above — **Open in GitHub Codespaces**
2. Wait for the container to build (~3 minutes the first time, fast after that)
3. Go to the **Ports** tab in VS Code or the Codespace interface
4. Click the link next to port **6080** → the full Ubuntu desktop opens in your browser

> 💡 Port 6080 is set to `public`, so you can share the link with others.

---

## 🧩 What's included?

| Component | Purpose |
|-----------|---------|
| `Xvfb` | Virtual display (no physical monitor needed) |
| `XFCE4` | Full Ubuntu desktop environment |
| `xfce4-goodies` | Extra apps: text editor, screenshot tool, etc. |
| `Google Chrome` | The browser you control |
| `x11vnc` | VNC server on port 5900 |
| `noVNC` | VNC → browser bridge on port **6080** |

---

## 🛠️ Restart manually

If the desktop freezes or you want to restart:

```bash
./start.sh
```

Or kill everything first:

```bash
pkill -f "Xvfb|x11vnc|xfce|websockify|novnc|chrome" ; ./start.sh
```

---

## 📁 Structure

```
.
├── .devcontainer/
│   ├── devcontainer.json   # Codespace configuration
│   └── Dockerfile          # Pre-installs everything (fast startup)
├── start.sh                # Starts XFCE, Chrome and noVNC
└── README.md
```

---

## 🪲 Troubleshooting

| Problem | Solution |
|---------|----------|
| 502 Bad Gateway on port 6080 | Run `./start.sh` in the terminal |
| Black screen | Wait 5 seconds and refresh |
| Chrome won't start | Type `google-chrome --no-sandbox` in the XFCE terminal |
| Codespace doesn't restart properly | Do a **Rebuild Container** via the Command Palette |

---

*Fixed and documented by **Vink🦉***
