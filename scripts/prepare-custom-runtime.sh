#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

git submodule update --init --recursive
if git -C deepseek-harness apply --check ../patches/deepseek-harness-custom.patch; then
  git -C deepseek-harness apply ../patches/deepseek-harness-custom.patch
elif ! git -C deepseek-harness apply --reverse --check ../patches/deepseek-harness-custom.patch; then
  echo "Harness working tree is neither clean nor patched by this repository." >&2
  exit 1
fi

# Rebuild all pinned Harness packages from the patched submodule, then replace
# the Desktop's vendored runtime tarballs and resolution manifest.
yarn upstream:prepare-runtime
node scripts/sync-vendored-runtime.mjs --write --channel stable
yarn install
