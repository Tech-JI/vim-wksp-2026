#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
DOCKER_DIR=$(cd "${SCRIPT_DIR}/.." && pwd)
REPO_ROOT=$(cd "${DOCKER_DIR}/.." && pwd)

TARGET_ARCH=${TARGET_ARCH:-$(uname -m)}
TEST_IMAGE=${TEST_IMAGE:-vim-wksp-2026-nvim-bundle-test}

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

ARTIFACT_PATH=${ARTIFACT_PATH:-$DOCKER_DIR/out/nvim-bundle-${ARCH_SUFFIX}.tar.gz}

if [[ ! -f "$ARTIFACT_PATH" ]]; then
  "$SCRIPT_DIR/package-bundle.sh"
fi

docker build -f "$DOCKER_DIR/Dockerfile.test" -t "$TEST_IMAGE" "$REPO_ROOT" >/dev/null

CONTAINER_NAME=${CONTAINER_NAME:-nvim-bundle-enter-${ARCH_SUFFIX}-$$}

cleanup() {
  docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true
}

trap cleanup EXIT

docker create --name "$CONTAINER_NAME" --network none -it "$TEST_IMAGE" >/dev/null
docker start "$CONTAINER_NAME" >/dev/null
docker cp "$ARTIFACT_PATH" "$CONTAINER_NAME:/tmp/nvim-bundle.tar.gz"
docker exec "$CONTAINER_NAME" bash -lc 'mkdir -p /opt && tar -xzf /tmp/nvim-bundle.tar.gz -C /opt && mv /opt/nvim-bundle /opt/nvim-bundle-test'

printf 'Container: %s\n' "$CONTAINER_NAME"
printf 'Bundle path: /opt/nvim-bundle-test\n'
printf 'Suggested checks:\n'
printf '  /opt/nvim-bundle-test/run.sh\n'
printf '  :Lazy\n'
printf '  :checkhealth\n'
printf '  :e /opt/nvim-bundle-test/xdg/config/nvim/init.lua\n'

docker exec -it "$CONTAINER_NAME" bash
