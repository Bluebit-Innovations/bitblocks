#!/usr/bin/env python3
"""
issue_labeler.py

Auto-labels new GitHub issues containing reliability keywords.
Env vars:
  GITHUB_TOKEN
  GITHUB_REPO       e.g. org/repo
  RELIABILITY_LABEL Label name to apply (e.g. "reliability")
  KEYWORDS          Comma-separated terms to match (e.g. outage,latency)
Dependencies:
  pip install PyGithub python-dotenv schedule
"""

import os
import time
import schedule
from github import Github
from datetime import datetime

from dotenv import load_dotenv
load_dotenv()

gh       = Github(os.getenv("GITHUB_TOKEN"))
repo     = gh.get_repo(os.getenv("GITHUB_REPO"))
label    = os.getenv("RELIABILITY_LABEL", "reliability")
keywords = [k.strip().lower() for k in os.getenv("KEYWORDS", "").split(",")]

def job():
    for issue in repo.get_issues(state="open", sort="created", direction="asc")[:50]:
        title = issue.title.lower()
        body  = (issue.body or "").lower()
        if label not in [l.name for l in issue.labels]:
            if any(kw in title or kw in body for kw in keywords):
                issue.add_to_labels(label)
                print(f"[{datetime.utcnow()}] Labeled issue #{issue.number}")

schedule.every(2).minutes.do(job)

if __name__ == "__main__":
    while True:
        schedule.run_pending()
        time.sleep(10)
