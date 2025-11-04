@echo off
echo ======================================
echo Starting Product Manager Microservices
echo ======================================
echo.
echo This script will open 5 terminal windows:
echo   1. User Service (port 8081)
echo   2. Product Service (port 8082)
echo   3. Order Service (port 8083)
echo   4. Payment Service (port 8084)
echo   5. React Frontend (port 3000)
echo.
echo Wait for each service to show "Started *Application" before using the UI.
echo Press any key to continue...
pause > nul

REM Start User Service
start "User Service" cmd /k "cd /d "%~dp0User\demo" && set PATH=C:\apache-maven-3.9.11-bin\apache-maven-3.9.11\bin;%PATH% && mvn spring-boot:run"

REM Wait 3 seconds
timeout /t 3 /nobreak > nul

REM Start Product Service
start "Product Service" cmd /k "cd /d "%~dp0Product\demo" && set PATH=C:\apache-maven-3.9.11-bin\apache-maven-3.9.11\bin;%PATH% && mvn spring-boot:run"

REM Wait 3 seconds
timeout /t 3 /nobreak > nul

REM Start Order Service
start "Order Service" cmd /k "cd /d "%~dp0Order\demo" && set PATH=C:\apache-maven-3.9.11-bin\apache-maven-3.9.11\bin;%PATH% && mvn spring-boot:run"

REM Wait 3 seconds
timeout /t 3 /nobreak > nul

REM Start Payment Service
start "Payment Service" cmd /k "cd /d "%~dp0Payment\demo" && set PATH=C:\apache-maven-3.9.11-bin\apache-maven-3.9.11\bin;%PATH% && mvn spring-boot:run"

REM Wait 5 seconds before starting frontend
timeout /t 5 /nobreak > nul

REM Start React Frontend
start "React Frontend" cmd /k "cd /d "%~dp0managerapp" && npm start"

echo.
echo All services are starting in separate windows.
echo Wait for "Started *Application" in each backend window.
echo The browser will open automatically when the frontend is ready.
echo.
echo To stop all services, close each terminal window or press Ctrl+C in each.
echo.
pause
