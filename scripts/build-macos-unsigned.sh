#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

git submodule update --init --recursive
git -C deepseek-harness apply --check ../patches/deepseek-harness-custom.patch
git -C deepseek-harness apply ../patches/deepseek-harness-custom.patch
yarn install --immutable
yarn workspace dsh-plugin-desktop dist:mac-smoke
