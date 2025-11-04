# Phase 4: Deployment on Cloud with CI/CD Pipeline

## Overview

Phase 4 focuses on deploying the Product Manager microservices to the cloud with an automated CI/CD pipeline. This phase covers containerization, cloud deployment strategies, and continuous integration/deployment workflows.

---

## Part 1: Containerization with Docker

### Docker Implementation (Completed ✅)

All microservices and the frontend have been containerized using multi-stage Docker builds.

#### Dockerfile Locations:
- `User/demo/Dockerfile`
- `Product/demo/Dockerfile`
- `Order/demo/Dockerfile`
- `Payment/demo/Dockerfile`
- `managerapp/Dockerfile`

#### Docker Compose Configuration:
- `docker-compose.yml` (project root)

### Building and Running with Docker

#### 1. Build All Services

```powershell
# Build all images
docker-compose build

# Or build and run together
docker-compose up --build
```

#### 2. Run Services

```powershell
# Run in foreground
docker-compose up

# Run in background (detached)
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

#### 3. Access Services

| Service | URL | Description |
|---------|-----|-------------|
| Frontend | http://localhost:3000 | React UI (nginx) |
| User Service | http://localhost:8081 | User API |
| Product Service | http://localhost:8082 | Product API |
| Order Service | http://localhost:8083 | Order API |
| Payment Service | http://localhost:8084 | Payment API |

---

## Part 2: Cloud Deployment Options

### Option 1: AWS Deployment

#### Architecture on AWS:

```
┌─────────────────────────────────────────────────────────────┐
│                        AWS Cloud                             │
│                                                              │
│  ┌────────────────────────────────────────────────────┐     │
│  │              Application Load Balancer             │     │
│  │                  (Port 80/443)                     │     │
│  └──────────┬───────────┬──────────┬──────────────────┘     │
│             │           │          │                         │
│  ┌──────────▼────┐  ┌──▼──────┐  ┌▼─────────┐              │
│  │ ECS/EKS       │  │ ECS/EKS │  │ ECS/EKS  │              │
│  │ User Service  │  │ Product │  │ Order    │              │
│  │               │  │ Service │  │ Service  │              │
│  └───────────────┘  └─────────┘  └──────────┘              │
│                                                              │
│  ┌─────────────────────────────────────────────────────┐    │
│  │          Amazon RDS (MySQL/PostgreSQL)             │    │
│  │  - userdb   - productdb   - orderdb   - paymentdb │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                              │
│  ┌─────────────────────────────────────────────────────┐    │
│  │           Amazon ECR (Container Registry)          │    │
│  └─────────────────────────────────────────────────────┘    │
└──────────────────────────────────────────────────────────────┘
```

#### AWS Services Used:
- **ECS (Elastic Container Service)**: Deploy Docker containers
- **ECR (Elastic Container Registry)**: Store Docker images
- **RDS (Relational Database Service)**: Managed MySQL/PostgreSQL
- **ALB (Application Load Balancer)**: Traffic distribution
- **CloudWatch**: Logging and monitoring
- **S3**: Frontend static hosting
- **Route 53**: DNS management

#### Deployment Steps:

**1. Push Docker Images to ECR**

```bash
# Authenticate Docker to ECR
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <account-id>.dkr.ecr.us-east-1.amazonaws.com

# Tag images
docker tag user-service:latest <account-id>.dkr.ecr.us-east-1.amazonaws.com/user-service:latest
docker tag product-service:latest <account-id>.dkr.ecr.us-east-1.amazonaws.com/product-service:latest

# Push images
docker push <account-id>.dkr.ecr.us-east-1.amazonaws.com/user-service:latest
docker push <account-id>.dkr.ecr.us-east-1.amazonaws.com/product-service:latest
```

**2. Create ECS Task Definitions**

```json
{
  "family": "user-service",
  "containerDefinitions": [
    {
      "name": "user-service",
      "image": "<account-id>.dkr.ecr.us-east-1.amazonaws.com/user-service:latest",
      "portMappings": [
        {
          "containerPort": 8081,
          "protocol": "tcp"
        }
      ],
      "environment": [
        {
          "name": "SPRING_DATASOURCE_URL",
          "value": "jdbc:mysql://rds-endpoint:3306/userdb"
        }
      ]
    }
  ]
}
```

**3. Deploy to ECS**

```bash
aws ecs create-service \
  --cluster product-manager-cluster \
  --service-name user-service \
  --task-definition user-service:1 \
  --desired-count 2 \
  --load-balancer targetGroupArn=<target-group-arn>,containerName=user-service,containerPort=8081
```

---

### Option 2: Azure Deployment

#### Azure Services:
- **Azure Container Instances (ACI)**: Quick container deployment
- **Azure Kubernetes Service (AKS)**: Orchestrated containers
- **Azure Container Registry (ACR)**: Image storage
- **Azure Database for MySQL**: Managed database
- **Azure Application Gateway**: Load balancing
- **Azure DevOps**: CI/CD pipeline

#### Deployment Commands:

```bash
# Login to Azure
az login

# Create resource group
az group create --name product-manager-rg --location eastus

# Create ACR
az acr create --resource-group product-manager-rg --name productmanageracr --sku Basic

# Push images
az acr login --name productmanageracr
docker tag user-service productmanageracr.azurecr.io/user-service:latest
docker push productmanageracr.azurecr.io/user-service:latest

# Create AKS cluster
az aks create \
  --resource-group product-manager-rg \
  --name product-manager-aks \
  --node-count 3 \
  --attach-acr productmanageracr

# Deploy to AKS
kubectl apply -f k8s-deployment.yml
```

---

### Option 3: Google Cloud Platform (GCP)

#### GCP Services:
- **Google Kubernetes Engine (GKE)**: Container orchestration
- **Google Container Registry (GCR)**: Image storage
- **Cloud SQL**: Managed MySQL/PostgreSQL
- **Cloud Load Balancing**: Traffic distribution
- **Cloud Build**: CI/CD

---

### Option 4: Kubernetes Deployment (Platform Agnostic)

#### Kubernetes Manifests

**1. Deployment for User Service**

```yaml
# user-deployment.yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: user-service
spec:
  replicas: 3
  selector:
    matchLabels:
      app: user-service
  template:
    metadata:
      labels:
        app: user-service
    spec:
      containers:
      - name: user-service
        image: <registry>/user-service:latest
        ports:
        - containerPort: 8081
        env:
        - name: SPRING_DATASOURCE_URL
          value: jdbc:mysql://mysql-service:3306/userdb
        - name: SPRING_DATASOURCE_USERNAME
          valueFrom:
            secretKeyRef:
              name: db-secret
              key: username
        - name: SPRING_DATASOURCE_PASSWORD
          valueFrom:
            secretKeyRef:
              name: db-secret
              key: password
---
apiVersion: v1
kind: Service
metadata:
  name: user-service
spec:
  selector:
    app: user-service
  ports:
  - protocol: TCP
    port: 8081
    targetPort: 8081
  type: LoadBalancer
```

**2. ConfigMap for Database Configuration**

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: db-config
data:
  database-host: mysql-service
  database-port: "3306"
```

**3. Secret for Database Credentials**

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: db-secret
type: Opaque
data:
  username: cm9vdA==  # base64 encoded 'root'
  password: cGFzc3dvcmQ=  # base64 encoded 'password'
```

**4. Deploy to Kubernetes**

```bash
# Apply configurations
kubectl apply -f user-deployment.yml
kubectl apply -f product-deployment.yml
kubectl apply -f order-deployment.yml
kubectl apply -f payment-deployment.yml

# Check deployments
kubectl get deployments
kubectl get pods
kubectl get services

# Scale deployment
kubectl scale deployment user-service --replicas=5
```

---

## Part 3: CI/CD Pipeline Implementation

### GitHub Actions Workflow

Create `.github/workflows/ci-cd.yml`:

```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

env:
  REGISTRY: ghcr.io
  IMAGE_PREFIX: ${{ github.repository }}

jobs:
  build-and-test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        service: [User, Product, Order, Payment]
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v3
    
    - name: Set up JDK 21
      uses: actions/setup-java@v3
      with:
        java-version: '21'
        distribution: 'temurin'
        cache: maven
    
    - name: Build with Maven
      working-directory: ./${{ matrix.service }}/demo
      run: mvn clean package -DskipTests
    
    - name: Run tests
      working-directory: ./${{ matrix.service }}/demo
      run: mvn test
    
    - name: Upload artifact
      uses: actions/upload-artifact@v3
      with:
        name: ${{ matrix.service }}-service-jar
        path: ./${{ matrix.service }}/demo/target/*.jar

  build-frontend:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v3
    
    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '20'
        cache: 'npm'
        cache-dependency-path: ./managerapp/package-lock.json
    
    - name: Install dependencies
      working-directory: ./managerapp
      run: npm install
    
    - name: Build frontend
      working-directory: ./managerapp
      run: npm run build
    
    - name: Upload build
      uses: actions/upload-artifact@v3
      with:
        name: frontend-build
        path: ./managerapp/build

  docker-build-push:
    needs: [build-and-test, build-frontend]
    runs-on: ubuntu-latest
    if: github.event_name == 'push' && github.ref == 'refs/heads/main'
    strategy:
      matrix:
        service: [user, product, order, payment, frontend]
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v3
    
    - name: Log in to Container Registry
      uses: docker/login-action@v2
      with:
        registry: ${{ env.REGISTRY }}
        username: ${{ github.actor }}
        password: ${{ secrets.GITHUB_TOKEN }}
    
    - name: Extract metadata
      id: meta
      uses: docker/metadata-action@v4
      with:
        images: ${{ env.REGISTRY }}/${{ env.IMAGE_PREFIX }}/${{ matrix.service }}-service
        tags: |
          type=ref,event=branch
          type=sha,prefix={{branch}}-
          type=semver,pattern={{version}}
    
    - name: Build and push Docker image
      uses: docker/build-push-action@v4
      with:
        context: ./${{ matrix.service }}/demo
        push: true
        tags: ${{ steps.meta.outputs.tags }}
        labels: ${{ steps.meta.outputs.labels }}

  deploy:
    needs: docker-build-push
    runs-on: ubuntu-latest
    if: github.event_name == 'push' && github.ref == 'refs/heads/main'
    
    steps:
    - name: Deploy to Kubernetes
      uses: azure/k8s-deploy@v4
      with:
        manifests: |
          k8s/user-deployment.yml
          k8s/product-deployment.yml
          k8s/order-deployment.yml
          k8s/payment-deployment.yml
        images: |
          ${{ env.REGISTRY }}/${{ env.IMAGE_PREFIX }}/user-service:${{ github.sha }}
          ${{ env.REGISTRY }}/${{ env.IMAGE_PREFIX }}/product-service:${{ github.sha }}
        kubectl-version: 'latest'
```

---

### Jenkins Pipeline (Alternative)

Create `Jenkinsfile`:

```groovy
pipeline {
    agent any
    
    environment {
        DOCKER_REGISTRY = 'docker.io'
        IMAGE_PREFIX = 'productmanager'
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build Services') {
            parallel {
                stage('User Service') {
                    steps {
                        dir('User/demo') {
                            sh 'mvn clean package -DskipTests'
                        }
                    }
                }
                stage('Product Service') {
                    steps {
                        dir('Product/demo') {
                            sh 'mvn clean package -DskipTests'
                        }
                    }
                }
                stage('Order Service') {
                    steps {
                        dir('Order/demo') {
                            sh 'mvn clean package -DskipTests'
                        }
                    }
                }
                stage('Payment Service') {
                    steps {
                        dir('Payment/demo') {
                            sh 'mvn clean package -DskipTests'
                        }
                    }
                }
            }
        }
        
        stage('Run Tests') {
            parallel {
                stage('User Tests') {
                    steps {
                        dir('User/demo') {
                            sh 'mvn test'
                        }
                    }
                }
                stage('Product Tests') {
                    steps {
                        dir('Product/demo') {
                            sh 'mvn test'
                        }
                    }
                }
            }
        }
        
        stage('Docker Build') {
            steps {
                script {
                    docker.build("${DOCKER_REGISTRY}/${IMAGE_PREFIX}/user-service:${BUILD_NUMBER}", "User/demo")
                    docker.build("${DOCKER_REGISTRY}/${IMAGE_PREFIX}/product-service:${BUILD_NUMBER}", "Product/demo")
                }
            }
        }
        
        stage('Push to Registry') {
            steps {
                script {
                    docker.withRegistry("https://${DOCKER_REGISTRY}", 'docker-credentials') {
                        docker.image("${DOCKER_REGISTRY}/${IMAGE_PREFIX}/user-service:${BUILD_NUMBER}").push()
                        docker.image("${DOCKER_REGISTRY}/${IMAGE_PREFIX}/product-service:${BUILD_NUMBER}").push()
                    }
                }
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                kubernetesDeploy(
                    configs: 'k8s/*.yml',
                    kubeconfigId: 'k8s-config'
                )
            }
        }
    }
    
    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
```

---

## Part 4: Monitoring and Logging

### 1. Prometheus + Grafana (Metrics)

Add dependencies to pom.xml:

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
<dependency>
    <groupId>io.micrometer</groupId>
    <artifactId>micrometer-registry-prometheus</artifactId>
</dependency>
```

Enable metrics in application.properties:

```properties
management.endpoints.web.exposure.include=health,metrics,prometheus
management.metrics.export.prometheus.enabled=true
```

### 2. ELK Stack (Logging)

- **Elasticsearch**: Log storage
- **Logstash**: Log processing
- **Kibana**: Log visualization

Add Logback configuration:

```xml
<!-- logback-spring.xml -->
<configuration>
    <appender name="LOGSTASH" class="net.logstash.logback.appender.LogstashTcpSocketAppender">
        <destination>localhost:5000</destination>
        <encoder class="net.logstash.logback.encoder.LogstashEncoder"/>
    </appender>
    
    <root level="INFO">
        <appender-ref ref="LOGSTASH"/>
    </root>
</configuration>
```

---

## Part 5: Swagger/OpenAPI Documentation

### Add Swagger Dependencies

```xml
<dependency>
    <groupId>org.springdoc</groupId>
    <artifactId>springdoc-openapi-starter-webmvc-ui</artifactId>
    <version>2.3.0</version>
</dependency>
```

### Configure OpenAPI

```java
@Configuration
public class OpenApiConfig {
    
    @Bean
    public OpenAPI customOpenAPI() {
        return new OpenAPI()
            .info(new Info()
                .title("Product Manager API")
                .version("1.0")
                .description("Microservices for Product Management System")
                .contact(new Contact()
                    .name("Development Team")
                    .email("dev@productmanager.com")))
            .externalDocs(new ExternalDocumentation()
                .description("Full Documentation")
                .url("https://docs.productmanager.com"));
    }
}
```

### Access Swagger UI

- User Service: http://localhost:8081/swagger-ui.html
- Product Service: http://localhost:8082/swagger-ui.html
- Order Service: http://localhost:8083/swagger-ui.html
- Payment Service: http://localhost:8084/swagger-ui.html

---

## Summary

Phase 4 completes the Product Manager project by implementing:

✅ **Docker Containerization** of all microservices and frontend  
✅ **Docker Compose** for local multi-container orchestration  
✅ **Cloud Deployment Options** (AWS, Azure, GCP, Kubernetes)  
✅ **CI/CD Pipeline** using GitHub Actions/Jenkins  
✅ **Monitoring** with Prometheus and Grafana  
✅ **Centralized Logging** with ELK Stack  
✅ **API Documentation** with Swagger/OpenAPI  
✅ **Production-Ready** deployment configurations  

The system is now fully automated, scalable, and ready for production deployment on any cloud platform.

---

**Document Version**: 1.0  
**Last Updated**: November 4, 2025  
**Author**: Development Team
