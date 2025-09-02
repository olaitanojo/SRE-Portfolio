# Azure Deployment Script for SRE CI/CD Pipeline
# This script automates the deployment to Azure Container Instances

param(
    [Parameter(Mandatory=$false)]
    [string]$ResourceGroupName = "sre-cicd-pipeline-rg",
    
    [Parameter(Mandatory=$false)]
    [string]$Location = "East US",
    
    [Parameter(Mandatory=$false)]
    [string]$ProjectName = "sre-cicd-pipeline",
    
    [Parameter(Mandatory=$false)]
    [string]$ImageTag = "latest"
)

Write-Host "🚀 Starting Azure Deployment for SRE CI/CD Pipeline" -ForegroundColor Green
Write-Host "Resource Group: $ResourceGroupName" -ForegroundColor Yellow
Write-Host "Location: $Location" -ForegroundColor Yellow
Write-Host "Project Name: $ProjectName" -ForegroundColor Yellow
Write-Host "Image Tag: $ImageTag" -ForegroundColor Yellow

# Check if Azure CLI is configured
Write-Host "📋 Checking Azure CLI configuration..." -ForegroundColor Blue
try {
    $azAccount = az account show --output json | ConvertFrom-Json
    Write-Host "✅ Azure CLI configured for subscription: $($azAccount.name)" -ForegroundColor Green
} catch {
    Write-Host "❌ Azure CLI not configured. Please run 'az login' first." -ForegroundColor Red
    exit 1
}

# Create resource group
Write-Host "🏗️ Creating resource group..." -ForegroundColor Blue
az group create --name $ResourceGroupName --location "$Location" --tags Project=SRE-Portfolio Component=ResourceGroup

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to create resource group!" -ForegroundColor Red
    exit 1
}

# Deploy the ARM template
Write-Host "📦 Deploying Azure resources..." -ForegroundColor Blue
$deploymentName = "$ProjectName-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

$deployResult = az deployment group create `
    --resource-group $ResourceGroupName `
    --template-file azure-deployment.json `
    --parameters "projectName=$ProjectName" "containerImageTag=$ImageTag" `
    --name $deploymentName `
    --output json

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ ARM template deployment failed!" -ForegroundColor Red
    exit 1
}

$deployment = $deployResult | ConvertFrom-Json

# Get deployment outputs
Write-Host "📄 Getting deployment information..." -ForegroundColor Blue
$outputs = az deployment group show --resource-group $ResourceGroupName --name $deploymentName --query "properties.outputs" --output json | ConvertFrom-Json

# Display deployment information
Write-Host "✅ Azure deployment completed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "📊 Deployment Outputs:" -ForegroundColor Cyan
Write-Host "Container Registry: $($outputs.containerRegistryLoginServer.value)" -ForegroundColor White
Write-Host "Registry Name: $($outputs.containerRegistryName.value)" -ForegroundColor White

if ($outputs.trafficManagerUrl) {
    Write-Host "🌐 Load Balanced URL: $($outputs.trafficManagerUrl.value)" -ForegroundColor Green
}

Write-Host ""
Write-Host "📍 Container Instances:" -ForegroundColor Cyan
foreach ($endpoint in $outputs.containerEndpoints.value) {
    Write-Host "  • $($endpoint.instanceName): $($endpoint.url)" -ForegroundColor White
    Write-Host "    Health Check: $($endpoint.url)/health" -ForegroundColor Gray
    Write-Host "    Metrics: $($endpoint.url)/metrics" -ForegroundColor Gray
}

# Get ACR credentials for Docker push
Write-Host ""
Write-Host "🔑 Getting ACR credentials..." -ForegroundColor Blue
$acrCredentials = az acr credential show --name $outputs.containerRegistryName.value --output json | ConvertFrom-Json

# Build and push Docker image
Write-Host "📦 Building and pushing Docker image..." -ForegroundColor Blue

# Login to ACR
Write-Host "Logging into ACR..." -ForegroundColor Yellow
$acrCredentials.passwords[0].value | docker login $outputs.containerRegistryLoginServer.value --username $outputs.containerRegistryName.value --password-stdin

# Build image
Write-Host "Building Docker image..." -ForegroundColor Yellow
$imageUri = "$($outputs.containerRegistryLoginServer.value)/${ProjectName}:$ImageTag"
docker build -t $imageUri .

# Push image
Write-Host "Pushing image to ACR..." -ForegroundColor Yellow
docker push $imageUri

# Restart container instances to pull new image
Write-Host "🔄 Restarting container instances..." -ForegroundColor Blue
foreach ($endpoint in $outputs.containerEndpoints.value) {
    az container restart --resource-group $ResourceGroupName --name $endpoint.instanceName
}

Write-Host ""
Write-Host "🧪 Testing deployment..." -ForegroundColor Blue
Start-Sleep -Seconds 30  # Wait for containers to restart

# Test the first container instance
if ($outputs.containerEndpoints.value.Count -gt 0) {
    $testUrl = "$($outputs.containerEndpoints.value[0].url)/health"
    try {
        $healthCheck = Invoke-RestMethod -Uri $testUrl -Method GET
        Write-Host "✅ Health check passed!" -ForegroundColor Green
        Write-Host $healthCheck -ForegroundColor White
    } catch {
        Write-Host "⚠️ Health check failed. The service might still be starting up." -ForegroundColor Yellow
        Write-Host "Please wait a few minutes and check: $testUrl" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "🎉 Azure deployment completed!" -ForegroundColor Green
Write-Host ""
Write-Host "🔧 Management Commands:" -ForegroundColor Cyan
Write-Host "  View logs: az container logs --resource-group $ResourceGroupName --name <container-instance-name>" -ForegroundColor Gray
Write-Host "  Scale up: az deployment group create --resource-group $ResourceGroupName --template-file azure-deployment.json --parameters replicaCount=<number>" -ForegroundColor Gray
Write-Host "  Clean up: az group delete --name $ResourceGroupName --yes --no-wait" -ForegroundColor Gray
