#!/bin/bash

set -euo pipefail

show_help() {
  local command_name
  command_name="$(basename "$0")"

  cat <<EOF
Usage: ${command_name} [--help]

Build the distributable Vale package zip.

Output:
  dist/Millennialism.zip

This script packages:
  * .vale.ini
  * styles/

Examples:
  ${command_name}
EOF
}

main() {
  if [[ $# -gt 0 ]]; then
    case "${1}" in
    --help)
      show_help
      exit 0
      ;;
    *)
      echo "Error: unknown option '${1}'." >&2
      show_help >&2
      exit 1
      ;;
    esac
  fi

  local script_dir repo_root dist_dir package_root package_file
  script_dir="$(cd "$(dirname "$0")" && pwd)"
  repo_root="$(cd "${script_dir}/.." && pwd)"
  dist_dir="${repo_root}/dist"
  package_root="${dist_dir}/Millennialism"
  package_file="${dist_dir}/Millennialism.zip"

  rm -rf "${package_root}"
  mkdir -p "${package_root}"

  cp "${repo_root}/.vale.ini" "${package_root}/.vale.ini"
  cp -R "${repo_root}/styles" "${package_root}/styles"

  rm -f "${package_file}"
  (
    cd "${dist_dir}"
    zip -rq "${package_file}" "Millennialism"
  )

  echo "Built ${package_file}"
}

main "$@"
