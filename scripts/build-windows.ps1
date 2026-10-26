$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

git submodule update --init --recursive
git -C deepseek-harness apply --check ../patches/deepseek-harness-custom.patch
if ($LASTEXITCODE -eq 0) {
  git -C deepseek-harness apply ../patches/deepseek-harness-custom.patch
} else {
  git -C deepseek-harness apply --reverse --check ../patches/deepseek-harness-custom.patch
  if ($LASTEXITCODE -ne 0) {
    throw 'Harness working tree is neither clean nor patched by this repository.'
  }
}

# Rebuild patched Harness packages and replace the Desktop vendored runtime.
yarn upstream:prepare-runtime
node scripts/sync-vendored-runtime.mjs --write --channel stable
yarn install
yarn workspace dsh-plugin-desktop dist:win
