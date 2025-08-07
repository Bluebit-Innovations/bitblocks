#!/usr/bin/env python3
"""
burnout_detector.py

Analyzes alert logs and on-call hours to spot fatigue.
Env vars:
  ALERT_LOG_PATH         Path to newline-delimited JSON with {"user","timestamp","severity"}
  ONCALL_LOG_PATH        Path to newline-delimited JSON with {"user","start","end"}
  ALERT_THRESHOLD        Alerts/day threshold (default 50)
  HOURS_THRESHOLD        Hours-on-call/day threshold (default 12)
  SLACK_WEBHOOK_URL
Dependencies:
  pip install python-dotenv
"""

import os
import json
import time
from datetime import datetime, timedelta
from collections import defaultdict
from dotenv import load_dotenv

load_dotenv()

ALERT_LOG = os.getenv("ALERT_LOG_PATH")
ONCALL_LOG = os.getenv("ONCALL_LOG_PATH")
A_THRESH = int(os.getenv("ALERT_THRESHOLD", "50"))
H_THRESH = int(os.getenv("HOURS_THRESHOLD", "12"))
WEBHOOK  = os.getenv("SLACK_WEBHOOK_URL")

def load_json_lines(path):
    with open(path) as f:
        return [json.loads(l) for l in f]

def send(msg):
    if WEBHOOK:
        import requests
        requests.post(WEBHOOK, json={"text": msg})
    else:
        print(msg)

def job():
    today = datetime.utcnow().date()
    alerts = load_json_lines(ALERT_LOG)
    calls  = load_json_lines(ONCALL_LOG)
    # count alerts per user today
    a_count = defaultdict(int)
    for a in alerts:
        ts = datetime.fromisoformat(a["timestamp"])
        if ts.date() == today:
            a_count[a["user"]] += 1
    # sum on-call hours per user today
    h_count = defaultdict(float)
    for c in calls:
        start = datetime.fromisoformat(c["start"])
        end   = datetime.fromisoformat(c["end"])
        if start.date() == today:
            h_count[c["user"]] += (min(end, datetime.utcnow()) - start).total_seconds()/3600
    # detect fatigue
    for user in set(a_count)|set(h_count):
        ac = a_count.get(user,0)
        hc = h_count.get(user,0)
        if ac > A_THRESH or hc > H_THRESH:
            send(f"⚠️ *Burnout risk*: {user} had {ac} alerts and {hc:.1f}h on-call today")

if __name__ == "__main__":
    job()
