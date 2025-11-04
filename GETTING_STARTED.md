# 🎯 GETTING STARTED

## Welcome to Product Manager Microservices! 

This guide will get you up and running in **5 minutes**.

---

## ✅ What You'll Need

Before starting, make sure you have:

```
□ Java 21+ installed          → java -version
□ Node.js 16+ installed       → node -v
□ npm installed               → npm -v
□ VS Code or any IDE
□ 5 terminal windows ready
□ Internet connection (for npm install)
```

---

## 🚀 3-Step Quick Start

### STEP 1: Verify Prerequisites

```powershell
# Check Java
java -version
# Should show: openjdk version "21" or higher

# Check Node
node -v
# Should show: v16.x.x or higher

# Check npm
npm -v
# Should show: 8.x.x or higher
```

✅ All good? Continue to Step 2!
❌ Missing something? Install it first!

---

### STEP 2: Start Backend Services

Open **4 separate terminals** and run these commands:

#### Terminal 1 - User Service
```powershell
cd "User\demo"
.\mvnw.cmd spring-boot:run
```
⏳ Wait for: `Started UserApplication` ✅

#### Terminal 2 - Product Service
```powershell
cd "Product\demo"
.\mvnw.cmd spring-boot:run
```
⏳ Wait for: `Started ProductApplication` ✅

#### Terminal 3 - Order Service
```powershell
cd "Order\demo"
.\mvnw.cmd spring-boot:run
```
⏳ Wait for: `Started OrderApplication` ✅

#### Terminal 4 - Payment Service
```powershell
cd "Payment\demo"
.\mvnw.cmd spring-boot:run
```
⏳ Wait for: `Started PaymentApplication` ✅

---

### STEP 3: Start Frontend

Open a **5th terminal**:

```powershell
cd managerapp

# First time only - install dependencies
npm install

# Start the React app
npm start
```

⏳ Wait for browser to open automatically!
🌐 URL: http://localhost:3000

---

## 🎉 You're Running!

If you see this in your browser, you're all set:

```
┌────────────────────────────────────────┐
│  🛍️ Product Manager - Microservices    │
│  ┌──────┬──────┬──────┬──────┐        │
│  │Users │Products│Orders│Payments│     │
│  └──────┴──────┴──────┴──────┘        │
└────────────────────────────────────────┘
```

---

## ✨ Your First Test

Let's create your first complete transaction!

### 1️⃣ Create a User (10 seconds)

```
1. Click on "👥 Users" tab
2. Fill the form:
   - Name: Alice Smith
   - Email: alice@test.com
   - Password: alice123
   - Role: USER
3. Click "Register User"
```

✅ User appears in table with ID: 1

---

### 2️⃣ Add a Product (10 seconds)

```
1. Click on "📦 Products" tab
2. Fill the form:
   - Product Name: MacBook Pro
   - Category: Electronics
   - Price: 1299.99
   - Stock: 25
3. Click "Add Product"
```

✅ Product appears in table with ID: 1

---

### 3️⃣ Create an Order (10 seconds)

```
1. Click on "🛒 Orders" tab
2. Fill the form:
   - User ID: 1
   - Product ID: 1
   - Quantity: 1
   - Total Price: 1299.99
   - Status: PENDING
3. Click "Create Order"
```

✅ Order appears in table with ID: 1

---

### 4️⃣ Process Payment (10 seconds)

```
1. Click on "💳 Payments" tab
2. Fill the form:
   - Order ID: 1
   - Amount: 1299.99
   - Payment Mode: CREDIT_CARD
   - Payment Status: PENDING
3. Click "Create Payment"
4. Click "Process" button on the payment row
```

✅ Payment status changes to SUCCESS! 🎉

---

## 🎊 Congratulations!

You just:
- ✅ Started 4 microservices
- ✅ Launched a React frontend
- ✅ Created a user
- ✅ Added a product
- ✅ Placed an order
- ✅ Processed a payment

**Total time: ~5 minutes!**

---

## 🎓 What's Next?

Now that you're running, explore more:

### 📚 Learn the Architecture
→ Read: [ARCHITECTURE.md](ARCHITECTURE.md)

### 🔌 Test the APIs
→ Read: [API_GUIDE.md](API_GUIDE.md)

### 🔍 Understand the Code
→ Explore the source files:
- `User/demo/src/main/java/com/example/demo/`
- `Product/demo/src/main/java/com/example/demo/`
- `Order/demo/src/main/java/com/example/demo/`
- `Payment/demo/src/main/java/com/example/demo/`
- `managerapp/src/components/`

### 🧪 Advanced Testing
→ Try these features:
- Edit a user's role
- Update product stock
- Change order status
- Refund a payment
- Delete records

---

## 📡 Quick API Tests

Want to test APIs directly? Try these:

```powershell
# Get all users
curl http://localhost:8081/users

# Get all products
curl http://localhost:8082/products

# Get all orders
curl http://localhost:8083/orders

# Get all payments
curl http://localhost:8084/payments
```

---

## 🗄️ Access Databases

Each microservice has its own H2 database console:

| Service | URL | JDBC URL | Username | Password |
|---------|-----|----------|----------|----------|
| User | http://localhost:8081/h2-console | `jdbc:h2:mem:userdb` | `sa` | (empty) |
| Product | http://localhost:8082/h2-console | `jdbc:h2:mem:productdb` | `sa` | (empty) |
| Order | http://localhost:8083/h2-console | `jdbc:h2:mem:orderdb` | `sa` | (empty) |
| Payment | http://localhost:8084/h2-console | `jdbc:h2:mem:paymentdb` | `sa` | (empty) |

---

## 🛑 How to Stop

When you're done testing:

```
1. Press Ctrl + C in each terminal
2. Wait for services to stop
3. Close browser tab
4. Close terminals
```

That's it! Next time, just repeat the 3 steps above.

---

## ⚠️ Common First-Time Issues

### "Port already in use"
**Solution:** Something is already using the port.
```powershell
# Find what's using port 8081
netstat -ano | findstr :8081

# Kill the process
taskkill /PID <number> /F
```

### "npm install takes forever"
**Solution:** Normal on first run. Takes 2-5 minutes.
```powershell
# If it fails, try:
npm cache clean --force
npm install
```

### "Can't connect to backend"
**Solution:** Make sure all 4 backend services show "Started"
```powershell
# Test each one:
curl http://localhost:8081/users
curl http://localhost:8082/products
curl http://localhost:8083/orders
curl http://localhost:8084/payments
```

### Need more help?
→ Check: [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

---

## 💡 Pro Tips

1. **Start services in order** - Wait for each to fully start
2. **Keep terminals visible** - Arrange them so you can see all logs
3. **Watch for "Started"** - That's your success message
4. **Use the right IDs** - User ID 1, Product ID 1, etc.
5. **Clear browser cache** - If frontend looks weird, try Ctrl + F5

---

## 📊 Expected Behavior

### First Startup (takes longer):
```
User Service:     ~30-45 seconds (downloading dependencies)
Product Service:  ~30-45 seconds
Order Service:    ~30-45 seconds
Payment Service:  ~30-45 seconds
Frontend:         ~2-5 minutes (npm install)
```

### Subsequent Startups (faster):
```
Each Backend:     ~15-20 seconds
Frontend:         ~10-15 seconds
```

---

## 🎯 Success Checklist

After following this guide, you should have:

```
✅ 5 terminals open and running
✅ Browser showing the application
✅ Created at least one user
✅ Added at least one product
✅ Made at least one order
✅ Processed at least one payment
✅ Understand how to navigate the app
✅ Know how to stop the services
```

---

## 🚀 Ready for More?

### Full Documentation
[📖 README.md](README.md) - Complete project documentation

### Detailed Running Guide
[🎬 RUNNING_GUIDE.md](RUNNING_GUIDE.md) - Visual step-by-step

### API Reference
[📡 API_GUIDE.md](API_GUIDE.md) - All 34 endpoints documented

### Architecture
[🏗️ ARCHITECTURE.md](ARCHITECTURE.md) - System design

### All Documentation
[📍 INDEX.md](INDEX.md) - Complete documentation index

---

## 🎊 You Did It!

You're now running a complete microservices application with:
- 4 independent backend services
- 1 React frontend
- 4 separate databases
- 34 API endpoints
- Full CRUD operations

**Welcome to microservices development! 🎉**

---

**Questions? Issues? Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md)**

**Happy Coding! 🚀**
