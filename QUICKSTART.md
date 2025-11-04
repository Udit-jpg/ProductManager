# 🚀 Quick Start Guide - Product Manager Microservices

## ⚡ Fast Setup (5 Minutes)

### Step 1: Open 5 Terminal Windows
You need 5 separate PowerShell/Terminal windows in VS Code.

### Step 2: Start Each Service

**Terminal 1 - User Service:**
```powershell
cd "c:\Users\uudit\Downloads\Product Manager\User\demo"
.\mvnw.cmd spring-boot:run
```
✅ Wait for: "Started UserApplication"

**Terminal 2 - Product Service:**
```powershell
cd "c:\Users\uudit\Downloads\Product Manager\Product\demo"
.\mvnw.cmd spring-boot:run
```
✅ Wait for: "Started ProductApplication"

**Terminal 3 - Order Service:**
```powershell
cd "c:\Users\uudit\Downloads\Product Manager\Order\demo"
.\mvnw.cmd spring-boot:run
```
✅ Wait for: "Started OrderApplication"

**Terminal 4 - Payment Service:**
```powershell
cd "c:\Users\uudit\Downloads\Product Manager\Payment\demo"
.\mvnw.cmd spring-boot:run
```
✅ Wait for: "Started PaymentApplication"

**Terminal 5 - React Frontend:**
```powershell
cd "c:\Users\uudit\Downloads\Product Manager\managerapp"
npm install
npm start
```
✅ Browser opens automatically at http://localhost:3000

---

## 🌐 Access Points

| Service | URL | Purpose |
|---------|-----|---------|
| **Frontend** | http://localhost:3000 | Main Application UI |
| **User API** | http://localhost:8081/users | User Management |
| **Product API** | http://localhost:8082/products | Product Management |
| **Order API** | http://localhost:8083/orders | Order Management |
| **Payment API** | http://localhost:8084/payments | Payment Processing |

---

## 📝 Testing the Application

### 1️⃣ Create a User
- Open http://localhost:3000
- Click on **👥 Users** tab
- Fill in the registration form:
  - Name: John Doe
  - Email: john@example.com
  - Password: password123
  - Role: USER
- Click **Register User**
- ✅ User appears in the table below

### 2️⃣ Add a Product
- Click on **📦 Products** tab
- Fill in the form:
  - Product Name: Laptop
  - Category: Electronics
  - Price: 999.99
  - Stock: 50
- Click **Add Product**
- ✅ Product appears in the table

### 3️⃣ Create an Order
- Click on **🛒 Orders** tab
- Fill in the form:
  - User ID: 1 (from step 1)
  - Product ID: 1 (from step 2)
  - Quantity: 2
  - Total Price: 1999.98
  - Status: PENDING
- Click **Create Order**
- ✅ Order appears in the table

### 4️⃣ Process Payment
- Click on **💳 Payments** tab
- Fill in the form:
  - Order ID: 1 (from step 3)
  - Amount: 1999.98
  - Payment Mode: CREDIT_CARD
  - Payment Status: PENDING
- Click **Create Payment**
- Click **Process** button on the payment
- ✅ Payment status changes to SUCCESS

---

## 🧪 API Testing with cURL

### Test User Service
```powershell
# Get all users
curl http://localhost:8081/users

# Register a user
curl -X POST http://localhost:8081/users/register -H "Content-Type: application/json" -d "{\"name\":\"Alice\",\"email\":\"alice@example.com\",\"password\":\"pass123\",\"role\":\"USER\"}"
```

### Test Product Service
```powershell
# Get all products
curl http://localhost:8082/products

# Add a product
curl -X POST http://localhost:8082/products -H "Content-Type: application/json" -d "{\"name\":\"Phone\",\"category\":\"Electronics\",\"price\":599.99,\"stock\":100}"
```

### Test Order Service
```powershell
# Get all orders
curl http://localhost:8083/orders

# Create an order
curl -X POST http://localhost:8083/orders -H "Content-Type: application/json" -d "{\"userId\":1,\"productId\":1,\"quantity\":1,\"totalPrice\":599.99,\"status\":\"PENDING\"}"
```

### Test Payment Service
```powershell
# Get all payments
curl http://localhost:8084/payments

# Create a payment
curl -X POST http://localhost:8084/payments -H "Content-Type: application/json" -d "{\"orderId\":1,\"amount\":599.99,\"paymentMode\":\"UPI\",\"paymentStatus\":\"PENDING\"}"
```

---

## 🗄️ Database Access (H2 Console)

Access the H2 database console for each service:

| Service | H2 Console URL | JDBC URL |
|---------|---------------|----------|
| User | http://localhost:8081/h2-console | `jdbc:h2:mem:userdb` |
| Product | http://localhost:8082/h2-console | `jdbc:h2:mem:productdb` |
| Order | http://localhost:8083/h2-console | `jdbc:h2:mem:orderdb` |
| Payment | http://localhost:8084/h2-console | `jdbc:h2:mem:paymentdb` |

**Login Credentials:**
- Username: `sa`
- Password: (leave empty)

---

## 🛑 Stopping Services

Press `Ctrl + C` in each terminal window to stop the services.

---

## ⚠️ Troubleshooting

### Port Already in Use
If you see "Port already in use" error:
```powershell
# Find and kill the process using the port
netstat -ano | findstr :<PORT>
taskkill /PID <PID> /F
```

### Frontend Can't Connect to Backend
- Ensure all 4 backend services are running
- Check that you see "Started [Service]Application" in each terminal
- Try clearing browser cache and refreshing

### Maven Build Fails
```powershell
# Clean and rebuild
.\mvnw.cmd clean install
```

### React Errors
```powershell
# Delete node_modules and reinstall
rm -r node_modules
npm install
```

---

## 📊 Sample Data Flow

```
1. User Registration (User Service)
   ↓
2. Add Products (Product Service)
   ↓
3. User Places Order (Order Service)
   ↓
4. Payment Processing (Payment Service)
   ↓
5. Order Status Updates (Order Service)
```

---

## 🎯 Features to Explore

- ✅ User registration and management
- ✅ Product CRUD operations
- ✅ Order creation and tracking
- ✅ Payment processing and status updates
- ✅ Real-time UI updates
- ✅ Different order statuses (PENDING, CONFIRMED, SHIPPED, DELIVERED)
- ✅ Multiple payment modes (Credit Card, UPI, etc.)
- ✅ Role-based users (USER, ADMIN, MANAGER)

---

**Happy Testing! 🎉**

For detailed API documentation, see the main README.md file.
