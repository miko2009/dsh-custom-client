#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

"$repo_root/scripts/prepare-custom-runtime.sh"
yarn workspace dsh-plugin-desktop dist:mac-smoke
