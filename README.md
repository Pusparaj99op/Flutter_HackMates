# EcoQuest AR Carbon Tracker

A Flutter mobile app that gamifies carbon footprint tracking with AR challenges, social leaderboards, and real-time analytics.

## 🎯 Features

- **Activity Logging**: Track food, transport, and energy consumption with CO₂ calculations
- **AR Challenges**: Complete daily AR challenges (Scan Plastic, Plant Tree, Bike Route)
- **Social Leaderboards**: Compete with friends, city, and global users
- **Gamification**: Earn points, maintain streaks, unlock badges
- **Real-time Analytics**: Weekly charts, category breakdowns, progress tracking
- **Firebase Backend**: Cloud storage, authentication, and real-time sync

## 📋 Prerequisites

Before you begin, ensure you have:

- **Flutter SDK** (3.0.0 or higher)
- **Android Studio** with Android SDK (API 26+)
- **Firebase Account** (free tier is sufficient)
- **Git** (for version control)

## 🚀 Quick Start

### 1. Install Flutter

**Option A: Using Snap (Recommended for Linux)**
```bash
sudo snap install flutter --classic
flutter doctor --android-licenses
```

**Option B: Manual Installation**
```bash
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:$HOME/flutter/bin"
flutter doctor --android-licenses
```

### 2. Clone and Setup Project

```bash
cd /home/pranay/Music/Flutter_HackMates
flutter pub get
```

### 3. Configure Firebase

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create new project: "EcoQuest AR Carbon Tracker"
3. Add Android app with package name: `com.ecoquest.carbontracker`
4. Download `google-services.json`
5. Replace the placeholder file at: `android/app/google-services.json`

**Enable Firebase Services:**
- Authentication → Enable Google Sign-In and Email/Password
- Firestore Database → Create database (production mode, us-central1)
- Realtime Database → Create database (locked mode, us-central1)
- Storage → Get started (production mode)

**Deploy Security Rules:**

Copy rules from `FIREBASE_SETUP_REFERENCE.md` and paste into:
- Firestore → Rules tab → Publish
- Realtime Database → Rules tab → Publish
- Storage → Rules tab → Publish

**Seed Initial Data:**

Follow instructions in `FIREBASE_SETUP_REFERENCE.md` Sections 5-7 to create:
- 3 challenge documents in `challenges` collection
- 3 badge documents in `badges` collection
- Leaderboard cache structure in Realtime Database

### 4. Download Assets (Optional)

The app will work without custom assets, but for the best experience:

- **Lottie Animations**: See `assets/lottie/README.md`
- **Onboarding Images**: See `assets/images/README.md`
- **Challenge Icons**: See `assets/icons/README.md`

### 5. Build and Run

**Connect Android Device or Start Emulator:**
```bash
flutter devices  # List available devices
```

**Run in Debug Mode:**
```bash
flutter run
```

**Build Release APK:**
```bash
flutter build apk --release
```

The APK will be located at: `build/app/outputs/flutter-apk/app-release.apk`

**Install on Device:**
```bash
adb install build/app/outputs/flutter-apk/app-release.apk
```

## 📱 App Structure

```
lib/
├── main.dart                          # App entry point
├── screens/
│   ├── splash_screen.dart            # 2-second splash animation
│   ├── onboarding_screen.dart        # 3-slide carousel
│   ├── auth_screen.dart              # Google + Email/Password auth
│   ├── profile_setup_screen.dart     # Name, city, commute mode
│   ├── home_dashboard_screen.dart    # CO₂ circle, streak, quick logs
│   ├── tracker_history_screen.dart   # Charts and activity list
│   ├── ar_challenges_screen.dart     # Camera + ML Kit challenges
│   └── social_screen.dart            # Friends, city, global leaderboards
├── models/
│   ├── user_model.dart               # User profile data
│   ├── activity_log_model.dart       # Activity logs with CO₂ calc
│   └── challenge_model.dart          # Challenge and completion data
├── services/
│   ├── firebase_service.dart         # Firebase initialization
│   ├── auth_service.dart             # Authentication logic
│   └── firestore_service.dart        # Database operations
└── widgets/
    ├── bottom_nav_bar.dart           # 4-tab navigation
    ├── quick_log_card.dart           # Category logging cards
    ├── leaderboard_item.dart         # Rank display with badges
    ├── challenge_card.dart           # Challenge UI component
    ├── activity_log_item.dart        # Activity display
    ├── food_log_modal.dart           # Food logging modal
    ├── transport_log_modal.dart      # Transport logging modal
    └── energy_log_modal.dart         # Energy logging modal
```

## 🔧 Configuration

### CO₂ Emission Factors

Defined in `lib/models/activity_log_model.dart`:

**Food** (g CO₂ per serving):
- Beef: 3000g
- Chicken: 800g
- Fish: 600g
- Vegetarian: 500g
- Vegan: 300g

**Transport** (g CO₂ per km):
- Car: 120g
- Bus: 40g
- Bike: 0g
- Walk: 0g

**Energy** (g CO₂ per kWh):
- Electricity: 500g
- Gas: 200g

### Points System

- **Activity Logging**: 1 point per 10g CO₂ saved
- **AR Challenges**: 50 points per challenge completion
- **Daily Limits**: 1 completion per challenge per day

### Theme Colors

- **Primary**: #4CAF50 (Green)
- **Secondary**: #2196F3 (Blue)
- **Material 3**: Enabled

## 🧪 Testing

### Test Accounts

Create test accounts in Firebase Console → Authentication → Users:

```
Email: judge1@ecoquest.demo
Password: Demo123!

Email: judge2@ecoquest.demo
Password: Demo123!

Email: judge3@ecoquest.demo
Password: Demo123!
```

### Manual Test Flow

1. **Onboarding**: Splash → 3 slides → Get Started
2. **Auth**: Sign up with email or Google
3. **Profile Setup**: Enter name, select city (Mumbai), commute mode (Bike)
4. **Dashboard**: View CO₂ circle at 0g, streak at 0 days
5. **Log Activity**: 
   - Tap Food card → Select Beef, 1 serving → Save
   - Verify: CO₂ updates to 3000g, points = 300
6. **Tracker**: View weekly bar chart, category pie chart
7. **AR Challenge**: Navigate to AR tab → Start "Scan Plastic" → Complete
8. **Social**: View leaderboards (Friends/City/Global)

## 🐛 Troubleshooting

### "flutter: command not found"
```bash
sudo snap install flutter --classic
# OR add to PATH
export PATH="$PATH:$HOME/flutter/bin"
```

### "Firebase connection failed"
- Verify `google-services.json` matches package name
- Check Firebase project has billing enabled (free tier OK)
- Wait 5 minutes for backend propagation

### "Camera permission denied"
- Android: Grant camera permission in app settings
- Check `AndroidManifest.xml` has camera permission

### "Gradle build failed"
- Run `flutter clean`
- Delete `android/.gradle` folder
- Run `flutter pub get` again

### "No devices found"
- Connect phone via USB with debugging enabled
- OR start emulator: `flutter emulators --launch <emulator_id>`

## 📊 Performance

- **First Build**: 5-10 minutes (downloads dependencies)
- **Subsequent Builds**: 30-60 seconds
- **Release APK Size**: 45-60MB
- **Hot Reload**: < 1 second

## 🔐 Security

- Firestore security rules enforce user isolation
- RTDB rules limit leaderboard writes to authenticated users
- Storage rules restrict file uploads to 10MB
- All API keys are in `google-services.json` (replace placeholder!)

## 📚 Documentation

- **Implementation Guide**: See `IMPLEMENTATION_GUIDE.md`
- **Firebase Setup**: See `FIREBASE_SETUP_REFERENCE.md`
- **Build Instructions**: See `BUILD_INSTRUCTIONS.md`
- **Specification**: See `specs/001-ar-carbon-tracker/spec.md`

## 🎨 Design System

**Material 3 Components:**
- Cards with 12px border radius
- Elevated buttons with 32px horizontal padding
- Bottom navigation with 4 tabs
- Circular progress indicators

**Typography:**
- Headlines: 24-36px, bold
- Body: 14-16px, regular
- Captions: 12px, grey

## 🚢 Deployment

### Generate Release APK

```bash
flutter build apk --release
```

### APK Location

```
build/app/outputs/flutter-apk/app-release.apk
```

### Install on Device

```bash
adb install build/app/outputs/flutter-apk/app-release.apk
```

### Hackathon Submission

1. Build release APK
2. Test on physical device
3. Record 30-second demo video
4. Take screenshots of key screens
5. Package: APK + demo video + screenshots

## 📝 License

This project is part of a hackathon submission.

## 👥 Team

Flutter HackMates

## 🙏 Acknowledgments

- Firebase for backend infrastructure
- Flutter team for the framework
- LottieFiles for animations
- Undraw for illustrations
- Flaticon for icons

---

**Ready to build?** Follow the Quick Start section above!

For detailed step-by-step instructions, see `BUILD_INSTRUCTIONS.md`.
