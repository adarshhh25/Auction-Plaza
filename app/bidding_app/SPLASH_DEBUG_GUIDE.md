# Flutter Splash Screen - Debugging Guide

## ✅ Issue Fixed

The splash screen was stuck because **`_navigateToNext()` never called navigation**. The function waited 2 seconds and exited without triggering `context.go()`.

---

## 🔧 Debugging Steps

### Step 1: Enable Verbose Logging

```powershell
# Run Flutter with verbose output
flutter run -v

# Or for more detailed logs
flutter run -v --enable-software-rendering
```

### Step 2: Check Build Status

```powershell
# Clear build cache
flutter clean

# Get dependencies
flutter pub get

# Rebuild
flutter run
```

### Step 3: Check Emulator Status

```powershell
# List connected devices
adb devices

# Restart ADB if needed
adb kill-server
adb start-server

# Check emulator logs
adb logcat | findstr flutter
```

### Step 4: Monitor Debug Console

Look for these debug prints in the console:
```
🔍 Splash: Auth Status - false/true
🔍 Splash: Loading - false/true
✅ Navigating to /login or /home
❌ Splash error: [error message]
```

---

## 🐛 Common Causes of Stuck Splash Screen

### 1. **No Explicit Navigation**
   - ❌ `await Future.delayed()` without `context.go()`
   - ✅ Always call `context.go()` or `context.push()` after delays

### 2. **API Call Blocking (Most Common)**
   - Backend not running (localhost:5000)
   - No network connection
   - Infinite timeout waiting for response
   - **Fix**: Add timeouts and fallback navigation

### 3. **initState() Blocking Operations**
   - Heavy initialization in `initState()`
   - Synchronous database operations
   - **Fix**: Move heavy operations to `Future` with timeouts

### 4. **Provider Not Updating**
   - State not changing after async operation
   - Provider disposed before navigation
   - **Fix**: Check `mounted` before navigation

### 5. **GoRouter Redirect Loop**
   - Redirect logic sends back to splash
   - No exit condition in redirect
   - **Fix**: Ensure redirect has proper exit paths

---

## 🎯 Working Splash Screen Pattern

```dart
Future<void> _navigateToNext() async {
  try {
    // 1. Show splash for minimum duration
    await Future.delayed(const Duration(seconds: 2));
    
    // 2. Check if widget still mounted
    if (!mounted) return;
    
    // 3. Get authentication state
    final authState = ref.read(authProvider);
    
    // 4. Wait for async checks (with timeout!)
    if (authState.isLoading) {
      await Future.delayed(const Duration(seconds: 1));
    }
    
    // 5. Check mounted again
    if (!mounted) return;
    
    // 6. Navigate with explicit route
    if (authState.isAuthenticated) {
      context.go('/home');
    } else {
      context.go('/login');
    }
  } catch (e) {
    // 7. ALWAYS provide fallback
    if (mounted) {
      context.go('/login');
    }
  }
}
```

---

## 🧪 Testing Navigation

### Test 1: Force Navigation to Login
```dart
// In splash_screen.dart, temporarily hardcode:
context.go('/login');
```

### Test 2: Check Auth Provider State
```dart
// Add this in _navigateToNext():
print('Auth State: ${ref.read(authProvider)}');
print('Is Authenticated: ${ref.read(authProvider).isAuthenticated}');
print('Is Loading: ${ref.read(authProvider).isLoading}');
```

### Test 3: Bypass Auth Check
```dart
// In auth_provider.dart, temporarily return:
Future<bool> isLoggedIn() async {
  return false; // Force not logged in
}
```

---

## 🚀 Quick Commands Reference

### Flutter Commands
```powershell
# Navigate to project directory
cd C:\Users\Dell\Desktop\Not-Done\Bidding-App\app\bidding_app

# Clean build
flutter clean

# Get dependencies
flutter pub get

# Run on emulator
flutter run

# Run with verbose logs
flutter run -v

# Check Flutter doctor
flutter doctor -v

# Upgrade Flutter
flutter upgrade
```

### ADB Commands
```powershell
# List devices
adb devices

# Restart ADB
adb kill-server
adb start-server

# View Flutter logs
adb logcat -s flutter

# Clear app data
adb shell pm clear com.example.bidding_app

# Restart emulator
adb reboot
```

### Emulator Commands
```powershell
# List emulators
emulator -list-avds

# Start specific emulator
emulator -avd <avd_name>

# Wipe emulator data (fresh start)
emulator -avd <avd_name> -wipe-data
```

---

## 📱 Emulator Performance Issues

### Check Emulator API Level
- Your emulator is API 36 (Android 14)
- Ensure Flutter supports this API level
- Try API 33 (Android 13) if issues persist

### Enable Hardware Acceleration
1. Open AVD Manager in Android Studio
2. Select your emulator → Edit
3. Ensure "Graphics: Hardware - GLES 2.0" is selected
4. Increase RAM to 4GB if possible

### Reduce Emulator Load
```powershell
# Run without audio
emulator -avd <name> -no-audio

# Reduce graphics load
flutter run --enable-software-rendering
```

---

## 🔍 Debugging Checklist

- [ ] Backend server running at `http://localhost:5000` (or update API config)
- [ ] Flutter dependencies installed (`flutter pub get`)
- [ ] Build cache cleared (`flutter clean`)
- [ ] ADB devices showing emulator (`adb devices`)
- [ ] No compilation errors (`flutter analyze`)
- [ ] Splash screen calls `context.go()` after delay
- [ ] Auth provider completes within timeout
- [ ] Debug prints visible in console
- [ ] Navigation routes properly configured in `app_router.dart`
- [ ] No redirect loops in GoRouter logic

---

## 🎨 Alternative: Simpler Splash Implementation

If you want a minimal splash that always works:

```dart
class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    // Wait 3 seconds, then always go to login
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    // ... your splash UI
  }
}
```

---

## 📞 Backend Connection

Your app connects to: `http://localhost:5000/api/v1`

### If Backend Not Running:
1. Navigate to backend directory:
   ```powershell
   cd C:\Users\Dell\Desktop\Not-Done\Bidding-App\backend
   ```

2. Install dependencies:
   ```powershell
   npm install
   ```

3. Start backend:
   ```powershell
   npm run dev
   ```

4. Verify backend is running:
   ```powershell
   curl http://localhost:5000/api/v1/health
   ```

### Update API Config for Physical Device:
```dart
// In lib/core/config/api_config.dart
static const String baseUrl = 'http://10.0.2.2:5000/api/v1'; // For Android emulator
// OR
static const String baseUrl = 'http://<YOUR_LOCAL_IP>:5000/api/v1'; // For physical device
```

---

## ✅ Verification

After applying the fix, you should see:

1. **Console Output:**
   ```
   🔍 Splash: Auth Status - false
   🔍 Splash: Loading - false
   ✅ Navigating to /login
   ```

2. **Expected Behavior:**
   - Splash screen shows for 2 seconds
   - App automatically navigates to login screen
   - No more infinite loading spinner

---

## 🎯 Next Steps

1. **Test the fix:**
   ```powershell
   cd C:\Users\Dell\Desktop\Not-Done\Bidding-App\app\bidding_app
   flutter run
   ```

2. **If still stuck:** Check console for debug prints and error messages

3. **If backend connection issues:** Update `api_config.dart` or disable auth check temporarily

---

**The splash screen is now fixed and includes:**
✅ Explicit navigation after delay  
✅ Timeout handling  
✅ Error fallback to login  
✅ Debug logging  
✅ Mounted checks to prevent navigation errors
