# hxlive

Helix im Terminal, Live-Preview im Browserfenster daneben. Speichern mit `:w`
lädt die Vorschau neu (CSS wird ohne Reload eingespielt), `:q` räumt Server
und Fenster wieder ab. Läuft auf macOS und Linux (Omarchy/Hyprland oder ein
beliebiger anderer Desktop).

```sh
mkdir spielwiese && cd spielwiese
hxlive init      # index.html + style.css anlegen
hxlive           # loslegen
```

## Installation

```sh
git clone git@github.com:gobijan/hxlive.git ~/Work/hxlive
~/Work/hxlive/install.sh        # Symlink nach ~/.local/bin, Update per git pull
```

oder ohne Clone:

```sh
curl -fsSL https://raw.githubusercontent.com/gobijan/hxlive/main/install.sh | bash
```

Der Installer prüft die Abhängigkeiten und sagt, was fehlt:

| | macOS | Omarchy / Arch |
|---|---|---|
| Helix | `brew install helix` | `pacman -S helix` |
| Browser | Chrome, Chromium, Brave oder Edge | Chromium (Standard bei Omarchy) |
| Server | `mise use -g npm:browser-sync` oder nur Node (dann via `npx`) | dito |
| optional | `mise use -g superhtml` | dito |

## Befehle

```
hxlive [dateien…]   Server + Vorschau + Helix (ohne Argumente: index.html,
                    style.css, script.js, falls vorhanden)
hxlive init         Startdateien anlegen
hxlive serve        nur den Server, Logs im Terminal
hxlive preview      Vorschaufenster (wieder) öffnen
hxlive close        alle hxlive-Vorschaufenster schließen
hxlive check        HTML mit superhtml prüfen
-p, --port N        Port (Standard 3000; ist er belegt, nimmt hxlive den nächsten freien)
```

Umgebungsvariablen: `HXLIVE_PORT`, `HXLIVE_EDITOR` (z. B. `nvim`),
`HXLIVE_BROWSER` (Pfad zu einem Chromium-Browser).

## Wie das Fenster platziert wird

- **Hyprland:** Start per `hyprctl` mit `no_initial_focus`. Das Fenster wird
  rechts neben das Terminal gekachelt, der Fokus bleibt bei Helix.
- **macOS:** Start auf der rechten Bildschirmhälfte, danach bekommt das
  Terminal den Fokus zurück. Verschiebst du das Fenster, merkt sich das
  Profil die neue Position.
- **Andere Desktops:** normales Fenster, platziert vom Window-Manager.

Die Vorschau ist ein `--app`-Fenster (ohne Tabs und Adressleiste) mit eigenem
Profil unter `~/.cache/hxlive/`, damit hxlive es gezielt schließen kann, ohne
deinen normalen Browser anzufassen.
