#!/usr/bin/env python3
"""
ssl_expiry_notifier.py

Checks SSL cert expiration for domains.
Environment variables:
  SSL_DOMAINS               Comma-separated hostnames (e.g. example.com,api.example.com)
  SSL_EXPIRY_THRESHOLD_DAYS Days before expiry to alert (default 30)
  SLACK_WEBHOOK_URL         (optional) Slack Incoming Webhook for notifications
Dependencies:
  pip install python-dotenv
"""

import os
import ssl
import socket
from datetime import datetime
from dotenv import load_dotenv

load_dotenv()

def send_alert(msg: str):
    webhook = os.getenv("SLACK_WEBHOOK_URL")
    if webhook:
        import requests
        requests.post(webhook, json={"text": msg})
    else:
        print(msg)

def get_expiry(hostname: str) -> datetime:
    ctx = ssl.create_default_context()
    with ctx.wrap_socket(socket.socket(), server_hostname=hostname) as s:
        s.settimeout(5)
        s.connect((hostname, 443))
        cert = s.getpeercert()
    expiry_str = cert["notAfter"]  # e.g. 'Apr 10 12:00:00 2026 GMT'
    return datetime.strptime(expiry_str, "%b %d %H:%M:%S %Y %Z")

def main():
    domains = [
        d.strip()
        for d in os.getenv("SSL_DOMAINS", "").split(",")
        if d.strip()
    ]
    threshold = int(os.getenv("SSL_EXPIRY_THRESHOLD_DAYS", "30"))
    now = datetime.utcnow()

    for host in domains:
        ts = now.isoformat()
        try:
            exp = get_expiry(host)
            days_left = (exp - now).days
            if days_left <= threshold:
                send_alert(f"[{ts}] 🔔 {host} cert expires in {days_left} days on {exp.date()}")
            else:
                print(f"[{ts}] ✅ {host} expires in {days_left} days")
        except Exception as e:
            send_alert(f"[{ts}] ❌ {host} SSL check failed: {e}")

if __name__ == "__main__":
    main()
