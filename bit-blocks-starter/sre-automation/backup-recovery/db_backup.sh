#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# db_backup.sh
# Description: Perform a database backup (PostgreSQL/MySQL) and store it locally.
# Usage: ./db_backup.sh
# -----------------------------------------------------------------------------

set -euo pipefail

# Load configuration
source "$(dirname "$0")/../../config/.env"

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_PATH="${BACKUP_DIR}/${DB_NAME}_${TIMESTAMP}.sql"
LOG_FILE="${BACKUP_DIR}/backup.log"

mkdir -p "$BACKUP_DIR"

echo "[$(date)] Starting backup for database '${DB_NAME}'..." | tee -a "$LOG_FILE"

if [[ "$DB_TYPE" == "postgres" ]]; then
  PGPASSWORD="$DB_PASS" pg_dump -h "$DB_HOST" -U "$DB_USER" "$DB_NAME" > "$BACKUP_PATH"
elif [[ "$DB_TYPE" == "mysql" ]]; then
  mysqldump -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" > "$BACKUP_PATH"
else
  echo "Unsupported DB_TYPE: $DB_TYPE" | tee -a "$LOG_FILE"
  exit 1
fi

echo "[$(date)] Backup complete: $BACKUP_PATH" | tee -a "$LOG_FILE"
echo "[$(date)] Generating checksum..." | tee -a "$LOG_FILE"
sha256sum "$BACKUP_PATH" > "${BACKUP_PATH}.sha256"
echo "[$(date)] Checksum saved to ${BACKUP_PATH}.sha256" | tee -a "$LOG_FILE"
