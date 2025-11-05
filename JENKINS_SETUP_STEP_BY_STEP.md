# Step-by-Step Guide: Adding Product Manager Project to Jenkins

This guide will walk you through setting up your Product Manager microservices project in your local Jenkins server (running on port 9090) with a pipeline.

---

## 📋 Prerequisites Checklist

Before starting, ensure you have:

- ✅ Jenkins installed and running on `http://localhost:9090`
- ✅ JDK 21 installed
- ✅ Maven 3.9+ installed
- ✅ Node.js 20+ installed
- ✅ Git installed
- ✅ Your GitHub repository: https://github.com/Udit-jpg/ProductManager.git

---

## Part 1: Install Required Jenkins Plugins

### Step 1: Access Jenkins Plugin Manager

1. Open Jenkins: `http://localhost:9090`
2. Log in with your admin credentials
3. Click **Manage Jenkins** (left sidebar)
4. Click **Plugins** or **Manage Plugins**

### Step 2: Install Required Plugins

Go to **Available Plugins** tab and search for these plugins (install them one by one or select all):

#### Essential Plugins:

1. **Git Plugin** - For Git integration
   - Search: `Git`
   - Check the box
   
2. **GitHub Plugin** - For GitHub integration
   - Search: `GitHub`
   - Check the box

3. **Pipeline Plugin** - For pipeline support
   - Search: `Pipeline`
   - Check the box

4. **HTML Publisher Plugin** - For HTML reports
   - Search: `HTML Publisher`
   - Check the box

5. **JUnit Plugin** - For test results
   - Search: `JUnit`
   - Check the box

6. **Email Extension Plugin** - For email notifications
   - Search: `Email Extension`
   - Check the box

7. **Checkstyle Plugin** - For code quality
   - Search: `Checkstyle`
   - Check the box

8. **Warnings Next Generation Plugin** - For warnings
   - Search: `Warnings NG`
   - Check the box

9. **Maven Integration Plugin** - For Maven support
   - Search: `Maven Integration`
   - Check the box

10. **NodeJS Plugin** - For Node.js support
    - Search: `NodeJS`
    - Check the box

### Step 3: Install Plugins

1. Click **Install** button at the bottom
2. Check **Restart Jenkins when installation is complete and no jobs are running**
3. Wait for Jenkins to restart

---

## Part 2: Configure Global Tools

### Step 1: Access Global Tool Configuration

1. Go to **Manage Jenkins**
2. Click **Tools** or **Global Tool Configuration**

### Step 2: Configure JDK

1. Scroll to **JDK** section
2. Click **Add JDK**
3. Configure:
   ```
   Name: JDK-21
   ☐ Install automatically (uncheck this)
   JAVA_HOME: C:\Program Files\Java\jdk-21
   ```
   
   **Note**: Replace with your actual JDK path. To find it:
   ```powershell
   echo $env:JAVA_HOME
   # OR
   where java
   ```

### Step 3: Configure Maven

1. Scroll to **Maven** section
2. Click **Add Maven**
3. Configure:
   ```
   Name: Maven-3.9.11
   ☐ Install automatically (uncheck if already installed)
   MAVEN_HOME: C:\Program Files\Apache\maven
   ```
   
   **To find Maven path:**
   ```powershell
   mvn -version
   # Look for "Maven home:" line
   ```

   **OR check "Install automatically" and select version 3.9.11**

### Step 4: Configure Git

1. Scroll to **Git** section
2. Click **Add Git**
3. Configure:
   ```
   Name: Default
   Path to Git executable: C:\Program Files\Git\bin\git.exe
   ```
   
   **To find Git path:**
   ```powershell
   where git
   ```

### Step 5: Configure NodeJS

1. Scroll to **NodeJS** section
2. Click **Add NodeJS**
3. Configure:
   ```
   Name: NodeJS-20
   ☑ Install automatically (check this)
   Version: Select NodeJS 20.x from dropdown
   
   Global npm packages to install: npm@latest
   ```

### Step 6: Save Configuration

Click **Save** or **Apply** at the bottom of the page.

---

## Part 3: Add GitHub Credentials

### Step 1: Generate GitHub Personal Access Token

1. Go to GitHub: https://github.com/settings/tokens
2. Click **Generate new token** → **Generate new token (classic)**
3. Configure:
   ```
   Note: Jenkins Access Token for ProductManager
   Expiration: 90 days (or No expiration)
   
   Select scopes:
   ✅ repo (select all under repo)
      ✅ repo:status
      ✅ repo_deployment
      ✅ public_repo
      ✅ repo:invite
      ✅ security_events
   ✅ admin:repo_hook (select all)
      ✅ write:repo_hook
      ✅ read:repo_hook
   ```
4. Click **Generate token**
5. **COPY THE TOKEN** (you won't see it again!)

### Step 2: Add Credentials to Jenkins

1. In Jenkins, go to **Manage Jenkins**
2. Click **Credentials**
3. Click **(global)** domain
4. Click **Add Credentials** (left sidebar)
5. Configure:
   ```
   Kind: Username with password
   Scope: Global
   Username: Udit-jpg (your GitHub username)
   Password: <paste your GitHub token here>
   ID: github-credentials
   Description: GitHub Access Token for ProductManager
   ```
6. Click **Create**

---

## Part 4: Create Pipeline Job

### Step 1: Create New Item

1. Go to Jenkins Dashboard: `http://localhost:9090`
2. Click **New Item** (left sidebar)
3. Enter item name: `ProductManager-Pipeline`
4. Select **Pipeline**
5. Click **OK**

### Step 2: Configure General Settings

In the **General** section:

1. **Description**: 
   ```
   Product Manager Microservices - Automated build and test pipeline
   ```

2. **GitHub project** (check the box):
   ```
   Project url: https://github.com/Udit-jpg/ProductManager/
   ```

3. **Discard old builds** (optional but recommended):
   - Check the box
   - Strategy: Log Rotation
   - Days to keep builds: 7
   - Max # of builds to keep: 10

### Step 3: Configure Build Triggers

In the **Build Triggers** section:

Check these boxes:
- ✅ **GitHub hook trigger for GITScm polling**

This enables automatic builds when you push to GitHub.

### Step 4: Configure Pipeline

In the **Pipeline** section:

1. **Definition**: Select **Pipeline script from SCM**

2. **SCM**: Select **Git**

3. **Repository URL**: 
   ```
   https://github.com/Udit-jpg/ProductManager.git
   ```

4. **Credentials**: Select the credentials you created (`github-credentials`)

5. **Branches to build**:
   ```
   Branch Specifier: */main
   ```

6. **Repository browser**: (Auto)

7. **Script Path**:
   ```
   Jenkinsfile
   ```

8. **Lightweight checkout**: ☐ (leave unchecked)

### Step 5: Save the Job

Click **Save** at the bottom.

---

## Part 5: Test the Pipeline (First Build)

### Step 1: Manual Build

1. You should now be on the Pipeline project page
2. Click **Build Now** (left sidebar)
3. Watch the build progress in **Build History**
4. Click on the build number (e.g., #1)

### Step 2: Monitor Build

You'll see:
- **Console Output** - Real-time build logs
- **Build stages** - Visual progress of each stage
- **Status** - Success/Failure indication

### Step 3: View Build Output

Watch the console output. You should see:

```
========================================
Stage: Checkout Code from GitHub
========================================
Cloning repository...

========================================
Building User Service
========================================
[INFO] Building jar: .../User/demo/target/demo-0.0.1-SNAPSHOT.jar

========================================
Building Product Service
========================================
[INFO] Building jar: .../Product/demo/target/demo-0.0.1-SNAPSHOT.jar

... (and so on for all services)
```

### Step 4: Check for Errors

If the build fails:

1. Click **Console Output**
2. Look for error messages (usually in red)
3. Common issues:
   - **Maven not found**: Check Maven configuration in Tools
   - **JDK not found**: Check JDK configuration in Tools
   - **Git error**: Check credentials
   - **npm error**: Check NodeJS plugin installation

---

## Part 6: View Build Reports

After a successful build:

### Step 1: HTML Build Report

1. On the build page, look for **Build Report** in the left sidebar
2. Click it to see a beautiful HTML report with:
   - Build status
   - Service status
   - Test results
   - Docker images
   - Artifacts

### Step 2: Test Results

1. Click **Test Result** (left sidebar)
2. View JUnit test results for all services

### Step 3: Console Output

1. Click **Console Output**
2. See complete build logs

---

## Part 7: Set Up GitHub Webhook (Automatic Builds)

### Step 1: Make Jenkins Accessible

If Jenkins is on your local machine, you need to make it accessible from the internet.

#### Option A: Using ngrok (Recommended for testing)

```powershell
# Download ngrok from https://ngrok.com/download
# Install and authenticate

# Start ngrok
ngrok http 9090
```

You'll get a URL like: `https://abc123.ngrok.io`

#### Option B: Port Forwarding (If you have public IP)

Configure your router to forward port 9090 to your local machine.

### Step 2: Configure Webhook in GitHub

1. Go to your repository: https://github.com/Udit-jpg/ProductManager
2. Click **Settings**
3. Click **Webhooks** (left sidebar)
4. Click **Add webhook**
5. Configure:
   ```
   Payload URL: https://abc123.ngrok.io/github-webhook/
   (or http://your-public-ip:9090/github-webhook/)
   
   Content type: application/json
   
   Secret: (leave empty)
   
   Which events would you like to trigger this webhook?
   ○ Just the push event (selected)
   
   ✅ Active (checked)
   ```
6. Click **Add webhook**

### Step 3: Test Webhook

1. Make a small change to your repository:
   ```powershell
   cd "C:\Users\uudit\Downloads\Product Manager"
   echo "# Testing webhook" >> README.md
   git add README.md
   git commit -m "Test Jenkins webhook trigger"
   git push origin main
   ```

2. Go to Jenkins Dashboard
3. Watch for automatic build to start!
4. Check GitHub webhook deliveries:
   - GitHub → Settings → Webhooks → Click your webhook
   - Check **Recent Deliveries**
   - Should show green checkmark ✓

---

## Part 8: Configure Email Notifications (Optional)

### Step 1: Configure SMTP

1. Go to **Manage Jenkins** → **System**
2. Scroll to **Extended E-mail Notification**
3. Configure:
   ```
   SMTP server: smtp.gmail.com
   SMTP Port: 465
   
   ✅ Use SSL
   
   Credentials: Add new credentials
     Username: your-email@gmail.com
     Password: your-app-password (NOT your Gmail password!)
   
   Default Recipients: udit.upadhyay067@somaiya.edu
   ```

### Step 2: Generate Gmail App Password

1. Go to Google Account → Security
2. Enable 2-Step Verification (if not already)
3. Go to App Passwords
4. Select **Mail** and **Windows Computer**
5. Click **Generate**
6. Copy the 16-character password
7. Use this in Jenkins credentials

### Step 3: Test Email

In the Extended E-mail Notification section:
1. Click **Test configuration by sending test e-mail**
2. Enter your email
3. Click **Test configuration**
4. Check your inbox!

---

## Part 9: Understanding the Pipeline Stages

Your Jenkinsfile has these stages:

### 1. **Checkout** 
   - Clones code from GitHub
   - Gets commit info

### 2. **Build Services** (Parallel)
   - Compiles all 4 microservices
   - User, Product, Order, Payment

### 3. **Run Unit Tests** (Parallel)
   - Runs tests for all services
   - Generates JUnit reports

### 4. **Code Quality Analysis**
   - Runs Checkstyle
   - Checks code quality

### 5. **Package Services** (Parallel)
   - Creates JAR files
   - Archives artifacts

### 6. **Build Frontend**
   - npm install
   - npm run build
   - Creates production bundle

### 7. **Docker Build** (if main branch)
   - Builds Docker images
   - Tags with build number

### 8. **Generate Build Report**
   - Creates beautiful HTML report
   - Publishes to Jenkins

### 9. **Post Actions**
   - Sends email on success/failure
   - Archives artifacts
   - Cleans workspace

---

## Part 10: Troubleshooting Common Issues

### Issue 1: Build fails with "mvn: command not found"

**Solution:**
1. Go to **Manage Jenkins** → **Tools**
2. Check Maven configuration
3. Verify MAVEN_HOME path
4. OR enable "Install automatically"

### Issue 2: Build fails with "git: not found"

**Solution:**
1. Go to **Manage Jenkins** → **Tools**
2. Add Git installation
3. Path: `C:\Program Files\Git\bin\git.exe`

### Issue 3: "Permission denied" on Windows

**Solution:**
```powershell
# Run as Administrator
# OR change Jenkinsfile from 'sh' to 'bat' commands
```

### Issue 4: Node.js build fails

**Solution:**
1. Install NodeJS plugin
2. Go to **Manage Jenkins** → **Tools**
3. Configure NodeJS 20
4. Enable "Install automatically"

### Issue 5: Tests fail

**Solution:**
1. Check Console Output for error details
2. Verify H2 database is in test dependencies
3. Check application.properties

### Issue 6: Email not sending

**Solution:**
1. Use Gmail App Password, not account password
2. Enable "Less secure app access" (if needed)
3. Check SMTP settings
4. Test configuration in Jenkins

### Issue 7: Webhook not triggering

**Solution:**
1. Check ngrok is running: `ngrok http 9090`
2. Update webhook URL in GitHub
3. Check webhook delivery in GitHub
4. Ensure "GitHub hook trigger" is enabled in Jenkins job

---

## Part 11: Quick Reference Commands

### Start Jenkins (if not running as service)

```powershell
# Navigate to Jenkins directory
cd C:\Jenkins

# Start Jenkins
java -jar jenkins.war --httpPort=9090
```

### Check Build Manually

```powershell
# Navigate to project
cd "C:\Users\uudit\Downloads\Product Manager"

# Build User Service manually
cd User/demo
mvn clean package

# Build Product Service manually
cd ../../Product/demo
mvn clean package

# Build Frontend manually
cd ../../managerapp
npm install
npm run build
```

### Access Important URLs

```
Jenkins Dashboard:        http://localhost:9090
Pipeline Job:            http://localhost:9090/job/ProductManager-Pipeline/
Latest Build:            http://localhost:9090/job/ProductManager-Pipeline/lastBuild/
Build Report:            http://localhost:9090/job/ProductManager-Pipeline/lastBuild/Build_Report/
Test Results:            http://localhost:9090/job/ProductManager-Pipeline/lastBuild/testReport/
Console Output:          http://localhost:9090/job/ProductManager-Pipeline/lastBuild/console
```

---

## Part 12: Next Steps

After successful setup:

### 1. Customize the Pipeline

Edit `Jenkinsfile` to add:
- Integration tests
- Code coverage (Jacoco)
- SonarQube analysis
- Docker push to registry
- Deployment stages

### 2. Set Up Multi-Branch Pipeline

For feature branches:
1. Create new **Multibranch Pipeline** job
2. Configure GitHub source
3. Builds all branches automatically

### 3. Add More Notifications

- Slack integration
- Microsoft Teams
- Discord webhooks

### 4. Schedule Builds

In Build Triggers:
```
✅ Build periodically
Schedule: H 2 * * * (daily at 2 AM)
```

### 5. Parameterized Builds

Add parameters:
- Environment (dev/staging/prod)
- Version number
- Docker registry URL

---

## 🎉 Success Checklist

After following this guide, you should have:

- ✅ Jenkins running on port 9090
- ✅ All required plugins installed
- ✅ Global tools configured (JDK, Maven, Git, NodeJS)
- ✅ GitHub credentials added
- ✅ Pipeline job created and configured
- ✅ Successful first build
- ✅ HTML reports generated
- ✅ GitHub webhook configured (optional)
- ✅ Email notifications working (optional)

---

## 📞 Need Help?

If you encounter issues:

1. **Check Console Output** - Most errors are explained there
2. **Jenkins Logs** - `C:\Users\<username>\.jenkins\logs\`
3. **Plugin Issues** - Try updating plugins
4. **Restart Jenkins** - Sometimes fixes mysterious issues

---

## 🎯 What Happens on Every Commit

Once everything is set up:

```
1. You make code changes
   ↓
2. git commit && git push
   ↓
3. GitHub webhook triggers Jenkins
   ↓
4. Jenkins automatically:
   - Checks out latest code
   - Builds all 4 microservices
   - Runs all unit tests
   - Analyzes code quality
   - Packages JAR files
   - Builds React frontend
   - Creates Docker images
   - Generates HTML report
   ↓
5. You receive email notification
   ↓
6. You view beautiful HTML report
   ✓ All services: SUCCESS
   ✓ All tests: PASSED
   ✓ Build artifacts: READY
```

**No manual intervention needed!** 🚀

---

**Document Version**: 1.0  
**Last Updated**: November 5, 2025  
**Jenkins Port**: 9090  
**Author**: Development Team
