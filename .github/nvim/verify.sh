#!/usr/bin/env bash
set -euo pipefail

TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

cat > "$TMP_DIR/sample.lua" <<'EOF'
local message = "treesitter"
print(message)
EOF

"$BUNDLE_RUN" --headless "$TMP_DIR/sample.lua" \
  "+lua local ok,_ = pcall(vim.treesitter.get_parser, 0, 'lua'); assert(ok, 'lua parser missing'); print('treesitter_lua=true')" \
  +qa >"$TMP_DIR/verify.log" 2>&1

cat "$TMP_DIR/verify.log"

if grep -Eq 'Error detected while processing|E[0-9]{3,4}:|permission denied' "$TMP_DIR/verify.log"; then
  exit 1
fi

health_output=$("$BUNDLE_RUN" --headless "+checkhealth" +qa 2>&1 || true)
printf '%s\n' "$health_output" > "$TMP_DIR/checkhealth.log"

if grep -q "ERROR" "$TMP_DIR/checkhealth.log"; then
  cat "$TMP_DIR/checkhealth.log" >&2
  exit 1
fi

printf 'checkhealth_errors=0\n'
