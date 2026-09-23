# NAQDA Aquaculture Flutter App

Quick start:

```bash
# install deps
flutter pub get

# generate firebase options (after installing FlutterFire CLI)
flutter pub global activate flutterfire_cli
flutterfire configure

# run
flutter run
```

Files of interest:
- `lib/main.dart` - app entry
- `lib/services/auth_service.dart` - Firebase Auth wrapper
- `lib/screens/login_screen.dart` - login UI (email + phone OTP)
- `lib/firebase_options.dart` - placeholder; replace with generated file
