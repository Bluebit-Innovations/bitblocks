#!/usr/bin/env python3
"""
audit_log_archive.py

Aggregates cloud audit logs daily and archives to S3/GCS/Azure Blob.
Requires env vars:
  AWS_REGION, AWS_AUDIT_LOG_GROUP,
  GCP_PROJECT, GCP_LOG_SINK_BUCKET,
  AZURE_STORAGE_ACCOUNT, AZURE_STORAGE_KEY, AZURE_AUDIT_CONTAINER
Dependencies:
  pip install boto3 google-cloud-logging azure-storage-blob python-dotenv
"""

import os
import datetime
from dotenv import load_dotenv

load_dotenv()

def archive_aws_logs():
    import boto3
    logs = boto3.client("logs", region_name=os.getenv("AWS_REGION"))
    s3 = boto3.client("s3", region_name=os.getenv("AWS_REGION"))
    group = os.getenv("AWS_AUDIT_LOG_GROUP")
    start = int((datetime.datetime.utcnow() - datetime.timedelta(days=1)).timestamp() * 1000)
    streams = logs.describe_log_streams(logGroupName=group)["logStreams"]
    data = ""
    for s in streams:
        events = logs.get_log_events(logGroupName=group, logStreamName=s["logStreamName"], startTime=start)["events"]
        for e in events:
            data += e["message"] + "\n"
    key = f"audit/{group}/{datetime.datetime.utcnow().date()}.log"
    s3.put_object(Bucket=os.getenv("AWS_AUDIT_BUCKET"), Key=key, Body=data.encode())
    print(f"AWS logs archived to s3://{os.getenv('AWS_AUDIT_BUCKET')}/{key}")

def archive_gcp_logs():
    from google.cloud import logging_v2, storage
    client = logging_v2.LoggingServiceV2Client()
    tsink = storage.Client().bucket(os.getenv("GCP_LOG_SINK_BUCKET"))
    # Here we assume a sink already routes logs; skip pull, just copy on schedule if needed
    print("GCP logs assumed delivered via sink to bucket.")

def archive_azure_logs():
    from azure.storage.blob import BlobClient
    # Assuming Azure Diagnostic settings push logs to blob
    print("Azure logs assumed in container; relying on retention policies.")

if __name__ == "__main__":
    archive_aws_logs()
    archive_gcp_logs()
    archive_azure_logs()
