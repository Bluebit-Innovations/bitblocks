#!/usr/bin/env python3
"""
daily_health_summary.py

Gathers key metrics (uptime, error rates, capacity) and posts a Slack digest or emails a report.
Env vars:
  SLACK_WEBHOOK_URL        Incoming webhook for Slack (optional)
  EMAIL_SMTP_SERVER        SMTP server (optional)
  EMAIL_SMTP_PORT          SMTP port
  EMAIL_USER               SMTP username
  EMAIL_PASS               SMTP password
  EMAIL_RECIPIENTS         Comma-separated emails
  METRIC_ENDPOINTS         Comma-separated URLs returning JSON with {"name","value"}
Dependencies:
  pip install requests python-dotenv schedule
"""

import os
import json
import smtplib
import requests
import schedule
import time
from email.message import EmailMessage
from datetime import datetime
from dotenv import load_dotenv

load_dotenv()

SLACK_WEBHOOK = os.getenv("SLACK_WEBHOOK_URL")
SMTP_SERVER   = os.getenv("EMAIL_SMTP_SERVER")
SMTP_PORT     = int(os.getenv("EMAIL_SMTP_PORT", "587"))
SMTP_USER     = os.getenv("EMAIL_USER")
SMTP_PASS     = os.getenv("EMAIL_PASS")
RECIPIENTS    = [e.strip() for e in os.getenv("EMAIL_RECIPIENTS", "").split(",") if e.strip()]
METRICS       = [u.strip() for u in os.getenv("METRIC_ENDPOINTS", "").split(",") if u.strip()]

def fetch_metrics():
    report = []
    for url in METRICS:
        try:
            r = requests.get(url, timeout=5)
            data = r.json()
            report.append(f"- {data['name']}: {data['value']}")
        except Exception as e:
            report.append(f"- ⚠️ Failed to fetch {url}: {e}")
    return report

def send_slack(msg: str):
    if SLACK_WEBHOOK:
        requests.post(SLACK_WEBHOOK, json={"text": msg})
    else:
        print(msg)

def send_email(subject: str, body: str):
    if not SMTP_SERVER or not RECIPIENTS:
        return
    msg = EmailMessage()
    msg["Subject"] = subject
    msg["From"] = SMTP_USER
    msg["To"] = ", ".join(RECIPIENTS)
    msg.set_content(body)
    with smtplib.SMTP(SMTP_SERVER, SMTP_PORT) as s:
        s.starttls()
        s.login(SMTP_USER, SMTP_PASS)
        s.send_message(msg)

def job():
    ts = datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S UTC")
    lines = [f"*Daily Health Summary* — {ts}", *fetch_metrics()]
    text = "\n".join(lines)
    send_slack(text)
    send_email("Daily Health Summary", text)

# Schedule at 08:00 UTC daily
schedule.every().day.at("08:00").do(job)

if __name__ == "__main__":
    while True:
        schedule.run_pending()
        time.sleep(30)
