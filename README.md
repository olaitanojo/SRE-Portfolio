# 🚀 SRE CI/CD Pipeline - Production-Ready Deployment Automation

[![CI/CD Pipeline](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-blue?logo=github-actions)](https://github.com/olaitanojo/SRE-Portfolio/actions)
[![Docker](https://img.shields.io/badge/Docker-Production%20Ready-blue?logo=docker)](https://hub.docker.com/r/olaitanojo/sre-cicd-demo)
[![Python](https://img.shields.io/badge/Python-3.11-green?logo=python)](https://python.org)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![SRE](https://img.shields.io/badge/SRE-Best%20Practices-orange)](https://sre.google/)
[![Monitoring](https://img.shields.io/badge/Monitoring-Prometheus%20%7C%20Grafana-red)](https://prometheus.io/)

> 🚀 **Status**: Production Ready | 🧪 **Tests**: 11/11 Passing | 📊 **Coverage**: 89% | 🔒 **Security**: Scanned | ⚡ **Deployment**: Multi-Strategy | 🎯 **Pipeline**: Testing

## 📖 Overview

This **SRE CI/CD Pipeline** is a cornerstone component of the comprehensive [SRE Portfolio](../README.md), demonstrating enterprise-grade deployment automation with reliability engineering principles. It showcases automated testing, security scanning, multiple deployment strategies, chaos engineering, and comprehensive monitoring - all essential for maintaining reliable services at scale.

**Part of the Complete SRE Portfolio**: This pipeline integrates with other portfolio components including [Prometheus Monitoring Stack](../prometheus-monitoring-stack/), [Incident Response Toolkit](../incident-response-toolkit/), and [Infrastructure Automation](../terraform-aws-infrastructure/).

## 🎯 SRE Concepts Demonstrated

- **Deployment Strategies**: Rolling, Blue-Green, and Canary deployments
- **Service Level Objectives**: Automated SLO monitoring and compliance
- **Quality Gates**: Automated code quality and security checks
- **Observability**: Built-in metrics and monitoring integration
- **Incident Response**: Automated rollback and alerting
- **Reliability Testing**: Chaos engineering and resilience testing

## 🏗️ CI/CD Pipeline Architecture

### Pipeline Stages
1. **Quality Gate**: Code quality, security, and testing
2. **Build & Push**: Container image building and registry push
3. **Infrastructure Validation**: Terraform and security scanning
4. **Deployment**: Environment-specific deployment strategies
5. **Post-Deployment**: SLO monitoring and validation
6. **Chaos Engineering**: Resilience testing (staging only)

### Deployment Strategies

#### Rolling Deployment
- Zero-downtime deployment with gradual instance replacement
- Health check validation at each step
- Automatic rollback on failure

#### Blue-Green Deployment
- Complete environment switch with validation
- Instant rollback capability
- Full isolation between environments

#### Canary Deployment
- Gradual traffic shift (10% → 25% → 50% → 75% → 100%)
- Automated metric monitoring at each stage
- Progressive rollback on metric violations

## 🚀 Features

### Quality Assurance
- **Code Quality**: Black formatting, Flake8 linting, MyPy type checking
- **Security Scanning**: Bandit security analysis, Trivy vulnerability scanning
- **Testing**: Comprehensive unit tests with coverage reporting
- **License Compliance**: Automated license checking

### Deployment Safety
- **Pre-deployment Validation**: Infrastructure and security checks
- **Health Checks**: Application health monitoring during deployment
- **SLO Monitoring**: Automated service level objective validation
- **Rollback Automation**: Automatic rollback on failure detection

### Observability
- **Metrics**: Prometheus metrics with custom business metrics
- **Logging**: Structured logging with centralized collection
- **Alerting**: Integration with monitoring systems
- **Tracing**: Request correlation and performance tracking

## 📊 Service Level Objectives

### SLO Definitions
- **Availability**: 99.5% uptime
- **Latency**: 95th percentile < 500ms
- **Error Rate**: < 1% of requests

### Monitoring
- Automated SLO compliance checking
- Real-time metric collection
- Alert generation on SLO violations
- Historical trend analysis

## 🛠️ Technology Stack

### Core Technologies
- **Application**: Python Flask with Prometheus integration
- **Containerization**: Docker with security best practices
- **CI/CD**: GitHub Actions with advanced workflows
- **Infrastructure**: AWS with Terraform (auto-scaling, load balancing)

### Development Tools
- **Testing**: pytest with coverage reporting
- **Quality**: Black, Flake8, MyPy, Bandit
- **Security**: Trivy, Checkov, OWASP ZAP
- **Monitoring**: Prometheus, CloudWatch, custom metrics

## 🚀 Quick Start

### Repository Setup
```bash
# Clone the repository
git clone https://github.com/olaitanojo/SRE-Portfolio.git
cd sre-cicd-pipeline

# Create development environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt
```

### Local Development
```bash
# Run tests
pytest -v --cov=app

# Check code quality
black --check .
flake8 .
mypy . --ignore-missing-imports

# Security scan
bandit -r .

# Run application locally
python app.py
```

### Access Endpoints
- **Application**: http://localhost:8080
- **Health Check**: http://localhost:8080/health
- **Metrics**: http://localhost:8080/metrics
- **API**: http://localhost:8080/api/users

## 📋 GitHub Actions Setup

### Required Secrets
Configure these in GitHub repository settings:

- `DOCKER_USERNAME` - Docker Hub username
- `DOCKER_PASSWORD` - Docker Hub password/token
- `AWS_ACCESS_KEY_ID` - AWS access key
- `AWS_SECRET_ACCESS_KEY` - AWS secret key
- `AWS_REGION` - AWS region (e.g., us-west-2)
- `SLACK_WEBHOOK_URL` - Slack webhook for notifications
- `NOTIFICATION_EMAIL` - Email for alerts
- `SSH_PRIVATE_KEY` - SSH private key for deployments

### Workflow Triggers
- **Push to main**: Production deployment
- **Push to develop**: Staging deployment  
- **Pull Requests**: Quality gate validation
- **Manual Trigger**: Custom deployment strategy selection

## 🔧 Deployment Commands

### Manual Deployment
```bash
# Rolling deployment
./scripts/deploy-rolling.sh latest production

# Blue-green deployment
./scripts/deploy-blue-green.sh v1.2.3 production

# Canary deployment
./scripts/deploy-canary.sh latest production
```

### SLO Monitoring
```bash
# Check current SLO compliance
./scripts/check-slos.sh production
```

## 📈 Monitoring and Observability

### Application Metrics
- HTTP request rates and latency
- Error rates by endpoint and status code
- Active connection counts
- Custom business metrics

### Infrastructure Metrics
- CPU, memory, and disk utilization
- Network I/O and throughput
- Container resource usage
- Auto-scaling events

### Deployment Metrics
- Deployment frequency and duration
- Success/failure rates by strategy
- Rollback frequency and causes
- SLO compliance trends

## 🧪 Testing Strategy

### Unit Tests
- Endpoint functionality testing
- Performance requirement validation
- Error handling verification
- Concurrent request handling

### Integration Tests
- End-to-end API testing
- Database integration validation
- External service mocking
- Load testing integration

### Chaos Engineering
- Instance termination testing
- Network partition simulation
- Resource exhaustion testing
- Dependency failure simulation

## 🔒 Security Features

### Application Security
- Non-root container execution
- Dependency vulnerability scanning
- Security header implementation
- Input validation and sanitization

### Pipeline Security
- Secret management with GitHub Secrets
- Image vulnerability scanning
- Infrastructure security validation
- License compliance checking

### Production Security
- IAM role-based access
- Network security groups
- Encrypted data transmission
- Audit logging and compliance

## 📚 Learning Outcomes

This project demonstrates:
- **Modern CI/CD**: Advanced GitHub Actions workflows
- **Deployment Safety**: Multiple deployment strategies with validation
- **Quality Engineering**: Comprehensive testing and security scanning
- **SRE Practices**: SLO monitoring and reliability engineering
- **Observability**: Metrics, logging, and monitoring integration
- **Automation**: End-to-end automated deployment pipeline

## 🔄 Future Enhancements

1. **Advanced Monitoring**
   - Distributed tracing with Jaeger
   - Log aggregation with ELK stack
   - Custom alerting rules

2. **Enhanced Security**
   - Runtime security monitoring
   - Compliance scanning (SOC2, PCI)
   - Zero-trust networking

3. **Advanced Deployment**
   - Feature flags integration
   - A/B testing capabilities
   - Multi-region deployments

4. **Chaos Engineering**
   - Automated chaos experiments
   - Resilience testing in production
   - Failure injection frameworks

## 📖 Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Deployment Strategies Guide](https://docs.aws.amazon.com/whitepapers/latest/blue-green-deployments/welcome.html)
- [SRE Best Practices](https://sre.google/sre-book/)
- [DORA Metrics](https://cloud.google.com/blog/products/devops-sre/using-the-four-keys-to-measure-your-devops-performance)

---

*This project showcases modern CI/CD practices with SRE principles, demonstrating skills in automation, reliability engineering, and deployment safety - core competencies for DevOps and SRE roles.*

**Created by [olaitanojo](https://github.com/olaitanojo)**
