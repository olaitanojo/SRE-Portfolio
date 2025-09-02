# 🚀 GitHub Setup & Deployment Guide

This guide walks you through setting up your SRE CI/CD Pipeline on GitHub with full automation.

## 📋 Prerequisites

- [x] Git repository initialized
- [x] Code committed locally
- [ ] GitHub account ready
- [ ] Docker Hub account (for container registry)

---

## 🎯 Step 1: Create GitHub Repository

### Option A: Using GitHub CLI (Recommended)
```bash
# Install GitHub CLI if not already installed
# https://cli.github.com/

# Authenticate with GitHub
gh auth login

# Create repository
gh repo create sre-cicd-pipeline --public --description "Production-ready SRE CI/CD Pipeline with automated deployment strategies, monitoring, and observability"

# Set remote and push
git remote add origin https://github.com/YOUR_USERNAME/sre-cicd-pipeline.git
git branch -M main
git push -u origin main
git push origin develop
```

### Option B: Using GitHub Web Interface
1. Go to https://github.com/new
2. **Repository name**: `sre-cicd-pipeline`
3. **Description**: `Production-ready SRE CI/CD Pipeline with automated deployment strategies, monitoring, and observability`
4. **Visibility**: Public (to showcase your work)
5. **Initialize**: Leave unchecked (we have existing code)
6. Click **Create repository**

Then connect your local repo:
```bash
git remote add origin https://github.com/YOUR_USERNAME/sre-cicd-pipeline.git
git branch -M main
git push -u origin main
git push origin develop
```

---

## 🔐 Step 2: Configure GitHub Secrets

Navigate to: **Repository Settings → Secrets and variables → Actions**

### Required Secrets:

#### Container Registry (Docker Hub)
```
DOCKER_USERNAME    # Your Docker Hub username
DOCKER_PASSWORD    # Your Docker Hub access token (not password!)
```

#### Optional Secrets (for cloud deployment)
```
AWS_ACCESS_KEY_ID        # For AWS deployments
AWS_SECRET_ACCESS_KEY    # For AWS deployments
SLACK_WEBHOOK_URL        # For deployment notifications
SONAR_TOKEN             # For SonarQube integration
```

### How to Get Docker Hub Token:
1. Go to https://hub.docker.com/settings/security
2. Click **New Access Token**
3. Name: `github-actions-sre-pipeline`
4. Permissions: **Read, Write, Delete**
5. Copy the generated token (use this as `DOCKER_PASSWORD`)

---

## 🏗️ Step 3: Repository Configuration

### Branch Protection Rules
1. Go to **Settings → Branches**
2. Add rule for `main` branch:
   - ✅ Require a pull request before merging
   - ✅ Require status checks to pass before merging
   - ✅ Require branches to be up to date before merging
   - ✅ Require conversation resolution before merging
   - ✅ Include administrators

### Environment Settings
1. Go to **Settings → Environments**
2. Create environments:
   - `staging` (no restrictions)
   - `production` (require reviewers)

---

## 🎬 Step 4: Test Your CI/CD Pipeline

### Automated Triggers
The pipeline automatically triggers on:
- **Push to `main`** → Production deployment
- **Push to `develop`** → Staging deployment
- **Pull Request** → Quality gate validation
- **Manual trigger** → Custom deployment strategy

### First Test - Quality Gate
1. Create a new branch: `git checkout -b feature/test-pipeline`
2. Make a small change to `README.md`
3. Commit and push: `git add . && git commit -m "test: trigger CI pipeline" && git push origin feature/test-pipeline`
4. Create Pull Request to `develop`
5. Watch the pipeline run quality gates

### Production Deployment Test
1. Merge PR to `develop`
2. Create PR from `develop` to `main`
3. Merge to trigger production deployment

---

## 📊 Step 5: Monitor Your Pipeline

### GitHub Actions Dashboard
- Go to **Actions** tab to see pipeline runs
- Monitor build status, test results, security scans

### Local Monitoring Stack
Run locally to test metrics collection:
```bash
docker-compose -f docker-compose.monitoring.yml up -d
```

Access services:
- **Application**: http://localhost:8080
- **Prometheus**: http://localhost:9090
- **Grafana**: http://localhost:3000 (admin/admin)

---

## 🚀 Step 6: Advanced Features

### Manual Deployment with Strategy Selection
1. Go to **Actions → SRE CI/CD Pipeline**
2. Click **Run workflow**
3. Select deployment strategy:
   - **Rolling**: Zero-downtime gradual replacement
   - **Blue-Green**: Complete environment switch
   - **Canary**: Progressive traffic shifting
4. Choose target environment: `staging` or `production`

### Deployment Scripts
Test deployment scripts locally:
```bash
# Rolling deployment
./scripts/deploy-rolling.sh latest production

# Blue-green deployment
./scripts/deploy-blue-green.sh v1.0.1 production

# Canary deployment
./scripts/deploy-canary.sh latest production

# SLO monitoring
./scripts/check-slos.sh production
```

---

## 🔧 Troubleshooting

### Common Issues

#### Pipeline Fails on Security Scan
- Check Dockerfile follows security best practices
- Ensure no high-severity vulnerabilities in dependencies

#### Docker Build Fails
- Verify `DOCKER_USERNAME` and `DOCKER_PASSWORD` secrets are set correctly
- Ensure Docker Hub token has write permissions

#### Tests Fail
```bash
# Run tests locally
pytest -v --cov=app test_app.py
black --check .
flake8 .
```

#### Deployment Scripts Fail
- Ensure AWS CLI is configured (if using AWS deployment)
- Check target infrastructure exists
- Verify environment variables are set

### Pipeline Status Badges
Add to your README.md:
```markdown
[![CI/CD Pipeline](https://github.com/YOUR_USERNAME/sre-cicd-pipeline/actions/workflows/ci-cd-pipeline.yml/badge.svg)](https://github.com/YOUR_USERNAME/sre-cicd-pipeline/actions/workflows/ci-cd-pipeline.yml)
```

---

## 📈 Key Metrics to Monitor

### SLO Metrics
- **Availability**: >99.5%
- **Latency P95**: <500ms
- **Error Rate**: <1%

### Pipeline Metrics
- Build success rate
- Deployment frequency
- Lead time for changes
- Mean time to recovery

### Application Metrics
- Request rate and latency
- Error rates by endpoint
- Active connections
- System resource usage

---

## 🎯 Next Steps

1. **Set up monitoring dashboards** in Grafana
2. **Configure alerting rules** in Alertmanager
3. **Implement chaos engineering** tests
4. **Add performance testing** to pipeline
5. **Set up log aggregation** (ELK Stack)
6. **Implement feature flags** for safer deployments

---

## 📚 Documentation References

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Docker Hub Access Tokens](https://docs.docker.com/docker-hub/access-tokens/)
- [SRE Best Practices](https://sre.google/sre-book/)
- [DORA Metrics](https://cloud.google.com/blog/products/devops-sre/using-the-four-keys-to-measure-your-devops-performance)

---

**🎉 Congratulations! Your production-ready SRE CI/CD pipeline is now fully configured and ready to showcase modern DevOps practices!**
