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

# Only checks dependencies and editor setup, never installs anything.
echo
"$BIN_DIR/hxlive" doctor && echo && echo "Done. In any project directory just run: hxlive"
