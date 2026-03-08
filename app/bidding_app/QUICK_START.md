# 🚀 Quick Start Guide - BidMaster Flutter App

## ✅ Setup Complete!

All code has been generated successfully. Your Flutter architecture is ready!

## 📋 What's Included

### ✨ Core Architecture
- ✅ API service layer with JWT token handling
- ✅ Secure storage for tokens
- ✅ Riverpod state management
- ✅ GoRouter navigation with auth guards
- ✅ Socket.IO for real-time bidding
- ✅ Freezed models with JSON serialization
- ✅ Professional Material 3 theme (Light/Dark mode)

### 📱 Screens
- ✅ Splash Screen
- ✅ Login & Register
- ✅ Home (Auction List with pagination)
- ✅ Auction Details (with real-time updates)
- ✅ My Bids
- ✅ Wallet
- ✅ Profile

### 🔧 Features
- ✅ JWT authentication with auto-refresh
- ✅ Real-time bid updates via Socket.IO
- ✅ Wallet management
- ✅ Secure token storage
- ✅ Beautiful UI with Material 3
- ✅ Responsive design for all devices

## 🎯 Next Steps

### 1. Update Backend URL (IMPORTANT!)

Open `lib/core/config/api_config.dart` and update the base URL:

```dart
// For Android Emulator:
static const String baseUrl = 'http://10.0.2.2:5000/api/v1';

// For iOS Simulator:
static const String baseUrl = 'http://localhost:5000/api/v1';

// For Physical Device:
static const String baseUrl = 'http://YOUR_COMPUTER_IP:5000/api/v1';
```

**To find your computer's IP:**
- Windows: `ipconfig` (look for IPv4 Address)
- Mac/Linux: `ifconfig` (look for inet address)

### 2. Start Backend Server

Make sure your Node.js backend is running:

```bash
cd ../../backend
npm install
npm run dev
```

Backend should be running on `http://localhost:5000`

### 3. Run Flutter App

```bash
flutter run
```

Choose your target device (Chrome, Android, iOS, etc.)

### 4. Test the App

1. **Register a new account:**
   - Choose role (Buyer or Seller)
   - Enter details
   - Submit

2. **Add funds to wallet:**
   - Go to Profile → Wallet
   - Add some funds (e.g., $1000)

3. **Browse auctions:**
   - View the home screen
   - See all active auctions

4. **Place a bid:**
   - Tap on an auction
   - View details
   - Place a bid
   - Watch real-time updates!

## 📁 Project Structure Summary

```
lib/
├── core/              # Config, constants, theme, utils
├── models/            # Data models (User, Auction, Bid, etc.)
├── services/          # API & Socket.IO services
├── providers/         # Riverpod state management
├── screens/           # All UI screens
├── widgets/           # Reusable components
├── routes/            # Navigation configuration
└── main.dart          # App entry point
```

## 🔑 Key Files to Know

| File | Purpose |
|------|---------|
| `lib/core/config/api_config.dart` | Backend URL & endpoints |
| `lib/routes/app_router.dart` | Navigation routes |
| `lib/providers/auth_provider.dart` | Authentication state |
| `lib/services/api_client.dart` | HTTP client with JWT |
| `lib/services/socket_service.dart` | Real-time Socket.IO |

## 🐛 Troubleshooting

### Can't connect to backend?
- ✅ Check backend is running on port 5000
- ✅ Update `api_config.dart` with correct URL
- ✅ For physical devices, use your computer's IP address

### Socket.IO not working?
- ✅ Ensure JWT tokens are valid
- ✅ Check Socket.IO URL in `api_config.dart`
- ✅ Verify backend Socket.IO is running

### Build errors?
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

## 📚 Documentation

See `ARCHITECTURE.md` for detailed documentation on:
- Architecture decisions
- Why Riverpod?
- API integration patterns
- Security features
- Real-time implementation
- And much more!

## 🎨 Customization

### Change Theme Colors
Edit `lib/core/theme/app_theme.dart`:
```dart
static const Color primaryColor = Color(0xFF2196F3);
static const Color secondaryColor = Color(0xFFFF9800);
```

### Add New Routes
Edit `lib/routes/app_router.dart`:
```dart
GoRoute(
  path: '/my-new-route',
  builder: (context, state) => MyNewScreen(),
),
```

### Add New API Endpoints
Edit `lib/core/config/api_config.dart`:
```dart
static const String myEndpoint = '/my/endpoint';
```

## ✅ Verification Checklist

Before running the app:

- [ ] Backend server is running on port 5000
- [ ] MongoDB is connected
- [ ] `api_config.dart` has correct backend URL
- [ ] Dependencies installed (`flutter pub get`)
- [ ] Code generated (`build_runner`)
- [ ] No compilation errors

## 🎉 You're Ready!

Run the app and start bidding!

```bash
flutter run
```

## 💡 Tips

1. **Test with multiple users:** Open app in multiple emulators/devices to see real-time bidding
2. **Check wallet balance:** Always ensure you have enough balance before bidding
3. **Dark mode:** Toggle in Profile settings
4. **Refresh auctions:** Pull down on home screen to refresh

## 📞 Need Help?

- Check `ARCHITECTURE.md` for detailed architecture
- Review code comments in each file
- All models are documented
- Services have clear method signatures

---

**Built with ❤️ using Flutter, Riverpod, and Socket.IO**

**Happy Bidding! 🎯**
