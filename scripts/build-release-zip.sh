#!/bin/bash

set -euo pipefail

print_help() {
  cat <<EOF
Usage: $(basename "$0") [--help]

Build the distributable Vale package zip for releases.

Creates:
  dist/Millennialisms.zip

Archive layout:
  Millennialisms/
    .vale.ini
    styles/
    README.md
    LICENSE (if present)

Notes:
  * This script builds a complete Vale package.
  * It fails if required package files are missing.
EOF
}

cleanup() {
  if [[ -n "${TEMP_DIR:-}" && -d "${TEMP_DIR}" ]]; then
    rm -rf "${TEMP_DIR}"
  fi
}

main() {
  if [[ "${1:-}" == "--help" ]]; then
    print_help
    exit 0
  fi

  local project_root
  local package_root
  local output_file

  project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
  package_root="Millennialisms"
  output_file="dist/Millennialisms.zip"

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

  TEMP_DIR="$(mktemp -d)"
  trap cleanup EXIT

  mkdir -p "${TEMP_DIR}/${package_root}"

  cp ".vale.ini" "${TEMP_DIR}/${package_root}/.vale.ini"
  cp "README.md" "${TEMP_DIR}/${package_root}/README.md"
  cp -R "styles" "${TEMP_DIR}/${package_root}/styles"

  if [[ -f "LICENSE" ]]; then
    cp "LICENSE" "${TEMP_DIR}/${package_root}/LICENSE"
  fi

  rm -f "${output_file}"

  (
    cd "${TEMP_DIR}"
    zip -rq "${project_root}/${output_file}" "${package_root}"
  )

  if [[ ! -f "${output_file}" ]]; then
    echo "[error] Failed to create ${output_file}" >&2
    exit 1
  fi

  echo "[info] Built ${output_file}"
}

main "$@"
