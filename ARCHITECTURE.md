# 🏗️ Product Manager - Architecture Overview

## 📊 System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         Frontend Layer                          │
│                   React Application (Port 3000)                 │
│         Components: Users | Products | Orders | Payments        │
└────────┬─────────┬─────────┬─────────┬──────────────────────────┘
         │         │         │         │
         │ HTTP    │ HTTP    │ HTTP    │ HTTP
         │ REST    │ REST    │ REST    │ REST
         │         │         │         │
    ┌────▼────┐┌──▼──────┐┌─▼────────┐┌▼─────────┐
    │  User   ││ Product ││  Order   ││ Payment  │
    │ Service ││ Service ││ Service  ││ Service  │
    │ :8081   ││ :8082   ││ :8083    ││ :8084    │
    └────┬────┘└──┬──────┘└─┬────────┘└┬─────────┘
         │         │         │          │
    ┌────▼────┐┌──▼──────┐┌─▼────────┐┌▼─────────┐
    │ H2 DB   ││ H2 DB   ││ H2 DB    ││ H2 DB    │
    │ userdb  ││productdb││ orderdb  ││paymentdb │
    └─────────┘└─────────┘└──────────┘└──────────┘
```

---

## 🔄 Data Flow Diagram

```
User Registration & Product Setup
──────────────────────────────────
1. User → Frontend → User Service → User DB
2. Admin → Frontend → Product Service → Product DB


Order Creation Flow
──────────────────────────────────
3. User selects product → Order Service
   ├─ Fetch User (User Service)
   ├─ Fetch Product (Product Service)
   └─ Create Order → Order DB


Payment Processing Flow
──────────────────────────────────
4. Order created → Payment Service
   ├─ Link to Order ID
   ├─ Process Payment
   └─ Update Status → Payment DB


Status Update Flow
──────────────────────────────────
5. Payment Success → Order Service
   └─ Update Order Status (CONFIRMED → SHIPPED → DELIVERED)
```

---

## 📁 Project Structure

```
Product Manager/
│
├── User/demo/
│   ├── src/main/java/com/example/demo/
│   │   ├── model/User.java
│   │   ├── repository/UserRepository.java
│   │   ├── service/UserService.java
│   │   ├── controller/UserController.java
│   │   ├── config/CorsConfig.java
│   │   └── UserApplication.java
│   └── src/main/resources/
│       └── application.properties (Port: 8081, DB: userdb)
│
├── Product/demo/
│   ├── src/main/java/com/example/demo/
│   │   ├── model/Product.java
│   │   ├── repository/ProductRepository.java
│   │   ├── service/ProductService.java
│   │   ├── controller/ProductController.java
│   │   ├── config/CorsConfig.java
│   │   └── ProductApplication.java
│   └── src/main/resources/
│       └── application.properties (Port: 8082, DB: productdb)
│
├── Order/demo/
│   ├── src/main/java/com/example/demo/
│   │   ├── model/Order.java
│   │   ├── repository/OrderRepository.java
│   │   ├── service/OrderService.java
│   │   ├── controller/OrderController.java
│   │   ├── config/CorsConfig.java
│   │   └── OrderApplication.java
│   └── src/main/resources/
│       └── application.properties (Port: 8083, DB: orderdb)
│
├── Payment/demo/
│   ├── src/main/java/com/example/demo/
│   │   ├── model/Payment.java
│   │   ├── repository/PaymentRepository.java
│   │   ├── service/PaymentService.java
│   │   ├── controller/PaymentController.java
│   │   ├── config/CorsConfig.java
│   │   └── PaymentApplication.java
│   └── src/main/resources/
│       └── application.properties (Port: 8084, DB: paymentdb)
│
├── managerapp/
│   ├── src/
│   │   ├── components/
│   │   │   ├── Users.js
│   │   │   ├── Products.js
│   │   │   ├── Orders.js
│   │   │   └── Payments.js
│   │   ├── App.js
│   │   ├── App.css
│   │   └── index.js
│   └── package.json
│
├── README.md
├── QUICKSTART.md
├── API_GUIDE.md
├── ARCHITECTURE.md (this file)
├── start-services.ps1
└── START-HERE.bat
```

---

## 🧩 Component Responsibilities

### User Service
- ✅ User registration
- ✅ User authentication (login)
- ✅ User profile management
- ✅ Role-based access (USER, ADMIN, MANAGER)

### Product Service
- ✅ Product CRUD operations
- ✅ Category management
- ✅ Stock tracking
- ✅ Product search functionality

### Order Service
- ✅ Order creation
- ✅ Order tracking
- ✅ Order status updates
- ✅ User order history
- ✅ Product order history

### Payment Service
- ✅ Payment creation
- ✅ Payment processing
- ✅ Payment status tracking
- ✅ Multiple payment modes
- ✅ Refund handling

---

## 🔐 API Endpoints Summary

| Service | Base URL | Key Endpoints |
|---------|----------|---------------|
| **User** | http://localhost:8081 | `/users/register`, `/users/login`, `/users`, `/users/{id}` |
| **Product** | http://localhost:8082 | `/products`, `/products/{id}`, `/products/category/{cat}` |
| **Order** | http://localhost:8083 | `/orders`, `/orders/{id}`, `/orders/user/{userId}` |
| **Payment** | http://localhost:8084 | `/payments`, `/payments/{id}`, `/payments/order/{orderId}` |

---

## 🗄️ Database Schema

### users (User Service)
```sql
CREATE TABLE users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL
);
```

### products (Product Service)
```sql
CREATE TABLE products (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    category VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL
);
```

### orders (Order Service)
```sql
CREATE TABLE orders (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    quantity INT NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    status VARCHAR(50) NOT NULL
);
```

### payments (Payment Service)
```sql
CREATE TABLE payments (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    order_id BIGINT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_mode VARCHAR(50) NOT NULL,
    payment_status VARCHAR(50) NOT NULL
);
```

---

## 🔄 Microservices Design Patterns Used

1. **Database per Service** - Each microservice has its own database
2. **API Gateway Pattern** - Frontend acts as API gateway
3. **Service Registry** - Each service runs independently
4. **RESTful Communication** - HTTP/REST for inter-service communication

---

## 🚀 Technology Stack

### Backend
- **Framework**: Spring Boot 3.5.7
- **Language**: Java 21
- **ORM**: Spring Data JPA
- **Database**: H2 (In-Memory)
- **Build Tool**: Maven
- **Server**: Embedded Tomcat

### Frontend
- **Library**: React 19
- **Language**: JavaScript
- **HTTP Client**: Fetch API
- **Styling**: CSS3
- **Build Tool**: npm

---

## 📈 Scalability Considerations

### Current Setup (Development)
- Single instance per service
- In-memory databases (H2)
- No load balancing
- No service discovery

### Production Enhancements
- Multiple service instances
- Persistent databases (MySQL/PostgreSQL)
- Load balancer (Nginx/HAProxy)
- Service discovery (Eureka/Consul)
- API Gateway (Spring Cloud Gateway)
- Message Queue (RabbitMQ/Kafka)
- Monitoring (Prometheus/Grafana)
- Containerization (Docker/Kubernetes)

---

## 🎯 Learning Outcomes

By building this project, you learn:

✅ Microservices architecture
✅ RESTful API design
✅ Spring Boot development
✅ React frontend development
✅ Database design
✅ Service independence
✅ CORS configuration
✅ State management
✅ Error handling
✅ API integration

---

## 🔮 Future Enhancements

- [ ] JWT Authentication
- [ ] Service-to-Service communication
- [ ] Centralized logging
- [ ] API documentation (Swagger)
- [ ] Unit & Integration tests
- [ ] Docker containerization
- [ ] CI/CD pipeline
- [ ] Message queues for async processing
- [ ] Caching layer (Redis)
- [ ] File upload for product images

---

**Built with ❤️ for learning microservices architecture**
