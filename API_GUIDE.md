# API Testing Guide - Product Manager Microservices

## 📡 Complete API Reference

---

## 1️⃣ USER SERVICE (Port 8081)

### Register User
**POST** `http://localhost:8081/users/register`
```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123",
  "role": "USER"
}
```

### Login User
**POST** `http://localhost:8081/users/login`
```json
{
  "email": "john@example.com",
  "password": "password123"
}
```

### Get All Users
**GET** `http://localhost:8081/users`

### Get User by ID
**GET** `http://localhost:8081/users/1`

### Update User
**PUT** `http://localhost:8081/users/1`
```json
{
  "name": "John Updated",
  "email": "john@example.com",
  "password": "newpassword",
  "role": "ADMIN"
}
```

### Delete User
**DELETE** `http://localhost:8081/users/1`

---

## 2️⃣ PRODUCT SERVICE (Port 8082)

### Create Product
**POST** `http://localhost:8082/products`
```json
{
  "name": "Laptop",
  "category": "Electronics",
  "price": 999.99,
  "stock": 50
}
```

### Get All Products
**GET** `http://localhost:8082/products`

### Get Product by ID
**GET** `http://localhost:8082/products/1`

### Get Products by Category
**GET** `http://localhost:8082/products/category/Electronics`

### Search Products
**GET** `http://localhost:8082/products/search?name=laptop`

### Update Product
**PUT** `http://localhost:8082/products/1`
```json
{
  "name": "Gaming Laptop",
  "category": "Electronics",
  "price": 1299.99,
  "stock": 30
}
```

### Update Stock
**PATCH** `http://localhost:8082/products/1/stock?quantity=10`

### Delete Product
**DELETE** `http://localhost:8082/products/1`

---

## 3️⃣ ORDER SERVICE (Port 8083)

### Create Order
**POST** `http://localhost:8083/orders`
```json
{
  "userId": 1,
  "productId": 1,
  "quantity": 2,
  "totalPrice": 1999.98,
  "status": "PENDING"
}
```

### Get All Orders
**GET** `http://localhost:8083/orders`

### Get Order by ID
**GET** `http://localhost:8083/orders/1`

### Get Orders by User ID
**GET** `http://localhost:8083/orders/user/1`

### Get Orders by Status
**GET** `http://localhost:8083/orders/status/PENDING`

### Get Orders by Product ID
**GET** `http://localhost:8083/orders/product/1`

### Update Order
**PUT** `http://localhost:8083/orders/1`
```json
{
  "userId": 1,
  "productId": 1,
  "quantity": 3,
  "totalPrice": 2999.97,
  "status": "CONFIRMED"
}
```

### Update Order Status
**PATCH** `http://localhost:8083/orders/1/status`
```json
{
  "status": "SHIPPED"
}
```

### Delete Order
**DELETE** `http://localhost:8083/orders/1`

---

## 4️⃣ PAYMENT SERVICE (Port 8084)

### Create Payment
**POST** `http://localhost:8084/payments`
```json
{
  "orderId": 1,
  "amount": 1999.98,
  "paymentMode": "CREDIT_CARD",
  "paymentStatus": "PENDING"
}
```

### Get All Payments
**GET** `http://localhost:8084/payments`

### Get Payment by ID
**GET** `http://localhost:8084/payments/1`

### Get Payment by Order ID
**GET** `http://localhost:8084/payments/order/1`

### Get Payment Status
**GET** `http://localhost:8084/payments/status/1`

### Get Payments by Status
**GET** `http://localhost:8084/payments/status/filter/SUCCESS`

### Get Payments by Mode
**GET** `http://localhost:8084/payments/mode/CREDIT_CARD`

### Update Payment
**PUT** `http://localhost:8084/payments/1`
```json
{
  "orderId": 1,
  "amount": 2000.00,
  "paymentMode": "UPI",
  "paymentStatus": "SUCCESS"
}
```

### Update Payment Status
**PATCH** `http://localhost:8084/payments/1/status`
```json
{
  "status": "SUCCESS"
}
```

### Process Payment
**POST** `http://localhost:8084/payments/1/process`

### Delete Payment
**DELETE** `http://localhost:8084/payments/1`

---

## 📋 Sample Test Scenarios

### Scenario 1: Complete Order Flow

1. **Create User**
```bash
POST http://localhost:8081/users/register
{
  "name": "Alice Smith",
  "email": "alice@example.com",
  "password": "alice123",
  "role": "USER"
}
```

2. **Create Product**
```bash
POST http://localhost:8082/products
{
  "name": "iPhone 15",
  "category": "Electronics",
  "price": 899.99,
  "stock": 100
}
```

3. **Create Order**
```bash
POST http://localhost:8083/orders
{
  "userId": 1,
  "productId": 1,
  "quantity": 1,
  "totalPrice": 899.99,
  "status": "PENDING"
}
```

4. **Create Payment**
```bash
POST http://localhost:8084/payments
{
  "orderId": 1,
  "amount": 899.99,
  "paymentMode": "UPI",
  "paymentStatus": "PENDING"
}
```

5. **Process Payment**
```bash
POST http://localhost:8084/payments/1/process
```

6. **Update Order Status**
```bash
PATCH http://localhost:8083/orders/1/status
{
  "status": "CONFIRMED"
}
```

### Scenario 2: Bulk Product Management

1. **Add Multiple Products**
```bash
POST http://localhost:8082/products
{
  "name": "Samsung TV",
  "category": "Electronics",
  "price": 1299.99,
  "stock": 25
}

POST http://localhost:8082/products
{
  "name": "Nike Shoes",
  "category": "Sports",
  "price": 79.99,
  "stock": 150
}

POST http://localhost:8082/products
{
  "name": "Harry Potter Book",
  "category": "Books",
  "price": 19.99,
  "stock": 200
}
```

2. **Get Products by Category**
```bash
GET http://localhost:8082/products/category/Electronics
```

---

## 🔑 Enums & Valid Values

### User Roles
- `USER`
- `ADMIN`
- `MANAGER`

### Product Categories
- `Electronics`
- `Clothing`
- `Books`
- `Home`
- `Sports`
- `Toys`
- `Other`

### Order Status
- `PENDING`
- `CONFIRMED`
- `SHIPPED`
- `DELIVERED`
- `CANCELLED`

### Payment Modes
- `CREDIT_CARD`
- `DEBIT_CARD`
- `UPI`
- `NET_BANKING`
- `CASH`

### Payment Status
- `PENDING`
- `SUCCESS`
- `FAILED`
- `REFUNDED`

---

## 🧪 Using Postman

1. Import these endpoints into Postman
2. Create a Collection for each service
3. Set base URL variables:
   - `user_service`: http://localhost:8081
   - `product_service`: http://localhost:8082
   - `order_service`: http://localhost:8083
   - `payment_service`: http://localhost:8084

---

## 🐛 Testing Tips

1. **Start Services in Order**: User → Product → Order → Payment
2. **Wait for Startup**: Each service takes 20-30 seconds
3. **Check Console**: Look for "Started [Service]Application"
4. **Test Sequentially**: Create users and products before orders
5. **Use Valid IDs**: Reference existing User/Product IDs in orders
6. **Monitor Logs**: Watch terminal output for errors

---

**Happy API Testing! 🚀**
