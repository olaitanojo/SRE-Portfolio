# AWS Deployment Script for SRE CI/CD Pipeline
# This script automates the deployment to AWS ECS Fargate

param(
    [Parameter(Mandatory=$false)]
    [string]$Region = "us-east-1",
    
    [Parameter(Mandatory=$false)]
    [string]$StackName = "sre-cicd-pipeline",
    
    [Parameter(Mandatory=$false)]
    [string]$ImageTag = "latest"
)

Write-Host "Starting AWS Deployment for SRE CI/CD Pipeline" -ForegroundColor Green
Write-Host "Region: $Region" -ForegroundColor Yellow
Write-Host "Stack Name: $StackName" -ForegroundColor Yellow
Write-Host "Image Tag: $ImageTag" -ForegroundColor Yellow

# Check if AWS CLI is configured
Write-Host "Checking AWS CLI configuration..." -ForegroundColor Blue
try {
    $awsIdentity = aws sts get-caller-identity --output json | ConvertFrom-Json
    Write-Host "AWS CLI configured for account: $($awsIdentity.Account)" -ForegroundColor Green
} catch {
    Write-Host "AWS CLI not configured. Please run 'aws configure' first." -ForegroundColor Red
    exit 1
}

# Get AWS Account ID
$accountId = $awsIdentity.Account

# Build and push Docker image to ECR
Write-Host "📦 Building and pushing Docker image..." -ForegroundColor Blue

# Create ECR repository if it doesn't exist
Write-Host "Creating ECR repository..." -ForegroundColor Yellow
aws ecr create-repository --repository-name $StackName --region $Region 2>$null

# Get ECR login token
Write-Host "Logging into ECR..." -ForegroundColor Yellow
$ecrLoginCommand = aws ecr get-login-password --region $Region
$ecrLoginCommand | docker login --username AWS --password-stdin "$accountId.dkr.ecr.$Region.amazonaws.com"

# Build Docker image
Write-Host "Building Docker image..." -ForegroundColor Yellow
$imageUri = "$accountId.dkr.ecr.$Region.amazonaws.com/${StackName}:$ImageTag"
docker build -t $imageUri .

# Push image to ECR
Write-Host "Pushing image to ECR..." -ForegroundColor Yellow
docker push $imageUri

# Deploy CloudFormation stack
Write-Host "🏗️ Deploying CloudFormation stack..." -ForegroundColor Blue
$deployResult = aws cloudformation deploy `
    --template-file aws-deployment.yml `
    --stack-name $StackName `
    --parameter-overrides "ProjectName=$StackName" "ImageTag=$ImageTag" `
    --capabilities CAPABILITY_IAM `
    --region $Region

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ CloudFormation stack deployed successfully!" -ForegroundColor Green
    
    # Get stack outputs
    Write-Host "📄 Getting deployment information..." -ForegroundColor Blue
    $outputs = aws cloudformation describe-stacks --stack-name $StackName --region $Region --query "Stacks[0].Outputs" --output json | ConvertFrom-Json
    
    foreach ($output in $outputs) {
        Write-Host "$($output.OutputKey): $($output.OutputValue)" -ForegroundColor Cyan
    }
    
    # Get Load Balancer DNS
    $albDns = $outputs | Where-Object { $_.OutputKey -eq "LoadBalancerDNS" } | Select-Object -ExpandProperty OutputValue
    
    if ($albDns) {
        Write-Host "🌐 Application URL: http://$albDns" -ForegroundColor Green
        Write-Host "🏥 Health Check: http://$albDns/health" -ForegroundColor Green
        Write-Host "📊 Metrics: http://$albDns/metrics" -ForegroundColor Green
        
        # Test the deployment
        Write-Host "🧪 Testing deployment..." -ForegroundColor Blue
        Start-Sleep -Seconds 60  # Wait for service to be ready
        
        try {
            $healthCheck = Invoke-RestMethod -Uri "http://$albDns/health" -Method GET
            Write-Host "✅ Health check passed!" -ForegroundColor Green
            Write-Host $healthCheck -ForegroundColor White
        } catch {
            Write-Host "⚠️ Health check failed. The service might still be starting up." -ForegroundColor Yellow
            Write-Host "Please wait a few minutes and check: http://$albDns/health" -ForegroundColor Yellow
        }
    }
} else {
    Write-Host "❌ CloudFormation deployment failed!" -ForegroundColor Red
    exit 1
}

Write-Host "🎉 AWS deployment completed!" -ForegroundColor Green
