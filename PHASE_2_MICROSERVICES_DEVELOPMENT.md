# Phase 2: Development of Microservices

## Overview

This phase covers the complete implementation of four core microservices for the Product Manager system. Each microservice is independently deployable, maintains its own database, and exposes RESTful APIs for client applications.

---

## Implemented Microservices

### 1. User Service (Port 8081)

**Purpose**: Manages user registration, authentication, and role-based access control

#### Key Features:
- User registration with email validation
- User authentication (login/logout)
- Role-based access (USER, ADMIN, MANAGER)
- User profile management (CRUD operations)
- Password encryption support

#### Technology Stack:
- **Framework**: Spring Boot 3.4.3
- **Database**: H2 (in-memory) / MySQL (production)
- **ORM**: Spring Data JPA + Hibernate 6.6.8
- **Security**: Spring Security (planned for Phase 3)
- **API Documentation**: Swagger/OpenAPI

#### Database Schema:
```sql
CREATE TABLE users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL
);

CREATE UNIQUE INDEX idx_users_email ON users(email);
```

#### API Endpoints:

| Method | Endpoint | Description | Request Body | Response |
|--------|----------|-------------|--------------|----------|
| POST | `/users/register` | Register new user | User JSON | 201 Created |
| POST | `/users/login` | User login | {email, password} | 200 OK |
| GET | `/users` | Get all users | - | 200 OK |
| GET | `/users/{id}` | Get user by ID | - | 200 OK / 404 Not Found |
| PUT | `/users/{id}` | Update user | User JSON | 200 OK / 404 Not Found |
| DELETE | `/users/{id}` | Delete user | - | 200 OK / 404 Not Found |

#### Sample Request/Response:

**Register User (POST /users/register)**:
```json
Request:
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123",
  "role": "USER"
}

Response (201):
{
  "id": 1,
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123",
  "role": "USER"
}
```

**Login (POST /users/login)**:
```json
Request:
{
  "email": "john@example.com",
  "password": "password123"
}

Response (200):
{
  "id": 1,
  "name": "John Doe",
  "email": "john@example.com",
  "role": "USER"
}
```

#### Implementation Files:
- `UserApplication.java` - Main application class
- `User.java` - Entity model
- `UserRepository.java` - Data access layer
- `UserService.java` - Business logic layer
- `UserController.java` - REST API controller
- `CorsConfig.java` - CORS configuration

---

### 2. Product Service (Port 8082)

**Purpose**: Manages product catalog, inventory, and product information

#### Key Features:
- Product CRUD operations
- Category-based product filtering
- Product search functionality
- Stock/inventory management
- Price management

#### Technology Stack:
- **Framework**: Spring Boot 3.4.3
- **Database**: H2 (in-memory) / MySQL (production)
- **ORM**: Spring Data JPA + Hibernate 6.6.8
- **API Documentation**: Swagger/OpenAPI

#### Database Schema:
```sql
CREATE TABLE products (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    category VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL
);

CREATE INDEX idx_products_category ON products(category);
CREATE INDEX idx_products_name ON products(name);
```

#### API Endpoints:

| Method | Endpoint | Description | Request Body | Response |
|--------|----------|-------------|--------------|----------|
| POST | `/products` | Create product | Product JSON | 201 Created |
| GET | `/products` | Get all products | - | 200 OK |
| GET | `/products/{id}` | Get product by ID | - | 200 OK / 404 Not Found |
| GET | `/products/category/{category}` | Get by category | - | 200 OK |
| GET | `/products/search?name={name}` | Search products | - | 200 OK |
| PUT | `/products/{id}` | Update product | Product JSON | 200 OK / 404 Not Found |
| PATCH | `/products/{id}/stock?quantity={qty}` | Update stock | - | 200 OK / 404 Not Found |
| DELETE | `/products/{id}` | Delete product | - | 200 OK / 404 Not Found |

#### Sample Request/Response:

**Create Product (POST /products)**:
```json
Request:
{
  "name": "Laptop",
  "category": "Electronics",
  "price": 999.99,
  "stock": 50
}

Response (201):
{
  "id": 1,
  "name": "Laptop",
  "category": "Electronics",
  "price": 999.99,
  "stock": 50
}
```

**Get Products by Category (GET /products/category/Electronics)**:
```json
Response (200):
[
  {
    "id": 1,
    "name": "Laptop",
    "category": "Electronics",
    "price": 999.99,
    "stock": 50
  },
  {
    "id": 2,
    "name": "Phone",
    "category": "Electronics",
    "price": 599.99,
    "stock": 100
  }
]
```

#### Implementation Files:
- `ProductApplication.java` - Main application class
- `Product.java` - Entity model
- `ProductRepository.java` - Data access layer
- `ProductService.java` - Business logic layer
- `ProductController.java` - REST API controller
- `CorsConfig.java` - CORS configuration

---

### 3. Order Service (Port 8083)

**Purpose**: Handles order creation, tracking, and status management

#### Key Features:
- Order creation with user and product references
- Order status tracking and updates
- Order history for users
- Order cancellation
- Multi-status workflow

#### Technology Stack:
- **Framework**: Spring Boot 3.4.3
- **Database**: H2 (in-memory) / MySQL (production)
- **ORM**: Spring Data JPA + Hibernate 6.6.8
- **Inter-service Communication**: RestTemplate/WebClient (planned)
- **API Documentation**: Swagger/OpenAPI

#### Database Schema:
```sql
CREATE TABLE orders (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    quantity INT NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    status VARCHAR(50) NOT NULL
);

CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(status);
```

#### Order Status Flow:
```
PENDING → CONFIRMED → SHIPPED → DELIVERED
   ↓
CANCELLED
```

#### API Endpoints:

| Method | Endpoint | Description | Request Body | Response |
|--------|----------|-------------|--------------|----------|
| POST | `/orders` | Create order | Order JSON | 201 Created |
| GET | `/orders` | Get all orders | - | 200 OK |
| GET | `/orders/{id}` | Get order by ID | - | 200 OK / 404 Not Found |
| GET | `/orders/user/{userId}` | Get user orders | - | 200 OK |
| PUT | `/orders/{id}` | Update order | Order JSON | 200 OK / 404 Not Found |
| PATCH | `/orders/{id}/status?status={status}` | Update status | - | 200 OK / 404 Not Found |
| DELETE | `/orders/{id}` | Cancel order | - | 200 OK / 404 Not Found |

#### Sample Request/Response:

**Create Order (POST /orders)**:
```json
Request:
{
  "userId": 1,
  "productId": 1,
  "quantity": 2,
  "totalPrice": 1999.98,
  "status": "PENDING"
}

Response (201):
{
  "id": 1,
  "userId": 1,
  "productId": 1,
  "quantity": 2,
  "totalPrice": 1999.98,
  "status": "PENDING"
}
```

**Get User Orders (GET /orders/user/1)**:
```json
Response (200):
[
  {
    "id": 1,
    "userId": 1,
    "productId": 1,
    "quantity": 2,
    "totalPrice": 1999.98,
    "status": "CONFIRMED"
  },
  {
    "id": 2,
    "userId": 1,
    "productId": 2,
    "quantity": 1,
    "totalPrice": 599.99,
    "status": "DELIVERED"
  }
]
```

#### Implementation Files:
- `OrderApplication.java` - Main application class
- `Order.java` - Entity model
- `OrderRepository.java` - Data access layer
- `OrderService.java` - Business logic layer
- `OrderController.java` - REST API controller
- `CorsConfig.java` - CORS configuration

---

### 4. Payment Service (Port 8084)

**Purpose**: Manages payment transactions and payment status

#### Key Features:
- Payment creation for orders
- Multiple payment modes support
- Payment processing workflow
- Payment status tracking
- Refund support

#### Technology Stack:
- **Framework**: Spring Boot 3.4.3
- **Database**: H2 (in-memory) / MySQL (production)
- **ORM**: Spring Data JPA + Hibernate 6.6.8
- **Inter-service Communication**: RestTemplate/WebClient (planned)
- **API Documentation**: Swagger/OpenAPI

#### Database Schema:
```sql
CREATE TABLE payments (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    order_id BIGINT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_mode VARCHAR(50) NOT NULL,
    payment_status VARCHAR(50) NOT NULL
);

CREATE INDEX idx_payments_order_id ON payments(order_id);
CREATE INDEX idx_payments_status ON payments(payment_status);
```

#### Payment Modes:
- CREDIT_CARD
- DEBIT_CARD
- UPI
- NET_BANKING
- CASH

#### Payment Status Flow:
```
PENDING → SUCCESS
   ↓
FAILED → REFUNDED
```

#### API Endpoints:

| Method | Endpoint | Description | Request Body | Response |
|--------|----------|-------------|--------------|----------|
| POST | `/payments` | Create payment | Payment JSON | 201 Created |
| GET | `/payments` | Get all payments | - | 200 OK |
| GET | `/payments/{id}` | Get payment by ID | - | 200 OK / 404 Not Found |
| GET | `/payments/order/{orderId}` | Get order payment | - | 200 OK |
| PUT | `/payments/{id}` | Update payment | Payment JSON | 200 OK / 404 Not Found |
| PATCH | `/payments/{id}/process` | Process payment | - | 200 OK / 404 Not Found |
| DELETE | `/payments/{id}` | Delete payment | - | 200 OK / 404 Not Found |

#### Sample Request/Response:

**Create Payment (POST /payments)**:
```json
Request:
{
  "orderId": 1,
  "amount": 1999.98,
  "paymentMode": "CREDIT_CARD",
  "paymentStatus": "PENDING"
}

Response (201):
{
  "id": 1,
  "orderId": 1,
  "amount": 1999.98,
  "paymentMode": "CREDIT_CARD",
  "paymentStatus": "PENDING"
}
```

**Process Payment (PATCH /payments/1/process)**:
```json
Response (200):
{
  "id": 1,
  "orderId": 1,
  "amount": 1999.98,
  "paymentMode": "CREDIT_CARD",
  "paymentStatus": "SUCCESS"
}
```

#### Implementation Files:
- `PaymentApplication.java` - Main application class
- `Payment.java` - Entity model
- `PaymentRepository.java` - Data access layer
- `PaymentService.java` - Business logic layer
- `PaymentController.java` - REST API controller
- `CorsConfig.java` - CORS configuration

---

## Common Implementation Details

### 1. Database Configuration (Spring Data JPA)

All services use Spring Data JPA with Hibernate for database operations. H2 in-memory database is used for development, with MySQL/PostgreSQL support for production.

**application.properties (Example - User Service)**:
```properties
# Application Configuration
spring.application.name=user-service
server.port=8081

# H2 Database Configuration
spring.datasource.url=jdbc:h2:mem:userdb
spring.datasource.driverClassName=org.h2.Driver
spring.datasource.username=sa
spring.datasource.password=

# JPA Configuration
spring.jpa.database-platform=org.hibernate.dialect.H2Dialect
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true

# H2 Console
spring.h2.console.enabled=true
spring.h2.console.path=/h2-console
```

**MySQL Configuration (Production)**:
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/userdb
spring.datasource.driverClassName=com.mysql.cj.jdbc.Driver
spring.datasource.username=root
spring.datasource.password=yourpassword
spring.jpa.database-platform=org.hibernate.dialect.MySQLDialect
spring.jpa.hibernate.ddl-auto=validate
```

### 2. CORS Configuration

All services include CORS configuration to allow cross-origin requests from the React frontend.

**CorsConfig.java**:
```java
@Configuration
public class CorsConfig implements WebMvcConfigurer {
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOrigins("http://localhost:3000")
                .allowedMethods("GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS")
                .allowedHeaders("*")
                .allowCredentials(true);
    }
}
```

### 3. Error Handling

Each service implements proper error handling with appropriate HTTP status codes:

- **200 OK**: Successful GET/PUT/PATCH
- **201 Created**: Successful POST
- **400 Bad Request**: Invalid input data
- **404 Not Found**: Resource not found
- **500 Internal Server Error**: Server-side errors

### 4. Inter-Service Communication (Planned for Phase 3)

Currently, services are independent. In Phase 3, we will implement:

**RestTemplate Example** (Order Service calling User Service):
```java
@Service
public class OrderService {
    
    @Autowired
    private RestTemplate restTemplate;
    
    public User getUserById(Long userId) {
        String url = "http://localhost:8081/users/" + userId;
        return restTemplate.getForObject(url, User.class);
    }
}
```

**WebClient Example** (Reactive approach):
```java
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

---

## Swagger/OpenAPI Documentation (Optional for Phase 2)

### Configuration

Add Swagger dependencies to `pom.xml`:

```xml
<dependency>
    <groupId>org.springdoc</groupId>
    <artifactId>springdoc-openapi-starter-webmvc-ui</artifactId>
    <version>2.3.0</version>
</dependency>
```

### OpenAPI Configuration Class:

```java
@Configuration
public class OpenApiConfig {
    
    @Bean
    public OpenAPI userServiceAPI() {
        return new OpenAPI()
            .info(new Info()
                .title("User Service API")
                .description("User management microservice")
                .version("1.0.0")
                .contact(new Contact()
                    .name("Development Team")
                    .email("dev@productmanager.com")));
    }
}
```

### Accessing Swagger UI:

- User Service: http://localhost:8081/swagger-ui.html
- Product Service: http://localhost:8082/swagger-ui.html
- Order Service: http://localhost:8083/swagger-ui.html
- Payment Service: http://localhost:8084/swagger-ui.html

---

## Project Structure

```
Product Manager/
├── User/demo/
│   ├── src/main/java/com/example/demo/
│   │   ├── UserApplication.java
│   │   ├── model/User.java
│   │   ├── repository/UserRepository.java
│   │   ├── service/UserService.java
│   │   ├── controller/UserController.java
│   │   └── config/CorsConfig.java
│   ├── src/main/resources/
│   │   └── application.properties
│   └── pom.xml
│
├── Product/demo/
│   ├── src/main/java/com/example/demo/
│   │   ├── ProductApplication.java
│   │   ├── model/Product.java
│   │   ├── repository/ProductRepository.java
│   │   ├── service/ProductService.java
│   │   ├── controller/ProductController.java
│   │   └── config/CorsConfig.java
│   ├── src/main/resources/
│   │   └── application.properties
│   └── pom.xml
│
├── Order/demo/
│   ├── src/main/java/com/example/demo/
│   │   ├── OrderApplication.java
│   │   ├── model/Order.java
│   │   ├── repository/OrderRepository.java
│   │   ├── service/OrderService.java
│   │   ├── controller/OrderController.java
│   │   └── config/CorsConfig.java
│   ├── src/main/resources/
│   │   └── application.properties
│   └── pom.xml
│
└── Payment/demo/
    ├── src/main/java/com/example/demo/
    │   ├── PaymentApplication.java
    │   ├── model/Payment.java
    │   ├── repository/PaymentRepository.java
    │   ├── service/PaymentService.java
    │   ├── controller/PaymentController.java
    │   └── config/CorsConfig.java
    ├── src/main/resources/
    │   └── application.properties
    └── pom.xml
```

---

## Testing the Microservices

### 1. Start All Services

Use the provided batch script or manual commands:

```powershell
# User Service
cd User/demo
mvn spring-boot:run

# Product Service
cd Product/demo
mvn spring-boot:run

# Order Service
cd Order/demo
mvn spring-boot:run

# Payment Service
cd Payment/demo
mvn spring-boot:run
```

### 2. Test with cURL

**Register User**:
```bash
curl -X POST http://localhost:8081/users/register \
  -H "Content-Type: application/json" \
  -d '{"name":"John Doe","email":"john@example.com","password":"pass123","role":"USER"}'
```

**Create Product**:
```bash
curl -X POST http://localhost:8082/products \
  -H "Content-Type: application/json" \
  -d '{"name":"Laptop","category":"Electronics","price":999.99,"stock":50}'
```

**Create Order**:
```bash
curl -X POST http://localhost:8083/orders \
  -H "Content-Type: application/json" \
  -d '{"userId":1,"productId":1,"quantity":2,"totalPrice":1999.98,"status":"PENDING"}'
```

**Create Payment**:
```bash
curl -X POST http://localhost:8084/payments \
  -H "Content-Type: application/json" \
  -d '{"orderId":1,"amount":1999.98,"paymentMode":"CREDIT_CARD","paymentStatus":"PENDING"}'
```

### 3. Access H2 Console

For development and debugging:

- User DB: http://localhost:8081/h2-console
  - JDBC URL: `jdbc:h2:mem:userdb`
- Product DB: http://localhost:8082/h2-console
  - JDBC URL: `jdbc:h2:mem:productdb`
- Order DB: http://localhost:8083/h2-console
  - JDBC URL: `jdbc:h2:mem:orderdb`
- Payment DB: http://localhost:8084/h2-console
  - JDBC URL: `jdbc:h2:mem:paymentdb`

**Credentials**: Username=`sa`, Password=(empty)

---

## Best Practices Implemented

### 1. Layered Architecture
- **Controller Layer**: Handles HTTP requests/responses
- **Service Layer**: Contains business logic
- **Repository Layer**: Data access abstraction
- **Model Layer**: Domain entities

### 2. Dependency Injection
- Using Spring's `@Autowired` for loose coupling
- Constructor injection preferred over field injection

### 3. RESTful API Design
- Proper HTTP methods (GET, POST, PUT, PATCH, DELETE)
- Meaningful resource URIs
- Appropriate status codes
- JSON request/response format

### 4. Exception Handling
- Try-catch blocks for error scenarios
- Meaningful error messages
- Proper HTTP status codes

### 5. Database Per Service
- Each microservice has its own database
- No direct database sharing
- Cross-service data access via APIs

---

## Known Limitations (To be addressed in Phase 3)

1. **No Service Discovery**: Services use hardcoded URLs
2. **No API Gateway**: Direct client-to-service communication
3. **No Authentication**: API endpoints are open
4. **No Circuit Breaker**: No resilience patterns implemented
5. **No Centralized Logging**: Each service logs independently
6. **No Distributed Tracing**: Hard to trace requests across services

---

## Summary

Phase 2 successfully implements:

✅ **4 Core Microservices** (User, Product, Order, Payment)  
✅ **Spring Data JPA** for all database operations  
✅ **RESTful APIs** with proper HTTP methods and status codes  
✅ **H2 Database** for development (MySQL-ready for production)  
✅ **CORS Configuration** for frontend integration  
✅ **Layered Architecture** following best practices  
✅ **Independent Deployment** of each service  
✅ **Swagger Documentation** (optional, ready to enable)  

**Next Phase**: Implement Eureka Server, API Gateway, and inter-service communication.

---

**Document Version**: 1.0  
**Last Updated**: November 4, 2025  
**Author**: Development Team
