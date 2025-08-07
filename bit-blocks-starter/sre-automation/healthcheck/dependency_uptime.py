#!/usr/bin/env python3
"""
dependency_uptime.py

Checks uptime of 3rd-party API endpoints.
Environment variables:
  DEPENDENCY_APIS       Comma-separated URLs (e.g. https://api.stripe.com,https://api.sendgrid.com)
  UPTIME_THRESHOLD_MS   Milliseconds max acceptable latency (default 500ms)
  SLACK_WEBHOOK_URL     (optional) Slack Incoming Webhook for alerts
Dependencies:
  pip install requests python-dotenv
"""

import os
import requests
from datetime import datetime
from dotenv import load_dotenv

load_dotenv()

def send_alert(msg: str):
    webhook = os.getenv("SLACK_WEBHOOK_URL")
    if webhook:
        requests.post(webhook, json={"text": msg})
    else:
        print(msg)

def main():
    apis = [
        url.strip()
        for url in os.getenv("DEPENDENCY_APIS", "").split(",")
        if url.strip()
    ]
    thresh = int(os.getenv("UPTIME_THRESHOLD_MS", "500"))
    for url in apis:
        ts = datetime.utcnow().isoformat()
        try:
            r = requests.get(url, timeout=10)
            latency = int(r.elapsed.total_seconds() * 1000)
            if r.status_code != 200 or latency > thresh:
                send_alert(f"[{ts}] ⚠️ {url} status={r.status_code} latency={latency}ms")
            else:
                print(f"[{ts}] OK → {url} ({latency}ms)")
        except Exception as e:
            send_alert(f"[{ts}] ❌ {url} exception: {e}")

if __name__ == "__main__":
    main()
