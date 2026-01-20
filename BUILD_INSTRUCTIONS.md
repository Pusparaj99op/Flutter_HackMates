# 🚀 EcoQuest AR Carbon Tracker - Build Instructions

**Generated**: 2025-12-06
**Platform**: Flutter (Android)
**Build Time**: 15-20 minutes

---

## ✅ **Step 1: Install Flutter** (10 minutes)

### On Linux (Ubuntu/Debian):

```bash
# Install Flutter via snap (recommended)
sudo snap install flutter --classic

# Or download manually
cd ~
git clone https://github.com/flutter/flutter.git -b stable
echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc
source ~/.bashrc

# Verify installation
flutter --version
```

### Accept Android licenses:
```bash
flutter doctor --android-licenses
# Press 'y' to accept all licenses
```

---

## ✅ **Step 2: Install Android Studio** (if not installed)

```bash
# Download Android Studio
wget https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2023.1.1.26/android-studio-2023.1.1.26-linux.tar.gz

# Extract
tar -xzf android-studio-*.tar.gz -C ~/

# Run Android Studio
~/android-studio/bin/studio.sh

# In Android Studio:
# - Install Android SDK (API 33 or higher)
# - Install Android SDK Command-line Tools
# - Create a virtual device (AVD) or connect physical device
```

---

## ✅ **Step 3: Get Firebase Configuration**

### Create Firebase Project:
1. Go to https://console.firebase.google.com
2. Click "Add Project" → Name: "EcoQuest AR Carbon Tracker"
3. Enable Google Analytics (optional)
4. Click "Create project"

### Add Android App:
1. Click Android icon in Firebase Console
2. Package name: `com.ecoquest.carbontracker`
3. Download `google-services.json`
4. Place file here: `/home/pranay/Music/Flutter_HackMates/android/app/google-services.json`

### Enable Firebase Services:
1. **Authentication**: Enable Google Sign-In and Email/Password
2. **Firestore Database**: Create in production mode (us-central1)
3. **Realtime Database**: Create in locked mode
4. **Storage**: Enable in production mode

---

## ✅ **Step 4: Install Dependencies**

```bash
cd /home/pranay/Music/Flutter_HackMates

# Get Flutter packages
flutter pub get

# Check for any issues
flutter doctor
```

---

## ✅ **Step 5: Build the APK**

### Option A: Debug APK (faster, for testing)
```bash
flutter build apk --debug
```
**Output**: `build/app/outputs/flutter-apk/app-debug.apk`

### Option B: Release APK (optimized, for distribution)
```bash
flutter build apk --release
```
**Output**: `build/app/outputs/flutter-apk/app-release.apk`

---

## ✅ **Step 6: Install on Device**

### Via USB (physical device):
```bash
# Enable USB debugging on your Android phone
# Connect via USB cable

# Install APK
flutter install

# Or manually:
adb install build/app/outputs/flutter-apk/app-release.apk
```

### Via Emulator:
```bash
# Start emulator
flutter emulators --launch <emulator_id>

# Install and run
flutter run
```

---

## ✅ **Step 7: Run the App**

```bash
# Run in debug mode with hot reload
flutter run

# Or just launch the installed APK on your device
```

---

## 🔧 **Troubleshooting**

### Issue: "Firebase not configured"
**Fix**: Make sure `google-services.json` is in `android/app/` directory

### Issue: "SDK not found"
**Fix**: Run `flutter doctor` and follow suggestions

### Issue: "Gradle build failed"
**Fix**:
```bash
cd android
./gradlew clean
cd ..
flutter build apk
```

### Issue: "No connected devices"
**Fix**:
- Enable USB debugging on Android phone
- Run `adb devices` to check connection
- Or start an emulator: `flutter emulators --launch <name>`

---

## 📱 **Quick Test Commands**

```bash
# Check Flutter setup
flutter doctor -v

# List connected devices
flutter devices

# Run app with specific device
flutter run -d <device-id>

# Build and profile performance
flutter run --profile

# Generate release APK
flutter build apk --release --target-platform android-arm64
```

---

## 🎯 **Expected Build Times**

- **First build**: 5-10 minutes (downloads dependencies)
- **Subsequent builds**: 30-60 seconds (incremental)
- **Release APK**: 2-3 minutes
- **APK size**: ~45-60MB

---

## ✅ **Success Criteria**

After successful build, you should have:
- ✅ APK file in `build/app/outputs/flutter-apk/`
- ✅ App installs on Android 8.0+ devices
- ✅ App launches without crashes
- ✅ Firebase services connected (after configuration)

---

## 📞 **Next Steps**

1. **Build the APK**: `flutter build apk --release`
2. **Test on device**: Install and verify all screens work
3. **Configure Firebase**: Follow FIREBASE_SETUP_REFERENCE.md for security rules and seed data
4. **Demo ready**: App is functional with local data, cloud sync requires Firebase setup

---

**Need help?** Check `flutter doctor` output or review error logs in terminal.
