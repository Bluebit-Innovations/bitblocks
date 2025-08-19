# Runbook: Pod in CrashLoopBackOff

**When to use:** A pod is repeatedly crashing and restarting (`CrashLoopBackOff` or `Error`).  
**Severity guide:** S1 if impacts production user traffic; otherwise S2/S3.  
**Owners:** On-call SRE / App Owner.  
**SLOs affected:** Availability / Latency.

---

## 0) Fast Triage (≤ 5 min)

```bash
NS=default
APP=myapp

kubectl -n $NS get pods -l app.kubernetes.io/name=$APP -o wide
kubectl -n $NS describe pod <pod-name> | sed -n '1,200p'
kubectl -n $NS logs <pod-name> --previous --all-containers --tail=200
```

**Classify quickly:**

- **Image/Boot errors:** `exec format error`, `not found`, `permission denied`
- **Config/Secrets:** `ENV missing`, `cannot connect`, `permission`
- **Probes:** failing `liveness`/`startup`/`readiness`
- **OOMKilled:** look for `Last State: Terminated (OOMKilled)`
- **Crash on migrations:** app exits after running DB migrations

---

## 1) Common Root Causes & Signals

| Symptom                  | Likely Cause                      | Signal                                |
| ------------------------ | --------------------------------- | ------------------------------------- |
| Immediate crash at start | Bad entrypoint / runtime mismatch | Logs show `exec`/module errors        |
| Restarts after seconds   | Liveness probe too strict         | `describe` shows probe failures       |
| Never becomes Ready      | Readiness probe wrong path/port   | Readiness failing; app logs OK        |
| OOMKilled                | Too little memory / leak          | `describe` termination reason         |
| Image pull backoff       | Bad tag / registry auth           | ImagePullBackOff, events show 403/404 |
| Config/secret missing    | Ref typo / not mounted            | EnvFrom errors, app logs missing var  |

---

## 2) Safe Remediation (ordered)

> Prefer **reversible** actions first. If prod impact: **roll back** quickly, then fix.

### A) Roll back to last good version

```bash
kubectl -n $NS rollout history deploy/$APP
kubectl -n $NS rollout undo deploy/$APP
kubectl -n $NS rollout status deploy/$APP --timeout=2m
```

### B) Relax probes temporarily (buy time)

```bash
kubectl -n $NS patch deploy/$APP --type='json' -p='[
    {"op":"replace","path":"/spec/template/spec/containers/0/livenessProbe/initialDelaySeconds","value":30},
    {"op":"replace","path":"/spec/template/spec/containers/0/readinessProbe/periodSeconds","value":15}
]'
```

### C) Fix config/secret quickly

```bash
# Recreate secret/configmap then restart pods
kubectl -n $NS create secret generic myapp-secrets --from-literal=API_KEY=xxxx --dry-run=client -o yaml | kubectl apply -f -
kubectl -n $NS rollout restart deploy/$APP
```

### D) Mitigate OOM

```bash
# Inspect resources
kubectl -n $NS get deploy $APP -o jsonpath='{.spec.template.spec.containers[*].resources}'
# Hotfix: raise memory limit (temporary)
kubectl -n $NS set resources deploy/$APP --limits=memory=1Gi --requests=memory=512Mi
kubectl -n $NS rollout status deploy/$APP
```

### E) Image/tag/regcred

```bash
kubectl -n $NS set image deploy/$APP myapp=ghcr.io/your-org/myapp:<known-good-tag>
# Or fix imagePullSecrets if needed
kubectl -n $NS patch serviceaccount default -p '{"imagePullSecrets":[{"name":"regcred"}]}'
```

---

## 3) Verification

```bash
kubectl -n $NS get pods -l app.kubernetes.io/name=$APP
kubectl -n $NS rollout status deploy/$APP
kubectl -n $NS logs deploy/$APP --tail=50
kubectl -n $NS get events --sort-by=.lastTimestamp | tail -n 20
```

Smoke test application endpoint and confirm dashboards (errors, latency) recover.

---

## 4) Prevention / Follow-ups

- Tighten **CI tests**: startup smoke test; probe endpoints.
- Right-size **requests/limits**; add **memory leak** detection.
- Pin **image tags** (semver) and keep a **rollback play** in CI.
- Add **synthetic checks** to catch regressions early.

---

## 5) Automation Hooks (Bit-Blocks)

- GitHub Action: on failed rollout, auto-`rollout undo` + notify Slack.
- KEDA/Probes policy linter (kube-score/OPA) in PR gate.

