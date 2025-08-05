#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# verify_backup.sh
# Description: Verify integrity of all `.sql` backups in BACKUP_DIR using sha256.
# Usage: ./verify_backup.sh
# -----------------------------------------------------------------------------

set -euo pipefail

source "$(dirname "$0")/../../config/.env"

cd "$BACKUP_DIR"

echo "[$(date)] Verifying backups in $BACKUP_DIR..."

for checksum_file in *.sha256; do
  sql_file="${checksum_file%.sha256}"
  if [[ ! -f "$sql_file" ]]; then
    echo "WARNING: Missing SQL file for checksum: $checksum_file"
    continue
  fi

  echo "Verifying $sql_file..."
  if sha256sum --check --status "$checksum_file"; then
    echo "  → OK: $sql_file"
  else
    echo "  → FAILED: $sql_file"
  fi
done

echo "[$(date)] Verification run complete."
