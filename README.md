# 🦉 Remote Browser Codespace

Een volledig draaiende **Chromium browser** in je browser — via GitHub Codespaces en noVNC. Geen installatie nodig.

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/bren-uijl/remote-browser-codespace)

---

## 🚀 Snel starten

1. Klik op de knop hierboven — **Open in GitHub Codespaces**
2. Wacht tot de container klaar is (dit duurt ~2 minuten de eerste keer)
3. Ga naar het **Ports** tabblad in VS Code of de Codespace interface
4. Klik op de link bij poort **6080** → de browser opent in je browser

> 💡 Poort 6080 is ingesteld als `public`, dus je kunt de link ook delen.

---

## 🧩 Wat zit erin?

| Component | Functie |
|-----------|---------|
| `Xvfb` | Virtueel scherm (geen fysieke monitor nodig) |
| `Fluxbox` | Lichtgewicht window manager |
| `Chromium` | De browser die je bedient |
| `x11vnc` | VNC server op poort 5900 |
| `noVNC` | VNC → browser bridge op poort **6080** |

---

## 🛠️ Handmatig herstarten

Als de browser vastloopt of je wil hem opnieuw starten:

```bash
./start.sh
```

---

## 📁 Structuur

```
.
├── .devcontainer/
│   └── devcontainer.json   # Codespace configuratie
├── start.sh                # Start Xvfb, Fluxbox, Chromium, noVNC
└── README.md
```

---

## 🪲 Problemen?

| Probleem | Oplossing |
|----------|-----------|
| 502 Bad Gateway op poort 6080 | Voer `./start.sh` uit in de terminal |
| Scherm blijft zwart | Wacht 5 seconden en refresh |
| Codespace start niet opnieuw op | Doe een **Rebuild Container** via het Command Palette |

---

*Gefixt en gedocumenteerd door **Vink🦉***