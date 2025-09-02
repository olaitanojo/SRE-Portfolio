# 📊 SRE Monitoring and Alerting Stack

[![Prometheus](https://img.shields.io/badge/Prometheus-E6522C?style=for-the-badge&logo=Prometheus&logoColor=white)](https://prometheus.io/)
[![Grafana](https://img.shields.io/badge/grafana-%23F46800.svg?style=for-the-badge&logo=grafana&logoColor=white)](https://grafana.com/)
[![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)
[![AlertManager](https://img.shields.io/badge/AlertManager-FF6C2C?style=for-the-badge&logo=prometheus&logoColor=white)](https://prometheus.io/docs/alerting/latest/alertmanager/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## 🌟 Overview
This project demonstrates a comprehensive monitoring and alerting solution using modern SRE practices. It showcases the implementation of observability, alerting, and incident response capabilities that are essential for maintaining reliable systems in production environments.

## 📋 Table of Contents
- [🏗️ Architecture](#%EF%B8%8F-architecture)
- [🎯 SRE Concepts](#-key-sre-concepts-demonstrated)
- [📊 Metrics](#-metrics-and-monitoring)
- [🚨 Alerting](#-alerting-rules)
- [🚀 Quick Start](#-quick-start)
- [📈 Dashboards](#-dashboard-access)
- [📝 SRE Principles](#-sre-principles-applied)

## 🎯 Key SRE Concepts Demonstrated

- **Observability**: Multi-layer monitoring with metrics, logs, and traces
- **Service Level Objectives (SLOs)**: Error rate and latency monitoring
- **Incident Response**: Automated alerting and escalation
- **Capacity Planning**: Resource utilization tracking
- **Reliability Engineering**: Proactive monitoring and alerting

## 🏗️ Architecture

### System Overview
```mermaid
graph TB
    subgraph "Application Layer"
        A1[Sample Web App]
        A2[Sample API Service]
        A3[Custom Applications]
    end
    
    subgraph "Metrics Collection"
        B1[Prometheus]
        B2[Node Exporter]
        B3[cAdvisor]
        B4[Application Metrics]
    end
    
    subgraph "Data Storage"
        C1[Time Series Database]
        C2[Retention Policies]
        C3[Data Persistence]
    end
    
    subgraph "Visualization Layer"
        D1[Grafana Dashboards]
        D2[SRE Golden Signals]
        D3[Infrastructure Metrics]
        D4[Custom Dashboards]
    end
    
    subgraph "Alerting System"
        E1[AlertManager]
        E2[Alert Rules]
        E3[Notification Channels]
        E4[Escalation Policies]
    end
    
    subgraph "Monitoring Targets"
        F1[System Resources]
        F2[Container Metrics]
        F3[Application Health]
        F4[Network Performance]
    end
    
    A1 --> B4
    A2 --> B4
    A3 --> B4
    
    B1 --> C1
    B2 --> B1
    B3 --> B1
    B4 --> B1
    
    C1 --> D1
    C2 --> D2
    C3 --> D3
    
    B1 --> E2
    E2 --> E1
    E1 --> E3
    E3 --> E4
    
    F1 --> B2
    F2 --> B3
    F3 --> B4
    F4 --> B1
```

### Data Flow Architecture
```mermaid
flowchart LR
    subgraph "Targets"
        A[Applications]
        B[System Nodes]
        C[Containers]
    end
    
    subgraph "Collection"
        D[Prometheus Scraping]
        E[Push Gateway]
    end
    
    subgraph "Processing"
        F[PromQL Queries]
        G[Rule Evaluation]
        H[Alert Generation]
    end
    
    subgraph "Output"
        I[Grafana Dashboards]
        J[AlertManager]
        K[Notification Channels]
    end
    
    A --> D
    B --> D
    C --> D
    A --> E
    
    D --> F
    E --> F
    F --> G
    G --> H
    
    F --> I
    H --> J
    J --> K
```

### Alerting Workflow
```mermaid
sequenceDiagram
    participant App as Application
    participant Prom as Prometheus
    participant Rules as Alert Rules
    participant AM as AlertManager
    participant Notify as Notifications
    participant OnCall as On-Call Engineer
    
    App->>Prom: Expose Metrics
    Prom->>Prom: Scrape Metrics
    Prom->>Rules: Evaluate Alert Rules
    Rules->>AM: Fire Alert
    AM->>AM: Group & Deduplicate
    AM->>Notify: Send to Channels
    
    alt Critical Alert
        Notify->>OnCall: Immediate Notification
        OnCall->>OnCall: Investigate Issue
        OnCall->>App: Implement Fix
        App->>Prom: Healthy Metrics
        Prom->>AM: Resolve Alert
    else Warning Alert
        Notify->>OnCall: Delayed Notification
        OnCall->>OnCall: Monitor Situation
    end
```

### Component Architecture
```mermaid
C4Container
    title Prometheus Monitoring Stack
    
    Person(user, "SRE Engineer", "Monitors system reliability")
    System_Boundary(monitoring, "Monitoring System") {
        Container(prometheus, "Prometheus", "Time Series DB", "Metrics collection and storage")
        Container(grafana, "Grafana", "Visualization", "Dashboards and alerts")
        Container(alertmanager, "AlertManager", "Alert Routing", "Alert management and notifications")
        Container(nodeexporter, "Node Exporter", "System Metrics", "Host-level metrics collection")
    }
    
    System_Ext(app, "Applications", "Monitored services")
    System_Ext(infra, "Infrastructure", "Servers and containers")
    System_Ext(notify, "Notification Systems", "Slack, Email, PagerDuty")
    
    Rel(user, grafana, "Views dashboards")
    Rel(prometheus, grafana, "Provides metrics")
    Rel(prometheus, alertmanager, "Sends alerts")
    Rel(alertmanager, notify, "Sends notifications")
    Rel(app, prometheus, "Exposes metrics")
    Rel(infra, nodeexporter, "System metrics")
    Rel(nodeexporter, prometheus, "Scrapes metrics")
```

### Monitoring Stack Components

- **Prometheus**: Metrics collection, storage, and alerting engine
- **Grafana**: Visualization platform with rich dashboards and alerting
- **AlertManager**: Alert routing, grouping, and notification management
- **Node Exporter**: System-level metrics collection (CPU, memory, disk, network)
- **cAdvisor**: Container resource usage and performance metrics
- **Sample Applications**: Instrumented web services demonstrating observability

## 📊 Metrics and Monitoring

### Application Metrics
- HTTP request rate and latency
- Error rate and status codes
- Active connections and queue sizes
- Custom business metrics

### Infrastructure Metrics
- CPU, Memory, Disk utilization
- Network I/O and throughput
- Container resource usage
- System load and availability

### SRE Golden Signals
1. **Latency**: Response time percentiles
2. **Traffic**: Request rate and throughput
3. **Errors**: Error rate and count
4. **Saturation**: Resource utilization

## 🚨 Alerting Rules

### Critical Alerts
- Service downtime (>1 minute)
- High error rate (>10% for 2 minutes)
- Critical resource exhaustion

### Warning Alerts
- High CPU usage (>80% for 5 minutes)
- High memory usage (>85% for 5 minutes)
- Elevated response times (>500ms 95th percentile)
- Low disk space (>85% usage)

## 🚀 Quick Start

### Prerequisites
- Docker and Docker Compose
- 8GB+ RAM recommended
- Ports 3000, 8080, 8081, 9090, 9093, 9100, 8082 available

### Launch the Stack
```bash
# Clone the repository
git clone <repository-url>
cd prometheus-monitoring-stack

# Start all services
docker-compose up -d

# View logs
docker-compose logs -f
```

### Access the Services
- **Grafana Dashboard**: http://localhost:3000 (admin/admin123)
- **Prometheus**: http://localhost:9090
- **Alertmanager**: http://localhost:9093
- **Sample App**: http://localhost:8080
- **Sample API**: http://localhost:8081

## 📈 Dashboard Access

1. Open Grafana at http://localhost:3000
2. Login with admin/admin123
3. Navigate to pre-configured dashboards
4. Explore real-time metrics and alerts

## 🔧 Load Testing

Generate traffic to see metrics in action:

```bash
# Install load testing tool
pip install locust

# Run load tests
locust -f load_test.py --host=http://localhost:8080
```

## 📋 Key Files

- `docker-compose.yml`: Service orchestration
- `config/prometheus.yml`: Prometheus configuration
- `config/alerts.yml`: Alerting rules
- `config/alertmanager.yml`: Alert routing
- `dashboards/`: Grafana dashboard definitions
- `sample-app/`: Instrumented web application
- `sample-api/`: Instrumented API service

## 🎓 Learning Outcomes

This project demonstrates:
- Setting up production-grade monitoring
- Implementing SRE best practices
- Creating meaningful alerts and dashboards
- Instrumenting applications for observability
- Managing alert fatigue with proper routing
- Building reliability into systems from the ground up

## 🔄 Next Steps

1. Integrate with cloud provider monitoring (AWS CloudWatch, GCP Monitoring)
2. Add distributed tracing with Jaeger
3. Implement log aggregation with ELK stack
4. Add chaos engineering experiments
5. Create runbooks and incident response procedures

## 📝 SRE Principles Applied

- **Embrace Risk**: Balanced approach to reliability vs. velocity
- **Service Level Objectives**: Quantitative reliability targets
- **Monitoring**: Comprehensive observability strategy
- **Automation**: Automated alerting and response
- **Simplicity**: Clear, maintainable monitoring setup

---

*This project showcases practical SRE skills including monitoring, alerting, observability, and incident response - core competencies for Site Reliability Engineer roles.*

---

**Created by [olaitanojo](https://github.com/olaitanojo)**
