# Firebase Setup & Flutter Auth Integration

This guide walks through creating a Firebase project, enabling authentication (Email/Password and Phone OTP), adding platform apps, configuring native files, and wiring Firebase Auth in a Flutter app.

Sections:
- Create Firebase Project
- Add Android/iOS Apps
- Configure Flutter Project
- Add Dependencies
- Initialize Firebase in Flutter
- Implement AuthService (Email & Phone OTP)
- Create Login UI

## 1. Create Firebase Project
1. Go to https://console.firebase.google.com/ and click "Add project".
2. Enter a project name (e.g., `naqda-aquaculture`) and follow the prompts.
3. (Optional) Enable Google Analytics for the project.

## 2. Add Android and iOS Apps
### Android
1. In Firebase console, click the Android icon to add an app.
2. Enter your Android package name (from `android/app/src/main/AndroidManifest.xml`, e.g., `com.example.aquaculture_app`).
3. Download `google-services.json` and place it into `android/app/`.
4. Add SHA-1 (and SHA-256) in the Firebase project settings if you plan to use phone auth or Google sign-in. You can get SHA with:

```bash
# debug key
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

### iOS
1. Click the iOS icon in Firebase and register your app with the `iosBundleId` (from `ios/Runner/Info.plist`).
2. Download `GoogleService-Info.plist` and place it into `ios/Runner/` using Xcode (drag into project).
3. For Phone Auth on iOS, enable the APNs key in Firebase and upload it.

## 3. Enable Authentication Providers
1. In Firebase Console, open `Authentication` → `Sign-in method`.
2. Enable `Email/Password`.
3. Enable `Phone` (for OTP) and configure reCAPTCHA or APNs as required.

## 4. Configure Native Projects
### Android (`android/build.gradle`)
Add classpath:

```gradle
buildscript {
  dependencies {
    classpath 'com.google.gms:google-services:4.3.15' // version may vary
  }
}
```

In `android/app/build.gradle` add at the bottom:

```gradle
apply plugin: 'com.google.gms.google-services'
```

### iOS
Ensure iOS minimum deployment target in `ios/Podfile` is at least 11.0 and run `pod install` in `ios/` after adding packages.

## 5. Add Flutter Dependencies
In your Flutter app's `pubspec.yaml` add:

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^2.7.0
  firebase_auth: ^4.6.0
  cloud_firestore: ^4.6.0 # optional
  firebase_storage: ^11.2.0 # optional
  provider: ^6.1.4 # or any state management
```

Run:

```bash
flutter pub get
```

## 6. Initialize Firebase in Flutter
Edit `lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // generated via FlutterFire CLI

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}
```

To generate `firebase_options.dart`, use the FlutterFire CLI:

```bash
flutter pub global activate flutterfire_cli
flutterfire configure
```

## 7. Implement AuthService (Email & Phone OTP)
Create `lib/services/auth_service.dart` with methods for signUp, signIn (email), signOut, sendPhoneVerification, verifySmsCode.

## 8. Create Login UI
Create `lib/screens/login_screen.dart` with a simple UI to switch between Email & Phone login modes, show errors, and navigate on success.

---

See the sample implementation files in this folder for a working example.
