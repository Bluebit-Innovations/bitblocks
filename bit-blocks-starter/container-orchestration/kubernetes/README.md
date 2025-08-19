# Bit-Blocks: Container Orchestration (Root)

This folder contains **cluster-wide** or **reusable** artifacts for backups, RBAC, and operational hygiene. It complements the app-scoped manifests under [`kubernetes/app-deployment/`](./app-deployment/).

---

## Contents

- **backup-cronjob.yml** – Daily logical DB backups with secure upload (pre-signed URL or rclone).
- **rbac-minimal.yml** – Minimal ServiceAccounts and Role/Binding for backup job and namespace-scoped CI/CD deployer.

> See [`kubernetes/app-deployment/`](./app-deployment/) for app `Deployment`, `Service`, `Ingress`, `HPA`, `CronJob`, `StatefulSet`, `PDB`, and `NetworkPolicy`.

---

## Quick Start

### 1. Create/Update Secrets & Config

Edit and apply the backup configuration:

```bash
# Edit inline or via kustomize/helm values
kubectl apply -f backup-cronjob.yml
```

**Required variables (Postgres example):**

- `DB_HOST`, `DB_PORT`, `DB_USER`, `DB_PASSWORD`, `DB_NAME`
- `BACKUP_NAME` – logical label for file names
- `BACKUP_UPLOAD_MODE` – `s3-presigned` or `rclone`

---

### 2A. Upload via Pre-Signed URL (Recommended)

Generate a new pre-signed URL per run (CI, external tool, or short-lived Secret):

```bash
kubectl -n default create secret generic backup-secrets \
    --from-literal=DB_HOST=postgres.default.svc.cluster.local \
    --from-literal=DB_PORT=5432 \
    --from-literal=DB_USER=appuser \
    --from-literal=DB_PASSWORD=apppassword \
    --from-literal=DB_NAME=appdb \
    --from-literal=PRESIGNED_URL='https://s3.example.com/...signed...'
```

Set `BACKUP_UPLOAD_MODE=s3-presigned` in backup-config (`ConfigMap`).

---

### 2B. Upload via rclone (S3/GCS/Azure/B2/etc.)

Provide `RCLONE_CONF` in `backup-secrets` and set:

- `BACKUP_UPLOAD_MODE=rclone`
- `RCLONE_REMOTE` / `RCLONE_TARGET_PATH` in backup-config

**Example `RCLONE_CONF` (AWS S3):**

```ini
[s3remote]
type = s3
provider = AWS
access_key_id = YOUR_ACCESS_KEY
secret_access_key = YOUR_SECRET
region = us-east-1
```

---

### 3. Apply RBAC (Recommended)

```bash
kubectl apply -f rbac-minimal.yml
```

- `backup-runner` ServiceAccount is referenced by the CronJob.
- `deployer` ServiceAccount can be used by CI/CD within the default namespace to apply manifests.

---

## Adapting the Backup Job

**MySQL:**

```sh
mysqldump -h $DB_HOST -P $DB_PORT -u $DB_USER -p$DB_PASSWORD $DB_NAME | gzip > "$FILE"
```

**MongoDB:**

```sh
mongodump --host "$DB_HOST" --port "$DB_PORT" --username "$DB_USER" --password "$DB_PASSWORD" \
    --db "$DB_NAME" --archive | gzip > "$FILE"
```

Swap the `apk add` line to install the respective client:

- MySQL: `mysql-client`
- MongoDB: `mongodb-tools` (or use a container image that already includes it)

---

## Security Notes

- The job runs as non-root with `RuntimeDefault` seccomp.
- Prefer pre-signed URLs to avoid long-lived credentials in-cluster.
- If using rclone, scope the credentials to a dedicated bucket/path and rotate regularly.
- Keep backups encrypted at rest at the storage provider; consider server-side or client-side encryption.

---

## SRE Tips

Pair this with:

- `pdb.yml` and `networkpolicy.yml` (in app folder) for availability and isolation.
- Monitoring alerts for job failures and backup age (e.g., alert if last backup > 24h).
- Test restores regularly: periodically run a restore job into a scratch database and run health checks.

---

## Troubleshooting

- **403 on upload:** If using pre-signed URLs, ensure it’s PUT capable and not expired; refresh before each run.
- **RBAC errors:** The backup job itself doesn’t need API access, but your CI deployer might. Use the deployer Role.
- **Large DBs:** Increase Job CPU/memory limits or shard databases; consider streaming to object storage instead of temp files.

---

## License

MIT — tailor and ship with your product.
