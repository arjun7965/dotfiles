#!/usr/bin/env bash
set -euo pipefail

# One-time setup: keep repo files as source of truth and link live config paths.
DEFAULT_DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DOTFILES="${DOTFILES:-$DEFAULT_DOTFILES}"

if [[ "$DOTFILES" != /* ]]; then
  echo "Error: DOTFILES must be an absolute path. Current value: $DOTFILES" >&2
  exit 1
fi

if [[ ! -d "$DOTFILES/nvim" || ! -d "$DOTFILES/tmux" ]]; then
  echo "Error: expected nvim/ and tmux/ under $DOTFILES" >&2
  exit 1
fi

timestamp="$(date +%Y%m%d-%H%M%S)"

backup_if_needed() {
  local path="$1"
  if [[ -e "$path" || -L "$path" ]]; then
    local backup="${path}.backup.${timestamp}"
    mv "$path" "$backup"
    echo "Backed up $path -> $backup"
  fi
}

ensure_link() {
  local target="$1"
  local link_path="$2"

  if [[ -L "$link_path" ]]; then
    local current_target
    current_target="$(readlink -f "$link_path" 2>/dev/null || true)"
    local desired_target
    desired_target="$(readlink -f "$target")"
    if [[ "$current_target" == "$desired_target" ]]; then
      echo "OK: $link_path already points to $target"
      return
    fi
  fi

  backup_if_needed "$link_path"
  ln -sfn "$target" "$link_path"
  echo "Linked $link_path -> $target"
}

mkdir -p "$HOME/.config"

ensure_link "$DOTFILES/nvim" "$HOME/.config/nvim"
ensure_link "$DOTFILES/tmux" "$HOME/.config/tmux"
ensure_link "$HOME/.config/tmux/tmux.conf" "$HOME/.tmux.conf"

echo ""
echo "Verification checks:"
ls -ld "$HOME/.config/nvim" "$HOME/.config/tmux"
ls -l "$HOME/.tmux.conf"
ls "$HOME/.config/nvim/init.lua" "$HOME/.config/tmux/tmux.conf" "$HOME/.tmux.conf"

if command -v tmux >/dev/null 2>&1; then
  if tmux source-file "$HOME/.tmux.conf" >/dev/null 2>&1; then
    echo "tmux reload: success"
  else
    echo "tmux reload: skipped (no running server/session or command failed)"
  fi
else
  echo "tmux reload: skipped (tmux not installed)"
fi

echo "Done. Edit configs in $DOTFILES and changes apply via symlinks."
