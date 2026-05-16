# Zerin Driver

A professional ride-sharing driver application built with Flutter. This app enables drivers to manage rides, track earnings, and provide transportation services efficiently.

## Features

- **Ride Management**: Accept, reject, and manage ride requests
- **Real-time Location Tracking**: GPS-based location tracking for accurate navigation
- **Earnings Dashboard**: Track daily earnings, bonuses, and payment history
- **Wallet Management**: Withdraw earnings, view transaction history
- **Chat Support**: In-app communication with support team and passengers
- **Trip History**: View complete ride history with detailed information
- **Multi-language Support**: English and Arabic language support
- **Dark/Light Theme**: Customizable theme options
- **Safety Features**: Emergency alerts and safety precautions
- **Push Notifications**: Real-time notifications for ride requests and updates

## Screenshots

*[Add screenshots of the app here]*
- Splash Screen
- Login/Sign Up
- Dashboard
- Ride Request
- Trip Details
- Earnings
- Wallet
- Profile

## Prerequisites

- Flutter SDK 3.3.4 or higher
- Dart SDK 3.3.4 or higher
- Android Studio / VS Code
- Android SDK 36 or higher
- iOS Xcode 15 or higher (for iOS builds)

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/raydanielg/zerin-driver-2026.git
cd zerin-driver-2026
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Configuration

#### Firebase Configuration

1. Add your `google-services.json` to `android/app/` for Android
2. Add your `GoogleService-Info.plist` to `ios/Runner/` for iOS
3. Update Firebase configuration in `lib/main.dart` with your project details

#### Google Maps Configuration

1. Get your Google Maps API key from [Google Cloud Console](https://console.cloud.google.com/)
2. Add the API key to `android/app/src/main/AndroidManifest.xml`:
   ```xml
   <meta-data
       android:name="com.google.android.geo.API_KEY"
       android:value="YOUR_API_KEY_HERE" />
   ```
3. Update `lib/util/app_constants.dart` with your polyline map key

#### App Configuration

Update the following in `lib/util/app_constants.dart`:
- `baseUrl`: Your backend API URL
- `appName`: App name (default: Zerin Driver)

## Build Instructions

### Debug Build

#### Android
```bash
flutter run
```

#### iOS
```bash
flutter run
```

### Release Build

#### Android APK
```bash
flutter build apk --release
```

#### Android App Bundle (Google Play)
```bash
flutter build appbundle --release
```

#### iOS
```bash
flutter build ios --release
```

## Project Structure

```
lib/
├── common_widgets/        # Reusable widgets
├── features/             # Feature modules
│   ├── auth/            # Authentication screens
│   ├── dashboard/       # Main dashboard
│   ├── map/             # Map and location features
│   ├── ride/            # Ride management
│   ├── splash/          # Splash screen
│   └── wallet/          # Wallet and earnings
├── helper/              # Helper functions
├── localization/        # Internationalization
├── theme/               # App themes
├── util/                # Utilities and constants
└── main.dart            # App entry point
```

## Technologies Used

- **Flutter**: 3.3.4+
- **Dart**: 3.3.4+
- **GetX**: State management and routing
- **Firebase**: Authentication, Cloud Messaging
- **Google Maps**: Maps and location services
- **Geolocator**: GPS location tracking
- **Connectivity Plus**: Network connectivity
- **Shared Preferences**: Local data storage
- **HTTP**: API requests

## API Keys Setup

### Required API Keys

1. **Google Maps API Key**: For maps and location services
2. **Firebase API Keys**: For authentication and push notifications
3. **Backend API**: For ride management and data synchronization

### Key Storage

- **Android**: `android/app/google-services.json`
- **iOS**: `ios/Runner/GoogleService-Info.plist`
- **Never commit** these files to version control

## Deep Linking

The app supports deep linking for driver location tracking:
- Scheme: `https://zerinexpress.com`
- Path: `/locate-driver`

## Release Notes

### Version 3.1.0
- Updated app branding to Zerin Driver
- Improved UI/UX with green theme
- Enhanced map styling
- Fixed crash issues on startup
- Added proper error handling for network failures
- Updated API configuration

## Troubleshooting

### Common Issues

1. **Build Errors**: Run `flutter clean` and `flutter pub get`
2. **Map Not Loading**: Verify Google Maps API key is valid
3. **Firebase Issues**: Check google-services.json configuration
4. **Network Errors**: Ensure backend URL is correct

## License

This project is proprietary software. All rights reserved.

## Support

For support and inquiries:
- Email: support@zerinexpress.com
- Website: https://zerinexpress.com

## Contributing

This is a proprietary project. External contributions are not accepted at this time.

---

**Copyright © 2026 Zerin Express. All rights reserved.**
