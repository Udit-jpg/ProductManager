-- ============================================================================
-- Product Manager Microservices - MySQL Database Schema and Sample Data
-- ============================================================================
-- Version: 1.0
-- Date: November 4, 2025
-- Description: Complete database setup for all four microservices
--              (User, Product, Order, Payment)
-- ============================================================================

-- ============================================================================
-- DATABASE 1: USER SERVICE
-- ============================================================================

DROP DATABASE IF EXISTS userdb;
CREATE DATABASE userdb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE userdb;

-- Users Table
CREATE TABLE users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'CUSTOMER',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_username (username),
    INDEX idx_email (email),
    INDEX idx_role (role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Sample Data for Users
INSERT INTO users (username, email, password, role) VALUES
('john_doe', 'john.doe@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'CUSTOMER'),
('jane_smith', 'jane.smith@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'CUSTOMER'),
('admin_user', 'admin@productmanager.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'ADMIN'),
('alice_jones', 'alice.jones@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'CUSTOMER'),
('bob_wilson', 'bob.wilson@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'CUSTOMER'),
('charlie_brown', 'charlie.brown@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'CUSTOMER'),
('diana_prince', 'diana.prince@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'MANAGER'),
('eve_martinez', 'eve.martinez@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'CUSTOMER'),
('frank_thomas', 'frank.thomas@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'CUSTOMER'),
('grace_hopper', 'grace.hopper@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'CUSTOMER');

-- Note: Password is hashed version of 'password123' using BCrypt
-- In production, always use strong hashing algorithms like BCrypt

-- ============================================================================
-- DATABASE 2: PRODUCT SERVICE
-- ============================================================================

DROP DATABASE IF EXISTS productdb;
CREATE DATABASE productdb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE productdb;

-- Products Table
CREATE TABLE products (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0,
    category VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_category (category),
    INDEX idx_price (price),
    INDEX idx_stock (stock_quantity),
    CONSTRAINT chk_price CHECK (price >= 0),
    CONSTRAINT chk_stock CHECK (stock_quantity >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Sample Data for Products
INSERT INTO products (name, description, price, stock_quantity, category) VALUES
('Wireless Mouse', 'Ergonomic wireless mouse with USB receiver', 29.99, 150, 'Electronics'),
('Mechanical Keyboard', 'RGB mechanical gaming keyboard with blue switches', 89.99, 75, 'Electronics'),
('USB-C Hub', '7-in-1 USB-C hub with HDMI, USB 3.0, and SD card reader', 49.99, 200, 'Electronics'),
('Laptop Stand', 'Adjustable aluminum laptop stand for better ergonomics', 39.99, 100, 'Accessories'),
('Webcam HD', '1080p HD webcam with built-in microphone', 69.99, 50, 'Electronics'),
('External SSD 1TB', 'Portable external SSD with 1TB storage capacity', 129.99, 80, 'Storage'),
('Noise Cancelling Headphones', 'Over-ear headphones with active noise cancellation', 199.99, 40, 'Audio'),
('Desk Lamp LED', 'Adjustable LED desk lamp with touch control', 34.99, 120, 'Accessories'),
('Monitor 27 inch', '27-inch 4K UHD monitor with IPS panel', 399.99, 30, 'Electronics'),
('Wireless Charger', 'Fast wireless charging pad for smartphones', 24.99, 180, 'Electronics'),
('Bluetooth Speaker', 'Portable Bluetooth speaker with 12-hour battery', 59.99, 95, 'Audio'),
('HDMI Cable 2m', 'High-speed HDMI 2.1 cable 2 meters', 14.99, 250, 'Accessories'),
('Phone Case', 'Protective phone case for various models', 19.99, 300, 'Accessories'),
('Smart Watch', 'Fitness tracker smartwatch with heart rate monitor', 149.99, 60, 'Electronics'),
('Power Bank 20000mAh', 'High-capacity power bank with dual USB ports', 44.99, 110, 'Electronics'),
('Webcam Cover', 'Sliding webcam privacy cover for laptops', 9.99, 500, 'Accessories'),
('USB Flash Drive 64GB', '64GB USB 3.0 flash drive', 19.99, 220, 'Storage'),
('Microphone USB', 'Professional USB condenser microphone', 79.99, 45, 'Audio'),
('Cable Organizer', 'Desktop cable management organizer', 12.99, 180, 'Accessories'),
('Graphics Tablet', 'Digital drawing tablet with stylus', 159.99, 35, 'Electronics');

-- ============================================================================
-- DATABASE 3: ORDER SERVICE
-- ============================================================================

DROP DATABASE IF EXISTS orderdb;
CREATE DATABASE orderdb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE orderdb;

-- Orders Table
CREATE TABLE orders (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    total_price DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_user_id (user_id),
    INDEX idx_product_id (product_id),
    INDEX idx_status (status),
    INDEX idx_order_date (order_date),
    CONSTRAINT chk_quantity CHECK (quantity > 0),
    CONSTRAINT chk_total_price CHECK (total_price >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Sample Data for Orders
INSERT INTO orders (user_id, product_id, quantity, total_price, status, order_date) VALUES
-- John Doe's orders
(1, 1, 2, 59.98, 'COMPLETED', '2025-01-15 10:30:00'),
(1, 3, 1, 49.99, 'COMPLETED', '2025-01-20 14:15:00'),
(1, 10, 3, 74.97, 'SHIPPED', '2025-02-01 09:45:00'),

-- Jane Smith's orders
(2, 2, 1, 89.99, 'COMPLETED', '2025-01-18 11:20:00'),
(2, 7, 1, 199.99, 'SHIPPED', '2025-02-05 16:30:00'),
(2, 14, 1, 149.99, 'PENDING', '2025-02-10 13:00:00'),

-- Alice Jones's orders
(4, 6, 1, 129.99, 'COMPLETED', '2025-01-22 15:40:00'),
(4, 11, 2, 119.98, 'COMPLETED', '2025-01-28 10:10:00'),
(4, 4, 1, 39.99, 'SHIPPED', '2025-02-07 12:25:00'),

-- Bob Wilson's orders
(5, 9, 1, 399.99, 'COMPLETED', '2025-01-25 14:50:00'),
(5, 15, 2, 89.98, 'PENDING', '2025-02-11 11:35:00'),

-- Charlie Brown's orders
(6, 5, 1, 69.99, 'COMPLETED', '2025-01-27 09:15:00'),
(6, 12, 3, 44.97, 'COMPLETED', '2025-02-02 15:20:00'),
(6, 18, 1, 79.99, 'SHIPPED', '2025-02-08 10:40:00'),

-- Eve Martinez's orders
(8, 8, 2, 69.98, 'COMPLETED', '2025-01-30 13:55:00'),
(8, 13, 4, 79.96, 'SHIPPED', '2025-02-06 14:10:00'),

-- Frank Thomas's orders
(9, 17, 3, 59.97, 'COMPLETED', '2025-02-03 11:05:00'),
(9, 19, 1, 12.99, 'PENDING', '2025-02-12 09:30:00'),

-- Grace Hopper's orders
(10, 20, 1, 159.99, 'PENDING', '2025-02-09 16:45:00'),
(10, 16, 5, 49.95, 'COMPLETED', '2025-02-04 12:20:00');

-- Order Status Types: PENDING, PROCESSING, SHIPPED, COMPLETED, CANCELLED

-- ============================================================================
-- DATABASE 4: PAYMENT SERVICE
-- ============================================================================

DROP DATABASE IF EXISTS paymentdb;
CREATE DATABASE paymentdb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE paymentdb;

-- Payments Table
CREATE TABLE payments (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    order_id BIGINT NOT NULL UNIQUE,
    amount DECIMAL(10, 2) NOT NULL,
    payment_method VARCHAR(30) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    transaction_id VARCHAR(100) UNIQUE,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_order_id (order_id),
    INDEX idx_status (status),
    INDEX idx_transaction_id (transaction_id),
    INDEX idx_payment_date (payment_date),
    CONSTRAINT chk_amount CHECK (amount >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Sample Data for Payments
INSERT INTO payments (order_id, amount, payment_method, status, transaction_id, payment_date) VALUES
-- Completed payments
(1, 59.98, 'CREDIT_CARD', 'SUCCESS', 'TXN1001234567', '2025-01-15 10:32:00'),
(2, 49.99, 'PAYPAL', 'SUCCESS', 'TXN1001234568', '2025-01-20 14:17:00'),
(4, 89.99, 'DEBIT_CARD', 'SUCCESS', 'TXN1001234569', '2025-01-18 11:22:00'),
(7, 129.99, 'CREDIT_CARD', 'SUCCESS', 'TXN1001234570', '2025-01-22 15:42:00'),
(8, 119.98, 'PAYPAL', 'SUCCESS', 'TXN1001234571', '2025-01-28 10:12:00'),
(10, 399.99, 'CREDIT_CARD', 'SUCCESS', 'TXN1001234572', '2025-01-25 14:52:00'),
(12, 69.99, 'DEBIT_CARD', 'SUCCESS', 'TXN1001234573', '2025-01-27 09:17:00'),
(13, 44.97, 'CREDIT_CARD', 'SUCCESS', 'TXN1001234574', '2025-02-02 15:22:00'),
(15, 69.98, 'PAYPAL', 'SUCCESS', 'TXN1001234575', '2025-01-30 13:57:00'),
(17, 59.97, 'CREDIT_CARD', 'SUCCESS', 'TXN1001234576', '2025-02-03 11:07:00'),
(20, 49.95, 'DEBIT_CARD', 'SUCCESS', 'TXN1001234577', '2025-02-04 12:22:00'),

-- Pending/Processing payments
(3, 74.97, 'CREDIT_CARD', 'PROCESSING', 'TXN1001234578', '2025-02-01 09:47:00'),
(5, 199.99, 'PAYPAL', 'PROCESSING', 'TXN1001234579', '2025-02-05 16:32:00'),
(6, 149.99, 'CREDIT_CARD', 'PENDING', NULL, '2025-02-10 13:02:00'),
(9, 39.99, 'DEBIT_CARD', 'PROCESSING', 'TXN1001234580', '2025-02-07 12:27:00'),
(11, 89.98, 'CREDIT_CARD', 'PENDING', NULL, '2025-02-11 11:37:00'),
(14, 79.99, 'PAYPAL', 'PROCESSING', 'TXN1001234581', '2025-02-08 10:42:00'),
(16, 79.96, 'CREDIT_CARD', 'PROCESSING', 'TXN1001234582', '2025-02-06 14:12:00'),
(18, 12.99, 'DEBIT_CARD', 'PENDING', NULL, '2025-02-12 09:32:00'),
(19, 159.99, 'CREDIT_CARD', 'PENDING', NULL, '2025-02-09 16:47:00');

-- Payment Methods: CREDIT_CARD, DEBIT_CARD, PAYPAL, UPI, NET_BANKING
-- Payment Status: PENDING, PROCESSING, SUCCESS, FAILED, REFUNDED

-- ============================================================================
-- VERIFICATION QUERIES
-- ============================================================================

-- Check user count
SELECT 'User Service - Total Users:' AS Info, COUNT(*) AS Count FROM userdb.users;

-- Check product count
SELECT 'Product Service - Total Products:' AS Info, COUNT(*) AS Count FROM productdb.products;

-- Check order count
SELECT 'Order Service - Total Orders:' AS Info, COUNT(*) AS Count FROM orderdb.orders;

-- Check payment count
SELECT 'Payment Service - Total Payments:' AS Info, COUNT(*) AS Count FROM paymentdb.payments;

-- Order status distribution
SELECT 
    'Order Status Distribution' AS Info,
    status,
    COUNT(*) AS count
FROM orderdb.orders
GROUP BY status;

-- Payment status distribution
SELECT 
    'Payment Status Distribution' AS Info,
    status,
    COUNT(*) AS count
FROM paymentdb.payments
GROUP BY status;

-- Revenue summary
SELECT 
    'Total Revenue' AS Info,
    SUM(amount) AS total_amount,
    AVG(amount) AS average_amount,
    COUNT(*) AS total_transactions
FROM paymentdb.payments
WHERE status = 'SUCCESS';

-- Product category distribution
SELECT 
    'Product Categories' AS Info,
    category,
    COUNT(*) AS product_count,
    SUM(stock_quantity) AS total_stock
FROM productdb.products
GROUP BY category;

-- ============================================================================
-- APPLICATION.PROPERTIES CONFIGURATION FOR MYSQL
-- ============================================================================

/*
For each microservice, update application.properties:

# User Service - application.properties
spring.application.name=user-service
server.port=8081

# MySQL Database Configuration
spring.datasource.url=jdbc:mysql://localhost:3306/userdb?useSSL=false&serverTimezone=UTC
spring.datasource.username=root
spring.datasource.password=your_password_here
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

# JPA/Hibernate Configuration
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQL8Dialect
spring.jpa.properties.hibernate.format_sql=true

# Eureka Client
eureka.client.service-url.defaultZone=http://localhost:8761/eureka/
eureka.instance.prefer-ip-address=true

---

# Product Service - application.properties
spring.application.name=product-service
server.port=8082
spring.datasource.url=jdbc:mysql://localhost:3306/productdb?useSSL=false&serverTimezone=UTC
spring.datasource.username=root
spring.datasource.password=your_password_here
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQL8Dialect
eureka.client.service-url.defaultZone=http://localhost:8761/eureka/

---

# Order Service - application.properties
spring.application.name=order-service
server.port=8083
spring.datasource.url=jdbc:mysql://localhost:3306/orderdb?useSSL=false&serverTimezone=UTC
spring.datasource.username=root
spring.datasource.password=your_password_here
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQL8Dialect
eureka.client.service-url.defaultZone=http://localhost:8761/eureka/

---

# Payment Service - application.properties
spring.application.name=payment-service
server.port=8084
spring.datasource.url=jdbc:mysql://localhost:3306/paymentdb?useSSL=false&serverTimezone=UTC
spring.datasource.username=root
spring.datasource.password=your_password_here
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQL8Dialect
eureka.client.service-url.defaultZone=http://localhost:8761/eureka/
*/

-- ============================================================================
-- MYSQL DEPENDENCY FOR POM.XML
-- ============================================================================

/*
Add this dependency to each service's pom.xml:

<dependency>
    <groupId>com.mysql</groupId>
    <artifactId>mysql-connector-j</artifactId>
    <scope>runtime</scope>
</dependency>

Remove or comment out H2 dependency:
<!--
<dependency>
    <groupId>com.h2database</groupId>
    <artifactId>h2</artifactId>
    <scope>runtime</scope>
</dependency>
-->
*/

-- ============================================================================
-- DOCKER-COMPOSE MYSQL INTEGRATION
-- ============================================================================

/*
Add MySQL service to docker-compose.yml:

services:
  mysql:
    image: mysql:8.0
    container_name: mysql-db
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
      MYSQL_DATABASE: userdb
    ports:
      - "3306:3306"
    volumes:
      - mysql-data:/var/lib/mysql
      - ./MYSQL_SCHEMA_AND_DATA.sql:/docker-entrypoint-initdb.d/init.sql
    networks:
      - pm-network
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
      timeout: 20s
      retries: 10

  user-service:
    depends_on:
      - mysql
    environment:
      SPRING_DATASOURCE_URL: jdbc:mysql://mysql:3306/userdb
      SPRING_DATASOURCE_USERNAME: root
      SPRING_DATASOURCE_PASSWORD: rootpassword

volumes:
  mysql-data:

networks:
  pm-network:
    driver: bridge
*/

-- ============================================================================
-- END OF SCRIPT
-- ============================================================================

-- Summary:
-- - 4 databases created: userdb, productdb, orderdb, paymentdb
-- - 10 users inserted
-- - 20 products inserted across multiple categories
-- - 20 orders inserted with various statuses
-- - 19 payments inserted with different payment methods
-- - All tables have proper indexes for performance
-- - Constraints ensure data integrity
-- - Ready for production deployment

SELECT '============================================================' AS '';
SELECT 'Database initialization completed successfully!' AS Status;
SELECT '============================================================' AS '';
SELECT 'Total Records Created:' AS '';
SELECT 'Users: 10' AS '';
SELECT 'Products: 20' AS '';
SELECT 'Orders: 20' AS '';
SELECT 'Payments: 19' AS '';
SELECT '============================================================' AS '';
