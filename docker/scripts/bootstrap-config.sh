#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
DOCKER_DIR=$(cd "${SCRIPT_DIR}/.." && pwd)

BUNDLE_ROOT=${1:-}
CONFIG_SOURCE=${2:-$DOCKER_DIR}

if [[ -z "$BUNDLE_ROOT" ]]; then
  printf 'usage: %s <bundle-root> [config-source]\n' "$0" >&2
  exit 1
fi

XDG_CONFIG_HOME="$BUNDLE_ROOT/xdg/config"
XDG_DATA_HOME="$BUNDLE_ROOT/xdg/data"
XDG_STATE_HOME="$BUNDLE_ROOT/xdg/state"
XDG_CACHE_HOME="$BUNDLE_ROOT/xdg/cache"

mkdir -p \
  "$BUNDLE_ROOT/home" \
  "$XDG_CONFIG_HOME/nvim" \
  "$XDG_DATA_HOME/nvim" \
  "$XDG_STATE_HOME/nvim" \
  "$XDG_CACHE_HOME/nvim"

cp "$CONFIG_SOURCE/init.lua" "$XDG_CONFIG_HOME/nvim/init.lua"
cp -R "$CONFIG_SOURCE/lua" "$XDG_CONFIG_HOME/nvim/"

if [[ -d "$CONFIG_SOURCE/dict" ]]; then
  cp -R "$CONFIG_SOURCE/dict" "$XDG_CONFIG_HOME/nvim/"
fi

if [[ -f "$CONFIG_SOURCE/lazy-lock.json" ]]; then
  cp "$CONFIG_SOURCE/lazy-lock.json" "$XDG_CONFIG_HOME/nvim/lazy-lock.json"
fi

cat > "$BUNDLE_ROOT/run.sh" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

export HOME="$ROOT_DIR/home"
export XDG_CONFIG_HOME="$ROOT_DIR/xdg/config"
export XDG_DATA_HOME="$ROOT_DIR/xdg/data"
export XDG_STATE_HOME="$ROOT_DIR/xdg/state"
export XDG_CACHE_HOME="$ROOT_DIR/xdg/cache"
export NVIM_APPNAME="nvim"
export PATH="$ROOT_DIR/nvim/bin:$PATH"

exec "$ROOT_DIR/nvim/bin/nvim" "$@"
EOF

chmod +x "$BUNDLE_ROOT/run.sh"

printf 'Bundle root: %s\n' "$BUNDLE_ROOT"
printf 'XDG_CONFIG_HOME: %s\n' "$XDG_CONFIG_HOME"
printf 'XDG_DATA_HOME: %s\n' "$XDG_DATA_HOME"
printf 'XDG_STATE_HOME: %s\n' "$XDG_STATE_HOME"
printf 'XDG_CACHE_HOME: %s\n' "$XDG_CACHE_HOME"
