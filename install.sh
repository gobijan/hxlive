#!/usr/bin/env bash
# Installs hxlive to ~/.local/bin (or $HXLIVE_PREFIX/bin).
#
#   From a clone:   ./install.sh          → symlink, `git pull` updates it
#   Without clone:  curl -fsSL https://raw.githubusercontent.com/gobijan/hxlive/main/install.sh | bash
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
  echo "✓ downloaded $BIN_DIR/hxlive"
fi

case ":$PATH:" in
  *":$BIN_DIR:"*) ;;
  *) echo "! $BIN_DIR is not on your PATH – add it to your shell config." ;;
esac

# Only check dependencies, never install anything without asking.
mac=false; [ "$(uname -s)" = Darwin ] && mac=true
missing=0
check() {
  if eval "$2" >/dev/null 2>&1; then echo "✓ $1"; else echo "✗ $1 – $3"; missing=1; fi
}

if $mac; then
  check Helix "command -v hx" "brew install helix"
  check "Chromium-based browser" \
    "ls -d /Applications/{'Google Chrome',Chromium,'Brave Browser','Microsoft Edge'}.app $HOME/Applications/*.app 2>/dev/null | grep -qE 'Chrome|Chromium|Brave|Edge'" \
    "brew install --cask google-chrome (or chromium/brave)"
else
  check Helix "command -v helix || command -v hx" "sudo pacman -S helix"
  check "Chromium-based browser" \
    "command -v chromium || command -v google-chrome-stable || command -v brave" \
    "sudo pacman -S chromium"
fi
check browser-sync "command -v browser-sync || command -v npx" \
  "mise use -g npm:browser-sync   (or just Node.js, then it runs via npx)"
check "superhtml (optional, for hxlive check)" "command -v superhtml" \
  "mise use -g superhtml"

[ $missing -eq 0 ] && echo && echo "Done. In any project directory just run: hxlive"
