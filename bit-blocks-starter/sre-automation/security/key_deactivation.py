#!/usr/bin/env python3
"""
key_deactivation.py

Deactivates AWS IAM, GCP Service Account keys, Azure AD app passwords after inactivity.
Requires env vars:
  AWS_REGION, GCP_PROJECT, AZURE_TENANT_ID, AZURE_CLIENT_ID, AZURE_CLIENT_SECRET
Dependencies:
  pip install boto3 google-api-python-client azure-identity msgraph-core python-dotenv
"""

import os
import datetime
from dotenv import load_dotenv

load_dotenv()

def deactivate_aws_keys():
    import boto3
    iam = boto3.client("iam", region_name=os.getenv("AWS_REGION"))
    for user in iam.list_users()["Users"]:
        for key in iam.list_access_keys(UserName=user["UserName"])["AccessKeyMetadata"]:
            last = iam.get_access_key_last_used(AccessKeyId=key["AccessKeyId"])["AccessKeyLastUsed"]["LastUsedDate"]
            if last and (datetime.datetime.utcnow() - last).days > int(os.getenv("AWS_KEY_MAX_DAYS", "90")):
                iam.update_access_key(UserName=user["UserName"], AccessKeyId=key["AccessKeyId"], Status="Inactive")
                print(f"⏸ Inactivated AWS key {key['AccessKeyId']} for {user['UserName']}")

def deactivate_gcp_keys():
    from google.oauth2 import service_account
    from googleapiclient import discovery
    svc = service_account.Credentials.from_service_account_file(os.getenv("GOOGLE_APPLICATION_CREDENTIALS"))
    svc_api = discovery.build("iam", "v1", credentials=svc)
    # GCP doesn’t track last use, so we base on createTime vs threshold
    threshold = datetime.datetime.utcnow() - datetime.timedelta(days=int(os.getenv("GCP_KEY_MAX_DAYS", "90")))
    for sa in svc_api.projects().serviceAccounts().list(name=f"projects/{os.getenv('GCP_PROJECT')}").execute().get("accounts", []):
        keys = svc_api.projects().serviceAccounts().keys().list(name=sa["name"], keyTypes=["USER_MANAGED"]).execute()["keys"]
        for k in keys:
            created = datetime.datetime.fromisoformat(k["validAfterTime"].replace("Z","+00:00"))
            if created < threshold:
                svc_api.projects().serviceAccounts().keys().delete(name=k["name"]).execute()
                print(f"🗑 Deleted GCP key {k['name']}")

def deactivate_azure_keys():
    from azure.identity import ClientSecretCredential
    from msgraph.core import GraphClient
    cred = ClientSecretCredential(
        tenant_id=os.getenv("AZURE_TENANT_ID"),
        client_id=os.getenv("AZURE_CLIENT_ID"),
        client_secret=os.getenv("AZURE_CLIENT_SECRET")
    )
    graph = GraphClient(credential=cred)
    threshold = datetime.datetime.utcnow() - datetime.timedelta(days=int(os.getenv("AZURE_KEY_MAX_DAYS", "90")))
    users = graph.get("/users").json()["value"]
    for u in users:
        creds = graph.get(f"/users/{u['id']}/authentication/passwordMethods").json()["value"]
        for c in creds:
            created = datetime.datetime.fromisoformat(c["createdDateTime"].replace("Z","+00:00"))
            if created < threshold:
                graph.delete(f"/users/{u['id']}/authentication/passwordMethods/{c['id']}")
                print(f"🔒 Revoked Azure auth method {c['id']} for {u['userPrincipalName']}")

if __name__ == "__main__":
    deactivate_aws_keys()
    deactivate_gcp_keys()
    deactivate_azure_keys()
