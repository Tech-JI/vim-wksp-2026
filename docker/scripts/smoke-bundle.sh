#!/usr/bin/env bash
set -euo pipefail

BUNDLE_ROOT=${1:-}

if [[ -z "$BUNDLE_ROOT" ]]; then
  printf 'usage: %s <bundle-root>\n' "$0" >&2
  exit 1
fi

BUNDLE_ROOT=$(cd "$BUNDLE_ROOT" && pwd)

if [[ ! -x "$BUNDLE_ROOT/run.sh" ]]; then
  printf 'bundle run.sh not found at %s\n' "$BUNDLE_ROOT/run.sh" >&2
  exit 1
fi

TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

export BUNDLE_EXPECTED_ROOT="$BUNDLE_ROOT"

run_headless_check() {
  local output_file=$1
  shift

  if ! "$BUNDLE_ROOT/run.sh" --headless "$@" >"$output_file" 2>&1; then
    cat "$output_file" >&2
    exit 1
  fi

  cat "$output_file"

  if grep -Eq 'Error detected while processing|E[0-9]{3,4}:|permission denied' "$output_file"; then
    exit 1
  fi
}

run_headless_check "$TMP_DIR/smoke-stdpath.log" \
  "+lua local root = vim.env.BUNDLE_EXPECTED_ROOT; assert(vim.startswith(vim.fn.stdpath('config'), root .. '/xdg/config')); assert(vim.startswith(vim.fn.stdpath('data'), root .. '/xdg/data')); assert(vim.startswith(vim.fn.stdpath('state'), root .. '/xdg/state')); assert(vim.startswith(vim.fn.stdpath('cache'), root .. '/xdg/cache')); print('stdpath_ok=true')" \
  "+lua assert(vim.fn.exists(':Lazy') == 2, 'Lazy command missing'); print('lazy_cmd=true')" \
  "+lua local ok, lazy = pcall(require, 'lazy'); assert(ok and lazy, 'lazy missing'); print('lazy_count=' .. lazy.stats().count)" \
  +qa

cat > "$TMP_DIR/sample.lua" <<'EOF'
local message = "treesitter"
print(message)
EOF

run_headless_check "$TMP_DIR/smoke-treesitter.log" "$TMP_DIR/sample.lua" \
  "+lua local ok,_ = pcall(vim.treesitter.get_parser, 0, 'lua'); assert(ok, 'lua parser missing'); print('treesitter_lua=true')" \
  +qa

health_output=$("$BUNDLE_ROOT/run.sh" --headless "+checkhealth" +qa 2>&1 || true)
printf '%s\n' "$health_output" > "$TMP_DIR/checkhealth.log"

if grep -q "ERROR" "$TMP_DIR/checkhealth.log"; then
  cat "$TMP_DIR/checkhealth.log" >&2
  exit 1
fi

printf 'checkhealth_errors=0\n'
