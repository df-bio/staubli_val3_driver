#! /usr/bin/env bash

set -euo pipefail

FORCE_FLAG=""
if [[ "${1:-}" == "--force" ]]; then
  FORCE_FLAG="--transfer-all"
elif [[ $# -gt 0 ]]; then
  echo "Usage: $0 [--force]" >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VAL3_DIR="${SCRIPT_DIR}/staubli_val3_driver/val3"

lftp -u default, 192.168.1.8 <<EOF
set ftp:ssl-allow no
set ftp:passive-mode yes
set net:timeout 20
set net:max-retries 3
set net:reconnect-interval-base 5
set mirror:parallel-transfer-count 1

lcd ${VAL3_DIR}
cd /usr/usrapp

mirror -R --verbose --no-perms --ignore-time ${FORCE_FLAG} . .

bye
EOF
