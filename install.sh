#!/usr/bin/env bash
# Installiert hxlive nach ~/.local/bin (oder $HXLIVE_PREFIX/bin).
#
#   Aus einem Clone:  ./install.sh          → Symlink, `git pull` aktualisiert
#   Ohne Clone:       curl -fsSL https://raw.githubusercontent.com/gobijan/hxlive/main/install.sh | bash
set -euo pipefail

REPO_RAW=${HXLIVE_RAW:-https://raw.githubusercontent.com/gobijan/hxlive/main}
BIN_DIR="${HXLIVE_PREFIX:-$HOME/.local}/bin"
mkdir -p "$BIN_DIR"

here=$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || true)
if [ -n "$here" ] && [ -f "$here/bin/hxlive" ]; then
  ln -sf "$here/bin/hxlive" "$BIN_DIR/hxlive"
  echo "✓ $BIN_DIR/hxlive → $here/bin/hxlive"
else
  curl -fsSL "$REPO_RAW/bin/hxlive" -o "$BIN_DIR/hxlive"
  chmod +x "$BIN_DIR/hxlive"
  echo "✓ $BIN_DIR/hxlive heruntergeladen"
fi

case ":$PATH:" in
  *":$BIN_DIR:"*) ;;
  *) echo "! $BIN_DIR ist nicht im PATH – in die Shell-Config eintragen." ;;
esac

# Abhängigkeiten nur prüfen, nichts ungefragt installieren.
mac=false; [ "$(uname -s)" = Darwin ] && mac=true
missing=0
check() {
  if eval "$2" >/dev/null 2>&1; then echo "✓ $1"; else echo "✗ $1 – $3"; missing=1; fi
}

if $mac; then
  check Helix "command -v hx" "brew install helix"
  check Chromium-Browser \
    "ls -d /Applications/{'Google Chrome',Chromium,'Brave Browser','Microsoft Edge'}.app $HOME/Applications/*.app 2>/dev/null | grep -qE 'Chrome|Chromium|Brave|Edge'" \
    "brew install --cask google-chrome (oder chromium/brave)"
else
  check Helix "command -v helix || command -v hx" "sudo pacman -S helix"
  check Chromium-Browser \
    "command -v chromium || command -v google-chrome-stable || command -v brave" \
    "sudo pacman -S chromium"
fi
check browser-sync "command -v browser-sync || command -v npx" \
  "mise use -g npm:browser-sync   (oder Node.js, dann läuft es via npx)"
check "superhtml (optional, für hxlive check)" "command -v superhtml" \
  "mise use -g superhtml"

[ $missing -eq 0 ] && echo && echo "Fertig. Im Projektordner einfach: hxlive"
