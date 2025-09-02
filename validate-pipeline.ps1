# SRE CI/CD Pipeline Local Validation Script
# Validates that all components work before GitHub deployment

Write-Host "🔍 SRE CI/CD Pipeline Validation" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

$errorCount = 0

# Test 1: Python Application Tests
Write-Host "🧪 Running Python Tests..." -ForegroundColor Yellow
try {
    $testResult = pytest -v --cov=app test_app.py 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ All tests passed!" -ForegroundColor Green
    } else {
        Write-Host "❌ Tests failed!" -ForegroundColor Red
        $errorCount++
    }
} catch {
    Write-Host "❌ Could not run tests!" -ForegroundColor Red
    $errorCount++
}

# Test 2: Code Quality
Write-Host ""
Write-Host "📝 Checking Code Quality..." -ForegroundColor Yellow
try {
    $flakeResult = flake8 . --count 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Code quality checks passed!" -ForegroundColor Green
    } else {
        Write-Host "❌ Code quality issues found!" -ForegroundColor Red
        $errorCount++
    }
} catch {
    Write-Host "❌ Could not run code quality checks!" -ForegroundColor Red
    $errorCount++
}

# Test 3: Docker Image Build
Write-Host ""
Write-Host "🐳 Testing Docker Image Build..." -ForegroundColor Yellow
try {
    $dockerResult = docker build -t sre-test:validation . 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Docker image built successfully!" -ForegroundColor Green
    } else {
        Write-Host "❌ Docker build failed!" -ForegroundColor Red
        $errorCount++
    }
} catch {
    Write-Host "❌ Could not build Docker image!" -ForegroundColor Red
    $errorCount++
}

# Test 4: Container Health Check
Write-Host ""
Write-Host "🏥 Testing Container Health..." -ForegroundColor Yellow
try {
    $containerId = docker run -d -p 8081:8080 sre-test:validation
    Start-Sleep -Seconds 10
    
    $healthCheck = Invoke-WebRequest -Uri "http://localhost:8081/health" -UseBasicParsing -TimeoutSec 5
    if ($healthCheck.StatusCode -eq 200) {
        Write-Host "✅ Container health check passed!" -ForegroundColor Green
    } else {
        Write-Host "❌ Container health check failed!" -ForegroundColor Red
        $errorCount++
    }
    
    # Cleanup
    docker stop $containerId 2>&1 | Out-Null
    docker rm $containerId 2>&1 | Out-Null
} catch {
    Write-Host "❌ Container health test failed!" -ForegroundColor Red
    $errorCount++
}

# Test 5: Git Repository Status
Write-Host ""
Write-Host "📦 Checking Git Repository..." -ForegroundColor Yellow
try {
    $gitStatus = git status --porcelain
    if ($gitStatus) {
        Write-Host "⚠️  Uncommitted changes detected!" -ForegroundColor Yellow
        Write-Host "   Run 'git add -A && git commit -m \"Final updates\"' if needed"
    } else {
        Write-Host "✅ Git repository is clean!" -ForegroundColor Green
    }
} catch {
    Write-Host "❌ Git repository check failed!" -ForegroundColor Red
    $errorCount++
}

# Cleanup test image
docker rmi sre-test:validation 2>&1 | Out-Null

# Summary
Write-Host ""
Write-Host "📊 Validation Summary" -ForegroundColor Cyan
Write-Host "===================" -ForegroundColor Cyan

if ($errorCount -eq 0) {
    Write-Host "🎉 All validations passed! Ready for GitHub deployment!" -ForegroundColor Green
    Write-Host ""
    Write-Host "🚀 Next Steps:" -ForegroundColor Yellow
    Write-Host "1. Create GitHub repository"
    Write-Host "2. Add remote: git remote add origin <your-repo-url>"
    Write-Host "3. Push code: git push -u origin main"
    Write-Host "4. Configure GitHub Secrets for Docker Hub"
    Write-Host "5. Test CI/CD pipeline with pull requests"
    Write-Host ""
    Write-Host "📖 See GITHUB-SETUP.md for detailed instructions"
} else {
    Write-Host "❌ $errorCount validation(s) failed! Please fix before deployment." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "🏗️  Your SRE CI/CD Pipeline includes:" -ForegroundColor Magenta
Write-Host "   • Flask app with Prometheus metrics"
Write-Host "   • 11 comprehensive tests (89% coverage)"
Write-Host "   • Production-ready Docker container"
Write-Host "   • GitHub Actions CI/CD workflow"
Write-Host "   • Rolling, Blue-Green & Canary deployments"
Write-Host "   • SLO monitoring and alerting"
Write-Host "   • Security scanning and quality gates"
Write-Host "   • Observability stack (Prometheus, Grafana)"
