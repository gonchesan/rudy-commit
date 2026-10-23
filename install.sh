#!/usr/bin/env bash
# Installs rudy-commit into ~/bin and registers the `commit dis` shortcut in ~/.bashrc.
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/rudy-commit"
DEST_DIR="$HOME/bin"
BASHRC="$HOME/.bashrc"
BEGIN='# >>> rudy-commit >>>'
END='# <<< rudy-commit <<<'

mkdir -p "$DEST_DIR"
cp "$SRC" "$DEST_DIR/rudy-commit"
chmod +x "$DEST_DIR/rudy-commit"
echo "Installed: $DEST_DIR/rudy-commit"

# Replace any previous rudy-commit block so re-running the installer applies updates.
if grep -qsF "$BEGIN" "$BASHRC"; then
  sed -i "/^$BEGIN\$/,/^$END\$/d" "$BASHRC"
fi

cat >> "$BASHRC" <<'EOF'
# >>> rudy-commit >>>
export PATH="$HOME/bin:$PATH"
# `commit dis [options]` runs rudy-commit.
commit() {
  if [[ "${1:-}" == "dis" ]]; then
    shift
    rudy-commit "$@"
  elif type -P commit >/dev/null; then
    command commit "$@"
  else
    echo "usage: commit dis [options]   (see: commit dis --help)" >&2
    return 1
  fi
}
# <<< rudy-commit <<<
EOF
echo "Registered the 'commit dis' shortcut in $BASHRC (run: source ~/.bashrc)"

if ! command -v ollama >/dev/null 2>&1; then
  echo
  echo "Ollama is not installed yet:"
  echo "  1. Download it from https://ollama.com/download"
  echo "  2. ollama pull llama3.2:3b"
fi
