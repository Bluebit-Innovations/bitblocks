# 🚀 Bit-Block CI/CD Starter Workflows

Welcome to the **Bit-Block Starter Pack** — a curated suite of GitHub Actions workflows built for **solo developers**, **startup founders**, and **lean engineering teams** who want to move fast and focus on what really matters: **building**.

This pack includes production-grade CI/CD templates for deploying apps, running tests, securing code, and automating development workflows — all without wasting time on boilerplate.

---

## 🧰 Core Workflows

| Workflow | Description |
|----------|-------------|
| `deploy-node-app.yml` | Deploy a Node.js app to AWS EC2 using SSH and PM2 |
| `docker-build.yml` | Build and push Docker image to Docker Hub or GHCR |
| `ci-node.yml` | Run tests, lint, and build for Node.js projects |
| `deploy-static-site.yml` | Deploy static frontend (React/Vue) to S3 |
| `ecr-deploy.yml` | Push Docker image to AWS ECR |
| `ecs-deploy.yml` | Deploy containers to AWS ECS Fargate |
| `lambda-deploy.yml` | Package and deploy AWS Lambda functions |
| `terraform-plan-apply.yml` | Run Terraform format, validate, plan, and apply |
| `gh-pages-deploy.yml` | Publish documentation or sites to GitHub Pages |
| `release.yml` | Auto-versioning and GitHub release generation |
| `security-scan.yml` | Scan dependencies and Docker images for vulnerabilities |
| `labeler.yml` | Automatically label pull requests based on file changes |
| `auto-merge.yml` | Auto-merge PRs once checks pass with correct label |
| `codeql-analysis.yml` | Static code analysis using GitHub CodeQL |

---

## ✅ Getting Started

1. **Copy the workflow(s)** you need into `.github/workflows/` in your repo.
2. **Add necessary secrets** to your GitHub repo:
   - AWS: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_S3_BUCKET`
   - Docker: `DOCKER_USERNAME`, `DOCKER_PASSWORD`
   - EC2: `EC2_PUBLIC_IP`, `EC2_SSH_KEY`
3. **Customize the values** (e.g., repo name, regions, container names) as needed.
4. ✅ Push code and watch the automation kick in!

---

## 👨🏾‍💻 Built For

- Indie Hackers & Solo Devs 🧑‍💻  
- Startup Engineering Teams 🚀  
- Hackathon Projects ⏱️  
- MVP Builders & SaaS Creators 💡

---

## 🛠 Need More?

Upgrade to our **Premium Workflows Pack** for:

- Multi-environment deployments (dev/staging/prod)
- Zero-downtime blue-green deploys
- GitOps & Infra drift detection
- AI-assisted code reviews
- Preview environments for PRs

---

## 💬 Support & Community

Have questions or ideas? Want to contribute?  
> Join the Bit-Block community and build the future of plug-and-play DevOps.

---

**Let’s ship faster, smarter, and more reliably. 🚢**
