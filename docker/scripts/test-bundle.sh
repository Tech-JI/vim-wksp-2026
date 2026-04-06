#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
DOCKER_DIR=$(cd "${SCRIPT_DIR}/.." && pwd)
REPO_ROOT=$(cd "${DOCKER_DIR}/.." && pwd)

TARGET_ARCH=${TARGET_ARCH:-$(uname -m)}
TEST_IMAGE=${TEST_IMAGE:-vim-wksp-2026-nvim-bundle-test}
KEEP_TEST_CONTAINER=${KEEP_TEST_CONTAINER:-0}

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

CONTAINER_NAME=${CONTAINER_NAME:-nvim-bundle-test-${ARCH_SUFFIX}-$$}

cleanup() {
  if [[ "$KEEP_TEST_CONTAINER" != "1" ]]; then
    docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true
  fi
}

trap cleanup EXIT

docker create --name "$CONTAINER_NAME" --network none "$TEST_IMAGE" >/dev/null
docker start "$CONTAINER_NAME" >/dev/null
docker cp "$ARTIFACT_PATH" "$CONTAINER_NAME:/tmp/nvim-bundle.tar.gz"

docker exec "$CONTAINER_NAME" bash -lc 'mkdir -p /opt && tar -xzf /tmp/nvim-bundle.tar.gz -C /opt && mv /opt/nvim-bundle /opt/nvim-bundle-test'

docker exec "$CONTAINER_NAME" bash -lc 'python3 - <<"PY"
from pathlib import Path
import hashlib

root = Path("/opt/nvim-bundle-test/xdg/data/nvim/lazy")
out = Path("/tmp/lazy-before.sha256")

with out.open("w", encoding="utf-8") as fh:
    for path in sorted(root.rglob("*")):
        rel = path.relative_to(root)
        if path.is_dir():
            fh.write(f"dir {rel}\n")
            continue
        digest = hashlib.sha256(path.read_bytes()).hexdigest()
        fh.write(f"file {rel} {path.stat().st_size} {digest}\n")
PY'

docker exec "$CONTAINER_NAME" bash -lc '/opt/nvim-bundle-test/run.sh --headless "+lua local root=\"/opt/nvim-bundle-test\"; assert(vim.startswith(vim.fn.stdpath(\"config\"), root .. \"/xdg/config\")); assert(vim.startswith(vim.fn.stdpath(\"data\"), root .. \"/xdg/data\")); assert(vim.startswith(vim.fn.stdpath(\"state\"), root .. \"/xdg/state\")); assert(vim.startswith(vim.fn.stdpath(\"cache\"), root .. \"/xdg/cache\")); print(\"stdpath_ok=true\")" "+lua local ok,lazy=pcall(require,\"lazy\"); assert(ok and lazy, \"lazy missing\"); print(\"lazy_count=\" .. lazy.stats().count)" +qa'

docker exec "$CONTAINER_NAME" bash -lc 'cat > /tmp/sample.lua <<"EOF"
local message = "treesitter"
print(message)
EOF
/opt/nvim-bundle-test/run.sh --headless /tmp/sample.lua "+lua local ok,_ = pcall(vim.treesitter.get_parser, 0, \"lua\"); assert(ok, \"lua parser missing\"); print(\"treesitter_lua=true\")" +qa'

docker exec "$CONTAINER_NAME" bash -lc 'health_output=$(/opt/nvim-bundle-test/run.sh --headless "+checkhealth" +qa 2>&1 || true); printf "%s\n" "$health_output" > /tmp/checkhealth.log; if grep -q "ERROR" /tmp/checkhealth.log; then cat /tmp/checkhealth.log >&2; exit 1; fi; printf "checkhealth_errors=0\n"'

docker exec "$CONTAINER_NAME" bash -lc 'python3 - <<"PY"
from pathlib import Path
import hashlib

root = Path("/opt/nvim-bundle-test/xdg/data/nvim/lazy")
out = Path("/tmp/lazy-after.sha256")

with out.open("w", encoding="utf-8") as fh:
    for path in sorted(root.rglob("*")):
        rel = path.relative_to(root)
        if path.is_dir():
            fh.write(f"dir {rel}\n")
            continue
        digest = hashlib.sha256(path.read_bytes()).hexdigest()
        fh.write(f"file {rel} {path.stat().st_size} {digest}\n")
PY
cmp -s /tmp/lazy-before.sha256 /tmp/lazy-after.sha256 && printf "lazy_tree_unchanged=true\n"'

printf 'Verified container: %s\n' "$CONTAINER_NAME"
if [[ "$KEEP_TEST_CONTAINER" == "1" ]]; then
  printf 'Container preserved. Enter it with:\n  docker exec -it %s bash\n' "$CONTAINER_NAME"
fi
