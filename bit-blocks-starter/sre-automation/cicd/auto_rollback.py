#!/usr/bin/env python3
"""
auto_rollback.py

Monitors error-budget burn from your SLO system. If burn > threshold,
automatically triggers your last known green CI workflow for rollback.
Requires:
  - GITHUB_TOKEN
  - GITHUB_REPO  (e.g. "org/repo")
  - WORKFLOW_FILE_NAME (filename of your GitHub Actions workflow, e.g. "deploy.yml")
  - SLO_SERVICE_URL
  - SLO_API_TOKEN
  - ERROR_BUDGET_THRESHOLD (e.g. "0.2" for 20%)
"""

import os
import sys
import requests
from github import Github

def fetch_error_budget_burn():
    url = os.getenv("SLO_SERVICE_URL")
    token = os.getenv("SLO_API_TOKEN")
    dr = requests.get(f"{url}/error_budget", headers={"Authorization": f"Bearer {token}"})
    dr.raise_for_status()
    data = dr.json()
    return float(data.get("burn_rate", 0.0))

def trigger_rollback():
    gh = Github(os.getenv("GITHUB_TOKEN"))
    repo = gh.get_repo(os.getenv("GITHUB_REPO"))
    wf_name = os.getenv("WORKFLOW_FILE_NAME")
    # find workflow object
    wf = next(w for w in repo.get_workflows() if w.path.endswith(wf_name))
    runs = repo.get_workflow_runs(wf.id, status="success")
    if runs.totalCount == 0:
        print("❌ No successful runs found to roll back to.")
        sys.exit(1)
    last_green = runs[0]
    repo.create_workflow_dispatch(
        workflow_id=wf.id,
        ref=last_green.head_branch,
        inputs={}
    )
    print(f"✅ Rollback dispatched on commit {last_green.head_sha}")

def main():
    threshold = float(os.getenv("ERROR_BUDGET_THRESHOLD", "0.1"))
    burn = fetch_error_budget_burn()
    print(f"Error budget burn: {burn:.2f}, threshold: {threshold:.2f}")
    if burn > threshold:
        print("🔥 Burn above threshold, rolling back!")
        trigger_rollback()
    else:
        print("✅ Burn within budget, no action.")

if __name__ == "__main__":
    main()
