# Quick Setup Guide

## Step-by-Step Local Development Setup

### 1. Prerequisites Installation

#### Install MongoDB
**Windows:**
- Download from: https://www.mongodb.com/try/download/community
- Or use MongoDB Atlas (cloud): https://www.mongodb.com/cloud/atlas

**macOS:**
```bash
brew tap mongodb/brew
brew install mongodb-community
brew services start mongodb-community
```

**Linux:**
```bash
sudo apt-get install mongodb-org
sudo systemctl start mongod
```

### 2. Project Setup

```bash
# Navigate to backend directory
cd backend

# Install dependencies
npm install

# The .env file is already configured with sensible defaults
# You can modify it if needed
```

### 3. Start the Server

```bash
# Development mode (with hot reload)
npm run dev
```

You should see:
```
✅ MongoDB Connected: localhost
✅ Socket.IO initialized with /bidding namespace
✅ Auction job started
🚀 Server started successfully!
```

### 4. Test the API

**Health Check:**
```bash
curl http://localhost:5000/health
```

**Register a User:**
```bash
curl -X POST http://localhost:5000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test User",
    "email": "test@example.com",
    "password": "Test123456",
    "role": "Buyer"
  }'
```

### 5. Common Issues

#### MongoDB Connection Error
```
Error: connect ECONNREFUSED 127.0.0.1:27017
```
**Solution:** Start MongoDB service

#### Port Already in Use
```
Error: listen EADDRINUSE: address already in use :::5000
```
**Solution:** Change PORT in .env file or kill process using port 5000

### 6. Project Structure Overview

```
backend/
├── src/
│   ├── config/          # Database, JWT configuration
│   ├── models/          # Database models (User, Auction, Bid, Payment)
│   ├── modules/         # Feature modules (organized by domain)
│   │   ├── auth/        # Authentication (login, register)
│   │   ├── users/       # User management
│   │   ├── auctions/    # Auction CRUD operations
│   │   ├── bids/        # Bidding logic (atomic operations)
│   │   ├── payments/    # Payment handling
│   │   └── notifications/  # Notification service
│   ├── middlewares/     # Express middlewares
│   ├── sockets/         # WebSocket implementation
│   ├── jobs/            # Scheduled background jobs
│   ├── utils/           # Utilities (logger, in-memory lock)
│   ├── app.ts           # Express application setup
│   └── server.ts        # Server entry point
```

### 7. API Testing Flow

1. **Register a Seller** (role: "Seller")
2. **Login as Seller** → Get access token
3. **Create an Auction** (use the access token)
4. **Register a Buyer** (role: "Buyer")
5. **Login as Buyer** → Get access token
6. **Add Funds to Wallet** (Buyer needs funds to bid)
7. **Place a Bid** on the auction
8. **Connect via WebSocket** to see real-time updates

### 8. WebSocket Testing

You can test WebSocket connections using:
- Postman (supports WebSocket)
- Socket.IO client library
- Browser developer tools

### 9. Production Build

```bash
# Build TypeScript
npm run build

# Start production server
npm start
```

### 10. Monitoring

Check logs in the `logs/` directory:
- `combined.log` - All logs
- `error.log` - Errors only

---

## Need Help?

- Check the main README.md for detailed documentation
- Review the code comments for implementation details
- All critical business logic is thoroughly commented
