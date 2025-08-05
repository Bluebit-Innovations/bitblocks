#!/usr/bin/env python3
"""
flaky_test_quarantine.py

Identifies flaky tests via GitHub Actions check runs and creates a quarantine issue.
Requires:
  - GITHUB_TOKEN
  - GITHUB_REPO
  - FLAKY_RUN_COUNT (e.g. "3" — number of recent runs to check)
  - QUARANTINE_LABEL (e.g. "flaky")
"""

import os
from collections import Counter
from github import Github

def main():
    gh    = Github(os.getenv("GITHUB_TOKEN"))
    repo  = gh.get_repo(os.getenv("GITHUB_REPO"))
    runs  = repo.get_workflow_runs(status="failure")
    n     = int(os.getenv("FLAKY_RUN_COUNT", "5"))
    label = os.getenv("QUARANTINE_LABEL", "flaky")

    # Collect failing test names across last n runs
    names = []
    for wr in runs[:n]:
        jobs = wr.get_jobs()
        for job in jobs:
            for step in job.steps:
                if step.conclusion == "failure" and step.name.startswith("pytest"):
                    # assumption: step.name includes test name
                    names.append(step.name)
    counts = Counter(names)
    flaky = [name for name,count in counts.items() if count > 1]
    if not flaky:
        print("✅ No flaky tests detected.")
        return

    body = "## Quarantine these flaky tests:\n" + "\n".join(f"- `{t}`" for t in flaky)
    issue = repo.create_issue(
        title="Flaky Tests Quarantine Report",
        body=body,
        labels=[label]
    )
    print(f"🐛 Created quarantine issue: {issue.html_url}")

if __name__ == "__main__":
    main()
