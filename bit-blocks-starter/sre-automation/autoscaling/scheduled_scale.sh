#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# scheduled_scale.sh
# Description: Scale a group to a fixed size based on weekday/weekend.
# Usage: ./scheduled_scale.sh <platform> <group> <weekday_size> <weekend_size>
# -----------------------------------------------------------------------------

set -euo pipefail
source "$(dirname "$0")/../../config/.env"

PLATFORM=$1         # aws or gcp
GROUP=$2            # ASG name or MIG name
WD_SIZE=$3          # e.g. 3
WE_SIZE=$4          # e.g. 1
HOUR=$(date +%u)    # 1=Mon … 7=Sun

TARGET=$([[ "$HOUR" -ge 6 ]] && echo "$WE_SIZE" || echo "$WD_SIZE")

echo "[$(date)] Scheduling scale for $GROUP => $TARGET"

if [[ "$PLATFORM" == "aws" ]]; then
  aws autoscaling set-desired-capacity --auto-scaling-group-name "$GROUP" \
        --desired-capacity "$TARGET"
elif [[ "$PLATFORM" == "gcp" ]]; then
  gcloud compute instance-groups managed resize "$GROUP" \
        --size="$TARGET" --zone="$GCP_ZONE"
else
  echo "Unsupported platform"
  exit 1
fi
echo "[$(date)] Scaling operation complete for $GROUP to $TARGET instances."