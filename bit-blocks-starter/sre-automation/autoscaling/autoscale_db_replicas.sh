#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# autoscale_db_replicas.sh
# Description: Scale RDS read replicas (AWS) or Cloud SQL read replicas (GCP).
# Usage: ./autoscale_db_replicas.sh <platform> <master_id> <up_cpu> <down_cpu> <min> <max>
# -----------------------------------------------------------------------------

set -euo pipefail
source "$(dirname "$0")/../../config/.env"

PLATFORM=$1
MASTER=$2
UP_CPU=$3
DOWN_CPU=$4
MIN=$5
MAX=$6

timestamp() { date +"%Y-%m-%d %H:%M:%S"; }

if [[ "$PLATFORM" == "aws" ]]; then
  CPU=$(aws cloudwatch get-metric-statistics \
    --namespace AWS/RDS --metric-name CPUUtilization \
    --dimensions Name=DBInstanceIdentifier,Value="$MASTER" \
    --start-time "$(date -u -d '5 minutes ago' +%Y-%m-%dT%H:%M:%SZ')" \
    --end-time "$(date -u +%Y-%m-%dT%H:%M:%SZ')" \
    --period 300 --statistics Average --query "Datapoints[0].Average" --output text)
  COUNT=$(aws rds describe-db-instances \
    --filters Name=read-replica-source-db-instance-identifier,Values="$MASTER" \
    --query "DBInstances | length(@)" --output text)

  echo "[$(timestamp)] AWS RDS CPU=$CPU%, replicas=$COUNT"

  if (( $(echo "$CPU > $UP_CPU" | bc -l) )) && (( COUNT < MAX )); then
    NEXT=$(( COUNT + 1 ))
    aws rds create-db-instance-read-replica \
      --db-instance-identifier "${MASTER}-rr${NEXT}" \
      --source-db-instance-identifier "$MASTER"
    echo "[$(timestamp)] Creating replica #$NEXT"
  elif (( $(echo "$CPU < $DOWN_CPU" | bc -l) )) && (( COUNT > MIN )); then
    LAST=$(( COUNT ))
    aws rds delete-db-instance --db-instance-identifier "${MASTER}-rr${LAST}" --skip-final-snapshot
    echo "[$(timestamp)] Deleting replica #$LAST"
  else
    echo "[$(timestamp)] No action"
  fi

elif [[ "$PLATFORM" == "gcp" ]]; then
  CPU=$(gcloud monitoring time-series list \
    --filter='metric.type="cloudsql.googleapis.com/database/cpu/utilization"' \
    --limit=1 --format="value(points[0].value.doubleValue)")
  COUNT=$(gcloud sql instances describe "$MASTER" \
    --format="value(replicaNames.size())")

  echo "[$(timestamp)] GCP Cloud SQL CPU=$(printf "%.0f" "$(echo "$CPU * 100")")%, replicas=$COUNT"

  if (( $(echo "$CPU * 100 > $UP_CPU" | bc -l) )) && (( COUNT < MAX )); then
    NEXT=$(( COUNT + 1 ))
    gcloud sql instances create "${MASTER}-rr${NEXT}" \
      --master-instance-name="$MASTER"
    echo "[$(timestamp)] Creating replica #$NEXT"
  elif (( $(echo "$CPU * 100 < $DOWN_CPU" | bc -l) )) && (( COUNT > MIN )); then
    LAST=$(( COUNT ))
    gcloud sql instances delete "${MASTER}-rr${LAST}" --quiet
    echo "[$(timestamp)] Deleting replica #$LAST"
  else
    echo "[$(timestamp)] No action"
  fi

else
  echo "Unsupported platform"
  exit 1
fi
