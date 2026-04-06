#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
DOCKER_DIR=$(cd "${SCRIPT_DIR}/.." && pwd)
REPO_ROOT=$(cd "${DOCKER_DIR}/.." && pwd)

IMAGE_NAME=${IMAGE_NAME:-vim-wksp-2026-nvim-bundle-dev}

docker build -f "$DOCKER_DIR/Dockerfile.dev" -t "$IMAGE_NAME" "$REPO_ROOT"
docker run --rm -it \
  -e TARGET_ARCH="${TARGET_ARCH:-}" \
  -v "$REPO_ROOT":/workspace \
  -w /workspace \
  "$IMAGE_NAME" \
  bash
