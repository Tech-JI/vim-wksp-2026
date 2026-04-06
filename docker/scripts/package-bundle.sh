#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
DOCKER_DIR=$(cd "${SCRIPT_DIR}/.." && pwd)

TARGET_ARCH=${TARGET_ARCH:-$(uname -m)}
BUNDLE_ROOT=${BUNDLE_ROOT:-$DOCKER_DIR/out/nvim-bundle}

case "$TARGET_ARCH" in
  x86_64|amd64)
    ARCH_SUFFIX="linux-x86_64"
    ;;
  aarch64|arm64)
    ARCH_SUFFIX="linux-arm64"
    ;;
  *)
    printf 'unsupported TARGET_ARCH: %s\n' "$TARGET_ARCH" >&2
    exit 1
    ;;
esac

if [[ ! -x "$BUNDLE_ROOT/run.sh" ]]; then
  printf 'bundle not found at %s; run docker/scripts/build-bundle.sh first\n' "$BUNDLE_ROOT" >&2
  exit 1
fi

ARTIFACT_PATH=${ARTIFACT_PATH:-$DOCKER_DIR/out/nvim-bundle-${ARCH_SUFFIX}.tar.gz}
TMP_ARTIFACT="${ARTIFACT_PATH}.tmp"

rm -f "$TMP_ARTIFACT"
COPYFILE_DISABLE=1 tar -C "$DOCKER_DIR/out" -czf "$TMP_ARTIFACT" nvim-bundle
mv "$TMP_ARTIFACT" "$ARTIFACT_PATH"

printf 'Artifact: %s\n' "$ARTIFACT_PATH"
if command -v shasum >/dev/null 2>&1; then
  shasum -a 256 "$ARTIFACT_PATH"
fi
