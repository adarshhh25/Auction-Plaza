# Bidding App Backend

Production-grade real-time mobile bidding application backend built with Express.js, TypeScript, MongoDB, and Socket.IO.

## 🚀 Features

- **Real-time Bidding**: WebSocket support for live auction updates
- **Atomic Operations**: In-memory locking for concurrent bid handling
- **Anti-Snipe Protection**: Automatic auction extension for last-minute bids
- **Role-Based Access Control**: Admin, Seller, and Buyer roles
- **JWT Authentication**: Access + Refresh token system
- **Scheduled Jobs**: Automatic auction closure when time expires
- **Rate Limiting**: Protection against spam and abuse
- **Comprehensive Validation**: Input validation with Joi
- **Security**: Helmet, CORS, bcrypt password hashing
- **Clean Architecture**: Modular structure with separation of concerns
- **Production Ready**: Error handling, logging, and scalability

## 📋 Prerequisites

- Node.js (v18 or higher)
- MongoDB (local or cloud instance)

## 🛠️ Installation

1. **Clone or navigate to the backend directory**
   ```bash
   cd backend
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Configure environment variables**
   
   Copy the `.env` file and update with your configuration:
   - MongoDB connection URI
   - JWT secret keys (change in production!)
   - CORS allowed origins

4. **Create logs directory**
   ```bash
   mkdir logs
   ```

## 🏃 Running the Application

### Development Mode
```bash
npm run dev
```

### Production Mode
```bash
npm run build
npm start
```

## 📁 Project Structure

```
backend/
├── src/
│   ├── config/          # Configuration (DB, JWT, Env)
│   ├── models/          # Mongoose models
│   ├── modules/         # Feature modules (Auth, Users, Auctions, Bids, etc.)
│   ├── middlewares/     # Express middlewares
│   ├── sockets/         # WebSocket implementation
│   ├── jobs/            # Scheduled jobs
│   ├── utils/           # Utilities (Logger, Lock)
│   ├── app.ts           # Express app setup
│   └── server.ts        # Server entry point
├── .env                 # Environment variables
├── package.json         # Dependencies
└── tsconfig.json        # TypeScript configuration
```

## 🔌 API Endpoints

### Authentication
- `POST /api/v1/auth/register` - Register new user
- `POST /api/v1/auth/login` - Login user
- `POST /api/v1/auth/refresh` - Refresh access token
- `POST /api/v1/auth/logout` - Logout user

### Users
- `GET /api/v1/users/profile` - Get user profile
- `PATCH /api/v1/users/profile` - Update profile
- `GET /api/v1/users/wallet/balance` - Get wallet balance
- `POST /api/v1/users/wallet/add` - Add funds to wallet

### Auctions
- `POST /api/v1/auctions` - Create auction (Seller only)
- `GET /api/v1/auctions` - Get all auctions
- `GET /api/v1/auctions/:id` - Get auction by ID
- `GET /api/v1/auctions/my-auctions` - Get seller's auctions
- `PATCH /api/v1/auctions/:id/status` - Update auction status

### Bids
- `POST /api/v1/bids/place` - Place a bid (Buyer only)
- `GET /api/v1/bids/auction/:auctionId` - Get auction bids
- `GET /api/v1/bids/my-bids` - Get user's bids
- `GET /api/v1/bids/winning` - Get winning bids

### Payments
- `POST /api/v1/payments/create` - Create payment
- `GET /api/v1/payments/my-payments` - Get user payments
- `GET /api/v1/payments/:id` - Get payment by ID

## 🔌 WebSocket Events

### Namespace: `/bidding`

**Client Events:**
- `joinAuction` - Join auction room `{ auctionId: string }`
- `leaveAuction` - Leave auction room `{ auctionId: string }`

**Server Events:**
- `bidUpdate` - New bid placed on auction
- `auctionExtended` - Auction time extended (anti-snipe)
- `auctionClosed` - Auction has ended

### Example Connection (Client Side)
```javascript
import io from 'socket.io-client';

const socket = io('http://localhost:5000/bidding', {
  auth: {
    token: 'YOUR_JWT_TOKEN'
  }
});

// Join auction room
socket.emit('joinAuction', { auctionId: '123456' });

// Listen for bid updates
socket.on('bidUpdate', (data) => {
  console.log('New bid:', data);
});

// Listen for auction extension
socket.on('auctionExtended', (data) => {
  console.log('Auction extended:', data);
});

// Listen for auction closure
socket.on('auctionClosed', (data) => {
  console.log('Auction ended:', data);
});
```

## 🔐 Authentication

All protected routes require a JWT access token in the Authorization header:

```
Authorization: Bearer YOUR_ACCESS_TOKEN
```

**Token Expiry:**
- Access Token: 15 minutes
- Refresh Token: 7 days

Use the `/api/v1/auth/refresh` endpoint to get a new access token.

## 👥 User Roles

- **Admin**: Full system access
- **Seller**: Can create and manage auctions
- **Buyer**: Can place bids and win auctions

## ⏰ Timezone Handling

**All dates and times are stored and compared in UTC** for worldwide compatibility.

### Key Principles
- ✅ Backend stores all dates in UTC (MongoDB default)
- ✅ Backend compares dates using JavaScript Date objects (UTC internally)
- ✅ API accepts/returns ISO 8601 format: `"2026-03-08T10:00:00.000Z"`
- ✅ Frontend converts to user's local timezone for display
- ✅ Server timezone setting is irrelevant to logic

### Example
```javascript
// Auction starts at 10:00 AM UTC
// - Displayed as 3:30 PM in India (IST)
// - Displayed as 2:00 AM in California (PST)
// - Same moment in time, different display

// Backend validation:
const now = new Date();  // Current UTC time
if (now < auction.startTime) {  // Both are UTC milliseconds
  throw new Error('Auction has not started yet');
}
```

### Debug Endpoint
```bash
GET /api/v1/auctions/debug/time?auctionId=YOUR_AUCTION_ID
```

Returns server time, auction timing, and validation status in UTC.

### Documentation
- **[QUICK_START.md](QUICK_START.md)** - 5-minute timezone guide
- **[BACKEND_TIMEZONE_ARCHITECTURE.md](BACKEND_TIMEZONE_ARCHITECTURE.md)** - Complete backend guide
- **[TIMEZONE_GUIDE.md](TIMEZONE_GUIDE.md)** - Full system guide (backend + frontend)
- **[QUICK_FIX.md](QUICK_FIX.md)** - Common timezone issues and fixes

## ⚙️ Business Logic

### Atomic Bid Placement

Bids are processed atomically using in-memory locks:

1. Validate auction is active and within time window
2. Validate bid amount > current highest + minimum increment
3. Validate user wallet balance
4. Acquire in-memory lock for auction
5. Update auction and create bid
6. Check anti-snipe rule
7. Broadcast via WebSocket
8. Release lock

### Anti-Snipe Rule

If a bid is placed within the last 60 seconds of an auction:
- Auction end time is extended by 60 seconds
- All participants are notified via WebSocket

### Scheduled Job

A background job runs every 10 seconds to:
- Find expired auctions
- Mark them as "Ended"
- Assign winner
- Broadcast closure event

## 🛡️ Security Features

- **Helmet**: Security headers
- **CORS**: Cross-origin protection
- **Rate Limiting**: Per-endpoint limits
- **Password Hashing**: bcrypt with configurable rounds
- **JWT**: Secure token-based authentication
- **Input Validation**: Joi schemas
- **SQL/NoSQL Injection**: Mongoose sanitization
- **Error Sanitization**: No sensitive data in responses

##  Logging

Logs are written to:
- `logs/combined.log` - All logs
- `logs/error.log` - Error logs only
- `logs/exceptions.log` - Uncaught exceptions
- `logs/rejections.log` - Unhandled promise rejections
- Console (development only)

## 🧪 Testing the API

### Example: Register a Seller

```bash
curl -X POST http://localhost:5000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Seller",
    "email": "seller@example.com",
    "password": "SecurePass123",
    "role": "Seller"
  }'
```

### Example: Create an Auction

```bash
curl -X POST http://localhost:5000/api/v1/auctions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -d '{
    "title": "Vintage Watch",
    "description": "Beautiful vintage watch in excellent condition",
    "images": ["https://example.com/image1.jpg"],
    "startingPrice": 100,
    "minimumIncrement": 5,
    "startTime": "2026-03-01T10:00:00Z",
    "endTime": "2026-03-01T20:00:00Z"
  }'
```

### Example: Place a Bid

```bash
curl -X POST http://localhost:5000/api/v1/bids/place \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -d '{
    "auctionId": "AUCTION_ID",
    "amount": 150
  }'
```

## 🐛 Troubleshooting

### MongoDB Connection Issues
- Ensure MongoDB is running
- Check connection string in `.env`
- Verify network access if using cloud MongoDB

### WebSocket Connection Issues
- Ensure JWT token is valid
- Check CORS configuration
- Verify Socket.IO namespace is `/bidding`

## 📝 Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| NODE_ENV | Environment mode | development |
| PORT | Server port | 5000 |
| MONGODB_URI | MongoDB connection string | mongodb://localhost:27017/bidding_app |
| JWT_ACCESS_SECRET | JWT access token secret | (required) |
| JWT_REFRESH_SECRET | JWT refresh token secret | (required) |
| JWT_ACCESS_EXPIRY | Access token expiry | 15m |
| JWT_REFRESH_EXPIRY | Refresh token expiry | 7d |
| ANTI_SNIPE_SECONDS | Anti-snipe threshold | 60 |
| ANTI_SNIPE_EXTENSION_SECONDS | Extension duration | 60 |
| AUCTION_CHECK_INTERVAL_SECONDS | Job interval | 10 |

## 🚀 Deployment

### Prerequisites
- Node.js server
- MongoDB instance

### Steps
1. Build the project: `npm run build`
2. Set environment variables on server
3. Start the server: `npm start`
4. Set up process manager (PM2 recommended)
5. Configure reverse proxy (Nginx)
6. Set up SSL certificate

### PM2 Example
```bash
pm2 start dist/server.js --name bidding-app
pm2 save
pm2 startup
```

## 📚 Technologies Used

- **Runtime**: Node.js
- **Framework**: Express.js
- **Language**: TypeScript
- **Database**: MongoDB + Mongoose
- **Cache**: Redis
- **WebSocket**: Socket.IO
- **Authentication**: JWT + bcrypt
- **Validation**: Joi
- **Logging**: Winston
- **Scheduling**: node-cron
- **Security**: Helmet, CORS, express-rate-limit

## 🤝 Contributing

This is a production-grade template. Feel free to extend and customize for your needs.

## 📄 License

MIT

## 👨‍💻 Author

Senior Backend Architect

---

**Note**: This is a complete, production-ready backend. All critical features are implemented including atomic operations, real-time updates, security, and scalability considerations.
