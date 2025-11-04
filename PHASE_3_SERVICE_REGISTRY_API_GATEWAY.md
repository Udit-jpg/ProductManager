# Phase 3: Service Registry & API Gateway

## Overview

Phase 3 focuses on implementing service discovery, centralized routing, and configuration management to transform our microservices into a production-ready distributed system. This phase introduces Spring Cloud components to enhance scalability, resilience, and maintainability.

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                         Client (Browser/Mobile)                  │
└──────────────────────┬──────────────────────────────────────────┘
                       │
                       │ All Requests
                       ▼
┌──────────────────────────────────────────────────────────────────┐
│                        API Gateway (Port 8080)                    │
│  ┌────────────────────────────────────────────────────────────┐  │
│  │  - Request Routing                                         │  │
│  │  - Load Balancing                                          │  │
│  │  - Rate Limiting                                           │  │
│  │  - Authentication & Authorization                          │  │
│  │  - Error Handling                                          │  │
│  └────────────────────────────────────────────────────────────┘  │
└────────────┬─────────────────────────────────────────────────────┘
             │
             │ Service Discovery
             ▼
┌──────────────────────────────────────────────────────────────────┐
│                    Eureka Server (Port 8761)                      │
│  ┌────────────────────────────────────────────────────────────┐  │
│  │  Service Registry:                                         │  │
│  │  - user-service     → localhost:8081                       │  │
│  │  - product-service  → localhost:8082                       │  │
│  │  - order-service    → localhost:8083                       │  │
│  │  - payment-service  → localhost:8084                       │  │
│  └────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
             │
             │ Service Registration
             │
    ┌────────┴────────┬─────────┬─────────┐
    ▼                 ▼         ▼         ▼
┌─────────┐    ┌──────────┐  ┌───────┐  ┌─────────┐
│  User   │    │ Product  │  │ Order │  │ Payment │
│ Service │    │ Service  │  │Service│  │ Service │
│  :8081  │    │  :8082   │  │ :8083 │  │  :8084  │
└─────────┘    └──────────┘  └───────┘  └─────────┘
```

---

## Component 1: Eureka Server (Service Discovery)

### Purpose
Eureka Server acts as a service registry where all microservices register themselves. It enables:
- Dynamic service discovery
- Load balancing
- Health monitoring
- Automatic service deregistration on failure

### Implementation

#### 1. Create Eureka Server Project

**Directory Structure**:
```
EurekaServer/
├── src/
│   └── main/
│       ├── java/com/example/eureka/
│       │   └── EurekaServerApplication.java
│       └── resources/
│           └── application.properties
└── pom.xml
```

#### 2. pom.xml Configuration

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
         http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>3.4.3</version>
        <relativePath/>
    </parent>
    
    <groupId>com.example</groupId>
    <artifactId>eureka-server</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <name>Eureka Server</name>
    
    <properties>
        <java.version>21</java.version>
        <spring-cloud.version>2024.0.0</spring-cloud.version>
    </properties>
    
    <dependencies>
        <!-- Eureka Server -->
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-netflix-eureka-server</artifactId>
        </dependency>
    </dependencies>
    
    <dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-dependencies</artifactId>
                <version>${spring-cloud.version}</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
        </dependencies>
    </dependencyManagement>
    
    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>
</project>
```

#### 3. Main Application Class

```java
package com.example.eureka;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.eureka.server.EnableEurekaServer;

@SpringBootApplication
@EnableEurekaServer
public class EurekaServerApplication {
    
    public static void main(String[] args) {
        SpringApplication.run(EurekaServerApplication.class, args);
    }
}
```

#### 4. application.properties

```properties
# Application Configuration
spring.application.name=eureka-server
server.port=8761

# Eureka Server Configuration
eureka.client.register-with-eureka=false
eureka.client.fetch-registry=false
eureka.server.enable-self-preservation=false
eureka.server.eviction-interval-timer-in-ms=15000

# Dashboard Configuration
eureka.dashboard.enabled=true
```

#### 5. Starting Eureka Server

```powershell
cd EurekaServer
mvn spring-boot:run
```

Access Eureka Dashboard: http://localhost:8761

---

## Component 2: Eureka Clients (Microservices Registration)

### Configure Each Microservice as Eureka Client

#### 1. Add Eureka Client Dependency to pom.xml

For **User, Product, Order, and Payment services**, add:

```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
</dependency>
```

#### 2. Enable Eureka Client in Application Class

```java
@SpringBootApplication
@EnableDiscoveryClient  // Add this annotation
public class UserApplication {
    public static void main(String[] args) {
        SpringApplication.run(UserApplication.class, args);
    }
}
```

#### 3. Update application.properties

**User Service**:
```properties
spring.application.name=user-service
server.port=8081

# Eureka Client Configuration
eureka.client.service-url.defaultZone=http://localhost:8761/eureka/
eureka.instance.prefer-ip-address=true
eureka.instance.lease-renewal-interval-in-seconds=10
```

**Product Service**:
```properties
spring.application.name=product-service
server.port=8082
eureka.client.service-url.defaultZone=http://localhost:8761/eureka/
eureka.instance.prefer-ip-address=true
```

**Order Service**:
```properties
spring.application.name=order-service
server.port=8083
eureka.client.service-url.defaultZone=http://localhost:8761/eureka/
eureka.instance.prefer-ip-address=true
```

**Payment Service**:
```properties
spring.application.name=payment-service
server.port=8084
eureka.client.service-url.defaultZone=http://localhost:8761/eureka/
eureka.instance.prefer-ip-address=true
```

---

## Component 3: API Gateway (Central Entry Point)

### Purpose
API Gateway serves as the single entry point for all client requests, providing:
- Centralized routing
- Load balancing across service instances
- Authentication and authorization
- Rate limiting
- Request/response transformation
- Circuit breaking

### Implementation

#### 1. Create API Gateway Project

**Directory Structure**:
```
APIGateway/
├── src/
│   └── main/
│       ├── java/com/example/gateway/
│       │   ├── ApiGatewayApplication.java
│       │   ├── config/
│       │   │   └── GatewayConfig.java
│       │   └── filter/
│       │       └── AuthenticationFilter.java
│       └── resources/
│           └── application.yml
└── pom.xml
```

#### 2. pom.xml Configuration

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
         http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>3.4.3</version>
        <relativePath/>
    </parent>
    
    <groupId>com.example</groupId>
    <artifactId>api-gateway</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <name>API Gateway</name>
    
    <properties>
        <java.version>21</java.version>
        <spring-cloud.version>2024.0.0</spring-cloud.version>
    </properties>
    
    <dependencies>
        <!-- Spring Cloud Gateway -->
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-gateway</artifactId>
        </dependency>
        
        <!-- Eureka Client -->
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
        </dependency>
        
        <!-- Circuit Breaker -->
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-circuitbreaker-reactor-resilience4j</artifactId>
        </dependency>
    </dependencies>
    
    <dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-dependencies</artifactId>
                <version>${spring-cloud.version}</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
        </dependencies>
    </dependencyManagement>
    
    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>
</project>
```

#### 3. Main Application Class

```java
package com.example.gateway;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

@SpringBootApplication
@EnableDiscoveryClient
public class ApiGatewayApplication {
    
    public static void main(String[] args) {
        SpringApplication.run(ApiGatewayApplication.class, args);
    }
}
```

#### 4. Gateway Configuration (application.yml)

```yaml
spring:
  application:
    name: api-gateway
  cloud:
    gateway:
      discovery:
        locator:
          enabled: true
          lower-case-service-id: true
      routes:
        # User Service Routes
        - id: user-service
          uri: lb://user-service
          predicates:
            - Path=/users/**
          filters:
            - name: CircuitBreaker
              args:
                name: userServiceCircuitBreaker
                fallbackUri: forward:/fallback/users
            - name: RequestRateLimiter
              args:
                redis-rate-limiter.replenishRate: 10
                redis-rate-limiter.burstCapacity: 20
        
        # Product Service Routes
        - id: product-service
          uri: lb://product-service
          predicates:
            - Path=/products/**
          filters:
            - name: CircuitBreaker
              args:
                name: productServiceCircuitBreaker
                fallbackUri: forward:/fallback/products
        
        # Order Service Routes
        - id: order-service
          uri: lb://order-service
          predicates:
            - Path=/orders/**
          filters:
            - name: CircuitBreaker
              args:
                name: orderServiceCircuitBreaker
                fallbackUri: forward:/fallback/orders
        
        # Payment Service Routes
        - id: payment-service
          uri: lb://payment-service
          predicates:
            - Path=/payments/**
          filters:
            - name: CircuitBreaker
              args:
                name: paymentServiceCircuitBreaker
                fallbackUri: forward:/fallback/payments

server:
  port: 8080

eureka:
  client:
    service-url:
      defaultZone: http://localhost:8761/eureka/
    register-with-eureka: true
    fetch-registry: true
  instance:
    prefer-ip-address: true

# Resilience4j Circuit Breaker Configuration
resilience4j:
  circuitbreaker:
    instances:
      userServiceCircuitBreaker:
        slidingWindowSize: 10
        permittedNumberOfCallsInHalfOpenState: 5
        failureRateThreshold: 50
        waitDurationInOpenState: 10000
        registerHealthIndicator: true
      productServiceCircuitBreaker:
        slidingWindowSize: 10
        failureRateThreshold: 50
      orderServiceCircuitBreaker:
        slidingWindowSize: 10
        failureRateThreshold: 50
      paymentServiceCircuitBreaker:
        slidingWindowSize: 10
        failureRateThreshold: 50

# Logging
logging:
  level:
    org.springframework.cloud.gateway: DEBUG
    reactor.netty: INFO
```

#### 5. Fallback Controller (Error Handling)

```java
package com.example.gateway.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/fallback")
public class FallbackController {
    
    @GetMapping("/users")
    public ResponseEntity<Map<String, String>> userFallback() {
        Map<String, String> response = new HashMap<>();
        response.put("message", "User Service is currently unavailable. Please try again later.");
        response.put("status", "503");
        return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE).body(response);
    }
    
    @GetMapping("/products")
    public ResponseEntity<Map<String, String>> productFallback() {
        Map<String, String> response = new HashMap<>();
        response.put("message", "Product Service is currently unavailable. Please try again later.");
        response.put("status", "503");
        return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE).body(response);
    }
    
    @GetMapping("/orders")
    public ResponseEntity<Map<String, String>> orderFallback() {
        Map<String, String> response = new HashMap<>();
        response.put("message", "Order Service is currently unavailable. Please try again later.");
        response.put("status", "503");
        return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE).body(response);
    }
    
    @GetMapping("/payments")
    public ResponseEntity<Map<String, String>> paymentFallback() {
        Map<String, String> response = new HashMap<>();
        response.put("message", "Payment Service is currently unavailable. Please try again later.");
        response.put("status", "503");
        return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE).body(response);
    }
}
```

#### 6. Custom Authentication Filter (Optional)

```java
package com.example.gateway.filter;

import org.springframework.cloud.gateway.filter.GatewayFilter;
import org.springframework.cloud.gateway.filter.factory.AbstractGatewayFilterFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;

@Component
public class AuthenticationFilter extends AbstractGatewayFilterFactory<AuthenticationFilter.Config> {
    
    public AuthenticationFilter() {
        super(Config.class);
    }
    
    @Override
    public GatewayFilter apply(Config config) {
        return (exchange, chain) -> {
            // Check for Authorization header
            if (!exchange.getRequest().getHeaders().containsKey(HttpHeaders.AUTHORIZATION)) {
                // If public endpoint, allow
                if (isPublicEndpoint(exchange)) {
                    return chain.filter(exchange);
                }
                
                // Otherwise, return 401 Unauthorized
                exchange.getResponse().setStatusCode(HttpStatus.UNAUTHORIZED);
                return exchange.getResponse().setComplete();
            }
            
            // Validate token (implement your JWT validation here)
            String authHeader = exchange.getRequest().getHeaders().getFirst(HttpHeaders.AUTHORIZATION);
            
            // For demonstration, we'll just check if token starts with "Bearer "
            if (authHeader != null && authHeader.startsWith("Bearer ")) {
                return chain.filter(exchange);
            }
            
            exchange.getResponse().setStatusCode(HttpStatus.UNAUTHORIZED);
            return exchange.getResponse().setComplete();
        };
    }
    
    private boolean isPublicEndpoint(ServerWebExchange exchange) {
        String path = exchange.getRequest().getPath().toString();
        return path.contains("/login") || 
               path.contains("/register") || 
               path.contains("/h2-console");
    }
    
    public static class Config {
        // Configuration properties if needed
    }
}
```

---

## Component 4: Config Server (Centralized Configuration) - OPTIONAL

### Purpose
Spring Cloud Config Server provides centralized configuration management for all microservices from a Git repository.

### Implementation

#### 1. Create Config Server Project

#### 2. pom.xml Configuration

```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-config-server</artifactId>
</dependency>
```

#### 3. Main Application Class

```java
@SpringBootApplication
@EnableConfigServer
public class ConfigServerApplication {
    public static void main(String[] args) {
        SpringApplication.run(ConfigServerApplication.class, args);
    }
}
```

#### 4. application.properties

```properties
spring.application.name=config-server
server.port=8888

# Git Repository Configuration
spring.cloud.config.server.git.uri=https://github.com/your-org/config-repo
spring.cloud.config.server.git.clone-on-start=true
spring.cloud.config.server.git.default-label=main
```

#### 5. Config Repository Structure

```
config-repo/
├── user-service.properties
├── product-service.properties
├── order-service.properties
├── payment-service.properties
└── application.properties (common config)
```

---

## Inter-Service Communication Patterns

### 1. Using RestTemplate with Eureka

```java
@Configuration
public class RestTemplateConfig {
    
    @Bean
    @LoadBalanced  // Enable load balancing via Eureka
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }
}

@Service
public class OrderService {
    
    @Autowired
    private RestTemplate restTemplate;
    
    public User getUserById(Long userId) {
        // Use service name instead of hardcoded URL
        String url = "http://user-service/users/" + userId;
        return restTemplate.getForObject(url, User.class);
    }
    
    public Product getProductById(Long productId) {
        String url = "http://product-service/products/" + productId;
        return restTemplate.getForObject(url, Product.class);
    }
}
```

### 2. Using WebClient (Reactive Approach)

```java
@Configuration
public class WebClientConfig {
    
    @Bean
    @LoadBalanced
    public WebClient.Builder webClientBuilder() {
        return WebClient.builder();
    }
}

@Service
public class OrderService {
    
    @Autowired
    private WebClient.Builder webClientBuilder;
    
    public Mono<User> getUserById(Long userId) {
        return webClientBuilder.build()
            .get()
            .uri("http://user-service/users/{id}", userId)
            .retrieve()
            .bodyToMono(User.class);
    }
}
```

### 3. Using OpenFeign (Declarative Approach)

#### Add Dependency:
```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-openfeign</artifactId>
</dependency>
```

#### Enable Feign:
```java
@SpringBootApplication
@EnableFeignClients
public class OrderApplication {
    // ...
}
```

#### Create Feign Client:
```java
@FeignClient(name = "user-service")
public interface UserServiceClient {
    
    @GetMapping("/users/{id}")
    User getUserById(@PathVariable("id") Long id);
}

@FeignClient(name = "product-service")
public interface ProductServiceClient {
    
    @GetMapping("/products/{id}")
    Product getProductById(@PathVariable("id") Long id);
}
```

#### Use in Service:
```java
@Service
public class OrderService {
    
    @Autowired
    private UserServiceClient userServiceClient;
    
    @Autowired
    private ProductServiceClient productServiceClient;
    
    public Order createOrder(OrderRequest request) {
        User user = userServiceClient.getUserById(request.getUserId());
        Product product = productServiceClient.getProductById(request.getProductId());
        
        // Create order logic
        // ...
    }
}
```

---

## Deployment & Testing

### 1. Startup Sequence

```powershell
# Step 1: Start Eureka Server
cd EurekaServer
mvn spring-boot:run

# Wait for Eureka to start (http://localhost:8761)

# Step 2: Start all microservices
cd User/demo
mvn spring-boot:run

cd Product/demo
mvn spring-boot:run

cd Order/demo
mvn spring-boot:run

cd Payment/demo
mvn spring-boot:run

# Step 3: Start API Gateway
cd APIGateway
mvn spring-boot:run

# Step 4 (Optional): Start Config Server
cd ConfigServer
mvn spring-boot:run
```

### 2. Verify Registration

Open Eureka Dashboard: http://localhost:8761

You should see all services registered:
- USER-SERVICE
- PRODUCT-SERVICE
- ORDER-SERVICE
- PAYMENT-SERVICE
- API-GATEWAY

### 3. Test API Gateway Routing

All requests now go through the API Gateway (port 8080):

```bash
# Instead of http://localhost:8081/users
curl http://localhost:8080/users

# Instead of http://localhost:8082/products
curl http://localhost:8080/products

# Instead of http://localhost:8083/orders
curl http://localhost:8080/orders

# Instead of http://localhost:8084/payments
curl http://localhost:8080/payments
```

---

## Benefits Achieved

✅ **Service Discovery**: Automatic service registration and discovery  
✅ **Load Balancing**: Client-side load balancing via Ribbon  
✅ **Single Entry Point**: All requests routed through API Gateway  
✅ **Circuit Breaking**: Resilience4j prevents cascading failures  
✅ **Rate Limiting**: Controls request throughput  
✅ **Centralized Configuration**: Config Server manages all configurations  
✅ **Health Monitoring**: Eureka tracks service health  
✅ **Dynamic Scaling**: Services can scale horizontally  

---

## Summary

Phase 3 transforms the microservices architecture into a production-ready distributed system by implementing:

✅ **Eureka Server** for service discovery and registration  
✅ **API Gateway** for centralized routing and security  
✅ **Circuit Breaker** for fault tolerance  
✅ **Rate Limiting** for traffic control  
✅ **Config Server** for centralized configuration management (optional)  
✅ **Inter-Service Communication** using RestTemplate, WebClient, and Feign  

**Next Phase**: Cloud deployment with CI/CD pipeline.

---

**Document Version**: 1.0  
**Last Updated**: November 4, 2025  
**Author**: Development Team
