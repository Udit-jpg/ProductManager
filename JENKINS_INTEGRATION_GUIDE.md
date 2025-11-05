# Jenkins Integration Guide for Product Manager Microservices

Complete guide to integrate Jenkins CI/CD pipeline with GitHub for automatic build reports after every commit.

---

## 📋 Table of Contents

1. [Prerequisites](#prerequisites)
2. [Jenkins Installation](#jenkins-installation)
3. [Jenkins Configuration](#jenkins-configuration)
4. [GitHub Webhook Setup](#github-webhook-setup)
5. [Pipeline Configuration](#pipeline-configuration)
6. [Report Generation](#report-generation)
7. [Troubleshooting](#troubleshooting)

---

## 🔧 Prerequisites

### Required Software

- **Jenkins 2.400+** (LTS version recommended)
- **JDK 21** (for Spring Boot services)
- **Maven 3.9.11+**
- **Node.js 20+** (for React frontend)
- **Git** installed on Jenkins server
- **Docker** (optional, for containerization)

### Required Jenkins Plugins

Install these plugins from Jenkins Plugin Manager:

1. **Git Plugin** - Git integration
2. **GitHub Plugin** - GitHub integration
3. **Pipeline Plugin** - Pipeline support
4. **HTML Publisher Plugin** - HTML report publishing
5. **JUnit Plugin** - Test result visualization
6. **Email Extension Plugin** - Email notifications
7. **Checkstyle Plugin** - Code quality reports
8. **Warnings Next Generation Plugin** - Issue reporting
9. **Maven Integration Plugin** - Maven support
10. **NodeJS Plugin** - Node.js support
11. **Docker Pipeline Plugin** - Docker integration (optional)

---

## 📥 Jenkins Installation

### Windows Installation

```powershell
# Download Jenkins from https://www.jenkins.io/download/
# Run the installer
java -jar jenkins.war

# Or install as Windows Service using the MSI installer
```

### Access Jenkins

1. Open browser: `http://localhost:8080`
2. Get initial admin password:
   ```powershell
   Get-Content C:\Users\<your-username>\.jenkins\secrets\initialAdminPassword
   ```
3. Complete setup wizard
4. Install suggested plugins

---

## ⚙️ Jenkins Configuration

### Step 1: Configure Global Tools

Go to **Manage Jenkins → Global Tool Configuration**

#### 1.1 JDK Configuration

```
Name: JDK-21
JAVA_HOME: C:\Program Files\Java\jdk-21
```

Or check "Install automatically" and select JDK 21.

#### 1.2 Maven Configuration

```
Name: Maven-3.9.11
MAVEN_HOME: C:\Program Files\Apache\maven-3.9.11
```

Or check "Install automatically" and select Maven 3.9.11.

#### 1.3 Git Configuration

```
Name: Default
Path to Git executable: C:\Program Files\Git\bin\git.exe
```

#### 1.4 NodeJS Configuration

```
Name: NodeJS-20
Version: NodeJS 20.x
Global npm packages: npm@latest
```

### Step 2: Configure GitHub Credentials

Go to **Manage Jenkins → Credentials → System → Global credentials**

1. Click **Add Credentials**
2. Select **Kind**: Username with password
3. Enter:
   - **Username**: Your GitHub username (e.g., `Udit-jpg`)
   - **Password**: GitHub Personal Access Token (not your password!)
   - **ID**: `github-credentials`
   - **Description**: GitHub Access Token

#### Generate GitHub Personal Access Token

1. Go to GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Click **Generate new token (classic)**
3. Select scopes:
   - ✓ `repo` (all)
   - ✓ `admin:repo_hook`
4. Copy the token (you won't see it again!)

### Step 3: Configure Email Notifications

Go to **Manage Jenkins → Configure System**

#### Extended E-mail Notification

```
SMTP server: smtp.gmail.com
SMTP Port: 465
Use SSL: ✓ (checked)

Credentials: Add → Gmail account
  Username: your-email@gmail.com
  Password: App Password (not your Gmail password)

Default Recipients: your-email@gmail.com
```

#### Gmail App Password Setup

1. Go to Google Account → Security → 2-Step Verification
2. Generate App Password for "Mail"
3. Use this password in Jenkins

---

## 🔗 GitHub Webhook Setup

### Step 1: Configure Webhook in GitHub

1. Go to your repository: `https://github.com/Udit-jpg/ProductManager`
2. Click **Settings → Webhooks → Add webhook**
3. Configure:
   ```
   Payload URL: http://<your-jenkins-server>:8080/github-webhook/
   Content type: application/json
   Secret: (leave empty or set a secret)
   
   Which events would you like to trigger this webhook?
   ☑ Just the push event
   
   ☑ Active
   ```
4. Click **Add webhook**

### Step 2: Test Webhook

1. Make a small change to your repository
2. Commit and push to GitHub
3. Check webhook deliveries in GitHub Settings → Webhooks
4. Verify Jenkins received the trigger

---

## 🚀 Pipeline Configuration

### Step 1: Create Jenkins Pipeline Job

1. Go to Jenkins Dashboard
2. Click **New Item**
3. Enter name: `ProductManager-Pipeline`
4. Select **Pipeline**
5. Click **OK**

### Step 2: Configure Pipeline Job

#### General Settings

```
✓ GitHub project
  Project url: https://github.com/Udit-jpg/ProductManager/
```

#### Build Triggers

```
✓ GitHub hook trigger for GITScm polling
```

This enables Jenkins to build automatically when GitHub webhook is triggered.

#### Pipeline Configuration

Select **Pipeline script from SCM**

```
SCM: Git
Repository URL: https://github.com/Udit-jpg/ProductManager.git
Credentials: Select your GitHub credentials

Branches to build: */main

Script Path: Jenkinsfile
```

### Step 3: Save Configuration

Click **Save**

---

## 📊 Report Generation

The Jenkinsfile includes automatic report generation:

### 1. Build Report (HTML)

**Location**: Available in Jenkins build artifacts
- Click on build number → **Build Report** (left sidebar)
- Beautiful HTML report with:
  - Build status
  - Service build status
  - Test results
  - Docker images
  - Build artifacts
  - Next steps

### 2. Test Reports (JUnit)

**Location**: Build number → **Test Result**
- Displays all test results
- Shows pass/fail status
- Detailed test execution time

### 3. Code Quality Reports (Checkstyle)

**Location**: Build number → **Checkstyle Warnings**
- Code style violations
- Best practice recommendations

### 4. Email Notifications

**Automatic emails sent**:
- ✓ On build success
- ✗ On build failure
- Includes build summary and links

---

## 🎯 How It Works

### Automatic Build Trigger Flow

```
┌─────────────────┐
│ Developer       │
│ Commits & Pushes│
│ to GitHub       │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ GitHub Webhook  │
│ Triggered       │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Jenkins Receives│
│ Notification    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Jenkins Pipeline│
│ Starts          │
└────────┬────────┘
         │
         ▼
┌─────────────────────────────────────────┐
│ Pipeline Stages:                        │
│ 1. Checkout code from GitHub            │
│ 2. Build all 4 microservices            │
│ 3. Run unit tests (parallel)            │
│ 4. Code quality analysis                │
│ 5. Package services (JAR files)         │
│ 6. Build React frontend                 │
│ 7. Build Docker images                  │
│ 8. Generate HTML report                 │
└────────┬────────────────────────────────┘
         │
         ▼
┌─────────────────┐
│ Publish Reports:│
│ - HTML Report   │
│ - Test Results  │
│ - Checkstyle    │
│ - Email         │
└─────────────────┘
```

---

## 📧 Email Report Example

### Success Email

```
Subject: ✓ Jenkins Build SUCCESS - Product Manager #42

Build Successful! 🎉

Project: Product Manager Microservices
Build Number: #42
Build Time: 2025-11-05 14:30:00
Git Author: Udit
Commit Message: Added new feature to User Service
Status: SUCCESS

Services Built:
✓ User Service (8081)
✓ Product Service (8082)
✓ Order Service (8083)
✓ Payment Service (8084)
✓ React Frontend (3000)

View Build Details: http://localhost:8080/job/ProductManager-Pipeline/42/
View Build Report: http://localhost:8080/job/ProductManager-Pipeline/42/Build_Report/
```

---

## 🧪 Testing the Setup

### Test 1: Manual Build

1. Go to Jenkins job
2. Click **Build Now**
3. Watch console output
4. Verify report generation

### Test 2: Automatic Trigger

1. Make a change to any file in your repository:
   ```powershell
   cd "c:\Users\uudit\Downloads\Product Manager"
   echo "# Test change" >> README.md
   git add README.md
   git commit -m "Test Jenkins webhook trigger"
   git push origin main
   ```

2. Check Jenkins:
   - Build should start automatically
   - Watch build progress
   - Verify report generation

### Test 3: Verify Reports

1. **HTML Report**: Click build → Build Report
2. **Test Report**: Click build → Test Result
3. **Email**: Check your inbox

---

## 🔍 Jenkinsfile Explanation

### Key Features

#### 1. Environment Variables

```groovy
environment {
    DOCKER_REGISTRY = 'docker.io'
    IMAGE_PREFIX = 'productmanager'
    GIT_REPO = 'https://github.com/Udit-jpg/ProductManager.git'
    EMAIL_RECIPIENTS = 'uudit@example.com'
}
```

#### 2. Parallel Builds

```groovy
stage('Run Unit Tests') {
    parallel {
        stage('Test User Service') { ... }
        stage('Test Product Service') { ... }
        stage('Test Order Service') { ... }
        stage('Test Payment Service') { ... }
    }
}
```

#### 3. Report Generation

```groovy
stage('Generate Build Report') {
    steps {
        script {
            writeFile file: "build-report-${BUILD_NUMBER}.html", text: reportContent
            publishHTML(...)
        }
    }
}
```

#### 4. Post Actions

```groovy
post {
    success {
        emailext(subject: "✓ Jenkins Build SUCCESS", ...)
    }
    failure {
        emailext(subject: "✗ Jenkins Build FAILED", ...)
    }
}
```

---

## 🛠️ Customization

### Modify Email Recipients

Edit `Jenkinsfile` line:
```groovy
EMAIL_RECIPIENTS = 'your-email@example.com,team@example.com'
```

### Add More Tests

Add to the test stage:
```groovy
stage('Integration Tests') {
    steps {
        dir('User/demo') {
            bat 'mvn verify'
        }
    }
}
```

### Add Code Coverage

Add Jacoco plugin:
```groovy
stage('Code Coverage') {
    steps {
        bat 'mvn jacoco:report'
    }
    post {
        always {
            jacoco()
        }
    }
}
```

### Add SonarQube Analysis

```groovy
stage('SonarQube Analysis') {
    steps {
        withSonarQubeEnv('SonarQube') {
            bat 'mvn sonar:sonar'
        }
    }
}
```

---

## 🐛 Troubleshooting

### Issue 1: Jenkins Not Receiving Webhook

**Solution**:
1. Check Jenkins URL is accessible from internet
2. Use ngrok for local testing:
   ```powershell
   ngrok http 8080
   ```
3. Update webhook URL with ngrok URL

### Issue 2: Build Fails on Maven

**Solution**:
1. Verify Maven installation in Global Tool Configuration
2. Check JAVA_HOME is set correctly
3. Ensure pom.xml is valid

### Issue 3: Email Not Sending

**Solution**:
1. Verify SMTP settings
2. Use Gmail App Password, not account password
3. Enable "Less secure app access" (if applicable)
4. Check email logs: Manage Jenkins → System Log

### Issue 4: Docker Build Fails

**Solution**:
1. Ensure Docker is installed on Jenkins server
2. Add Jenkins user to docker group (Linux)
3. Restart Jenkins service

### Issue 5: Node.js Build Fails

**Solution**:
1. Install NodeJS plugin
2. Configure NodeJS in Global Tool Configuration
3. Ensure npm is in PATH

---

## 📝 Best Practices

### 1. Credentials Management
- Never hardcode credentials in Jenkinsfile
- Use Jenkins Credentials Store
- Rotate tokens regularly

### 2. Build Optimization
- Use parallel stages for faster builds
- Cache Maven dependencies
- Use incremental builds

### 3. Report Retention
- Configure build retention policy
- Archive important artifacts
- Clean old builds regularly

### 4. Security
- Enable CSRF protection
- Use role-based access control
- Keep Jenkins and plugins updated

### 5. Monitoring
- Set up build notifications
- Monitor build trends
- Track build duration

---

## 🎯 Next Steps

After setting up Jenkins:

1. **Add More Stages**:
   - Integration tests
   - Performance tests
   - Security scans

2. **Deploy to Environments**:
   - Deploy to staging
   - Deploy to production
   - Blue-green deployment

3. **Advanced Features**:
   - Multi-branch pipeline
   - Parameterized builds
   - Scheduled builds

4. **Monitoring & Alerts**:
   - Slack notifications
   - Metrics collection
   - Dashboard visualization

---

## 📚 Additional Resources

- [Jenkins Documentation](https://www.jenkins.io/doc/)
- [Pipeline Syntax](https://www.jenkins.io/doc/book/pipeline/syntax/)
- [GitHub Webhooks](https://docs.github.com/en/webhooks)
- [Maven Plugin](https://www.jenkins.io/doc/pipeline/steps/maven-plugin/)

---

## 🤝 Support

For issues or questions:
- Check Jenkins console output
- Review build logs
- Consult Jenkins documentation
- GitHub Issues: https://github.com/Udit-jpg/ProductManager/issues

---

**Document Version**: 1.0  
**Last Updated**: November 5, 2025  
**Jenkins Version**: 2.400+ LTS
