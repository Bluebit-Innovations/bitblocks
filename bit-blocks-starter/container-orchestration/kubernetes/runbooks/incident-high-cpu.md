
# Runbook: High CPU (Pods/Nodes)

**When to use:** Sustained CPU > target, throttling, or node saturation causing latency/SLO burn.  
**Severity guide:** S1 if user-visible; S2 if contained; S3 for batch.

---

## 0) Fast Triage (≤ 5 min)

```bash
NS=default
APP=myapp

# Pod & Node CPU
kubectl -n $NS top pods --sort-by=cpu | head -n 15
kubectl top nodes

# HPA state
kubectl -n $NS get hpa
kubectl -n $NS describe hpa $APP || true

# Workload detail
kubectl -n $NS get deploy $APP -o wide
kubectl -n $NS describe deploy $APP | sed -n '1,200p'
```

---

## 1) Diagnose

- **Is it load spike or code path?** Check traffic, error rates, queue length.
- **Throttling?** Limits < usage → CPU throttling increases latency.
- **Single hot pod?** Imbalanced traffic / sticky sessions.
- **Node pressure?** Node CPU near 100% → schedule elsewhere / scale nodes.

---

## 2) Remediation Options (choose minimally disruptive)

### A) Scale out (quick relief)

```bash
# If HPA exists: temporarily bump max
kubectl -n $NS patch hpa $APP --type='json' -p='[{"op":"replace","path":"/spec/maxReplicas","value":20}]'
# Or manual scale
kubectl -n $NS scale deploy $APP --replicas=6
```

### B) Remove CPU throttling (temporary)

```bash
# Raise CPU limits or align limits=requests to reduce throttling
kubectl -n $NS set resources deploy/$APP --limits=cpu=1000m --requests=cpu=500m
kubectl -n $NS rollout status deploy/$APP
```

### C) Scale nodes / move workloads

- Cloud autoscaler: increase node group size or enable cluster autoscaler.
- Add a **separate nodepool** for noisy neighbors; set `nodeSelector/affinity`.

### D) Traffic shaping

- Enable **rate limiting** at ingress/API gateway.
- Short-term **feature flag** to reduce heavy endpoints.

### E) Fix hot code path (follow-up but start now)

- Add **caching** (Redis), batch expensive ops, remove tight loops.
- For JVM/Node/Go, review **profiling** (CPU pprof, flamegraphs).

---

## 3) Verification

```bash
kubectl -n $NS top pods | head -n 15
kubectl -n $NS get hpa $APP -o yaml | sed -n '1,80p' || true
# Check request rate, latency, error rate on dashboards
```

SLO burn rate should stabilize within minutes after scaling.

---

## 4) Right-Sizing & Policy (post-incident)

- Set realistic **requests/limits** (90th percentile usage + headroom).
- Calibrate **HPA**: target utilization 60–70%, sane min/max and cool-downs.
- Consider **KEDA** for event-driven scaling (queue length, RPS).
- Add **limitRange** in namespace to prevent missing resources.
- For hotspots, add **profiling** in CI pipelines and Perf tests.

---

## 5) Automation Hooks (Bit-Blocks)

- Alert: **burn rate** alerts (1h/6h windows).
- Auto-scale policy bump script with rollback timer.
- Canary guardrail: block deploy if inferred **CPU cost** > threshold from profiling.

