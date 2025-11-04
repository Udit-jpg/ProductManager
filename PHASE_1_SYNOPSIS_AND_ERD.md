# Phase 1: Synopsis & Entity-Relationship Diagram (ERD)

## Project Synopsis

### 1. Introduction to the Project

**Product Manager** is a comprehensive microservices-based e-commerce management system built using Spring Boot and React. The system follows a distributed architecture pattern where each business capability is developed as an independent microservice. This architecture enables scalability, maintainability, and independent deployment of services.

The application provides a complete product lifecycle management solution, from user registration to order fulfillment and payment processing. It demonstrates modern software engineering practices including containerization, cloud-native design, and RESTful API architecture.

---

### 2. Problem Statement

Traditional monolithic e-commerce applications face several challenges:

- **Scalability Issues**: Entire application must be scaled even when only specific features experience high load
- **Technology Lock-in**: Difficult to adopt new technologies for specific modules
- **Deployment Complexity**: Small changes require redeployment of the entire application
- **Single Point of Failure**: If one module fails, the entire application becomes unavailable
- **Team Coordination**: Large teams working on a single codebase leads to merge conflicts and coordination overhead

**Our Solution**: A microservices architecture that addresses these challenges by:
- Decomposing the application into independently deployable services
- Enabling horizontal scaling of individual services
- Supporting polyglot persistence and technology diversity
- Implementing fault isolation and resilience patterns
- Facilitating parallel development by multiple teams

---

### 3. Objectives

1. **Primary Objectives**:
   - Develop a fully functional e-commerce product management system using microservices architecture
   - Implement 4 core microservices (User, Product, Order, Payment)
   - Enable secure user authentication and role-based access control
   - Provide real-time order tracking and payment processing capabilities

2. **Technical Objectives**:
   - Demonstrate proficiency in Spring Boot microservices development
   - Implement RESTful APIs following OpenAPI standards
   - Configure service discovery using Eureka Server
   - Deploy API Gateway for centralized routing and security
   - Containerize services using Docker for cloud deployment
   - Implement CI/CD pipeline for automated testing and deployment

3. **Learning Objectives**:
   - Understand distributed systems design principles
   - Master inter-service communication patterns
   - Implement database per service pattern
   - Configure centralized configuration management
   - Deploy and manage microservices in cloud environments

---

### 4. Scope of the Project

#### In-Scope Features:

**User Management**:
- User registration and authentication
- Role-based access control (USER, ADMIN, MANAGER)
- User profile management (CRUD operations)
- Login/logout functionality

**Product Management**:
- Product catalog with categories
- Product CRUD operations
- Stock management and inventory tracking
- Product search and filtering by category

**Order Management**:
- Order creation with multiple line items
- Order status tracking (PENDING, CONFIRMED, SHIPPED, DELIVERED, CANCELLED)
- Order history for users
- Order-to-product relationship management

**Payment Processing**:
- Payment transaction creation
- Multiple payment modes (CREDIT_CARD, DEBIT_CARD, UPI, NET_BANKING, CASH)
- Payment status management (PENDING, SUCCESS, FAILED, REFUNDED)
- Payment processing workflow

**Technical Features**:
- RESTful API design for all services
- H2 in-memory database for development (MySQL/PostgreSQL for production)
- CORS configuration for frontend integration
- Docker containerization
- React-based web frontend
- Service discovery with Eureka
- API Gateway for request routing

#### Out-of-Scope (Future Enhancements):
- Email/SMS notifications
- Real-time chat support
- Advanced analytics and reporting
- Multi-language support
- Mobile application
- Third-party payment gateway integration
- Shipping provider integration
- Product reviews and ratings

---

### 5. Technologies Used

#### Backend Technologies:
| Technology | Version | Purpose |
|------------|---------|---------|
| **Java** | 21 | Primary programming language |
| **Spring Boot** | 3.4.3 | Microservices framework |
| **Spring Data JPA** | 3.4.3 | Database ORM and repository pattern |
| **Spring Cloud** | 2024.0.0 | Microservices infrastructure |
| **Spring Cloud Netflix Eureka** | 4.2.0 | Service discovery |
| **Spring Cloud Gateway** | 4.2.0 | API Gateway |
| **H2 Database** | 2.3.232 | In-memory database (development) |
| **MySQL** | 8.0+ | Production database |
| **Hibernate** | 6.6.8 | ORM implementation |
| **Maven** | 3.9.11 | Build automation tool |

#### Frontend Technologies:
| Technology | Version | Purpose |
|------------|---------|---------|
| **React** | 19.2.0 | UI framework |
| **JavaScript (ES6+)** | - | Programming language |
| **HTML5/CSS3** | - | Markup and styling |
| **Fetch API** | - | HTTP client for API calls |

#### DevOps & Infrastructure:
| Technology | Version | Purpose |
|------------|---------|---------|
| **Docker** | 24.0+ | Containerization |
| **Docker Compose** | 2.20+ | Multi-container orchestration |
| **Git** | 2.40+ | Version control |
| **GitHub Actions** | - | CI/CD pipeline |
| **Nginx** | 1.25+ | Frontend web server |

#### Development Tools:
- **IntelliJ IDEA / VS Code**: IDE
- **Postman**: API testing
- **Swagger/OpenAPI**: API documentation
- **H2 Console**: Database administration

---

### 6. Expected Outcome

#### Functional Outcomes:

1. **Working Microservices Application**:
   - 4 fully functional microservices (User, Product, Order, Payment)
   - Each service independently deployable and scalable
   - RESTful APIs for all CRUD operations
   - Proper error handling and validation

2. **Responsive Web Interface**:
   - User-friendly React frontend
   - Real-time data updates
   - Responsive design for mobile and desktop
   - Intuitive navigation and UX

3. **Service Discovery & Routing**:
   - Eureka Server successfully registering all services
   - API Gateway routing requests to appropriate services
   - Load balancing across service instances
   - Health monitoring and status checking

4. **Cloud Deployment**:
   - Dockerized microservices ready for cloud deployment
   - CI/CD pipeline for automated builds and deployments
   - Scalable infrastructure configuration
   - Environment-specific configurations

#### Technical Outcomes:

1. **Code Quality**:
   - Clean, maintainable, and well-documented code
   - Follows SOLID principles and design patterns
   - Comprehensive error handling
   - Input validation and security measures

2. **Database Design**:
   - Normalized database schema
   - Proper indexing for performance
   - Database per service pattern
   - Data consistency mechanisms

3. **API Documentation**:
   - Swagger/OpenAPI documentation for all endpoints
   - Clear request/response examples
   - Error code documentation
   - API versioning strategy

4. **Deployment Artifacts**:
   - Docker images for all services
   - docker-compose configuration
   - Kubernetes deployment files (optional)
   - Environment configuration files

#### Learning Outcomes:

Students/developers will gain hands-on experience with:
- Microservices architecture design and implementation
- Spring Boot ecosystem and best practices
- RESTful API design and development
- Service discovery and API Gateway patterns
- Containerization and orchestration
- CI/CD pipeline setup and management
- Cloud-native application development

---

## Entity-Relationship Diagram (ERD)

### Database Schema Overview

The Product Manager system uses a **Database per Service** pattern where each microservice maintains its own database. This ensures loose coupling and allows each service to evolve independently.

### 1. User Service Database Schema

#### Entity: `users`

| Column | Data Type | Constraints | Description |
|--------|-----------|-------------|-------------|
| `id` | BIGINT | PRIMARY KEY, AUTO_INCREMENT | Unique user identifier |
| `name` | VARCHAR(255) | NOT NULL | User's full name |
| `email` | VARCHAR(255) | NOT NULL, UNIQUE | User's email (login credential) |
| `password` | VARCHAR(255) | NOT NULL | Encrypted password |
| `role` | VARCHAR(50) | NOT NULL | User role (USER, ADMIN, MANAGER) |

**Indexes**:
- PRIMARY KEY on `id`
- UNIQUE INDEX on `email`

**Business Rules**:
- Email must be unique across all users
- Password should be hashed before storage
- Role determines access permissions

---

### 2. Product Service Database Schema

#### Entity: `products`

| Column | Data Type | Constraints | Description |
|--------|-----------|-------------|-------------|
| `id` | BIGINT | PRIMARY KEY, AUTO_INCREMENT | Unique product identifier |
| `name` | VARCHAR(255) | NOT NULL | Product name |
| `category` | VARCHAR(100) | NOT NULL | Product category |
| `price` | DECIMAL(10,2) | NOT NULL | Product price |
| `stock` | INT | NOT NULL | Available quantity |

**Indexes**:
- PRIMARY KEY on `id`
- INDEX on `category` (for category-based queries)
- INDEX on `name` (for search functionality)

**Business Rules**:
- Price must be greater than 0
- Stock cannot be negative
- Category standardization for filtering

---

### 3. Order Service Database Schema

#### Entity: `orders`

| Column | Data Type | Constraints | Description |
|--------|-----------|-------------|-------------|
| `id` | BIGINT | PRIMARY KEY, AUTO_INCREMENT | Unique order identifier |
| `user_id` | BIGINT | NOT NULL | Foreign key to User (logical) |
| `product_id` | BIGINT | NOT NULL | Foreign key to Product (logical) |
| `quantity` | INT | NOT NULL | Number of items ordered |
| `total_price` | DECIMAL(10,2) | NOT NULL | Total order amount |
| `status` | VARCHAR(50) | NOT NULL | Order status |

**Indexes**:
- PRIMARY KEY on `id`
- INDEX on `user_id` (for user order history)
- INDEX on `status` (for status-based filtering)

**Status Values**:
- `PENDING`: Order created, awaiting confirmation
- `CONFIRMED`: Order confirmed by system
- `SHIPPED`: Order dispatched
- `DELIVERED`: Order delivered to customer
- `CANCELLED`: Order cancelled

**Business Rules**:
- `user_id` references User service (loose coupling via API)
- `product_id` references Product service (loose coupling via API)
- `total_price` = `quantity` × product price
- Quantity must be greater than 0
- Status transitions follow predefined workflow

---

### 4. Payment Service Database Schema

#### Entity: `payments`

| Column | Data Type | Constraints | Description |
|--------|-----------|-------------|-------------|
| `id` | BIGINT | PRIMARY KEY, AUTO_INCREMENT | Unique payment identifier |
| `order_id` | BIGINT | NOT NULL | Foreign key to Order (logical) |
| `amount` | DECIMAL(10,2) | NOT NULL | Payment amount |
| `payment_mode` | VARCHAR(50) | NOT NULL | Payment method |
| `payment_status` | VARCHAR(50) | NOT NULL | Payment status |

**Indexes**:
- PRIMARY KEY on `id`
- INDEX on `order_id` (for order-payment lookup)
- INDEX on `payment_status` (for status tracking)

**Payment Modes**:
- `CREDIT_CARD`: Credit card payment
- `DEBIT_CARD`: Debit card payment
- `UPI`: Unified Payments Interface
- `NET_BANKING`: Internet banking
- `CASH`: Cash on delivery

**Payment Status Values**:
- `PENDING`: Payment initiated, awaiting processing
- `SUCCESS`: Payment successful
- `FAILED`: Payment failed
- `REFUNDED`: Payment refunded

**Business Rules**:
- `order_id` references Order service (loose coupling via API)
- Amount must match order total
- Payment mode determines processing logic
- Status transitions are immutable (append-only for audit)

---

### Entity Relationships (Cross-Service)

```
┌─────────────────┐
│   User Service  │
│   ┌─────────┐   │
│   │  users  │   │
│   └────┬────┘   │
└────────┼────────┘
         │ 1
         │
         │ *
┌────────▼────────┐
│  Order Service  │
│   ┌─────────┐   │
│   │ orders  │   │
│   └────┬────┘   │
└────────┼────────┘
         │ 1
         │
         │ 1
┌────────▼────────┐
│ Payment Service │
│  ┌──────────┐   │
│  │ payments │   │
│  └──────────┘   │
└─────────────────┘

         ┌─────────────────┐
         │ Product Service │
         │  ┌──────────┐   │
         │  │ products │   │
         │  └─────┬────┘   │
         └────────┼────────┘
                  │ 1
                  │
                  │ *
         ┌────────▼────────┐
         │  Order Service  │
         │   ┌─────────┐   │
         │   │ orders  │   │
         │   └─────────┘   │
         └─────────────────┘
```

**Relationship Description**:

1. **User → Order (1:N)**:
   - One user can place multiple orders
   - Implemented via `user_id` in orders table
   - Cross-service relationship (loose coupling)

2. **Product → Order (1:N)**:
   - One product can be in multiple orders
   - Implemented via `product_id` in orders table
   - Cross-service relationship (loose coupling)

3. **Order → Payment (1:1)**:
   - One order has one payment
   - Implemented via `order_id` in payments table
   - Cross-service relationship (loose coupling)

**Note**: In microservices architecture, we use **logical foreign keys** (stored as IDs) rather than database-level foreign key constraints. This maintains service independence while preserving data relationships through API communication.

---

### Database Normalization

All entities are in **Third Normal Form (3NF)**:

1. **First Normal Form (1NF)**:
   - ✅ All attributes contain atomic values (no multi-valued attributes)
   - ✅ Each column has a unique name
   - ✅ Each row is unique (primary key defined)

2. **Second Normal Form (2NF)**:
   - ✅ Meets 1NF requirements
   - ✅ No partial dependencies (all non-key attributes fully depend on primary key)
   - ✅ Each table represents a single entity

3. **Third Normal Form (3NF)**:
   - ✅ Meets 2NF requirements
   - ✅ No transitive dependencies
   - ✅ All non-key attributes depend only on the primary key

**Design Decisions**:
- Denormalization avoided to maintain data integrity
- Cross-service references use IDs only (no embedded objects)
- Each service owns its data exclusively
- No shared databases between services

---

### ERD Diagram (Visual Representation)

```
┌──────────────────────────────────────────────────────────────────┐
│                        USER SERVICE DB                            │
│  ┌────────────────────────────────────────────────────────────┐  │
│  │  Table: users                                              │  │
│  ├────────────────────────────────────────────────────────────┤  │
│  │  PK  id          : BIGINT                                  │  │
│  │      name        : VARCHAR(255)  NOT NULL                  │  │
│  │  UK  email       : VARCHAR(255)  NOT NULL, UNIQUE          │  │
│  │      password    : VARCHAR(255)  NOT NULL                  │  │
│  │      role        : VARCHAR(50)   NOT NULL                  │  │
│  └────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────┐
│                      PRODUCT SERVICE DB                           │
│  ┌────────────────────────────────────────────────────────────┐  │
│  │  Table: products                                           │  │
│  ├────────────────────────────────────────────────────────────┤  │
│  │  PK  id          : BIGINT                                  │  │
│  │      name        : VARCHAR(255)  NOT NULL                  │  │
│  │  IDX category    : VARCHAR(100)  NOT NULL                  │  │
│  │      price       : DECIMAL(10,2) NOT NULL                  │  │
│  │      stock       : INT           NOT NULL                  │  │
│  └────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────┐
│                       ORDER SERVICE DB                            │
│  ┌────────────────────────────────────────────────────────────┐  │
│  │  Table: orders                                             │  │
│  ├────────────────────────────────────────────────────────────┤  │
│  │  PK  id          : BIGINT                                  │  │
│  │  IDX user_id     : BIGINT        NOT NULL  (FK→User)       │  │
│  │      product_id  : BIGINT        NOT NULL  (FK→Product)    │  │
│  │      quantity    : INT           NOT NULL                  │  │
│  │      total_price : DECIMAL(10,2) NOT NULL                  │  │
│  │  IDX status      : VARCHAR(50)   NOT NULL                  │  │
│  └────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────┐
│                      PAYMENT SERVICE DB                           │
│  ┌────────────────────────────────────────────────────────────┐  │
│  │  Table: payments                                           │  │
│  ├────────────────────────────────────────────────────────────┤  │
│  │  PK  id             : BIGINT                               │  │
│  │  IDX order_id       : BIGINT        NOT NULL  (FK→Order)   │  │
│  │      amount         : DECIMAL(10,2) NOT NULL               │  │
│  │      payment_mode   : VARCHAR(50)   NOT NULL               │  │
│  │  IDX payment_status : VARCHAR(50)   NOT NULL               │  │
│  └────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

**Legend**:
- PK = Primary Key
- UK = Unique Key
- IDX = Indexed Column
- FK = Foreign Key (logical, not enforced at DB level)

---

## Summary

This phase establishes the foundation of the Product Manager microservices project by:

1. **Defining the problem** and proposing a microservices-based solution
2. **Setting clear objectives** for development and learning
3. **Identifying the scope** with well-defined in-scope and out-of-scope features
4. **Selecting appropriate technologies** for a modern, cloud-native application
5. **Designing a normalized database schema** following microservices best practices
6. **Creating an ERD** that shows entity relationships across services

The documentation provides a comprehensive blueprint for the development phase and ensures all stakeholders understand the project's goals, architecture, and expected outcomes.

---

**Document Version**: 1.0  
**Last Updated**: November 4, 2025  
**Author**: Development Team
