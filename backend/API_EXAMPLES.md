# API Testing Examples

This file contains example API requests for testing the Bidding App backend.

## Base URL
```
http://localhost:5000/api/v1
```

---

## 1. Authentication

### 1.1 Register Seller
```bash
POST /auth/register
Content-Type: application/json

{
  "name": "John Seller",
  "email": "seller@example.com",
  "password": "Seller123",
  "role": "Seller"
}

# Expected Response:
{
  "success": true,
  "message": "User registered successfully",
  "data": {
    "user": {
      "id": "...",
      "name": "John Seller",
      "email": "seller@example.com",
      "role": "Seller",
      "walletBalance": 0,
      "isVerified": false
    },
    "accessToken": "...",
    "refreshToken": "..."
  }
}
```

### 1.2 Register Buyer
```bash
POST /auth/register
Content-Type: application/json

{
  "name": "Alice Buyer",
  "email": "buyer@example.com",
  "password": "Buyer123",
  "role": "Buyer"
}
```

### 1.3 Login
```bash
POST /auth/login
Content-Type: application/json

{
  "email": "seller@example.com",
  "password": "Seller123"
}

# Expected Response:
{
  "success": true,
  "message": "Login successful",
  "data": {
    "user": { ... },
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "..."
  }
}
```

### 1.4 Refresh Token
```bash
POST /auth/refresh
Content-Type: application/json

{
  "refreshToken": "YOUR_REFRESH_TOKEN"
}
```

### 1.5 Logout
```bash
POST /auth/logout
Authorization: Bearer YOUR_ACCESS_TOKEN
```

---

## 2. Users

### 2.1 Get Profile
```bash
GET /users/profile
Authorization: Bearer YOUR_ACCESS_TOKEN
```

### 2.2 Update Profile
```bash
PATCH /users/profile
Authorization: Bearer YOUR_ACCESS_TOKEN
Content-Type: application/json

{
  "name": "John Updated"
}
```

### 2.3 Get Wallet Balance
```bash
GET /users/wallet/balance
Authorization: Bearer YOUR_ACCESS_TOKEN
```

### 2.4 Add Funds to Wallet
```bash
POST /users/wallet/add
Authorization: Bearer YOUR_ACCESS_TOKEN
Content-Type: application/json

{
  "amount": 1000
}
```

---

## 3. Auctions

### 3.1 Create Auction (Seller Only)
```bash
POST /auctions
Authorization: Bearer SELLER_ACCESS_TOKEN
Content-Type: application/json

{
  "title": "Vintage Rolex Watch",
  "description": "Beautiful vintage Rolex watch in excellent condition. Comes with original box and papers.",
  "images": [
    "https://example.com/watch1.jpg",
    "https://example.com/watch2.jpg"
  ],
  "startingPrice": 500,
  "minimumIncrement": 10,
  "startTime": "2026-03-01T10:00:00Z",
  "endTime": "2026-03-01T20:00:00Z"
}

# Expected Response:
{
  "success": true,
  "message": "Auction created successfully",
  "data": {
    "_id": "...",
    "title": "Vintage Rolex Watch",
    "currentHighestBid": 500,
    "status": "Active",
    ...
  }
}
```

### 3.2 Get All Auctions
```bash
GET /auctions?status=Active&page=1&limit=10&sort=-createdAt

# Query Parameters:
# - status: Pending | Active | Ended | Cancelled
# - page: 1, 2, 3...
# - limit: 1-100
# - sort: createdAt, -createdAt, endTime, -endTime
```

### 3.3 Get Auction by ID
```bash
GET /auctions/:auctionId
```

### 3.4 Get My Auctions (Seller Only)
```bash
GET /auctions/my-auctions?page=1&limit=10
Authorization: Bearer SELLER_ACCESS_TOKEN
```

### 3.5 Update Auction Status (Seller Only)
```bash
PATCH /auctions/:auctionId/status
Authorization: Bearer SELLER_ACCESS_TOKEN
Content-Type: application/json

{
  "status": "Active"
}

# Valid statuses: Pending | Active | Cancelled
# Note: Cannot change status of Ended auctions
```

---

## 4. Bids

### 4.1 Place Bid (Buyer Only)
```bash
POST /bids/place
Authorization: Bearer BUYER_ACCESS_TOKEN
Content-Type: application/json

{
  "auctionId": "AUCTION_ID_HERE",
  "amount": 600
}

# Requirements:
# - Amount must be >= currentHighestBid + minimumIncrement
# - User must have sufficient wallet balance
# - Auction must be Active and within time window
# - Seller cannot bid on own auction

# Expected Response:
{
  "success": true,
  "message": "Bid placed successfully",
  "data": {
    "bid": {
      "_id": "...",
      "amount": 600,
      "isWinningBid": true,
      "bidder": { ... }
    },
    "auction": { ... },
    "auctionExtended": false
  }
}
```

### 4.2 Get Auction Bids
```bash
GET /bids/auction/:auctionId?page=1&limit=20
Authorization: Bearer YOUR_ACCESS_TOKEN
```

### 4.3 Get My Bids (Buyer Only)
```bash
GET /bids/my-bids?page=1&limit=20
Authorization: Bearer BUYER_ACCESS_TOKEN
```

### 4.4 Get Winning Bids (Buyer Only)
```bash
GET /bids/winning
Authorization: Bearer BUYER_ACCESS_TOKEN

# Returns only bids where isWinningBid = true
```

---

## 5. Payments

### 5.1 Create Payment
```bash
POST /payments/create
Authorization: Bearer YOUR_ACCESS_TOKEN
Content-Type: application/json

{
  "auctionId": "AUCTION_ID_HERE"
}

# Only the winner can create payment for an auction
```

### 5.2 Get My Payments
```bash
GET /payments/my-payments
Authorization: Bearer YOUR_ACCESS_TOKEN
```

### 5.3 Get Payment by ID
```bash
GET /payments/:paymentId
Authorization: Bearer YOUR_ACCESS_TOKEN
```

---

## 6. WebSocket Events

### Connect to WebSocket
```javascript
import io from 'socket.io-client';

const socket = io('http://localhost:5000/bidding', {
  auth: {
    token: 'YOUR_ACCESS_TOKEN'
  }
});

// Connection successful
socket.on('connect', () => {
  console.log('Connected to bidding namespace');
});

// Join auction room
socket.emit('joinAuction', { auctionId: 'AUCTION_ID' });

socket.on('joinedAuction', (data) => {
  console.log('Joined auction:', data);
});
```

### Listen for Events
```javascript
// New bid placed
socket.on('bidUpdate', (data) => {
  console.log('New bid:', data);
  // data = { auctionId, bid, auctionExtended }
});

// Auction time extended (anti-snipe)
socket.on('auctionExtended', (data) => {
  console.log('Auction extended:', data);
  // data = { auctionId, newEndTime, extensionSeconds, message }
});

// Auction ended
socket.on('auctionClosed', (data) => {
  console.log('Auction closed:', data);
  // data = { auctionId, winner, finalBid, message }
});

// Leave auction room
socket.emit('leaveAuction', { auctionId: 'AUCTION_ID' });
```

---

## Complete Testing Flow

### Step 1: Setup Users
```bash
# Register Seller
POST /auth/register
{ "name": "Seller", "email": "seller@test.com", "password": "Test123", "role": "Seller" }
# Save accessToken as SELLER_TOKEN

# Register Buyer
POST /auth/register
{ "name": "Buyer", "email": "buyer@test.com", "password": "Test123", "role": "Buyer" }
# Save accessToken as BUYER_TOKEN
```

### Step 2: Seller Creates Auction
```bash
POST /auctions
Authorization: Bearer SELLER_TOKEN
{
  "title": "Test Auction",
  "description": "Test auction description",
  "images": ["https://via.placeholder.com/300"],
  "startingPrice": 100,
  "minimumIncrement": 5,
  "startTime": "2026-03-01T10:00:00Z",
  "endTime": "2026-03-25T20:00:00Z"
}
# Save auctionId
```

### Step 3: Buyer Adds Funds
```bash
POST /users/wallet/add
Authorization: Bearer BUYER_TOKEN
{ "amount": 500 }
```

### Step 4: Buyer Places Bid
```bash
POST /bids/place
Authorization: Bearer BUYER_TOKEN
{
  "auctionId": "AUCTION_ID",
  "amount": 110
}
```

### Step 5: Monitor via WebSocket
```javascript
// Connect and listen for real-time updates
const socket = io('http://localhost:5000/bidding', { auth: { token: BUYER_TOKEN }});
socket.emit('joinAuction', { auctionId: 'AUCTION_ID' });
socket.on('bidUpdate', (data) => console.log('New bid:', data));
```

---

## Testing Anti-Snipe Feature

1. Create an auction ending in 2 minutes
2. Place a bid within the last 60 seconds
3. Observe the auction endTime being extended by 60 seconds
4. WebSocket will emit 'auctionExtended' event

---

## Error Responses

All error responses follow this format:
```json
{
  "success": false,
  "message": "Error message here"
}
```

Common HTTP status codes:
- 200: Success
- 201: Created
- 400: Bad Request (validation error)
- 401: Unauthorized (invalid/missing token)
- 403: Forbidden (insufficient permissions)
- 404: Not Found
- 429: Too Many Requests (rate limited)
- 500: Internal Server Error

---

## Rate Limits

- General API: 100 requests per minute
- Authentication: 5 requests per 15 minutes
- Bid Placement: 5 requests per 10 seconds
- Auction Creation: 10 auctions per hour
