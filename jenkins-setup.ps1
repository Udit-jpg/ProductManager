# Jenkins Quick Setup Script for Product Manager

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Jenkins Setup for Product Manager" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Check Java installation
Write-Host "1. Checking Java installation..." -ForegroundColor Yellow
try {
    $javaVersion = java -version 2>&1 | Select-String "version"
    Write-Host "   ✓ Java found: $javaVersion" -ForegroundColor Green
} catch {
    Write-Host "   ✗ Java not found. Please install JDK 21" -ForegroundColor Red
    Write-Host "   Download from: https://adoptium.net/" -ForegroundColor Yellow
    exit 1
}

# Check Maven installation
Write-Host ""
Write-Host "2. Checking Maven installation..." -ForegroundColor Yellow
try {
    $mavenVersion = mvn -version 2>&1 | Select-String "Apache Maven"
    Write-Host "   ✓ Maven found: $mavenVersion" -ForegroundColor Green
} catch {
    Write-Host "   ✗ Maven not found. Please install Maven 3.9+" -ForegroundColor Red
    Write-Host "   Download from: https://maven.apache.org/download.cgi" -ForegroundColor Yellow
}

# Check Node.js installation
Write-Host ""
Write-Host "3. Checking Node.js installation..." -ForegroundColor Yellow
try {
    $nodeVersion = node -v
    Write-Host "   ✓ Node.js found: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "   ✗ Node.js not found. Please install Node.js 20+" -ForegroundColor Red
    Write-Host "   Download from: https://nodejs.org/" -ForegroundColor Yellow
}

# Check Git installation
Write-Host ""
Write-Host "4. Checking Git installation..." -ForegroundColor Yellow
try {
    $gitVersion = git --version
    Write-Host "   ✓ Git found: $gitVersion" -ForegroundColor Green
} catch {
    Write-Host "   ✗ Git not found. Please install Git" -ForegroundColor Red
    Write-Host "   Download from: https://git-scm.com/download/win" -ForegroundColor Yellow
}

# Check Docker installation (optional)
Write-Host ""
Write-Host "5. Checking Docker installation (optional)..." -ForegroundColor Yellow
try {
    $dockerVersion = docker --version
    Write-Host "   ✓ Docker found: $dockerVersion" -ForegroundColor Green
} catch {
    Write-Host "   ⚠ Docker not found (optional for Docker builds)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Jenkins Installation Steps" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Step 1: Download Jenkins" -ForegroundColor Green
Write-Host "   Visit: https://www.jenkins.io/download/" -ForegroundColor White
Write-Host "   Download Jenkins LTS WAR file or Windows installer" -ForegroundColor White
Write-Host ""

Write-Host "Step 2: Install Jenkins" -ForegroundColor Green
Write-Host "   Option A: Run WAR file" -ForegroundColor White
Write-Host "   java -jar jenkins.war" -ForegroundColor Cyan
Write-Host ""
Write-Host "   Option B: Use Windows installer (MSI)" -ForegroundColor White
Write-Host "   Run the downloaded .msi file" -ForegroundColor Cyan
Write-Host ""

Write-Host "Step 3: Access Jenkins" -ForegroundColor Green
Write-Host "   URL: http://localhost:9090" -ForegroundColor Cyan
Write-Host ""

Write-Host "Step 4: Get Initial Admin Password" -ForegroundColor Green
$jenkinsSecretPath = "$env:USERPROFILE\.jenkins\secrets\initialAdminPassword"
if (Test-Path $jenkinsSecretPath) {
    $password = Get-Content $jenkinsSecretPath
    Write-Host "   Your initial admin password: $password" -ForegroundColor Cyan
} else {
    Write-Host "   Location: $jenkinsSecretPath" -ForegroundColor Cyan
    Write-Host "   (File will be created after Jenkins first run)" -ForegroundColor Yellow
}
Write-Host ""

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Required Jenkins Plugins" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Install these plugins from Jenkins Plugin Manager:" -ForegroundColor White
Write-Host "1. Git Plugin" -ForegroundColor Yellow
Write-Host "2. GitHub Plugin" -ForegroundColor Yellow
Write-Host "3. Pipeline Plugin" -ForegroundColor Yellow
Write-Host "4. HTML Publisher Plugin" -ForegroundColor Yellow
Write-Host "5. JUnit Plugin" -ForegroundColor Yellow
Write-Host "6. Email Extension Plugin" -ForegroundColor Yellow
Write-Host "7. Checkstyle Plugin" -ForegroundColor Yellow
Write-Host "8. Warnings Next Generation Plugin" -ForegroundColor Yellow
Write-Host "9. Maven Integration Plugin" -ForegroundColor Yellow
Write-Host "10. NodeJS Plugin" -ForegroundColor Yellow
Write-Host ""

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "GitHub Personal Access Token" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Go to: https://github.com/settings/tokens" -ForegroundColor White
Write-Host "2. Click 'Generate new token (classic)'" -ForegroundColor White
Write-Host "3. Select scopes:" -ForegroundColor White
Write-Host "   ✓ repo (all)" -ForegroundColor Yellow
Write-Host "   ✓ admin:repo_hook" -ForegroundColor Yellow
Write-Host "4. Copy the token (you won't see it again!)" -ForegroundColor White
Write-Host ""

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Quick Configuration Checklist" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "□ Jenkins installed and running" -ForegroundColor White
Write-Host "□ Required plugins installed" -ForegroundColor White
Write-Host "□ JDK 21 configured in Global Tool Configuration" -ForegroundColor White
Write-Host "□ Maven 3.9+ configured in Global Tool Configuration" -ForegroundColor White
Write-Host "□ Git configured in Global Tool Configuration" -ForegroundColor White
Write-Host "□ NodeJS 20 configured in Global Tool Configuration" -ForegroundColor White
Write-Host "□ GitHub credentials added to Jenkins" -ForegroundColor White
Write-Host "□ Email SMTP configured (for notifications)" -ForegroundColor White
Write-Host "□ Pipeline job created: ProductManager-Pipeline" -ForegroundColor White
Write-Host "□ GitHub webhook configured" -ForegroundColor White
Write-Host ""

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Next Steps" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Read JENKINS_INTEGRATION_GUIDE.md for detailed setup" -ForegroundColor Green
Write-Host "2. Configure Jenkins Global Tools" -ForegroundColor Green
Write-Host "3. Add GitHub credentials to Jenkins" -ForegroundColor Green
Write-Host "4. Create Pipeline job in Jenkins" -ForegroundColor Green
Write-Host "5. Set up GitHub webhook" -ForegroundColor Green
Write-Host "6. Test with a commit to trigger automatic build" -ForegroundColor Green
Write-Host ""

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Test Build Command" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "After Jenkins is configured, test with:" -ForegroundColor White
Write-Host ""
Write-Host "cd `"c:\Users\uudit\Downloads\Product Manager`"" -ForegroundColor Cyan
Write-Host "echo `"# Jenkins test`" >> README.md" -ForegroundColor Cyan
Write-Host "git add README.md" -ForegroundColor Cyan
Write-Host "git commit -m `"Test Jenkins webhook`"" -ForegroundColor Cyan
Write-Host "git push origin main" -ForegroundColor Cyan
Write-Host ""
Write-Host "Watch Jenkins dashboard for automatic build!" -ForegroundColor Green
Write-Host ""

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Setup Complete!" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "For detailed instructions, see:" -ForegroundColor White
Write-Host "JENKINS_INTEGRATION_GUIDE.md" -ForegroundColor Cyan
Write-Host ""
