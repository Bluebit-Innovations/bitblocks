#!/usr/bin/env python3
"""
health_probes.py

Performs HTTP GET health checks against a list of endpoints.
Environment variables:
  HEALTH_ENDPOINTS       Comma-separated URLs to probe (e.g. https://svc1/health,https://svc2/health)
  SLACK_WEBHOOK_URL      (optional) Slack Incoming Webhook for notifications
Dependencies:
  pip install requests python-dotenv
"""

import os
import requests
from datetime import datetime
from dotenv import load_dotenv

load_dotenv()

def send_notification(msg: str):
    webhook = os.getenv("SLACK_WEBHOOK_URL")
    if webhook:
        requests.post(webhook, json={"text": msg})
    else:
        print(msg)

def main():
    endpoints = [
        url.strip()
        for url in os.getenv("HEALTH_ENDPOINTS", "").split(",")
        if url.strip()
    ]
    for url in endpoints:
        ts = datetime.utcnow().isoformat()
        try:
            r = requests.get(url, timeout=5)
            if r.status_code == 200:
                print(f"[{ts}] OK → {url}")
            else:
                send_notification(f"[{ts}] ⚠️ {url} returned {r.status_code}")
        except Exception as e:
            send_notification(f"[{ts}] ❌ {url} exception: {e}")

if __name__ == "__main__":
    main()
