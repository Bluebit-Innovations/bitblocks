#!/usr/bin/env python3
"""
saas_integration_test.py

Runs quick integration tests against Stripe, webhooks, and SMTP.
Environment variables:
  STRIPE_API_KEY          Your Stripe secret key
  WEBHOOK_URL            URL to POST a test payload
  SMTP_SERVER            e.g. smtp.example.com
  SMTP_PORT              e.g. 587
  SMTP_USER              SMTP username
  SMTP_PASS              SMTP password
  TEST_EMAIL_RECIPIENT    Address to send a test email
  SLACK_WEBHOOK_URL      (optional) Slack Incoming Webhook for notifications
Dependencies:
  pip install requests python-dotenv
"""

import os
import smtplib
import json
from datetime import datetime
from email.message import EmailMessage
from dotenv import load_dotenv
import requests

load_dotenv()

def notify(msg: str):
    webhook = os.getenv("SLACK_WEBHOOK_URL")
    if webhook:
        requests.post(webhook, json={"text": msg})
    else:
        print(msg)

def test_stripe():
    key = os.getenv("STRIPE_API_KEY")
    url = "https://api.stripe.com/v1/charges?limit=1"
    ts = datetime.utcnow().isoformat()
    try:
        r = requests.get(url, auth=(key, ""))
        if r.status_code == 200:
            print(f"[{ts}] ✅ Stripe API OK")
        else:
            notify(f"[{ts}] ⚠️ Stripe API returned {r.status_code}")
    except Exception as e:
        notify(f"[{ts}] ❌ Stripe API error: {e}")

def test_webhook():
    url = os.getenv("WEBHOOK_URL")
    payload = {"event": "test", "timestamp": datetime.utcnow().isoformat()}
    ts = datetime.utcnow().isoformat()
    try:
        r = requests.post(url, json=payload, timeout=5)
        if 200 <= r.status_code < 300:
            print(f"[{ts}] ✅ Webhook {url} OK")
        else:
            notify(f"[{ts}] ⚠️ Webhook {url} returned {r.status_code}")
    except Exception as e:
        notify(f"[{ts}] ❌ Webhook {url} error: {e}")

def test_email():
    ts = datetime.utcnow().isoformat()
    msg = EmailMessage()
    msg["Subject"] = "Test Email from SRE Automation"
    msg["From"] = os.getenv("SMTP_USER")
    msg["To"] = os.getenv("TEST_EMAIL_RECIPIENT")
    msg.set_content(f"Timestamp: {ts}")

    try:
        with smtplib.SMTP(os.getenv("SMTP_SERVER"), int(os.getenv("SMTP_PORT", "587"))) as smtp:
            smtp.starttls()
            smtp.login(os.getenv("SMTP_USER"), os.getenv("SMTP_PASS"))
            smtp.send_message(msg)
        print(f"[{ts}] ✅ Test email sent to {msg['To']}")
    except Exception as e:
        notify(f"[{ts}] ❌ Email send failed: {e}")

def main():
    test_stripe()
    test_webhook()
    test_email()

if __name__ == "__main__":
    main()
