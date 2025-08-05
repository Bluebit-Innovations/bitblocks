#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# sync_to_s3.sh
# Description: Sync local backups to an AWS S3 bucket for offsite storage.
# Usage: ./sync_to_s3.sh
# -----------------------------------------------------------------------------

set -euo pipefail

source "$(dirname "$0")/../../config/.env"

echo "[$(date)] Syncing backups from ${BACKUP_DIR} to s3://${S3_BUCKET}/${S3_PREFIX:-backups}/"

aws s3 sync \
  "$BACKUP_DIR/" \
  "s3://${S3_BUCKET}/${S3_PREFIX:-backups}/" \
  --profile "$AWS_PROFILE" \
  --region "$AWS_REGION" \
  --delete

echo "[$(date)] Sync complete."
