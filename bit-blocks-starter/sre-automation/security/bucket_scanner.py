#!/usr/bin/env python3
"""
bucket_scanner.py

Scans public AWS S3 / GCP Storage / Azure Blob containers and optionally remediates.
Requires env vars:
  AWS_REGION, GCP_PROJECT, AZURE_STORAGE_ACCOUNT, AZURE_STORAGE_KEY
Dependencies:
  pip install boto3 google-cloud-storage azure-storage-blob python-dotenv
"""

import os
from dotenv import load_dotenv

load_dotenv()

def remediate_aws_bucket(name):
    import boto3
    s3 = boto3.client("s3", region_name=os.getenv("AWS_REGION"))
    acl = s3.get_bucket_acl(Bucket=name)
    for grant in acl["Grants"]:
        if grant["Grantee"].get("URI","").endswith("AllUsers"):
            s3.put_public_access_block(
                Bucket=name,
                PublicAccessBlockConfiguration={
                    "BlockPublicAcls": True,
                    "IgnorePublicAcls": True,
                    "BlockPublicPolicy": True,
                    "RestrictPublicBuckets": True,
                }
            )
            print(f"🔒 Remediated AWS bucket: {name}")
            return
    print(f"✅ AWS bucket OK: {name}")

def scan_gcp_bucket(name):
    from google.cloud import storage
    client = storage.Client(project=os.getenv("GCP_PROJECT"))
    bucket = client.get_bucket(name)
    iam = bucket.get_iam_policy()
    for binding in iam.bindings:
        if "allUsers" in binding["members"]:
            binding["members"].remove("allUsers")
            bucket.set_iam_policy(iam)
            print(f"🔒 Remediated GCP bucket: {name}")
            return
    print(f"✅ GCP bucket OK: {name}")

def scan_azure_container(name):
    from azure.storage.blob import ContainerClient
    client = ContainerClient(
        account_url=f"https://{os.getenv('AZURE_STORAGE_ACCOUNT')}.blob.core.windows.net",
        container_name=name,
        credential=os.getenv("AZURE_STORAGE_KEY")
    )
    props = client.get_container_properties()
    if props.public_access:
        client.set_container_access_policy(public_access=None)
        print(f"🔒 Remediated Azure container: {name}")
    else:
        print(f"✅ Azure container OK: {name}")

if __name__ == "__main__":
    for b in os.getenv("AWS_BUCKETS", "").split(","):
        if b: remediate_aws_bucket(b.strip())
    for b in os.getenv("GCP_BUCKETS", "").split(","):
        if b: scan_gcp_bucket(b.strip())
    for c in os.getenv("AZURE_CONTAINERS", "").split(","):
        if c: scan_azure_container(c.strip())
