# Architecture Documentation

> **Note:** This application previously used Redis for caching, pub/sub, and distributed locking. Redis has been removed and replaced with:
> - Direct Socket.IO broadcasting for real-time events
> - In-memory locking for atomic operations (suitable for single-instance deployments)
> - Database queries without caching layer
>
> For multi-instance deployments, consider implementing database transactions or re-adding Redis.

## System Overview

This is a production-grade real-time bidding application backend built with:
- **Clean Architecture** principles
- **Microservices-ready** modular structure
- **Event-driven** real-time communication
- **Distributed systems** patterns

---

## Architecture Layers

### 1. Presentation Layer (Controllers)
- Handles HTTP requests and responses
- Input validation
- Response formatting
- Error handling

**Location:** `src/modules/*/controller.ts`

### 2. Business Logic Layer (Services)
- Core business rules
- Transaction management
- Data transformation
- External service integration

**Location:** `src/modules/*/service.ts`

### 3. Data Access Layer (Models)
- Database schemas
- Data validation
- Relationships
- Indexes

**Location:** `src/models/`

### 4. Infrastructure Layer
- Database connections
- External APIs
- Configuration

**Location:** `src/config/`

---

## Design Patterns Used

### 1. Repository Pattern
Each module encapsulates data access logic, making it easy to switch databases.

### 2. Dependency Injection
Services are injected where needed, improving testability.

### 3. Singleton Pattern
Used for configuration and logger to ensure single instances.

### 4. Middleware Pattern
Cross-cutting concerns (auth, validation, logging) implemented as middleware.

### 5. Direct Event Broadcasting
Socket.IO for event broadcasting to WebSocket clients.

### 6. In-Memory Lock Pattern
In-memory locking for atomic operations (suitable for single-instance deployments).

---

## Critical Components

### 1. Atomic Bid Placement

**Challenge:** Multiple users bidding simultaneously could cause race conditions.

**Solution:** In-memory locking for single-instance deployments

```typescript
// Simplified flow
await withLock(`auction:${auctionId}`, async () => {
  // 1. Validate auction state
  // 2. Validate bid amount
  // 3. Update auction
  // 4. Create bid record
  // 5. Broadcast via Socket.IO
}, { ttl: 30, retries: 5 });
```

**Key Features:**
- Lock acquisition with retries
- Automatic lock release
- TTL to prevent deadlocks
- Atomic database operations

### 2. Anti-Snipe Mechanism

**Problem:** Users placing bids at the last second to win.

**Solution:** Automatic auction extension

```typescript
// If bid placed within last 60 seconds
if (timeUntilEnd <= antiSnipeThreshold) {
  // Extend auction by 60 seconds
  await auctionsService.extendAuctionEndTime(auctionId, 60);
  // Notify all participants via WebSocket
  await redisService.publish('auction:extended', {...});
}
```

### 3. Real-Time Updates

**Architecture:**
```
Client → WebSocket → Server → Redis Pub/Sub → All Connected Clients
```

**Flow:**
1. User places bid (HTTP POST)
2. Server publishes event to Redis
3. Redis broadcasts to all server instances
4. Each instance emits to connected WebSocket clients
5. Clients receive instant updates

### 4. Scheduled Jobs

**Purpose:** Close expired auctions automatically

**Implementation:**
- Runs every 10 seconds (configurable)
- Finds auctions where `endTime < now` and `status = Active`
- Updates status to `Ended`
- Assigns winner
- Broadcasts event

**Code:**
```typescript
cron.schedule('*/10 * * * * *', async () => {
  const expired = await Auction.find({
    status: 'Active',
    endTime: { $lte: new Date() }
  });
  
  for (const auction of expired) {
    await closeAuction(auction._id);
  }
});
```

---

## Data Flow Examples

### Example 1: User Places Bid

```
Mobile App
    ↓ HTTP POST /bids/place
Express Router
    ↓ Middleware (auth, validation, rate limit)
Bids Controller
    ↓ Extract data
Bids Service
    ↓ Acquire Redis Lock
    ├─→ Validate auction
    ├─→ Validate bid amount
    ├─→ Validate wallet balance
    ├─→ Update MongoDB (auction + bid)
    ├─→ Update Redis cache
    ├─→ Check anti-snipe rule
    └─→ Publish to Redis pub/sub
Redis Pub/Sub
    ↓ Broadcast to all servers
Socket.IO Server
    ↓ Emit to room subscribers
Mobile App (All users in auction)
    ↓ Receive real-time update
UI Updates Instantly
```

### Example 2: Auction Auto-Close

```
Cron Job (runs every 10s)
    ↓
Auction Job Service
    ↓ Query MongoDB
Find Expired Auctions
    ↓ For each auction
    ├─→ Update status to 'Ended'
    ├─→ Find winning bid
    ├─→ Assign winner
    ├─→ Update Redis cache
    └─→ Publish 'auction:ended' event
Redis Pub/Sub
    ↓
Socket.IO broadcasts to auction room
    ↓
All participants notified
```

---

## Security Architecture

### 1. Authentication Flow

```
User Login
    ↓
Verify credentials (bcrypt)
    ↓
Generate JWT tokens
    ├─→ Access Token (15 min)
    └─→ Refresh Token (7 days)
Store refresh token in DB
    ↓
Return tokens to client
```

### 2. Request Authorization

```
Client Request
    ↓ Authorization: Bearer <token>
Auth Middleware
    ↓ Verify JWT signature
    ↓ Check expiry
    ↓ Extract user payload
Request
    ↓ User data attached to req.user
Role Middleware (if needed)
    ↓ Check user.role
Controller
```

### 3. Security Measures

| Layer | Security Feature |
|-------|-----------------|
| Transport | HTTPS (production) |
| Headers | Helmet.js |
| CORS | Whitelist origins |
| Input | Joi validation |
| Passwords | bcrypt (12 rounds) |
| Tokens | JWT with secrets |
| Rate Limiting | Per-endpoint limits |
| Database | Mongoose sanitization |
| Errors | Sanitized responses |

---

## Scalability Considerations

### 1. Horizontal Scaling

**Current:**
- Stateless server design
- Redis for shared state
- MongoDB with connection pooling

**To Scale:**
```
Load Balancer
    ├─→ Server Instance 1
    ├─→ Server Instance 2
    ├─→ Server Instance 3
    └─→ Server Instance N
         ↓
    ┌────┴────┐
MongoDB    Redis
 Cluster   Cluster
```

### 2. Database Optimization

**Indexes Created:**
```typescript
// Users
email (unique)

// Auctions
status, endTime, seller
{ status: 1, endTime: 1 } (compound)

// Bids
{ auction: 1, amount: -1 } (compound)
bidder
```

**Query Optimization:**
- Pagination for list endpoints
- Selective field projection
- Lean queries where appropriate
- Connection pooling

### 3. Caching Strategy

**Cache Layers:**

1. **Application Cache (Redis)**
   - Active auction IDs
   - Current highest bids
   - Frequently accessed auctions

2. **Query Results**
   - TTL: 5 minutes for auction data
   - Invalidation on updates

3. **Distributed Locks**
   - TTL: 10-30 seconds
   - Auto-release on completion

### 4. WebSocket Scaling

**Approach:** Redis Pub/Sub

```
Server 1 (Socket.IO)     Server 2 (Socket.IO)
    ↓                           ↓
    └──────→ Redis Pub/Sub ←────┘
                ↓
         Broadcast to all
```

**Benefits:**
- Multiple server instances
- Consistent broadcast
- No sticky sessions needed

---

## Performance Metrics

### Target Performance

| Metric | Target | Notes |
|--------|--------|-------|
| Bid Placement | < 200ms | P95 latency |
| API Response | < 100ms | Average |
| WebSocket Emit | < 50ms | Real-time |
| DB Query | < 50ms | With indexes |
| Lock Acquisition | < 100ms | With retries |

### Monitoring Points

1. **Application**
   - Response times
   - Error rates
   - Active WebSocket connections

2. **Database**
   - Query performance
   - Connection pool usage
   - Index hit ratio

3. **Redis**
   - Memory usage
   - Command latency
   - Connection count

---

## Error Handling Strategy

### 1. Error Categories

#### Operational Errors (Expected)
- Validation failures
- Authentication errors
- Business rule violations
- Not found errors

**Handling:** Return appropriate HTTP status + message

#### Programmer Errors (Unexpected)
- Null reference
- Type errors
- Logic bugs

**Handling:** Log error, return 500, restart process

### 2. Error Response Format

```typescript
{
  success: false,
  message: "User-friendly error message",
  errors: [ // Optional, for validation
    {
      field: "email",
      message: "Invalid email format"
    }
  ],
  stack: "..." // Only in development
}
```

### 3. Error Logging

**Levels:**
- ERROR: Application errors
- WARN: Operational issues
- INFO: Important events
- DEBUG: Development info

**Outputs:**
- Console (development)
- Files (always)
- External service (production - future)

---

## Testing Strategy

### 1. Unit Tests (Recommended)
- Test individual services
- Mock dependencies
- Test edge cases

### 2. Integration Tests (Recommended)
- Test API endpoints
- Use test database
- Test WebSocket events

### 3. Load Tests (Recommended)
- Concurrent bid placement
- WebSocket connections
- Database performance

---

## Deployment Architecture

### Development
```
Developer Machine
    ↓
npm run dev
    ↓
Local MongoDB + Redis
```

### Production (Recommended)
```
Cloud Provider (AWS/Azure/GCP)
    ├─→ Load Balancer
    │       ↓
    ├─→ Application Servers (EC2/VMs)
    │       ↓
    ├─→ MongoDB Atlas / Self-hosted Cluster
    └─→ Redis Cloud / ElastiCache
```

---

## Future Enhancements

### 1. Immediate Priorities
- [ ] Payment gateway integration (Stripe/PayPal)
- [ ] Email notifications (SendGrid/AWS SES)
- [ ] Image upload (AWS S3/Cloudinary)
- [ ] Push notifications (FCM)

### 2. Advanced Features
- [ ] Auction categories and search
- [ ] User ratings and reviews
- [ ] Bid history analytics
- [ ] Auction recommendations
- [ ] Mobile app (React Native)

### 3. Infrastructure
- [ ] Docker containerization
- [ ] Kubernetes orchestration
- [ ] CI/CD pipeline
- [ ] Monitoring (Prometheus/Grafana)
- [ ] APM (New Relic/DataDog)

---

## Development Guidelines

### 1. Code Style
- TypeScript strict mode
- ESLint + Prettier
- Meaningful variable names
- Comprehensive comments

### 2. Git Workflow
- Feature branches
- Commit messages: `type(scope): message`
- Pull request reviews
- Semantic versioning

### 3. Documentation
- Code comments for complex logic
- API documentation
- Architecture decisions
- Setup instructions

---

## Conclusion

This backend is production-ready with:
✅ Clean architecture
✅ Scalability patterns
✅ Security best practices
✅ Real-time capabilities
✅ Error handling
✅ Performance optimization
✅ Comprehensive logging

Ready for:
- Horizontal scaling
- High traffic
- Real-time operations
- Mobile applications
- Future enhancements
