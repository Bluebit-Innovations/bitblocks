#!/usr/bin/env python3
"""
rotate_secrets.py

Periodically rotate secrets in AWS Secrets Manager, GCP Secret Manager,
Azure Key Vault, and HashiCorp Vault.
Requires env vars (example in .env):
  AWS_REGION, GCP_PROJECT, AZURE_VAULT_URL,
  VAULT_URL, VAULT_TOKEN
Dependencies:
  pip install boto3 google-cloud-secret-manager azure-identity azure-keyvault-secrets hvac python-dotenv
"""

import os
import boto3
from google.cloud import secretmanager
from azure.identity import DefaultAzureCredential
from azure.keyvault.secrets import SecretClient
import hvac
from dotenv import load_dotenv

load_dotenv()

def rotate_aws_secret(name):
    client = boto3.client("secretsmanager", region_name=os.getenv("AWS_REGION"))
    # create new random secret; for demo we append timestamp
    new_val = client.get_secret_value(SecretId=name)["SecretString"] + "_" + str(int(__import__("time").time()))
    client.put_secret_value(SecretId=name, SecretString=new_val)
    print(f"AWS secret rotated: {name}")

def rotate_gcp_secret(name):
    client = secretmanager.SecretManagerServiceClient()
    parent = f"projects/{os.getenv('GCP_PROJECT')}/secrets/{name}"
    payload = f"new-value-{int(__import__('time').time())}".encode("UTF-8")
    client.add_secret_version(request={"parent": parent, "payload": {"data": payload}})
    print(f"GCP secret rotated: {name}")

def rotate_azure_secret(name):
    credential = DefaultAzureCredential()
    vault_url = os.getenv("AZURE_VAULT_URL")
    client = SecretClient(vault_url=vault_url, credential=credential)
    new_val = client.get_secret(name).value + "_" + str(int(__import__("time").time()))
    client.set_secret(name, new_val)
    print(f"Azure KeyVault secret rotated: {name}")

def rotate_vault_secret(path):
    client = hvac.Client(url=os.getenv("VAULT_URL"), token=os.getenv("VAULT_TOKEN"))
    old = client.secrets.kv.v2.read_secret_version(path=path)["data"]["data"]
    new = {**old, "rotated_at": str(int(__import__("time").time()))}
    client.secrets.kv.v2.create_or_update_secret(path=path, secret=new)
    print(f"Vault KV rotated: {path}")

if __name__ == "__main__":
    for sec in os.getenv("AWS_SECRETS", "").split(","):
        if sec: rotate_aws_secret(sec.strip())
    for sec in os.getenv("GCP_SECRETS", "").split(","):
        if sec: rotate_gcp_secret(sec.strip())
    for sec in os.getenv("AZURE_SECRETS", "").split(","):
        if sec: rotate_azure_secret(sec.strip())
    for path in os.getenv("VAULT_SECRETS", "").split(","):
        if path: rotate_vault_secret(path.strip())
