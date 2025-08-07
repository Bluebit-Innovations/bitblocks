#!/usr/bin/env python3
"""
oncall_notifier.py

Reads a rota file and messages the next person on Slack/email at shift start.
Env vars:
  ONCALL_ROTA_FILE        Path to CSV: shift_start_iso,shift_end_iso,user_slack,user_email
  SLACK_WEBHOOK_URL
  EMAIL_SMTP_SERVER,EMAIL_SMTP_PORT,EMAIL_USER,EMAIL_PASS
Dependencies:
  pip install python-dotenv slack-sdk schedule
"""

import os
import csv
import time
import smtplib
from datetime import datetime
from slack_sdk import WebhookClient
from email.message import EmailMessage
from dotenv import load_dotenv
import schedule

load_dotenv()

ROTA_FILE   = os.getenv("ONCALL_ROTA_FILE")
SLACK_URL   = os.getenv("SLACK_WEBHOOK_URL")
SMTP_SERVER = os.getenv("EMAIL_SMTP_SERVER")
SMTP_PORT   = int(os.getenv("EMAIL_SMTP_PORT", "587"))
SMTP_USER   = os.getenv("EMAIL_USER")
SMTP_PASS   = os.getenv("EMAIL_PASS")

def notify(slack_id: str, email: str, msg: str):
    if SLACK_URL and slack_id:
        WebhookClient(SLACK_URL).send(text=f"<@{slack_id}> {msg}")
    if SMTP_SERVER and email:
        m = EmailMessage()
        m["Subject"] = "On-Call Shift Start"
        m["From"]    = SMTP_USER
        m["To"]      = email
        m.set_content(msg)
        with smtplib.SMTP(SMTP_SERVER, SMTP_PORT) as s:
            s.starttls()
            s.login(SMTP_USER, SMTP_PASS)
            s.send_message(m)

def job():
    now = datetime.utcnow()
    with open(ROTA_FILE) as f:
        for row in csv.DictReader(f):
            start = datetime.fromisoformat(row["shift_start_iso"])
            if start <= now < datetime.fromisoformat(row["shift_end_iso"]):
                notify(row["user_slack"], row["user_email"],
                       f"Your on-call shift has started at {start.isoformat()} UTC")
                break

# Check every minute
schedule.every(1).minutes.do(job)

if __name__ == "__main__":
    while True:
        schedule.run_pending()
        time.sleep(10)
