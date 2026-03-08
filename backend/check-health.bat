@echo off
REM Bidding App Backend - Health Check Script for Windows
REM This script checks if all required services are running

echo ============================================
echo   Bidding App - System Health Check
echo ============================================
echo.

REM Check Node.js
echo Checking Node.js...
node --version >nul 2>&1
if %errorlevel% == 0 (
    echo [32m[OK][0m Node.js installed
) else (
    echo [31m[X][0m Node.js not found
    echo      Install from: https://nodejs.org/
)
echo.

REM Check npm
echo Checking npm...
npm --version >nul 2>&1
if %errorlevel% == 0 (
    echo [32m[OK][0m npm installed
) else (
    echo [31m[X][0m npm not found
)
echo.

REM Check MongoDB
echo Checking MongoDB...
mongod --version >nul 2>&1
if %errorlevel% == 0 (
    echo [32m[OK][0m MongoDB installed
) else (
    echo [33m[!][0m MongoDB not found locally
    echo      You can use MongoDB Atlas ^(cloud^) or install locally
)
echo.

REM Check Redis
echo Checking Redis...
redis-cli --version >nul 2>&1
if %errorlevel% == 0 (
    echo [32m[OK][0m Redis installed
    
    REM Check if Redis is running
    redis-cli ping >nul 2>&1
    if %errorlevel% == 0 (
        echo [32m[OK][0m Redis is running
    ) else (
        echo [33m[!][0m Redis installed but not running
        echo      Start Redis with: redis-server
    )
) else (
    echo [33m[!][0m Redis not found
    echo      Install from: https://github.com/microsoftarchive/redis/releases
)
echo.

REM Check dependencies
echo Checking project dependencies...
if exist "node_modules\" (
    echo [32m[OK][0m Dependencies installed
) else (
    echo [33m[!][0m Dependencies not installed
    echo      Run: npm install
)
echo.

REM Check .env
echo Checking configuration...
if exist ".env" (
    echo [32m[OK][0m .env file exists
) else (
    echo [31m[X][0m .env file not found
    echo      Copy .env.example to .env or use provided .env
)
echo.

echo ============================================
echo   Summary
echo ============================================
echo.
echo Next steps:
echo 1. Install Node.js if not installed
echo 2. Install and start MongoDB
echo 3. Install and start Redis
echo 4. Run: npm install
echo 5. Run: npm run dev
echo.
echo For detailed setup instructions, see SETUP.md
echo.
pause
