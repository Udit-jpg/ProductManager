# 🎬 Step-by-Step Running Guide

## Visual Guide to Starting Your Microservices Project

---

## 📋 Prerequisites Checklist

Before starting, verify you have:

```
✅ Java 21 or higher installed
   Check: java -version

✅ Node.js 16+ and npm installed
   Check: node -v && npm -v

✅ Maven wrapper files present
   Check: Files mvnw and mvnw.cmd exist

✅ VS Code with 5 terminal windows ready
   Action: Terminal → New Terminal (5 times)
```

---

## 🚀 Step-by-Step Launch

### STEP 1: Prepare Your Workspace

```
Open VS Code
↓
Open the folder: "Product Manager"
↓
Open 5 new terminal windows
(Terminal → New Terminal - repeat 5 times)
```

---

### STEP 2: Terminal 1 - User Service (8081)

```powershell
# Navigate to User Service
cd User\demo

# Start the service
.\mvnw.cmd spring-boot:run

# ✅ Wait for this message:
# "Started UserApplication in X.XXX seconds"
```

**What you'll see:**
```
  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/

...
Started UserApplication in 15.234 seconds (JVM running for 16.123)
```

**Status:** ✅ User Service Running on Port 8081

---

### STEP 3: Terminal 2 - Product Service (8082)

```powershell
# Navigate to Product Service
cd Product\demo

# Start the service
.\mvnw.cmd spring-boot:run

# ✅ Wait for:
# "Started ProductApplication in X.XXX seconds"
```

**Status:** ✅ Product Service Running on Port 8082

---

### STEP 4: Terminal 3 - Order Service (8083)

```powershell
# Navigate to Order Service
cd Order\demo

# Start the service
.\mvnw.cmd spring-boot:run

# ✅ Wait for:
# "Started OrderApplication in X.XXX seconds"
```

**Status:** ✅ Order Service Running on Port 8083

---

### STEP 5: Terminal 4 - Payment Service (8084)

```powershell
# Navigate to Payment Service
cd Payment\demo

# Start the service
.\mvnw.cmd spring-boot:run

# ✅ Wait for:
# "Started PaymentApplication in X.XXX seconds"
```

**Status:** ✅ Payment Service Running on Port 8084

---

### STEP 6: Terminal 5 - React Frontend (3000)

```powershell
# Navigate to React app
cd managerapp

# Install dependencies (first time only)
npm install

# Start React development server
npm start

# ✅ Browser opens automatically
# http://localhost:3000
```

**What you'll see:**
```
Compiled successfully!

You can now view managerapp in the browser.

  Local:            http://localhost:3000
  On Your Network:  http://192.168.x.x:3000

Note that the development build is not optimized.
To create a production build, use npm run build.

webpack compiled successfully
```

**Status:** ✅ Frontend Running on Port 3000

---

## ✅ Verification Steps

### 1. Check All Services Are Running

Open a new terminal and test each:

```powershell
# Test User Service
curl http://localhost:8081/users

# Test Product Service
curl http://localhost:8082/products

# Test Order Service
curl http://localhost:8083/orders

# Test Payment Service
curl http://localhost:8084/payments
```

**Expected Result:** Each should return `[]` (empty array) or JSON data

---

### 2. Check Frontend

Open browser: http://localhost:3000

You should see:
```
┌─────────────────────────────────────────────┐
│   🛍️ Product Manager - Microservices        │
├─────────────────────────────────────────────┤
│  [👥 Users] [📦 Products] [🛒 Orders] [💳 Payments] │
└─────────────────────────────────────────────┘
```

---

## 🎯 Your First Test

### Create a Complete Flow:

**1. Create a User**
```
Click: 👥 Users tab
Fill form:
  Name: John Doe
  Email: john@example.com
  Password: pass123
  Role: USER
Click: Register User
```

**2. Add a Product**
```
Click: 📦 Products tab
Fill form:
  Product Name: Laptop
  Category: Electronics
  Price: 999.99
  Stock: 50
Click: Add Product
```

**3. Create an Order**
```
Click: 🛒 Orders tab
Fill form:
  User ID: 1
  Product ID: 1
  Quantity: 1
  Total Price: 999.99
  Status: PENDING
Click: Create Order
```

**4. Process Payment**
```
Click: 💳 Payments tab
Fill form:
  Order ID: 1
  Amount: 999.99
  Payment Mode: CREDIT_CARD
  Payment Status: PENDING
Click: Create Payment

Then click: Process button
Status changes to: SUCCESS ✅
```

---

## 📊 Terminal Window Layout

Organize your terminals like this:

```
┌─────────────┬─────────────┬─────────────┐
│  Terminal 1 │  Terminal 2 │  Terminal 3 │
│  User:8081  │ Product:8082│  Order:8083 │
│   Running   │   Running   │   Running   │
└─────────────┴─────────────┴─────────────┘
┌─────────────┬─────────────┬─────────────┐
│  Terminal 4 │  Terminal 5 │  Terminal 6 │
│Payment:8084 │ React:3000  │  (Testing)  │
│   Running   │   Running   │   Available │
└─────────────┴─────────────┴─────────────┘
```

---

## ⏱️ Typical Startup Times

| Service | Startup Time |
|---------|--------------|
| User Service | ~15-30 seconds |
| Product Service | ~15-30 seconds |
| Order Service | ~15-30 seconds |
| Payment Service | ~15-30 seconds |
| React Frontend | ~10-20 seconds |

**Total:** ~2-3 minutes for all services

---

## 🎨 What Success Looks Like

### Backend Services:
```
✅ Terminal 1: User Service - Port 8081 - RUNNING
✅ Terminal 2: Product Service - Port 8082 - RUNNING
✅ Terminal 3: Order Service - Port 8083 - RUNNING
✅ Terminal 4: Payment Service - Port 8084 - RUNNING
```

### Frontend:
```
✅ Terminal 5: React App - Port 3000 - RUNNING
✅ Browser: http://localhost:3000 - LOADED
```

### Visual Confirmation:
- All terminals show "Started [Service]Application"
- No red ERROR messages
- Browser displays the app
- All tabs (Users, Products, Orders, Payments) visible

---

## 🛑 How to Stop

When you're done:

```
1. In each terminal, press: Ctrl + C
2. Wait for service to stop
3. Repeat for all 5 terminals
4. Close browser tab
```

---

## 🔄 Restart a Service

If one service crashes:

```powershell
# In that terminal:
# 1. Press Ctrl + C (if needed)
# 2. Press Up Arrow (to recall last command)
# 3. Press Enter
# 4. Wait for "Started [Service]Application"
```

---

## 📸 Screenshot Reference

When everything is running, you should see:

**Frontend:**
- Beautiful gradient background (purple)
- Four navigation tabs
- Clean, modern interface
- Responsive tables

**Terminals:**
- Spring Boot ASCII art
- "Started [Service]Application" message
- No ERROR messages
- Log entries appearing

---

## 🎯 Quick Command Reference

```powershell
# User Service
cd User\demo && .\mvnw.cmd spring-boot:run

# Product Service
cd Product\demo && .\mvnw.cmd spring-boot:run

# Order Service
cd Order\demo && .\mvnw.cmd spring-boot:run

# Payment Service
cd Payment\demo && .\mvnw.cmd spring-boot:run

# Frontend
cd managerapp && npm start
```

---

## 💡 Pro Tips

1. **Start services in order** - User, Product, Order, Payment, then Frontend
2. **Wait between starts** - Give each 30 seconds before starting next
3. **Keep terminals visible** - Stack them so you can see all logs
4. **Watch for errors** - Red text = problem
5. **Green text** - Usually good news
6. **Don't close terminals** - Keep them open while testing

---

## ✅ Final Checklist

Before testing your app:

```
□ All 5 terminals open
□ All 4 backend services show "Started"
□ React says "Compiled successfully"
□ Browser opened to localhost:3000
□ No red ERROR messages in any terminal
□ All navigation tabs visible in browser
```

---

**You're Ready! Start Testing Your Microservices! 🎉**

For detailed API testing, see: API_GUIDE.md
For troubleshooting, see: TROUBLESHOOTING.md
