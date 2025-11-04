# How to Run All Services

## ✅ Fixed Issues
1. **Eureka dependency removed** - Services no longer try to connect to Eureka server
2. **CORS configuration fixed** - Removed conflicting `@CrossOrigin` annotations from controllers
3. **Java version aligned** - All services use Java 21

---

## 🚀 Option 1: Use the Batch Script (Easiest)

Double-click `START_ALL_SERVICES.bat` in the project root folder.

This will open 5 windows:
- User Service (port 8081)
- Product Service (port 8082)
- Order Service (port 8083)
- Payment Service (port 8084)
- React Frontend (port 3000)

Wait for each backend service to show **"Started *Application"** before using the UI.

---

## 🚀 Option 2: Manual PowerShell Commands

Open 5 separate PowerShell windows and run these commands:

### Window 1 - User Service
```powershell
$env:PATH = "C:\apache-maven-3.9.11-bin\apache-maven-3.9.11\bin;" + $env:PATH
cd "C:\Users\uudit\Downloads\Product Manager\User\demo"
mvn spring-boot:run
```
✅ Wait for: **"Started UserApplication"**

### Window 2 - Product Service
```powershell
$env:PATH = "C:\apache-maven-3.9.11-bin\apache-maven-3.9.11\bin;" + $env:PATH
cd "C:\Users\uudit\Downloads\Product Manager\Product\demo"
mvn spring-boot:run
```
✅ Wait for: **"Started ProductApplication"**

### Window 3 - Order Service
```powershell
$env:PATH = "C:\apache-maven-3.9.11-bin\apache-maven-3.9.11\bin;" + $env:PATH
cd "C:\Users\uudit\Downloads\Product Manager\Order\demo"
mvn spring-boot:run
```
✅ Wait for: **"Started OrderApplication"**

### Window 4 - Payment Service
```powershell
$env:PATH = "C:\apache-maven-3.9.11-bin\apache-maven-3.9.11\bin;" + $env:PATH
cd "C:\Users\uudit\Downloads\Product Manager\Payment\demo"
mvn spring-boot:run
```
✅ Wait for: **"Started PaymentApplication"**

### Window 5 - React Frontend
```powershell
cd "C:\Users\uudit\Downloads\Product Manager\managerapp"
npm start
```
✅ Browser opens automatically at http://localhost:3000

---

## 🧪 Verify Services are Running

Open a PowerShell window and run:

```powershell
# Check which ports are listening
netstat -ano | findstr ":808"

# Test User service
Invoke-RestMethod -Uri http://localhost:8081/users -Method GET

# Test Product service
Invoke-RestMethod -Uri http://localhost:8082/products -Method GET

# Test Order service
Invoke-RestMethod -Uri http://localhost:8083/orders -Method GET

# Test Payment service
Invoke-RestMethod -Uri http://localhost:8084/payments -Method GET
```

All should return `[]` (empty array) since there's no data yet.

---

## 📝 Testing the Application

1. Open http://localhost:3000 in your browser
2. Click on **Users** tab
3. Register a user:
   - Name: John Doe
   - Email: john@example.com
   - Password: password123
   - Role: USER
4. Click **Products** tab and add a product:
   - Name: Laptop
   - Category: Electronics
   - Price: 999.99
   - Stock: 50
5. Click **Orders** tab and create an order:
   - User ID: 1
   - Product ID: 1
   - Quantity: 2
   - Total Price: 1999.98
   - Status: PENDING
6. Click **Payments** tab and create a payment:
   - Order ID: 1
   - Amount: 1999.98
   - Payment Mode: CREDIT_CARD
   - Payment Status: PENDING
7. Click **Process** to change payment status to SUCCESS

---

## 🛑 Stopping Services

Press `Ctrl + C` in each terminal window, or close the windows.

To kill all Java processes at once:
```powershell
taskkill /F /IM java.exe
```

---

## 🔧 Troubleshooting

### Port Already in Use
```powershell
# Find process using port 8081
netstat -ano | findstr ":8081"

# Kill by PID (replace <PID> with the number from last column)
taskkill /PID <PID> /F
```

### Frontend Can't Connect to Backend
- Make sure all 4 backend services are running
- Check for "Started *Application" in each terminal
- Clear browser cache and refresh
- Check browser console for errors (F12)

### Maven Build Fails
```powershell
cd "C:\Users\uudit\Downloads\Product Manager\User\demo"
mvn clean install
```

---

## 📊 API Endpoints

All services are now accessible:

| Service | Port | Base URL | Endpoints |
|---------|------|----------|-----------|
| User | 8081 | http://localhost:8081 | `/users`, `/users/register`, `/users/login`, `/users/{id}` |
| Product | 8082 | http://localhost:8082 | `/products`, `/products/{id}`, `/products/category/{category}` |
| Order | 8083 | http://localhost:8083 | `/orders`, `/orders/{id}`, `/orders/user/{userId}` |
| Payment | 8084 | http://localhost:8084 | `/payments`, `/payments/{id}`, `/payments/order/{orderId}`, `/payments/{id}/process` |
| Frontend | 3000 | http://localhost:3000 | React UI |

---

## ✅ Summary of Fixes Applied

1. **Removed Eureka Server/Client dependencies** from all pom.xml files
2. **Removed Eureka properties** from User service application.properties
3. **Removed `@CrossOrigin(origins = "*")` annotations** from all controllers (CORS is now handled globally by CorsConfig)
4. **All services configured to allow CORS from `http://localhost:3000`**
5. **Java 21 compiler settings verified** in all pom.xml files

The application is now ready to run!
