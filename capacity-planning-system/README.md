# Capacity Planning & Resource Optimization System

[![Python](https://img.shields.io/badge/Python-3.9+-blue.svg)](https://python.org)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.100+-009688.svg)](https://fastapi.tiangolo.com/)
[![React](https://img.shields.io/badge/React-18+-61DAFB.svg)](https://reactjs.org/)
[![Docker](https://img.shields.io/badge/Docker-Containerized-2496ED.svg)](https://docker.com)
[![ML](https://img.shields.io/badge/ML-TensorFlow%20%7C%20Prophet-FF6F00.svg)](https://tensorflow.org)
[![AWS](https://img.shields.io/badge/AWS-CloudWatch%20%7C%20Cost%20Explorer-FF9900.svg)](https://aws.amazon.com)
[![GCP](https://img.shields.io/badge/GCP-Cloud%20Monitoring-4285F4.svg)](https://cloud.google.com)
[![Azure](https://img.shields.io/badge/Azure-Monitor-0078D4.svg)](https://azure.microsoft.com)
[![InfluxDB](https://img.shields.io/badge/InfluxDB-Time%20Series-22ADF6.svg)](https://influxdata.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

An intelligent capacity planning system that monitors resource usage, forecasts future needs, and provides optimization recommendations for cloud infrastructure and applications.

## Features

### Resource Monitoring
- **Multi-cloud Support**: Monitor resources across AWS, GCP, Azure, and on-premises
- **Real-time Metrics**: Collect CPU, memory, disk, network, and custom application metrics
- **Historical Data**: Store and analyze long-term resource utilization trends
- **Cost Tracking**: Monitor resource costs and spending patterns
- **Alert Integration**: Connect with existing monitoring and alerting systems

### Capacity Forecasting
- **Machine Learning Models**: Use time series forecasting with seasonal patterns
- **Growth Prediction**: Predict resource needs based on business growth metrics
- **Scenario Planning**: Model different growth scenarios and their capacity requirements
- **Lead Time Planning**: Account for procurement and provisioning lead times
- **Confidence Intervals**: Provide prediction confidence levels and risk assessment

### Optimization Recommendations
- **Right-sizing Analysis**: Identify over-provisioned and under-utilized resources
- **Cost Optimization**: Recommend reserved instances, spot instances, and resource scheduling
- **Architecture Optimization**: Suggest infrastructure improvements and alternatives
- **Auto-scaling Configuration**: Optimize auto-scaling policies and thresholds
- **Resource Consolidation**: Identify opportunities for workload consolidation

### Reporting & Analytics
- **Executive Dashboards**: High-level capacity and cost reports for management
- **Technical Reports**: Detailed analysis for engineering teams
- **Trend Analysis**: Identify usage patterns and seasonal variations
- **ROI Analysis**: Calculate return on investment for optimization recommendations
- **Compliance Reports**: Generate reports for compliance and audit requirements

## Architecture

### System Architecture Overview

```mermaid
graph TB
    subgraph "Data Sources Layer"
        CloudAPIs["☁️ Cloud APIs<br/>AWS • GCP • Azure"]
        Monitoring["📊 Monitoring<br/>Prometheus • Grafana"]
        BillingAPIs["💰 Billing APIs<br/>Cost Explorer • Cloud Billing"]
        CustomApps["🔧 Custom Applications<br/>Business Metrics"]
    end

    subgraph "Data Collection Layer"
        MetricsCollector["📈 Metrics Collectors<br/>CloudWatch • Stackdriver"]
        CostCollector["💸 Cost Collectors<br/>Usage & Billing Data"]
        LogParser["📝 Log Parsers<br/>Application Logs"]
    end

    subgraph "Processing Layer"
        DataValidator["✅ Data Validation<br/>Quality Checks"]
        Aggregator["🔄 Data Aggregation<br/>Time Series Processing"]
        Enricher["🎯 Data Enrichment<br/>Context & Metadata"]
    end

    subgraph "Storage Layer"
        InfluxDB[("📊 InfluxDB<br/>Time Series Data")]
        PostgreSQL[("🗄️ PostgreSQL<br/>Metadata & Config")]
        Redis[("⚡ Redis<br/>Cache Layer")]
        DataLake[("🏗️ Data Lake<br/>S3 • GCS Historical")]
    end

    subgraph "Analytics Engine"
        MLModels["🤖 ML Forecasting<br/>Prophet • ARIMA • Neural Networks"]
        OptimizationEngine["⚙️ Optimization Engine<br/>Cost & Resource Optimization"]
        AnomalyDetection["🚨 Anomaly Detection<br/>Pattern Recognition"]
        TrendAnalysis["📈 Trend Analysis<br/>Statistical Analysis"]
    end

    subgraph "Application Layer"
        RestAPI["🔗 REST API<br/>FastAPI Backend"]
        WebDashboard["💻 Web Dashboard<br/>React Frontend"]
        CLITools["⌨️ CLI Tools<br/>Automation Scripts"]
        Webhooks["🔄 Webhook Integration<br/>Real-time Notifications"]
    end

    %% Data Flow
    CloudAPIs --> MetricsCollector
    Monitoring --> MetricsCollector
    BillingAPIs --> CostCollector
    CustomApps --> LogParser

    MetricsCollector --> DataValidator
    CostCollector --> DataValidator
    LogParser --> DataValidator

    DataValidator --> Aggregator
    Aggregator --> Enricher

    Enricher --> InfluxDB
    Enricher --> PostgreSQL
    Enricher --> Redis
    InfluxDB --> DataLake

    InfluxDB --> MLModels
    PostgreSQL --> OptimizationEngine
    Redis --> AnomalyDetection
    DataLake --> TrendAnalysis

    MLModels --> RestAPI
    OptimizationEngine --> RestAPI
    AnomalyDetection --> RestAPI
    TrendAnalysis --> RestAPI

    RestAPI --> WebDashboard
    RestAPI --> CLITools
    RestAPI --> Webhooks

    style CloudAPIs fill:#e1f5fe
    style MLModels fill:#f3e5f5
    style RestAPI fill:#e8f5e8
    style InfluxDB fill:#fff3e0
```

### ML Forecasting Pipeline

```mermaid
sequenceDiagram
    participant DS as Data Sources
    participant DC as Data Collector
    participant PP as Preprocessing
    participant ML as ML Models
    participant Forecast as Forecasting Engine
    participant API as REST API
    participant UI as Dashboard

    DS->>DC: Stream metrics data
    DC->>PP: Raw time series data
    PP->>PP: Clean & validate data
    PP->>PP: Feature engineering
    PP->>ML: Processed training data
    
    ML->>ML: Train Prophet model
    ML->>ML: Train ARIMA model
    ML->>ML: Train Neural Network
    
    ML->>Forecast: Model ensemble
    Forecast->>Forecast: Generate predictions
    Forecast->>Forecast: Calculate confidence intervals
    Forecast->>Forecast: Validate forecasts
    
    Forecast->>API: Forecast results
    API->>UI: JSON response
    UI->>UI: Render visualizations
    
    Note over ML,Forecast: Models retrained daily<br/>with new data
    Note over Forecast,API: Forecasts cached<br/>for 4 hours
```

### Cost Optimization Workflow

```mermaid
flowchart TD
    A["💰 Cost Data Ingestion"] --> B["📊 Resource Utilization Analysis"]
    B --> C{"🔍 Utilization < 50%?"}
    
    C -->|Yes| D["📉 Right-sizing Recommendation"]
    C -->|No| E["📈 Scale-up Analysis"]
    
    D --> F["💡 Generate Optimization Report"]
    E --> G{"🚀 Growth Rate > 20%?"}
    
    G -->|Yes| H["📈 Capacity Expansion Recommendation"]
    G -->|No| I["⚡ Auto-scaling Optimization"]
    
    H --> F
    I --> F
    
    F --> J["📋 ROI Calculation"]
    J --> K["📬 Notification & Alerts"]
    K --> L["🔄 Implementation Tracking"]
    
    L --> M{"✅ Implemented?"}
    M -->|Yes| N["📈 Measure Impact"]
    M -->|No| O["⏰ Follow-up Reminder"]
    
    N --> P["📊 Update Model Accuracy"]
    O --> K
    P --> A
    
    style A fill:#e3f2fd
    style F fill:#f3e5f5
    style N fill:#e8f5e8
```

### Container Architecture (C4 Model)

```mermaid
C4Container
    title Capacity Planning System - Container Diagram
    
    Person(user, "SRE/DevOps Engineer", "Monitors capacity and optimizes resources")
    Person(exec, "Executive", "Reviews cost reports and ROI")
    
    System_Boundary(cp, "Capacity Planning System") {
        Container(web, "Web Dashboard", "React, TypeScript", "Interactive capacity planning interface")
        Container(api, "REST API", "FastAPI, Python", "Core business logic and data access")
        Container(collector, "Data Collector", "Go, Python", "Collects metrics from cloud providers")
        Container(ml, "ML Engine", "Python, TensorFlow", "Forecasting and optimization models")
        Container(scheduler, "Job Scheduler", "Celery, Redis", "Handles background processing")
        
        ContainerDb(influx, "InfluxDB", "Time Series DB", "Stores metrics and forecasting data")
        ContainerDb(postgres, "PostgreSQL", "Relational DB", "Stores configuration and metadata")
        ContainerDb(redis, "Redis", "In-Memory DB", "Caching and job queue")
        ContainerDb(s3, "Data Lake", "S3/GCS", "Long-term historical data storage")
    }
    
    System_Ext(aws, "AWS Services", "CloudWatch, Cost Explorer, EC2")
    System_Ext(gcp, "GCP Services", "Cloud Monitoring, Billing API")
    System_Ext(azure, "Azure Services", "Azure Monitor, Cost Management")
    System_Ext(prom, "Prometheus", "Metrics collection system")
    System_Ext(grafana, "Grafana", "Monitoring dashboards")
    
    Rel(user, web, "Uses", "HTTPS")
    Rel(exec, web, "Reviews", "HTTPS")
    Rel(web, api, "API calls", "JSON/REST")
    Rel(api, influx, "Queries", "InfluxQL")
    Rel(api, postgres, "Reads/Writes", "SQL")
    Rel(api, redis, "Cache operations", "Redis Protocol")
    Rel(api, scheduler, "Triggers jobs", "Celery")
    
    Rel(collector, aws, "Collects metrics", "AWS API")
    Rel(collector, gcp, "Collects metrics", "GCP API")
    Rel(collector, azure, "Collects metrics", "Azure API")
    Rel(collector, prom, "Scrapes metrics", "HTTP")
    Rel(collector, influx, "Stores data", "Line Protocol")
    
    Rel(ml, influx, "Training data", "InfluxQL")
    Rel(ml, s3, "Model artifacts", "S3 API")
    Rel(scheduler, ml, "Triggers training", "Python")
    
    Rel(api, grafana, "Webhook alerts", "HTTP")
    
    UpdateLayoutConfig($c4ShapeInRow="3", $c4BoundaryInRow="1")
```

## Components

### Data Collection Layer
- **Cloud Connectors**: AWS CloudWatch, GCP Cloud Monitoring, Azure Monitor
- **Metrics Collectors**: Prometheus, InfluxDB, custom collectors
- **Cost Collectors**: AWS Cost Explorer, GCP Billing API, Azure Cost Management
- **Application Metrics**: Custom application performance and business metrics

### Analytics Engine
- **Forecasting Models**: ARIMA, Prophet, neural networks for time series prediction
- **Optimization Engine**: Cost optimization algorithms and recommendation engine
- **Anomaly Detection**: Identify unusual patterns and potential issues
- **Trend Analysis**: Statistical analysis of usage patterns and growth

### Storage Layer
- **Time Series Database**: InfluxDB for metrics storage
- **Metadata Store**: PostgreSQL for configuration and metadata
- **Cache Layer**: Redis for fast access to recent data
- **Data Lake**: S3/GCS for long-term historical data storage

### API & Interface Layer
- **REST API**: Programmatic access to all functionality
- **Web Dashboard**: React-based interface for interactive analysis
- **CLI Tools**: Command-line tools for automation and scripting
- **Webhook Integration**: Real-time notifications and integrations

## Quick Start

### Prerequisites
- Docker and Docker Compose
- Python 3.9+
- Node.js 16+
- Cloud provider credentials (AWS/GCP/Azure)

### Development Setup

1. Clone and configure:
```bash
git clone <repository-url>
cd capacity-planning-system
cp .env.example .env
# Configure your cloud credentials in .env
```

2. Start the system:
```bash
docker-compose up -d
```

3. Access the interfaces:
- Dashboard: http://localhost:3000
- API Documentation: http://localhost:8000/docs
- Grafana: http://localhost:3001

### Configuration

1. Configure cloud providers:
```yaml
# config/providers.yml
aws:
  enabled: true
  regions: ["us-east-1", "us-west-2"]
  accounts: ["123456789012"]
  
gcp:
  enabled: true
  projects: ["my-project-id"]
  
azure:
  enabled: false
```

2. Set up forecasting models:
```yaml
# config/forecasting.yml
models:
  cpu_usage:
    algorithm: "prophet"
    seasonality: true
    forecast_horizon: "30d"
    
  memory_usage:
    algorithm: "arima"
    forecast_horizon: "90d"
```

## Technology Stack

- **Backend**: Python (FastAPI), Go
- **Frontend**: React, TypeScript, D3.js
- **Database**: InfluxDB, PostgreSQL, Redis
- **ML/Analytics**: scikit-learn, Prophet, TensorFlow
- **Container Platform**: Docker, Kubernetes
- **Cloud APIs**: AWS SDK, GCP SDK, Azure SDK
- **Monitoring**: Prometheus, Grafana

## Use Cases

### 1. Resource Right-sizing
```python
# Get right-sizing recommendations
recommendations = capacity_api.get_rightsizing_recommendations(
    resource_type="ec2",
    utilization_threshold=0.8,
    time_range="30d"
)
```

### 2. Capacity Forecasting
```python
# Forecast capacity needs
forecast = capacity_api.forecast_capacity(
    service="web-app",
    metric="cpu_usage",
    horizon="90d",
    confidence_level=0.95
)
```

### 3. Cost Optimization
```python
# Get cost optimization suggestions
optimizations = capacity_api.get_cost_optimizations(
    account_id="123456789012",
    savings_target=0.20  # 20% cost reduction
)
```

### 4. Auto-scaling Optimization
```python
# Optimize auto-scaling policies
policy = capacity_api.optimize_autoscaling(
    cluster="production",
    service="api-service",
    target_utilization=0.70
)
```

## Configuration Examples

### Cloud Provider Setup
```yaml
# AWS Configuration
aws:
  regions:
    - us-east-1
    - us-west-2
  services:
    - ec2
    - rds
    - elasticache
    - lambda
  cost_explorer:
    enabled: true
    granularity: DAILY

# GCP Configuration  
gcp:
  projects:
    - my-production-project
    - my-staging-project
  services:
    - compute
    - sql
    - kubernetes
  billing:
    enabled: true
    export_table: "billing.gcp_billing_export_v1"
```

### Forecasting Models
```yaml
forecasting:
  default_horizon: "30d"
  confidence_levels: [0.80, 0.90, 0.95]
  
  models:
    cpu_forecast:
      algorithm: "prophet"
      parameters:
        yearly_seasonality: true
        weekly_seasonality: true
        daily_seasonality: false
        
    cost_forecast:
      algorithm: "linear_regression"
      parameters:
        include_trends: true
        seasonality: "monthly"
```

### Alert Rules
```yaml
alerts:
  high_growth_rate:
    threshold: 20  # 20% growth rate
    timeframe: "7d"
    notification: ["slack", "email"]
    
  capacity_threshold:
    threshold: 80  # 80% capacity utilization
    forecast_horizon: "30d"
    notification: ["pagerduty"]
    
  cost_anomaly:
    threshold: 150  # 150% of predicted cost
    notification: ["email", "slack"]
```

## API Examples

### Get Current Utilization
```bash
curl -X GET "http://localhost:8000/api/utilization?service=web-app&timeframe=24h" \
  -H "Authorization: Bearer $TOKEN"
```

### Generate Forecast
```bash
curl -X POST "http://localhost:8000/api/forecast" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "resource_type": "cpu",
    "service": "api-service", 
    "horizon": "30d",
    "confidence_level": 0.95
  }'
```

### Get Optimization Recommendations
```bash
curl -X GET "http://localhost:8000/api/recommendations?type=cost&savings_target=20" \
  -H "Authorization: Bearer $TOKEN"
```

## Performance & Scaling

### Resource Requirements
- **Development**: 4GB RAM, 2 CPU cores, 50GB storage
- **Production**: 16GB+ RAM, 8+ CPU cores, 500GB+ storage
- **Enterprise**: Multi-region deployment with dedicated analytics cluster

### Data Retention
- **Real-time data**: 7 days high resolution
- **Historical data**: 2 years aggregated data
- **Cost data**: 5 years for compliance
- **Forecasts**: Store predictions for accuracy tracking

## Security & Compliance

### Data Protection
- Encryption at rest and in transit
- Role-based access control (RBAC)
- Audit logging for all operations
- Data anonymization for sensitive metrics

### Cloud Permissions
- Read-only access to cloud resources
- Minimal required permissions principle
- Regular credential rotation
- Multi-account support with cross-account roles

## Contributing

1. Fork the repository
2. Create a feature branch
3. Add tests for new functionality
4. Ensure all tests pass
5. Submit a pull request

## License

MIT License - see LICENSE file for details

---

**Created by [olaitanojo](https://github.com/olaitanojo)**
