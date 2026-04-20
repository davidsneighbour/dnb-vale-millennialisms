#!/bin/bash

set -euo pipefail

print_help() {
  cat <<EOF
Usage: $(basename "$0") [--help]

Build the distributable Vale package zip for releases.

Creates:
  dist/Millennialisms.zip

Included files:
  .vale.ini
  styles/
  README.md
  LICENSE (if present)

Notes:
  * This script is intended for release packaging.
  * It fails if required package files are missing.
EOF
}

main() {
  if [[ "${1:-}" == "--help" ]]; then
    print_help
    exit 0
  fi

  local project_root
  project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

  cd "${project_root}"

  if [[ ! -f ".vale.ini" ]]; then
    echo "[error] Missing required file: .vale.ini" >&2
    exit 1
  fi

  if [[ ! -d "styles" ]]; then
    echo "[error] Missing required directory: styles" >&2
    exit 1
  fi

  if [[ ! -f "README.md" ]]; then
    echo "[error] Missing required file: README.md" >&2
    exit 1
  fi

  mkdir -p dist
  rm -f dist/Millennialisms.zip

  if [[ -f "LICENSE" ]]; then
    zip -rq dist/Millennialisms.zip .vale.ini styles README.md LICENSE
  else
    zip -rq dist/Millennialisms.zip .vale.ini styles README.md
  fi

  if [[ ! -f "dist/Millennialisms.zip" ]]; then
    echo "[error] Failed to create dist/Millennialisms.zip" >&2
    exit 1
  fi

  echo "[info] Built dist/Millennialisms.zip"
}

main "$@"