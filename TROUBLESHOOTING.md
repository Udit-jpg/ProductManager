# 🔧 Troubleshooting Guide

## Common Issues and Solutions

---

## 🚨 Service Won't Start

### Issue: "Port already in use"
```
***************************
APPLICATION FAILED TO START
***************************

Description:
Web server failed to start. Port 8081 was already in use.
```

**Solution:**
```powershell
# Find process using the port
netstat -ano | findstr :8081

# Kill the process (replace PID with actual process ID)
taskkill /PID <PID> /F

# Or change the port in application.properties
server.port=8085
```

---

## 🚨 Maven Build Issues

### Issue: "JAVA_HOME not set"
```
Error: JAVA_HOME not found in your environment.
```

**Solution:**
```powershell
# Set JAVA_HOME (replace with your Java path)
$env:JAVA_HOME = "C:\Program Files\Java\jdk-21"
$env:PATH = "$env:JAVA_HOME\bin;$env:PATH"

# Verify
java -version
```

### Issue: Maven wrapper not working
**Solution:**
```powershell
# Make mvnw executable
chmod +x mvnw

# Or use Maven directly if installed
mvn spring-boot:run
```

---

## 🚨 Database Issues

### Issue: "Table already exists"
**Solution:**
Change in `application.properties`:
```properties
# From
spring.jpa.hibernate.ddl-auto=create

# To
spring.jpa.hibernate.ddl-auto=update
```

### Issue: Can't access H2 Console
**Solution:**
1. Ensure service is running
2. Go to: http://localhost:8081/h2-console
3. Use correct JDBC URL: `jdbc:h2:mem:userdb`
4. Username: `sa`
5. Password: (leave empty)

---

## 🚨 Frontend Issues

### Issue: "npm install fails"
```
npm ERR! code ERESOLVE
```

**Solution:**
```powershell
# Delete node_modules and package-lock.json
Remove-Item -Recurse -Force node_modules
Remove-Item package-lock.json

# Clear npm cache
npm cache clean --force

# Reinstall
npm install --legacy-peer-deps
```

### Issue: Frontend can't connect to backend
```
Failed to fetch
TypeError: Failed to fetch
```

**Solutions:**
1. **Check if all backend services are running**
   ```powershell
   # Test each service
   curl http://localhost:8081/users
   curl http://localhost:8082/products
   curl http://localhost:8083/orders
   curl http://localhost:8084/payments
   ```

2. **Verify CORS configuration**
   - Check that CorsConfig.java exists in each service
   - Verify `allowedOrigins("http://localhost:3000")`

3. **Check browser console**
   - Press F12 → Console tab
   - Look for CORS errors

### Issue: "Module not found" errors
**Solution:**
```powershell
# Reinstall dependencies
npm install

# If still fails, check package.json has all dependencies
```

---

## 🚨 CORS Errors

### Issue: CORS policy blocking requests
```
Access to fetch at 'http://localhost:8081/users' from origin 
'http://localhost:3000' has been blocked by CORS policy
```

**Solution:**
1. Ensure CorsConfig.java exists in each service
2. Restart the affected service
3. Clear browser cache (Ctrl + F5)

**Alternative:** Add to Controller:
```java
@CrossOrigin(origins = "http://localhost:3000")
@RestController
```

---

## 🚨 React Issues

### Issue: "Invalid Hook Call"
**Solution:**
```powershell
# Delete node_modules and reinstall
Remove-Item -Recurse node_modules
npm install
```

### Issue: Blank page after npm start
**Solution:**
1. Check browser console (F12)
2. Check terminal for compilation errors
3. Verify all component imports in App.js
4. Try:
   ```powershell
   npm start -- --reset-cache
   ```

---

## 🚨 Network Issues

### Issue: Services can't communicate
**Checklist:**
- [ ] All services started successfully
- [ ] No port conflicts
- [ ] CORS configured correctly
- [ ] Correct URLs in React components
- [ ] Firewall not blocking ports

**Test connectivity:**
```powershell
# Test from PowerShell
curl http://localhost:8081/users
curl http://localhost:8082/products
curl http://localhost:8083/orders
curl http://localhost:8084/payments
```

---

## 🚨 Data Issues

### Issue: "Foreign key constraint violation"
**Note:** This project uses separate databases, so:
- User IDs in orders are NOT foreign keys
- Product IDs in orders are NOT foreign keys
- Order IDs in payments are NOT foreign keys

**Ensure:**
- Create users before creating orders
- Create products before creating orders
- Create orders before creating payments
- Use valid IDs when linking

---

## 🚨 Performance Issues

### Issue: Service starts very slowly
**Solutions:**
1. **Increase JVM memory:**
   ```powershell
   $env:MAVEN_OPTS = "-Xmx512m"
   .\mvnw.cmd spring-boot:run
   ```

2. **Skip tests:**
   ```powershell
   .\mvnw.cmd spring-boot:run -DskipTests
   ```

3. **Use compiled JAR:**
   ```powershell
   .\mvnw.cmd clean package -DskipTests
   java -jar target/demo-0.0.1-SNAPSHOT.jar
   ```

---

## 🚨 React Build Issues

### Issue: Build fails
**Solution:**
```powershell
# Clean build
npm run build -- --reset-cache

# Or with increased memory
$env:NODE_OPTIONS="--max-old-space-size=4096"
npm run build
```

---

## 🔍 Debugging Tips

### Check if service is running:
```powershell
# Windows
netstat -ano | findstr :<PORT>

# Example
netstat -ano | findstr :8081
```

### View service logs:
- Watch the terminal where service is running
- Look for "Started [Service]Application"
- Check for red ERROR messages

### Test API manually:
```powershell
# PowerShell
Invoke-RestMethod -Uri http://localhost:8081/users

# Or with curl
curl http://localhost:8081/users
```

### Check React dev tools:
1. Install React Developer Tools extension
2. Press F12 → React tab
3. Inspect component state

---

## 📊 Health Check Commands

```powershell
# Check Java version
java -version

# Check Node version
node -v
npm -v

# Check if ports are available
Test-NetConnection -ComputerName localhost -Port 8081
Test-NetConnection -ComputerName localhost -Port 8082
Test-NetConnection -ComputerName localhost -Port 8083
Test-NetConnection -ComputerName localhost -Port 8084
Test-NetConnection -ComputerName localhost -Port 3000
```

---

## 🆘 Still Having Issues?

### Restart Everything:
1. Stop all services (Ctrl + C in each terminal)
2. Close all terminals
3. Close VS Code
4. Reopen VS Code
5. Start services one by one
6. Wait for each to fully start before starting next

### Clean Start:
```powershell
# Backend - Clean all services
cd User\demo
.\mvnw.cmd clean
cd ..\..\Product\demo
.\mvnw.cmd clean
cd ..\..\Order\demo
.\mvnw.cmd clean
cd ..\..\Payment\demo
.\mvnw.cmd clean

# Frontend - Clean
cd ..\..\managerapp
Remove-Item -Recurse node_modules
Remove-Item package-lock.json
npm install
```

---

## 📝 Error Message Quick Reference

| Error Message | Likely Cause | Quick Fix |
|--------------|--------------|-----------|
| Port already in use | Service already running | Kill process or change port |
| CORS error | CORS not configured | Check CorsConfig.java |
| Failed to fetch | Backend not running | Start backend services |
| JPA error | Database issue | Check application.properties |
| npm ERR! | Dependency issue | Delete node_modules, reinstall |
| Module not found | Missing dependency | npm install |
| JAVA_HOME not found | Java not configured | Set JAVA_HOME |
| Connection refused | Service not started | Start the service |

---

## 🎯 Best Practices to Avoid Issues

1. **Start services in order**: User → Product → Order → Payment → Frontend
2. **Wait for full startup**: Look for "Started [Service]Application"
3. **One terminal per service**: Don't mix services in one terminal
4. **Keep terminals open**: Don't close running service terminals
5. **Check console regularly**: Watch for error messages
6. **Test endpoints**: Use curl to verify APIs before frontend
7. **Clear caches**: Browser cache and npm cache when needed
8. **Use correct IDs**: Reference existing IDs in foreign key fields

---

## 🔄 Complete Reset Procedure

If everything fails, complete reset:

```powershell
# 1. Stop ALL services (Ctrl + C in each terminal)

# 2. Clean backend
cd User\demo
.\mvnw.cmd clean install

cd ..\..\Product\demo
.\mvnw.cmd clean install

cd ..\..\Order\demo
.\mvnw.cmd clean install

cd ..\..\Payment\demo
.\mvnw.cmd clean install

# 3. Clean frontend
cd ..\..\managerapp
Remove-Item -Recurse -Force node_modules
Remove-Item -Force package-lock.json
npm cache clean --force
npm install

# 4. Restart VS Code

# 5. Start services fresh
```

---

**Need more help? Check:**
- README.md for general documentation
- API_GUIDE.md for API testing
- QUICKSTART.md for setup instructions

---

**Remember: Most issues are solved by restarting services! 🔄**
