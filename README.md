# 🛍️ Product Manager - Microservices Project

A complete microservices architecture project with 4 backend services (Spring Boot) and a React frontend.

---

## 🚀 Quick Navigation

**New here?** Start with these guides:

| 📖 Guide | 🎯 Purpose | ⏱️ Time |
|---------|-----------|---------|
| **[🎯 GETTING_STARTED](GETTING_STARTED.md)** | **5-min quick start** ⭐⭐⭐ | 5 min |
| **[📍 INDEX](INDEX.md)** | Documentation navigation | 2 min |
| **[🎬 RUNNING_GUIDE](RUNNING_GUIDE.md)** | Step-by-step startup | 10 min |
| **[⚡ QUICKSTART](QUICKSTART.md)** | Fast setup & testing | 5 min |
| **[📡 API_GUIDE](API_GUIDE.md)** | Complete API reference | 15 min |
| **[🏗️ ARCHITECTURE](ARCHITECTURE.md)** | System design | 10 min |
| **[🔧 TROUBLESHOOTING](TROUBLESHOOTING.md)** | Problem solving | As needed |

**👉 First time? Start here:** [GETTING_STARTED.md](GETTING_STARTED.md)

---

## 📋 Project Structure

```
Product Manager/
├── User/          - User Service (Port 8081)
├── Product/       - Product Service (Port 8082)
├── Order/         - Order Service (Port 8083)
├── Payment/       - Payment Service (Port 8084)
└── managerapp/    - React Frontend (Port 3000)
```

## 🎯 Microservices Overview

| Microservice | Description | Port | Endpoints |
|-------------|-------------|------|-----------|
| **User Service** | User management & authentication | 8081 | `/users/register`, `/users/login`, `/users/{id}` |
| **Product Service** | Product CRUD operations | 8082 | `/products`, `/products/{id}` |
| **Order Service** | Order management | 8083 | `/orders`, `/orders/{id}` |
| **Payment Service** | Payment processing | 8084 | `/payments`, `/payments/status/{id}` |

## 📊 Database Schema

### User Service
```sql
users(id, name, email, password, role)
```

### Product Service
```sql
products(id, name, category, price, stock)
```

### Order Service
```sql
orders(id, user_id, product_id, quantity, total_price, status)
```

### Payment Service
```sql
payments(id, order_id, amount, payment_mode, payment_status)
```

## 🚀 How to Run

### Prerequisites
- Java 21 or higher
- Node.js 16+ and npm
- Maven
- Git Bash or PowerShell

### Step 1: Start All Microservices

Open **4 separate terminal windows** and run each service:

#### Terminal 1 - User Service
```powershell
cd "User\demo"
.\mvnw.cmd spring-boot:run
```

#### Terminal 2 - Product Service
```powershell
cd "Product\demo"
.\mvnw.cmd spring-boot:run
```

#### Terminal 3 - Order Service
```powershell
cd "Order\demo"
.\mvnw.cmd spring-boot:run
```

#### Terminal 4 - Payment Service
```powershell
cd "Payment\demo"
.\mvnw.cmd spring-boot:run
```

### Step 2: Start React Frontend

Open a **5th terminal window**:

```powershell
cd managerapp
npm install
npm start
```

The React app will open automatically at `http://localhost:3000`

## 🌐 API Endpoints

### User Service (Port 8081)
- `POST /users/register` - Register new user
- `POST /users/login` - User login
- `GET /users` - Get all users
- `GET /users/{id}` - Get user by ID
- `PUT /users/{id}` - Update user
- `DELETE /users/{id}` - Delete user

### Product Service (Port 8082)
- `POST /products` - Create product
- `GET /products` - Get all products
- `GET /products/{id}` - Get product by ID
- `PUT /products/{id}` - Update product
- `DELETE /products/{id}` - Delete product
- `PATCH /products/{id}/stock` - Update stock

### Order Service (Port 8083)
- `POST /orders` - Create order
- `GET /orders` - Get all orders
- `GET /orders/{id}` - Get order by ID
- `GET /orders/user/{userId}` - Get orders by user
- `PUT /orders/{id}` - Update order
- `PATCH /orders/{id}/status` - Update order status
- `DELETE /orders/{id}` - Delete order

### Payment Service (Port 8084)
- `POST /payments` - Create payment
- `GET /payments` - Get all payments
- `GET /payments/{id}` - Get payment by ID
- `GET /payments/order/{orderId}` - Get payment by order
- `GET /payments/status/{id}` - Get payment status
- `POST /payments/{id}/process` - Process payment
- `PATCH /payments/{id}/status` - Update payment status
- `DELETE /payments/{id}` - Delete payment

## 🗄️ Database Access

Each microservice uses H2 in-memory database. Access H2 Console:

- User Service: `http://localhost:8081/h2-console`
- Product Service: `http://localhost:8082/h2-console`
- Order Service: `http://localhost:8083/h2-console`
- Payment Service: `http://localhost:8084/h2-console`

**Connection Details:**
- JDBC URL: (varies per service - see application.properties)
- Username: `sa`
- Password: (leave empty)

## 🎨 Frontend Features

The React frontend provides:
- **User Management** - Register, view, edit, delete users
- **Product Management** - Add, view, edit, delete products
- **Order Management** - Create, track, update orders
- **Payment Management** - Process and track payments

## 📝 Sample Data Flow

1. **Register a User** in User Service
2. **Add Products** in Product Service
3. **Create Order** linking User ID and Product ID
4. **Create Payment** for the Order
5. **Process Payment** to complete transaction

## 🛠️ Technology Stack

### Backend
- Spring Boot 3.5.7
- Spring Data JPA
- H2 Database
- Maven
- Java 21

### Frontend
- React 19
- CSS3
- Fetch API for REST calls

## ⚙️ Configuration

Each microservice has its own `application.properties`:
- Different server ports (8081-8084)
- Separate H2 databases
- CORS enabled for React integration

## 📦 Build for Production

### Backend Services
```powershell
cd User\demo
.\mvnw.cmd clean package
# Repeat for each service
```

### Frontend
```powershell
cd managerapp
npm run build
```

## 🤝 Contributing

This is a mini project for learning microservices architecture.

## 📄 License

MIT License - Feel free to use for learning purposes!

## 🎓 Learning Objectives

- Microservices architecture
- RESTful API design
- Spring Boot backend development
- React frontend development
- Service-to-service communication
- Database per service pattern
- CRUD operations
- State management in React

---

**Happy Coding! 🚀**
