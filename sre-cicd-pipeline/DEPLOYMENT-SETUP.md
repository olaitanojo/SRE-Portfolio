# Multi-Cloud Deployment Setup Guide

## 🎯 Overview
This guide helps you set up credentials and deploy the SRE CI/CD Pipeline application to both AWS and Azure.

## ⚙️ Prerequisites Setup

### 1. Docker Desktop
✅ **Already Installed** - Docker Desktop is ready

### 2. AWS CLI Configuration
You need to configure AWS CLI with your credentials:

```powershell
# Configure AWS CLI (you'll be prompted for credentials)
aws configure

# Required information:
# - AWS Access Key ID
# - AWS Secret Access Key  
# - Default region (e.g., us-east-1)
# - Default output format (json)
```

**To get AWS credentials:**
1. Log into AWS Console
2. Go to IAM → Users → Your User → Security Credentials
3. Create Access Key if you don't have one
4. Copy Access Key ID and Secret Access Key

### 3. Azure CLI Configuration
You need to log into Azure:

```powershell
# Login to Azure (will open browser for authentication)
az login

# Select subscription if you have multiple
az account list --output table
az account set --subscription "<subscription-id>"
```

## 🚀 Deployment Options

### Option 1: Deploy to AWS Only
```powershell
# Deploy to AWS ECS Fargate with Load Balancer
.\deploy-aws.ps1

# Or with custom parameters:
.\deploy-aws.ps1 -Region "us-west-2" -StackName "my-sre-app" -ImageTag "v1.0"
```

### Option 2: Deploy to Azure Only
```powershell
# Deploy to Azure Container Instances
.\deploy-azure.ps1

# Or with custom parameters:
.\deploy-azure.ps1 -ResourceGroupName "my-sre-rg" -Location "West US 2" -ProjectName "my-sre-app"
```

### Option 3: Deploy to Both Clouds
```powershell
# Deploy to both AWS and Azure
.\deploy-aws.ps1
.\deploy-azure.ps1
```

## 📊 What Gets Deployed

### AWS Deployment (ECS Fargate)
- **VPC** with public subnets across 2 availability zones
- **Application Load Balancer** for high availability
- **ECS Fargate Service** with 2-10 auto-scaling tasks
- **ECR Repository** for container images
- **CloudWatch Logs** for application logging
- **Security Groups** with proper access controls

### Azure Deployment (Container Instances)
- **Azure Container Registry** for images
- **Container Instances** (2 replicas by default)
- **Traffic Manager** for load balancing
- **Health Monitoring** with automatic restart
- **Public IP addresses** with DNS names

## 🏥 Health Monitoring

Both deployments include comprehensive health monitoring:

### Health Check Endpoints
- `/health` - Application health status
- `/ready` - Readiness probe for orchestration
- `/metrics` - Prometheus metrics for monitoring

### Monitoring Features
- **Automatic health checks** every 30 seconds
- **Auto-restart** on health check failures
- **Load balancer integration** removes unhealthy instances
- **Prometheus metrics** for observability

## 📈 Scaling

### AWS Auto Scaling
- **CPU-based scaling**: Scales when CPU > 70%
- **Min instances**: 2
- **Max instances**: 10
- **Scaling policies**: Automatic based on CloudWatch metrics

### Azure Scaling
- **Manual scaling**: Update replicaCount parameter and redeploy
- **Instance health**: Unhealthy instances are automatically restarted
- **Traffic distribution**: Traffic Manager distributes load across instances

## 🔧 Management Commands

### AWS Management
```powershell
# View ECS service status
aws ecs describe-services --cluster sre-cicd-pipeline-cluster --services sre-cicd-pipeline-service

# View logs
aws logs tail /ecs/sre-cicd-pipeline --follow

# Scale service
aws ecs update-service --cluster sre-cicd-pipeline-cluster --service sre-cicd-pipeline-service --desired-count 5

# Clean up
aws cloudformation delete-stack --stack-name sre-cicd-pipeline
```

### Azure Management
```powershell
# View container status
az container show --resource-group sre-cicd-pipeline-rg --name sre-cicd-pipeline-cg-1

# View logs
az container logs --resource-group sre-cicd-pipeline-rg --name sre-cicd-pipeline-cg-1

# Scale (redeploy with different replica count)
az deployment group create --resource-group sre-cicd-pipeline-rg --template-file azure-deployment.json --parameters replicaCount=5

# Clean up
az group delete --name sre-cicd-pipeline-rg --yes
```

## 💰 Cost Considerations

### AWS Costs (Estimated)
- **ECS Fargate**: ~$15-30/month for 2 instances
- **Application Load Balancer**: ~$16/month
- **ECR Storage**: ~$1/month for images
- **CloudWatch Logs**: ~$1-5/month
- **Total**: ~$33-52/month

### Azure Costs (Estimated)
- **Container Instances**: ~$10-20/month for 2 instances
- **Container Registry**: ~$5/month
- **Traffic Manager**: ~$5/month
- **Total**: ~$20-30/month

## 🔒 Security Features

### AWS Security
- **VPC isolation** with security groups
- **IAM roles** with minimal permissions
- **ECR image scanning** for vulnerabilities
- **CloudWatch audit logs**

### Azure Security
- **Container Registry** with admin access
- **Public IP restrictions** (can be configured)
- **Azure Monitor** integration
- **Resource group isolation**

## 🚨 Troubleshooting

### Common Issues

1. **Docker not running**
   ```powershell
   # Start Docker Desktop and wait for it to be ready
   ```

2. **AWS credentials not configured**
   ```powershell
   aws configure
   ```

3. **Azure not logged in**
   ```powershell
   az login
   ```

4. **Insufficient permissions**
   - Ensure your AWS user has ECS, ECR, CloudFormation permissions
   - Ensure your Azure account has Contributor role

### Deployment Failures
- Check CloudFormation events in AWS Console
- Check Azure deployment errors in Azure Portal
- Review Docker build logs for image issues

## 📞 Support

If you encounter issues:
1. Check the deployment logs
2. Verify cloud credentials are configured
3. Ensure Docker Desktop is running
4. Check resource limits and quotas

---

**Ready to deploy?** Start with setting up your cloud credentials, then run the deployment scripts!
