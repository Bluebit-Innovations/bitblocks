
# 🚀 Bit-Block Starter CI/CD Workflows for GitLab

A powerful collection of **production-grade GitLab CI/CD templates** designed to help **solo founders**, **startup teams**, and **indie developers** ship faster with confidence.

These plug-and-play `.gitlab-ci.yml` templates cover everything from app deployment to Docker builds, security scanning, auto-labeling, Lambda functions, and more.

---

## 📦 Included Workflows

| Workflow Name               | Description |
|----------------------------|-------------|
| `ci-node.yml`              | Node.js build, lint, test, and build pipeline. |
| `docker-build.yml`         | Build and push Docker images to a registry. |
| `deploy-node-app.yml`      | Deploy Node.js app to an EC2 instance via SSH. |
| `deploy-static-site.yml`   | Deploy static site to AWS S3 or GitLab Pages. |
| `ecr-deploy.yml`           | Push Docker images to AWS Elastic Container Registry (ECR). |
| `ecs-deploy.yml`           | Trigger ECS service redeployment with new images. |
| `lambda-deploy.yml`        | Deploy code to AWS Lambda. |
| `terraform-plan-apply.yml`| Plan and apply Terraform infrastructure changes. |
| `gh-pages-deploy.yml`      | Deploy to GitHub Pages (for GitHub-mirrored repos). |
| `release.yml`              | Automated versioning and changelog using Semantic Release. |
| `security-scan.yml`        | Scan app or Docker image for vulnerabilities with Trivy. |
| `codeql-analysis.yml`      | Static security analysis using GitHub CodeQL CLI. |
| `labeler.yml`              | Auto-label Merge Requests based on branch naming (e.g., `feat/`, `fix/`). |
| `auto-merge.yml`           | Auto-merge MRs after successful pipeline and approvals. |
| `preview-env.yml`          | Deploy pull request previews (Vercel, Netlify, ECS, etc.). |
| `clean-up-preview-env.yml`| Remove preview environments after PR merge or delete. |

---

## 🛠️ How to Use

1. **Pick a template** from the list above based on your stack and needs.
2. **Copy the `.yml` file** into your GitLab project root or include via `include:` in `.gitlab-ci.yml`.
3. **Set CI/CD variables** in GitLab for secrets like `AWS_ACCESS_KEY_ID`, `ECR_REPO`, `SSH_PRIVATE_KEY`, etc.
4. **Push and run!** GitLab will automatically execute the defined stages.

---

## 🔐 Recommended CI/CD Variables

| Variable Name           | Purpose |
|-------------------------|---------|
| `AWS_ACCESS_KEY_ID`     | Required for all AWS-based workflows |
| `AWS_SECRET_ACCESS_KEY` | AWS secret key |
| `SSH_PRIVATE_KEY`       | Required for EC2-based deploys |
| `EC2_HOST`              | IP or hostname of your EC2 instance |
| `ECR_REPO`, `ECR_REGISTRY` | Used in Docker builds to push to ECR |
| `LAMBDA_FUNCTION_NAME`  | Target Lambda function name |
| `GITLAB_TOKEN`          | For auto-labeling and auto-merging |
| `VERCEL_TOKEN`          | For Vercel preview environment deploys |
| `GH_TOKEN` / `GH_REPO`  | For GitHub Pages deploy (optional) |

---

## ✅ Example: Enabling Auto-Merge and Labeling

- Branches like `feat/login-page` will get the `feature` label.
- Once the pipeline passes and approvals are satisfied, the MR will merge automatically.

---

## 🔐 Example: Terraform Workflow

This workflow runs `terraform fmt`, `terraform validate`, `terraform plan`, and optionally `terraform apply` (manual).

You can configure backend state using `.tf` backend blocks and CI/CD secrets.

---

## 🔍 Example: Security Scanning

The `security-scan.yml` uses [Trivy](https://github.com/aquasecurity/trivy) to identify vulnerabilities in code or images. Can be extended with Snyk or GitLab's built-in SAST for Ultimate users.

---

## 🌍 Need Preview Environments?

Use `preview-env.yml` to auto-deploy per-branch previews to services like Vercel or ECS. Pair with `clean-up-preview-env.yml` for full lifecycle management.

---

## 💡 Pro Tips

- Modularize CI/CD by using `include: path` or templates folder.
- Protect `main` branch and enable required approvals.
- Monitor usage with GitLab CI/CD analytics.
- Scale deployments with multi-env support (`dev`, `staging`, `prod`).
- Pair with Observability tools like Grafana, Prometheus, or CloudWatch.

---

## 🧠 License & Contributions

These templates are open for modification and personal or commercial use. Feel free to submit improvements, issues, or feature requests.

---

**Made with 💙 by Bit-Block & Bluebit**  
Helping solo developers and startups focus on building, not deploying.


