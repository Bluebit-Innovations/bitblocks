#!/usr/bin/env python3
"""
k8s_node_monitor.py

Watches Kubernetes nodes and cordons+drains any that become NotReady.
Environment variables:
  KUBECONFIG           Path to kubeconfig (optional; in-cluster if omitted)
  SLACK_WEBHOOK_URL    (optional) Incoming webhook for alerts
  DRAIN_TIMEOUT_SEC    Seconds to wait for pod evictions (default: 300)
Dependencies:
  pip install kubernetes python-dotenv requests
"""

import os
import time
from datetime import datetime
from kubernetes import client, config
from kubernetes.client.rest import ApiException
from dotenv import load_dotenv

load_dotenv()

WEBHOOK = os.getenv("SLACK_WEBHOOK_URL")
TIMEOUT = int(os.getenv("DRAIN_TIMEOUT_SEC", "300"))

def log(msg: str):
    ts = datetime.utcnow().isoformat()
    print(f"[{ts}] {msg}")

def notify(msg: str):
    if WEBHOOK:
        import requests
        requests.post(WEBHOOK, json={"text": msg})
    else:
        log(msg)

def load_k8s():
    try:
        config.load_kube_config(os.getenv("KUBECONFIG"))
    except Exception:
        config.load_incluster_config()
    return client.CoreV1Api()

def cordon_node(v1: client.CoreV1Api, name: str):
    body = {"spec": {"unschedulable": True}}
    v1.patch_node(name, body)
    notify(f"🚧 Cordoned node `{name}`")

def drain_node(v1: client.CoreV1Api, name: str):
    notify(f"⏳ Draining node `{name}` (timeout {TIMEOUT}s)")
    try:
        # Evict all pods (excluding DaemonSets & mirror pods)
        pods = v1.list_pod_for_all_namespaces(field_selector=f"spec.nodeName={name}").items
        for pod in pods:
            if pod.metadata.owner_references:
                kinds = {o.kind for o in pod.metadata.owner_references}
                if "DaemonSet" in kinds:
                    continue
            # create eviction
            ev = client.V1beta1Eviction(
                metadata=client.V1ObjectMeta(name=pod.metadata.name, namespace=pod.metadata.namespace)
            )
            v1.create_namespaced_pod_eviction(name=pod.metadata.name, namespace=pod.metadata.namespace, body=ev)
        # wait until no non-daemon pods remain
        start = time.time()
        while time.time() - start < TIMEOUT:
            pending = [
                p for p in v1.list_pod_for_all_namespaces(field_selector=f"spec.nodeName={name}").items
                if not (p.metadata.owner_references and any(o.kind=="DaemonSet" for o in p.metadata.owner_references))
            ]
            if not pending:
                notify(f"✅ Drain complete: `{name}`")
                return
            time.sleep(5)
        notify(f"⚠️ Drain timed out for `{name}`; pods still running")
    except ApiException as e:
        notify(f"❌ Error draining `{name}`: {e}")

def monitor_nodes():
    v1 = load_k8s()
    watched = set()
    while True:
        for node in v1.list_node().items:
            name = node.metadata.name
            ready = any(
                cond.type=="Ready" and cond.status=="True"
                for cond in node.status.conditions
            )
            if not ready and name not in watched:
                watched.add(name)
                notify(f"⚠️ Node `{name}` NotReady. Initiating cordon+drain.")
                cordon_node(v1, name)
                drain_node(v1, name)
            elif ready and name in watched:
                watched.remove(name)
                notify(f"✅ Node `{name}` is Ready again. No action.")
        time.sleep(30)

if __name__ == "__main__":
    monitor_nodes()
