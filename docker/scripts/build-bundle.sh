#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
DOCKER_DIR=$(cd "${SCRIPT_DIR}/.." && pwd)
REPO_ROOT=$(cd "${DOCKER_DIR}/.." && pwd)

IMAGE_NAME=${IMAGE_NAME:-vim-wksp-2026-nvim-bundle-dev}
CONTAINER_WORKDIR=${CONTAINER_WORKDIR:-/workspace}

if [[ "${1:-}" != "--inside" ]]; then
  docker build -f "$DOCKER_DIR/Dockerfile.dev" -t "$IMAGE_NAME" "$REPO_ROOT"
  docker run --rm -t \
    -e TARGET_ARCH="${TARGET_ARCH:-}" \
    -e BUNDLE_OUT="${BUNDLE_OUT:-/workspace/docker/out/nvim-bundle}" \
    -v "$REPO_ROOT":"$CONTAINER_WORKDIR" \
    -w "$CONTAINER_WORKDIR" \
    "$IMAGE_NAME" \
    bash "/workspace/docker/scripts/build-bundle.sh" --inside
  exit 0
fi

TARGET_ARCH=${TARGET_ARCH:-$(uname -m)}

case "$TARGET_ARCH" in
  x86_64|amd64)
    NVIM_ARCH="x86_64"
    NVIM_URL="https://github.com/neovim/neovim/releases/download/v0.11.7/nvim-linux-x86_64.tar.gz"
    ;;
  aarch64|arm64)
    NVIM_ARCH="arm64"
    NVIM_URL="https://github.com/neovim/neovim/releases/download/v0.11.7/nvim-linux-arm64.tar.gz"
    ;;
  *)
    printf 'unsupported TARGET_ARCH: %s\n' "$TARGET_ARCH" >&2
    exit 1
    ;;
esac

BUNDLE_ROOT=${BUNDLE_OUT:-$REPO_ROOT/docker/out/nvim-bundle}
LAZY_DIR="$BUNDLE_ROOT/xdg/data/nvim/lazy/lazy.nvim"

TMP_DIR=$(mktemp -d)
OLD_BUNDLE_ROOT=""

cleanup() {
  rm -rf "$TMP_DIR"
  if [[ -n "$OLD_BUNDLE_ROOT" && -e "$OLD_BUNDLE_ROOT" ]]; then
    rm -rf "$OLD_BUNDLE_ROOT" 2>/dev/null || true
  fi
}

trap cleanup EXIT

if [[ -e "$BUNDLE_ROOT" ]]; then
  OLD_BUNDLE_ROOT="${BUNDLE_ROOT}.old.$$.${RANDOM}"
  mv "$BUNDLE_ROOT" "$OLD_BUNDLE_ROOT"
fi

mkdir -p "$BUNDLE_ROOT"

printf 'Target arch: %s (Neovim asset: %s)\n' "$TARGET_ARCH" "$NVIM_ARCH"
printf 'Bundle output: %s\n' "$BUNDLE_ROOT"
printf 'Neovim URL: %s\n' "$NVIM_URL"

curl -fL --retry 3 --retry-delay 2 "$NVIM_URL" -o "$TMP_DIR/nvim.tar.gz"
tar -xzf "$TMP_DIR/nvim.tar.gz" -C "$TMP_DIR"
mv "$TMP_DIR/nvim-linux-$NVIM_ARCH" "$BUNDLE_ROOT/nvim"

"$SCRIPT_DIR/bootstrap-config.sh" "$BUNDLE_ROOT" "$DOCKER_DIR"

git clone --filter=blob:none --branch=stable https://github.com/folke/lazy.nvim.git "$LAZY_DIR"

export HOME="$BUNDLE_ROOT/home"
export XDG_CONFIG_HOME="$BUNDLE_ROOT/xdg/config"
export XDG_DATA_HOME="$BUNDLE_ROOT/xdg/data"
export XDG_STATE_HOME="$BUNDLE_ROOT/xdg/state"
export XDG_CACHE_HOME="$BUNDLE_ROOT/xdg/cache"
export NVIM_APPNAME="nvim"
export PATH="$BUNDLE_ROOT/nvim/bin:$PATH"

declare -a REQUIRED_PARSERS=(lua vim vimdoc query bash)

parser_present() {
  local parser=$1

  [[ -f "$XDG_DATA_HOME/nvim/lazy/nvim-treesitter/parser/$parser.so" \
      || -f "$XDG_DATA_HOME/nvim/site/parser/$parser.so" \
      || -f "$BUNDLE_ROOT/nvim/lib/nvim/parser/$parser.so" ]]
}

export MYVIM_BOOTSTRAP=1
"$BUNDLE_ROOT/run.sh" --headless "+Lazy! sync" +qa
unset MYVIM_BOOTSTRAP

for parser in "${REQUIRED_PARSERS[@]}"; do
  if parser_present "$parser"; then
    printf 'Treesitter parser already present: %s\n' "$parser"
    continue
  fi

  printf 'Installing Treesitter parser: %s\n' "$parser"
  "$BUNDLE_ROOT/run.sh" --headless "+TSInstallSync! $parser" +qa
done

declare -a REQUIRED_PLUGIN_DIRS=(
  "Comment.nvim"
  "bufferline.nvim"
  "cmp-buffer"
  "cmp-cmdline"
  "cmp-dictionary"
  "cmp-nvim-lsp"
  "cmp-path"
  "cmp-vsnip"
  "flash.nvim"
  "formatter.nvim"
  "friendly-snippets"
  "indent-blankline.nvim"
  "lazy.nvim"
  "lspkind-nvim"
  "lualine.nvim"
  "nvim-autopairs"
  "nvim-cmp"
  "nvim-lint"
  "nvim-lspconfig"
  "nvim-tree.lua"
  "nvim-treesitter"
  "nvim-treesitter-textobjects"
  "nvim-web-devicons"
  "outline.nvim"
  "plenary.nvim"
  "snacks.nvim"
  "telescope-zoxide"
  "telescope.nvim"
  "todo-comments.nvim"
  "tokyonight.nvim"
  "trouble.nvim"
  "vim-snippets"
  "vim-vsnip"
  "which-key.nvim"
)

declare -a MISSING_PLUGIN_DIRS=()
for plugin_dir in "${REQUIRED_PLUGIN_DIRS[@]}"; do
  if [[ ! -d "$XDG_DATA_HOME/nvim/lazy/$plugin_dir" ]]; then
    MISSING_PLUGIN_DIRS+=("$plugin_dir")
  fi
done

if (( ${#MISSING_PLUGIN_DIRS[@]} > 0 )); then
  printf 'missing plugin directories: %s\n' "${MISSING_PLUGIN_DIRS[*]}" >&2
  exit 1
fi

declare -a MISSING_PARSERS=()
for parser in "${REQUIRED_PARSERS[@]}"; do
  if ! parser_present "$parser"; then
    MISSING_PARSERS+=("$parser")
  fi
done

if (( ${#MISSING_PARSERS[@]} > 0 )); then
  printf 'missing treesitter parsers: %s\n' "${MISSING_PARSERS[*]}" >&2
  exit 1
fi

printf '\nBuilt bundle successfully. Key paths:\n'
printf '  run.sh: %s\n' "$BUNDLE_ROOT/run.sh"
printf '  config: %s\n' "$XDG_CONFIG_HOME/nvim"
printf '  data:   %s\n' "$XDG_DATA_HOME/nvim"
printf '  state:  %s\n' "$XDG_STATE_HOME/nvim"
printf '  cache:  %s\n' "$XDG_CACHE_HOME/nvim"

python3 - "$BUNDLE_ROOT" <<'PY'
from pathlib import Path
import sys

root = Path(sys.argv[1])
max_depth = 3

print("\nBundle structure:")
for path in sorted(root.rglob("*")):
    rel = path.relative_to(root)
    depth = len(rel.parts)
    if depth > max_depth:
        continue
    suffix = "/" if path.is_dir() else ""
    print(f"  {rel}{suffix}")
PY
