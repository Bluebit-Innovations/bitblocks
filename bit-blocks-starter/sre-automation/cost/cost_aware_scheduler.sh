#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# cost_aware_scheduler.sh
# Description: Stop/start tagged instances outside business hours to save cost.
# Usage: ./cost_aware_scheduler.sh <platform> <tag_key> <tag_val> <start_hour> <end_hour>
# -----------------------------------------------------------------------------

set -euo pipefail
source "$(dirname "$0")/../../config/.env"

PLATFORM=$1           # aws or gcp
TAG_KEY=$2            # e.g. "Env"
TAG_VAL=$3            # e.g. "dev"
OFF_START=$4          # e.g. 20 (8 PM)
OFF_END=$5            # e.g. 6  (6 AM)

HOUR=$(date +%H)

in_offhours() {
  if (( OFF_START > OFF_END )); then
    (( HOUR >= OFF_START || HOUR < OFF_END ))
  else
    (( HOUR >= OFF_START && HOUR < OFF_END ))
  fi
}

if in_offhours; then
  ACTION="stop"
else
  ACTION="start"
fi

echo "[$(date)] $ACTION instances tagged $TAG_KEY=$TAG_VAL"

if [[ "$PLATFORM" == "aws" ]]; then
  INSTANCES=$(aws ec2 describe-instances \
    --filters "Name=tag:${TAG_KEY},Values=${TAG_VAL}" \
              "Name=instance-state-name,Values=running,stopped" \
    --query "Reservations[].Instances[].InstanceId" --output text)

  for id in $INSTANCES; do
    aws ec2 "${ACTION}-instances" --instance-ids "$id"
    echo "  → $ACTION $id"
  done

elif [[ "$PLATFORM" == "gcp" ]]; then
  ZONES=$(gcloud compute instances list \
    --filter="labels.${TAG_KEY}=${TAG_VAL}" \
    --format="value(zone.basename())" | sort -u)
  for zone in $ZONES; do
    INSTANCES=$(gcloud compute instances list \
      --filter="labels.${TAG_KEY}=${TAG_VAL}" \
      --zones="$zone" \
      --format="value(name)")
    for inst in $INSTANCES; do
      gcloud compute instances "$ACTION" "$inst" --zone="$zone" --quiet
      echo "  → $ACTION $inst ($zone)"
    done
  done

else
  echo "Unsupported platform"
  exit 1
fi
