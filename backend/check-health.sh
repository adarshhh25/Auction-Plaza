#!/bin/bash

# Bidding App Backend - Health Check Script
# This script checks if all required services are running

echo "============================================"
echo "  Bidding App - System Health Check"
echo "============================================"
echo ""

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check functions
check_service() {
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓${NC} $1"
    else
        echo -e "${RED}✗${NC} $1"
        echo -e "${YELLOW}  → $2${NC}"
    fi
}

# 1. Check Node.js
echo "Checking Node.js..."
node --version > /dev/null 2>&1
check_service "Node.js installed" "Install Node.js from https://nodejs.org/"
echo ""

# 2. Check npm
echo "Checking npm..."
npm --version > /dev/null 2>&1
check_service "npm installed" "npm comes with Node.js"
echo ""

# 3. Check MongoDB
echo "Checking MongoDB..."
mongod --version > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓${NC} MongoDB installed"
else
    echo -e "${YELLOW}⚠${NC} MongoDB not found locally"
    echo -e "${YELLOW}  → You can use MongoDB Atlas (cloud) or install locally${NC}"
fi
echo ""

# 4. Check Redis
echo "Checking Redis..."
redis-cli --version > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓${NC} Redis installed"
    
    # Check if Redis is running
    redis-cli ping > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓${NC} Redis is running"
    else
        echo -e "${YELLOW}⚠${NC} Redis is installed but not running"
        echo -e "${YELLOW}  → Start Redis with: redis-server${NC}"
    fi
else
    echo -e "${YELLOW}⚠${NC} Redis not found"
    echo -e "${YELLOW}  → Install from: https://redis.io/download${NC}"
fi
echo ""

# 5. Check if dependencies are installed
echo "Checking project dependencies..."
if [ -d "node_modules" ]; then
    echo -e "${GREEN}✓${NC} Dependencies installed"
else
    echo -e "${YELLOW}⚠${NC} Dependencies not installed"
    echo -e "${YELLOW}  → Run: npm install${NC}"
fi
echo ""

# 6. Check if .env exists
echo "Checking configuration..."
if [ -f ".env" ]; then
    echo -e "${GREEN}✓${NC} .env file exists"
else
    echo -e "${RED}✗${NC} .env file not found"
    echo -e "${YELLOW}  → Copy .env.example to .env or use the existing .env${NC}"
fi
echo ""

# Summary
echo "============================================"
echo "  Summary"
echo "============================================"
echo ""
echo "Next steps:"
echo "1. Install Node.js if not installed"
echo "2. Install and start MongoDB"
echo "3. Install and start Redis"
echo "4. Run: npm install"
echo "5. Run: npm run dev"
echo ""
echo "For detailed setup instructions, see SETUP.md"
echo ""
