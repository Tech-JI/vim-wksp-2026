#!/usr/bin/env bash
set -euo pipefail

TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

"$BUNDLE_RUN" --headless \
  "+lua local ok,_=pcall(require,'bufferline'); assert(ok, 'bufferline missing'); print('bufferline_require=true')" \
  +qa >"$TMP_DIR/smoke.log" 2>&1

cat "$TMP_DIR/smoke.log"

if grep -Eq 'Error detected while processing|E[0-9]{3,4}:|permission denied' "$TMP_DIR/smoke.log"; then
  exit 1
fi
