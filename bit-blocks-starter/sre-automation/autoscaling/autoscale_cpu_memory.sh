#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# autoscale_cpu_memory.sh
# Description: Poll CPU utilization and scale an ASG (AWS) or Managed Instance Group (GCP).
# Usage: ./autoscale_cpu_memory.sh <platform> <group_name> <up_thresh> <down_thresh> <min> <max>
# Example: ./autoscale_cpu_memory.sh aws my-asg 70 30 2 10
# -----------------------------------------------------------------------------

set -euo pipefail
source "$(dirname "$0")/../../config/.env"

PLATFORM=$1          # "aws" or "gcp"
GROUP=$2             # ASG name or MIG name
UP_THRESH=$3         # e.g. 70 (%)
DOWN_THRESH=$4       # e.g. 30 (%)
MIN_CAP=$5           # e.g. 2
MAX_CAP=$6           # e.g. 10

timestamp() { date +"%Y-%m-%d %H:%M:%S"; }

if [[ "$PLATFORM" == "aws" ]]; then
  # get average CPU over last 5m
  CPU=$(aws cloudwatch get-metric-statistics \
    --metric-name CPUUtilization --start-time "$(date -u -d '5 minutes ago' +%Y-%m-%dT%H:%M:%SZ')" \
    --end-time "$(date -u +%Y-%m-%dT%H:%M:%SZ')" \
    --period 300 --namespace AWS/EC2 \
    --statistics Average \
    --dimensions Name=AutoScalingGroupName,Value="$GROUP" \
    --query "Datapoints[0].Average" --output text)
  TARGET=$(aws autoscaling describe-auto-scaling-groups \
    --auto-scaling-group-names "$GROUP" \
    --query "AutoScalingGroups[0].DesiredCapacity" --output text)

  echo "[$(timestamp)] AWS CPU=$CPU%, desired=$TARGET"

  if (( $(echo "$CPU > $UP_THRESH" | bc -l) )); then
    NEW=$(( TARGET + 1 ))
  elif (( $(echo "$CPU < $DOWN_THRESH" | bc -l) )); then
    NEW=$(( TARGET - 1 ))
  else
    echo "[$(timestamp)] Within thresholds; no action."
    exit 0
  fi

  # clamp
  [[ $NEW -lt $MIN_CAP ]] && NEW=$MIN_CAP
  [[ $NEW -gt $MAX_CAP ]] && NEW=$MAX_CAP

  echo "[$(timestamp)] Scaling to $NEW"
  aws autoscaling set-desired-capacity --auto-scaling-group-name "$GROUP" --desired-capacity "$NEW"

elif [[ "$PLATFORM" == "gcp" ]]; then
  # get CPU from Stackdriver
  CPU=$(gcloud monitoring time-series list \
    --filter='metric.type="compute.googleapis.com/instance/cpu/utilization"' \
    --limit=1 --format="value(points[0].value.doubleValue)")
  TARGET=$(gcloud compute instance-groups managed describe "$GROUP" \
    --zone="$GCP_ZONE" --format="value(targetSize)")

  echo "[$(timestamp)] GCP CPU=$(printf "%.0f" "$(echo "$CPU * 100" )")%, desired=$TARGET"

  if (( $(echo "$CPU * 100 > $UP_THRESH" | bc -l) )); then
    NEW=$(( TARGET + 1 ))
  elif (( $(echo "$CPU * 100 < $DOWN_THRESH" | bc -l) )); then
    NEW=$(( TARGET - 1 ))
  else
    echo "[$(timestamp)] Within thresholds; no action."
    exit 0
  fi

  [[ $NEW -lt $MIN_CAP ]] && NEW=$MIN_CAP
  [[ $NEW -gt $MAX_CAP ]] && NEW=$MAX_CAP

  echo "[$(timestamp)] Scaling to $NEW"
  gcloud compute instance-groups managed resize "$GROUP" \
    --size="$NEW" --zone="$GCP_ZONE"
else
  echo "Unsupported platform: $PLATFORM"
  exit 1
fi
