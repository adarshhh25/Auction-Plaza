# BidMaster - Flutter Frontend Architecture Guide

## 🎯 Overview

This is a **production-grade Flutter mobile application** for a real-time bidding marketplace. It integrates seamlessly with a Node.js/Express/Socket.IO backend.

## 📁 Project Structure

```
lib/
├── core/                      # Core application infrastructure
│   ├── config/
│   │   └── api_config.dart    # API endpoints and Socket.IO configuration
│   ├── constants/
│   │   └── app_constants.dart # Application-wide constants
│   ├── theme/
│   │   └── app_theme.dart     # Light/Dark theme configuration
│   └── utils/
│       ├── currency_formatter.dart  # Currency formatting utilities
│       ├── date_formatter.dart      # Date/time formatting
│       └── validators.dart          # Form validation helpers
│
├── models/                    # Data models with JSON serialization
│   ├── user_model.dart        # User, WalletBalance, AuthResponse
│   ├── auction_model.dart     # Auction, CreateAuctionRequest
│   ├── bid_model.dart         # Bid, PlaceBidRequest
│   ├── payment_model.dart     # Payment models
│   └── api_response.dart      # Generic API response wrapper
│
├── services/                  # Business logic and API layer
│   ├── secure_storage_service.dart  # Secure token storage
│   ├── api_client.dart              # HTTP client with JWT handling
│   ├── auth_service.dart            # Authentication operations
│   ├── auction_service.dart         # Auction CRUD operations
│   ├── bid_service.dart             # Bidding operations
│   ├── user_service.dart            # User profile & wallet
│   └── socket_service.dart          # Real-time Socket.IO
│
├── providers/                 # Riverpod state management
│   ├── auth_provider.dart     # Authentication state
│   ├── auction_provider.dart  # Auction list state
│   ├── bid_provider.dart      # Bidding state
│   ├── wallet_provider.dart   # Wallet state
│   └── theme_provider.dart    # Theme mode state
│
├── screens/                   # UI screens
│   ├── auth/
│   │   ├── splash_screen.dart
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   ├── home/
│   │   └── home_screen.dart         # Auction list
│   ├── auction/
│   │   └── auction_detail_screen.dart
│   ├── bids/
│   │   └── my_bids_screen.dart
│   ├── wallet/
│   │   └── wallet_screen.dart
│   └── profile/
│       └── profile_screen.dart
│
├── widgets/                   # Reusable UI components
│   └── auction_card.dart      # Auction card widget
│
├── routes/
│   └── app_router.dart        # GoRouter navigation configuration
│
└── main.dart                  # Application entry point
```

## 🏗️ Architecture Highlights

### 1. **State Management - Riverpod**

**Why Riverpod?**
- ✅ Type-safe and compile-time safe
- ✅ No BuildContext required
- ✅ Better testability
- ✅ Automatic disposal
- ✅ Provider composition

**Key Providers:**
- `authProvider` - Manages authentication state
- `auctionsProvider` - Handles auction list with pagination
- `bidProvider` - Manages bid placement
- `walletProvider` - Tracks wallet balance

### 2. **API Layer - Dio + Interceptors**

**Features:**
- ✅ Automatic JWT token injection
- ✅ Token refresh on 401 errors
- ✅ Request/response logging
- ✅ Centralized error handling
- ✅ Type-safe API responses

**Example:**
```dart
// Automatic token refresh if expired
final response = await apiClient.get<User>(
  '/users/profile',
  fromJson: (json) => User.fromJson(json),
);
```

### 3. **Real-Time Bidding - Socket.IO**

**Implementation:**
```dart
socketService.connect();
socketService.joinAuction(auctionId);

socketService.onBidUpdate((data) {
  // Update UI with new bid
});
```

### 4. **Data Models - Freezed + JSON Serializable**

**Benefits:**
- ✅ Immutable data classes
- ✅ Auto-generated copyWith()
- ✅ JSON serialization
- ✅ Union types support

**Example:**
```dart
@freezed
class Auction with _$Auction {
  const factory Auction({
    required String id,
    required String title,
    required double currentBid,
    // ...
  }) = _Auction;

  factory Auction.fromJson(Map<String, dynamic> json) =>
      _$AuctionFromJson(json);
}
```

### 5. **Routing - GoRouter**

**Features:**
- ✅ Declarative routing
- ✅ Deep linking support
- ✅ Route guards (auth redirect)
- ✅ Type-safe navigation

### 6. **Secure Storage - flutter_secure_storage**

**Stored Data:**
- Access tokens (encrypted)
- Refresh tokens (encrypted)
- User data (encrypted)

## 📦 Dependencies Explained

| Package | Purpose |
|---------|---------|
| `flutter_riverpod` | Reactive state management |
| `dio` | HTTP client with interceptors |
| `go_router` | Declarative routing |
| `socket_io_client` | Real-time bidding updates |
| `flutter_secure_storage` | Encrypted token storage |
| `cached_network_image` | Efficient image loading & caching |
| `freezed` | Immutable data classes |
| `json_serializable` | JSON parsing code generation |
| `intl` | Date/time/currency formatting |

## 🚀 Setup Instructions

### 1. Install Dependencies

```bash
cd app/bidding_app
flutter pub get
```

### 2. Generate Code (Freezed + JSON)

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This generates:
- `*.freezed.dart` files (data classes)
- `*.g.dart` files (JSON serialization)

### 3. Configure Backend URL

Edit `lib/core/config/api_config.dart`:

```dart
static const String baseUrl = 'http://10.0.2.2:5000/api/v1';  // Android Emulator
// static const String baseUrl = 'http://localhost:5000/api/v1';  // iOS Simulator
// static const String baseUrl = 'http://YOUR_IP:5000/api/v1';  // Physical Device
```

### 4. Run the App

```bash
flutter run
```

## 🎨 UI Design

### Theme
- **Material 3 Design**
- **Light & Dark Mode**
- **Auction marketplace color scheme**
- **Professional card-based layout**

### Key Screens

| Screen | Purpose |
|--------|---------|
| Splash | Initial loading & auth check |
| Login/Register | User authentication |
| Home | Browse active auctions (grid view) |
| Auction Details | View details, bid history, place bids |
| My Bids | User's bidding history |
| Wallet | Manage funds |
| Profile | User settings & logout |

## 🔐 Security Features

1. **JWT Token Handling**
   - Access tokens stored securely
   - Automatic refresh on expiration
   - Tokens cleared on logout

2. **Secure Storage**
   - iOS: Keychain
   - Android: Keystore

3. **Network Security**
   - HTTPS for production
   - Certificate pinning (optional)

## 🔄 Real-Time Features

### Socket.IO Events

| Event | Description |
|-------|-------------|
| `bidUpdate` | New bid placed on auction |
| `auctionExtended` | Auction time extended (anti-snipe) |
| `auctionClosed` | Auction ended |

### Implementation
```dart
// Join auction room
socketService.joinAuction(auctionId);

// Listen for updates
socketService.onBidUpdate((data) {
  setState(() {
    currentBid = data['amount'];
  });
});
```

## 📱 Platform Support

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 🧪 Testing

### Run Tests
```bash
flutter test
```

### Widget Tests
Located in `test/` directory

## 🔧 Common Issues & Solutions

### 1. Build Runner Errors
```bash
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### 2. Network Connection Issues
- Check `api_config.dart` URL
- Ensure backend is running
- Use correct IP for physical devices

### 3. Socket Connection Fails
- Verify Socket.IO URL matches backend
- Check firewall settings
- Ensure JWT token is valid

## 📊 API Integration

### Authentication Flow
1. User logs in → receives tokens
2. Tokens stored securely
3. Access token added to all requests
4. Refresh token used when access token expires
5. Logout clears all stored data

### Example API Call
```dart
final authService = AuthService();
final response = await authService.login(
  email: 'user@example.com',
  password: 'password',
);

if (response.success) {
  // Tokens automatically saved
  // Navigate to home
}
```

## 🎯 Future Enhancements

- [ ] Push notifications
- [ ] Image upload for auctions
- [ ] Payment gateway integration
- [ ] Chat between buyer/seller
- [ ] Auction categories & filters
- [ ] Advanced search
- [ ] Favorites/Watchlist
- [ ] Bid history analytics

## 📄 License

This project is for educational/portfolio purposes.

## 👨‍💻 Author

Built by **Adarsh Jha**

---

## Quick Start Checklist

- [ ] Run `flutter pub get`
- [ ] Run `flutter pub run build_runner build --delete-conflicting-outputs`
- [ ] Update backend URL in `api_config.dart`
- [ ] Ensure backend is running on `http://localhost:5000`
- [ ] Run `flutter run`
- [ ] Register a new user
- [ ] Add funds to wallet
- [ ] Browse auctions
- [ ] Place a bid!

**Happy Bidding! 🎉**
