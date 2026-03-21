# GuardPay AI — Flutter Android App

A production-grade fintech mobile app built with Flutter (Dart).  
White + Blue theme · Material 3 · Android native.

---

## 📁 Project Structure

```
guardpay_flutter/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── theme/
│   │   └── app_theme.dart           # Colors, gradients, typography
│   ├── widgets/
│   │   └── shared_widgets.dart      # Reusable components
│   └── screens/
│       ├── login_screen.dart        # ① PIN + Face Login
│       ├── verify_screen.dart       # ② Camera Face Verification
│       ├── dashboard_screen.dart    # ③ Home Dashboard
│       ├── scan_screen.dart         # ④ Scan & Pay
│       ├── send_money_screen.dart   # ⑤ Send Money
│       ├── warning_screen.dart      # ⑥ High Risk Warning Popup
│       ├── accessibility_screen.dart# ⑦ Easy/Accessibility Mode
│       └── settings_screen.dart     # ⑧ Settings
├── android/
│   └── app/src/main/
│       └── AndroidManifest.xml
└── pubspec.yaml
```

---

## 🚀 How to Run (Step by Step)

### Prerequisites
1. Install **Flutter SDK**: https://flutter.dev/docs/get-started/install
2. Install **Android Studio**: https://developer.android.com/studio
3. Set up an **Android emulator** OR connect a real Android device with USB debugging ON

### Steps

```bash
# 1. Install Flutter SDK (if not already)
# Follow: https://flutter.dev/docs/get-started/install/linux

# 2. Clone / navigate to the project folder
cd guardpay_flutter

# 3. Install dependencies
flutter pub get

# 4. Check setup is correct
flutter doctor

# 5. List available devices
flutter devices

# 6. Run the app
flutter run

# 7. Build release APK
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

---

## 📱 Screens & Navigation

| Screen | File | Description |
|--------|------|-------------|
| ① Login | `login_screen.dart` | PIN keypad + Face Login button |
| ② Face Verify | `verify_screen.dart` | Live camera with scan animation |
| ③ Dashboard | `dashboard_screen.dart` | Balance, scan button, services, transactions |
| ④ Scan & Pay | `scan_screen.dart` | QR scanner with pay options |
| ⑤ Send Money | `send_money_screen.dart` | Receiver, amount, note, trust score |
| ⑥ Risk Warning | `warning_screen.dart` | Bottom sheet with risk reasons + consent |
| ⑦ Accessibility | `accessibility_screen.dart` | Big buttons, easy mode |
| ⑧ Settings | `settings_screen.dart` | Passkey, Face ID, devices, logout |

### Navigation Flow
```
Login ──► Face Verify ──► Dashboard
  │                          │
  ▼                     ┌────┼────┐
Accessibility         Scan  Send  Settings
                              │
                           Warning
                              │
                          Dashboard
```

---

## 🎨 Design System

### Colors
```dart
blue        = #1A6BFF   // Primary
blueDeep    = #0A4FD4   // Deep blue
blueLight   = #E8F1FF   // Light blue tint
green       = #18C97A   // Success
orange      = #FF8A2B   // Warning
red         = #FF3B55   // Danger
purple      = #7B5EFF   // Accent
dark        = #0B1A3F   // Text primary
muted       = #8496BE   // Text secondary
```

### Fonts
- **Sora** — headings, amounts, brand name
- **DM Sans** — body text, labels, buttons

---

## 🔧 Dependencies

```yaml
google_fonts: ^6.1.0     # Sora + DM Sans fonts
animate_do: ^3.3.4       # Entry animations
flutter_svg: ^2.0.9      # SVG support
cupertino_icons: ^1.0.6  # Icons
```

---

## 📦 Build APK

```bash
# Debug APK (for testing)
flutter build apk --debug

# Release APK (for distribution)
flutter build apk --release

# App Bundle (for Play Store)
flutter build appbundle --release
```

APK location: `build/app/outputs/flutter-apk/app-release.apk`

---

## 🔐 Android Permissions

The app requests:
- `CAMERA` — for Face Login / QR scanning
- `USE_BIOMETRIC` — for fingerprint/face authentication
- `INTERNET` — for UPI/payment APIs
- `VIBRATE` — for haptic feedback

---

## 📋 Notes

- This is **production-quality Flutter source code** ready to compile
- Replace placeholder UPI logic with real payment gateway SDK (Razorpay, PayU, etc.)
- Face Login animation is simulated — integrate `local_auth` package for real biometrics
- QR Scanner requires `mobile_scanner` package for real camera access

---

Made with ❤️ · GuardPay AI · v3.2.1
