#!/usr/bin/env bash
set -euo pipefail

LAZY_DIR="$XDG_DATA_HOME/$NVIM_APPNAME/lazy/lazy.nvim"

if [[ ! -d "$LAZY_DIR" ]]; then
  git clone --filter=blob:none --branch=stable https://github.com/folke/lazy.nvim.git "$LAZY_DIR"
fi

export MYVIM_BOOTSTRAP=1
"$BUNDLE_RUN" --headless "+Lazy! sync" +qa
unset MYVIM_BOOTSTRAP

for parser in lua vim vimdoc query bash; do
  if [[ -f "$XDG_DATA_HOME/$NVIM_APPNAME/lazy/nvim-treesitter/parser/$parser.so" ]] || [[ -f "$XDG_DATA_HOME/$NVIM_APPNAME/site/parser/$parser.so" ]] || [[ -f "$BUNDLE_ROOT/nvim/lib/nvim/parser/$parser.so" ]]; then
    continue
  fi

  "$BUNDLE_RUN" --headless "+TSInstallSync! $parser" +qa
done
