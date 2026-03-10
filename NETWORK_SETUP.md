# Flutter + Backend Connection Guide

## 🌐 Network Configuration for Different Environments

### Why `localhost` Doesn't Work in Android Emulator

**Problem:** When you use `http://localhost:5000` in the Android emulator, it tries to connect to the emulator's own localhost, **not your PC's localhost**.

**Solution:** Use the special IP address `10.0.2.2` which is a pre-configured alias for the host machine's loopback interface (127.0.0.1).

```
Your PC localhost (127.0.0.1:5000)
         ↓
Android sees this as: 10.0.2.2:5000
```

---

## ✅ Configuration Already Applied

The app now automatically detects the platform and uses the correct URL:

| Environment | URL Used | When It's Used |
|------------|----------|----------------|
| **Android Emulator** | `http://10.0.2.2:5000` | Debug mode on Android |
| **iOS Simulator** | `http://localhost:5000` | Debug mode on iOS |
| **Physical Device** | `http://192.168.1.100:5000` | Debug mode on physical device* |
| **Production** | `https://api.bidmaster.com` | Release mode |

*For physical devices, update your PC's IP in `api_config.dart`

---

## 🔧 Testing the Connection

### Step 1: Start Your Backend
```powershell
cd C:\Users\Dell\Desktop\Not-Done\Bidding-App\backend
npm run dev
```

You should see:
```
🚀 Server is running on port 5000
```

### Step 2: Test Backend from PC
Open browser and go to:
```
http://localhost:5000/api/v1/health
```

Should return: `{"status": "OK"}`

### Step 3: Test Backend from Emulator
The app will now automatically use `http://10.0.2.2:5000`

### Step 4: Run Flutter App
```powershell
cd C:\Users\Dell\Desktop\Not-Done\Bidding-App\app\bidding_app
flutter run
```

Watch the console for these logs:
```
🌐 API Config: Using Android Emulator URL: http://10.0.2.2:5000
🔧 API Client initialized with baseUrl: http://10.0.2.2:5000/api/v1
┌─────────────────────────────────────────────────────────────
│ 🚀 REQUEST: POST http://10.0.2.2:5000/api/v1/auth/register
│ Headers: {Content-Type: application/json, Accept: application/json}
│ Body: {name: John Doe, email: john@test.com, ...}
└─────────────────────────────────────────────────────────────
```

---

## 🐛 Troubleshooting

### Error: "Connection refused"

**Check 1:** Is backend running?
```powershell
# In backend folder
npm run dev
```

**Check 2:** Is backend listening on all interfaces?
In `backend/src/server.ts`, ensure:
```typescript
app.listen(5000, '0.0.0.0', () => {
  console.log('Server running on port 5000');
});
```

**Check 3:** Windows Firewall blocking?
```powershell
# Allow Node.js through firewall
New-NetFirewallRule -DisplayName "Node.js Server" -Direction Inbound -LocalPort 5000 -Protocol TCP -Action Allow
```

### Error: "Connection timeout"

- Backend is not running
- Wrong port number
- Firewall blocking

### For Physical Android Device

1. **Find your PC's IP address:**
```powershell
ipconfig
```
Look for "IPv4 Address" (e.g., 192.168.1.100)

2. **Update `api_config.dart`:**
```dart
static const String _localNetworkUrl = 'http://YOUR_PC_IP:5000';
```

3. **Ensure PC and phone are on same WiFi network**

4. **Allow firewall exception** (see above)

---

## 📱 Testing Registration

### Test User Payload:
```json
{
  "name": "Test User",
  "email": "test@example.com",
  "password": "Test123!",
  "role": "bidder"
}
```

### Expected Response:
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "...",
      "name": "Test User",
      "email": "test@example.com",
      "role": "bidder"
    },
    "tokens": {
      "accessToken": "...",
      "refreshToken": "..."
    }
  }
}
```

### Check Backend Logs:
You should see in backend terminal:
```
POST /api/v1/auth/register 201
```

---

## 🎯 Quick Reference

### Android Emulator Network
- **Host machine:** `10.0.2.2`
- **Emulator's localhost:** `127.0.0.1` (different from host!)
- **Router/Gateway:** `10.0.2.1`
- **DNS:** `10.0.2.3`

### Common Ports
- Backend API: `5000`
- Socket.IO: `5000` (same server)
- MongoDB: `27017` (default)

---

## 🔍 Debug Logs You Should See

When making a register request, you'll see detailed logs:

```
🌐 API Config: Using Android Emulator URL: http://10.0.2.2:5000
🔧 API Client initialized with baseUrl: http://10.0.2.2:5000/api/v1
┌─────────────────────────────────────────────────────────────
│ 🚀 REQUEST: POST http://10.0.2.2:5000/api/v1/auth/register
│ Headers: {Content-Type: application/json, Accept: application/json}
│ Body: {name: Test User, email: test@example.com, password: ***, role: bidder}
└─────────────────────────────────────────────────────────────
📡 Dio: *** request ***
uri: http://10.0.2.2:5000/api/v1/auth/register
method: POST
...
┌─────────────────────────────────────────────────────────────
│ ✅ RESPONSE: 201 http://10.0.2.2:5000/api/v1/auth/register
│ Data: {success: true, data: {...}}
└─────────────────────────────────────────────────────────────
```

If you see connection errors, check backend is running and firewall is configured.
