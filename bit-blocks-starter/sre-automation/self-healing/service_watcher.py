#!/usr/bin/env python3
"""
service_watcher.py

Monitors critical Linux services via systemd and restarts them if they go down.
Environment variables:
  WATCH_SERVICES       Comma-separated systemd unit names (e.g. nginx,redis.service)
  CHECK_INTERVAL       Seconds between checks (default: 60)
  SLACK_WEBHOOK_URL    (optional) Incoming webhook for alerts
Dependencies:
  pip install python-dotenv requests
"""

import os
import subprocess
import time
from datetime import datetime
from dotenv import load_dotenv

load_dotenv()

SERVICES = [s.strip() for s in os.getenv("WATCH_SERVICES", "").split(",") if s.strip()]
INTERVAL = int(os.getenv("CHECK_INTERVAL", "60"))
WEBHOOK = os.getenv("SLACK_WEBHOOK_URL")

def log(msg: str):
    ts = datetime.utcnow().isoformat()
    print(f"[{ts}] {msg}")

def notify(msg: str):
    if WEBHOOK:
        import requests
        requests.post(WEBHOOK, json={"text": msg})
    else:
        log(msg)

def is_active(service: str) -> bool:
    try:
        subprocess.run(
            ["systemctl", "is-active", "--quiet", service],
            check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL
        )
        return True
    except subprocess.CalledProcessError:
        return False

def restart(service: str):
    log(f"Attempting restart: {service}")
    try:
        subprocess.run(
            ["systemctl", "restart", service],
            check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE
        )
        notify(f"✅ Service `{service}` restarted successfully")
    except subprocess.CalledProcessError as e:
        notify(f"❌ Failed to restart `{service}`: {e.stderr.decode().strip()}")

def main():
    if not SERVICES:
        log("No services configured. Set WATCH_SERVICES.")
        return
    log(f"Watching services: {SERVICES}")
    while True:
        for svc in SERVICES:
            if not is_active(svc):
                notify(f"⚠️ Service `{svc}` is down. Restarting...")
                restart(svc)
        time.sleep(INTERVAL)

if __name__ == "__main__":
    main()
