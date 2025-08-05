#!/usr/bin/env python3
"""
stuck_pipeline_detector.py

Detects running Jenkins jobs exceeding a duration threshold and restarts them.
Requires:
  - JENKINS_URL
  - JENKINS_USER
  - JENKINS_TOKEN
  - JOB_NAME
  - STUCK_THRESHOLD_MINUTES (e.g. "60")
"""

import os
import time
import jenkins

def main():
    url      = os.getenv("JENKINS_URL")
    user     = os.getenv("JENKINS_USER")
    token    = os.getenv("JENKINS_TOKEN")
    job      = os.getenv("JOB_NAME")
    threshold = int(os.getenv("STUCK_THRESHOLD_MINUTES", "60"))

    server = jenkins.Jenkins(url, username=user, password=token)
    builds = server.get_running_builds()
    now = time.time()
    for b in builds:
        if b['name'] != job:
            continue
        info = server.get_build_info(job, b['number'])
        duration = now - (info['timestamp'] / 1000)
        if duration > threshold * 60:
            print(f"⏱ Build #{b['number']} stuck ({duration/60:.1f}m). Restarting...")
            server.stop_build(job, b['number'])
            server.build_job(job)
            print(f"♻️ Restarted build #{b['number']}")

if __name__ == "__main__":
    main()
