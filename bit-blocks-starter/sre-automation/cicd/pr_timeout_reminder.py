#!/usr/bin/env python3
"""
pr_timeout_reminder.py

Finds stale GitHub PRs that haven’t had updates in N days and posts a reminder comment.
Requires:
  - GITHUB_TOKEN
  - GITHUB_REPO
  - PR_STALE_DAYS (e.g. "7")
  - REMINDER_MESSAGE (the comment to post)
"""

import os
import datetime
from github import Github

def main():
    gh      = Github(os.getenv("GITHUB_TOKEN"))
    repo    = gh.get_repo(os.getenv("GITHUB_REPO"))
    stale   = int(os.getenv("PR_STALE_DAYS", "7"))
    message = os.getenv("REMINDER_MESSAGE", "Friendly reminder to revisit this PR 😊")

    cutoff = datetime.datetime.utcnow() - datetime.timedelta(days=stale)
    for pr in repo.get_pulls(state="open", sort="updated", direction="asc"):
        if pr.updated_at < cutoff:
            print(f"🔔 PR #{pr.number} is stale (last updated {pr.updated_at}). Commenting...")
            pr.create_issue_comment(message)

if __name__ == "__main__":
    main()
