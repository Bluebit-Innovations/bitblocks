
# Runbook: Node NotReady / Down

**When to use:**  
Use this runbook when `kubectl get nodes` shows `NotReady` or `Unknown`, pods are pending/evicted, or there is workload impact.

**Severity guide:**  
- **S1:** Capacity loss affects user traffic  
- **S2:** No user traffic impact

---

## 0) Fast Triage (≤ 5 min)

```bash
# Node status & events
kubectl get nodes -o wide
NODE=<notready-node>
kubectl describe node $NODE | sed -n '1,200p'
kubectl get events --sort-by=.lastTimestamp | tail -n 40
```

**Typical signals:**  
- `NotReady` (kubelet down)  
- `NetworkUnavailable`  
- `DiskPressure`  
- `PIDPressure`  
- `OutOfDisk`

---

## 1) Stabilize Workloads

> Keep user traffic healthy while you repair or replace the node.

### A) Cordon & (if reachable) drain the node

```bash
kubectl cordon $NODE
kubectl drain $NODE --ignore-daemonsets --delete-emptydir-data --force --grace-period=60 || true
```

### B) Ensure capacity exists elsewhere

- **Cluster autoscaler:** Increase desired size or uncordon spare nodes.
- **Manual scaling:** Scale node group up by +1 if autoscaling is off.

### C) Check PDBs blocking evictions

```bash
kubectl get pdb -A
# If eviction is blocked and impact is high, temporarily relax minAvailable for affected app.
```

---

## 2) Root Cause Paths

### Path 1 — Kubelet/Runtime Crash

- SSH or use serial console to restart kubelet/container runtime.
- Review `/var/log` (`kubelet`, `containerd`, `dockerd`).

### Path 2 — Network Loss

- Check CNI daemonset status:

    ```bash
    kubectl -n kube-system get pods -l k8s-app=calico-node -o wide || \
    kubectl -n kube-system get pods -l k8s-app=cni -o wide
    ```

- Check cloud route tables and security groups.

### Path 3 — Disk/IO Pressure

- Clear logs, rotate, or expand disk.
- Move large images; prune:

    ```bash
    sudo crictl image rm --prune || sudo docker system prune -af
    ```

### Path 4 — Node Terminated by Provider

- Preemptible/Spot reclaimed; confirm provider events.
- Replace with on-demand or ensure multiple spot pools and PDBs.

---

## 3) Replace or Recover

### Recover (node returns)

```bash
kubectl uncordon $NODE
```

### Replace (preferred for speed/reliability)

```bash
# Delete node object; autoscaler/cloud will recreate
kubectl delete node $NODE
# Ensure node group desired size ≥ needed
```

If using self-managed nodes, provision a new VM and join the cluster.

---

## 4) Verification

```bash
kubectl get nodes -o wide
kubectl get pods -A -o wide | grep -v Running | head -n 20
kubectl get events --sort-by=.lastTimestamp | tail -n 30
```

Confirm app SLOs and dashboards (latency, errors) are back to normal.

---

## 5) Prevention / Hardening

- **PodDisruptionBudgets** for critical workloads.
- **Multi-AZ nodepools**; diversify spot pools if using Spot.
- Enable/verify **cluster autoscaler** with headroom.
- Enforce **requests/limits** to avoid node pressure.
- Node health **alerts** (Ready, DiskPressure, NotReady duration).

---

## 6) Automation Hooks (Bit-Blocks)

- Node watchdog: if `NotReady > 5m` → **cordon+replace** + Slack.
- Auto-remediation script to **drain respecting PDB**, then trigger node group scale-up.
