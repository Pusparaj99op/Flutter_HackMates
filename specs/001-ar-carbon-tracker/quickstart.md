# Quickstart Guide: EcoQuest AR Carbon Tracker

**Feature**: 001-ar-carbon-tracker
**Date**: 2025-12-06
**Purpose**: Setup instructions for developers and demo environment

## Prerequisites

- Dreamflow AI account (free or paid tier)
- Firebase project (free Spark plan)
- Android device or emulator (Android 8.0+ / API 26+)
- Google account for OAuth testing

## Setup Steps

### 1. Firebase Project Setup (15 minutes)

**Create Firebase Project**:
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add Project"
3. Project name: "EcoQuest AR Carbon Tracker"
4. Disable Google Analytics (optional for demo)
5. Click "Create Project"

**Enable Authentication**:
1. Navigate to Authentication → Sign-in method
2. Enable "Google" provider
   - Add support email
   - Save OAuth client configuration
3. Enable "Email/Password" provider
4. Create test accounts (optional):
   - `judge1@ecoquest.demo` / `TestPass123!`
   - `judge2@ecoquest.demo` / `TestPass123!`
   - `judge3@ecoquest.demo` / `TestPass123!`

**Enable Firestore Database**:
1. Navigate to Firestore Database
2. Click "Create database"
3. Start in **production mode** (we'll add rules)
4. Select region: `us-central1` (or closest)
5. Click "Enable"

**Enable Realtime Database**:
1. Navigate to Realtime Database
2. Click "Create Database"
3. Start in **locked mode**
4. Click "Enable"

**Enable Storage**:
1. Navigate to Storage
2. Click "Get Started"
3. Start in **production mode**
4. Click "Done"

**Download Configuration**:
1. Navigate to Project Settings (gear icon)
2. Add Android app
   - Package name: `com.ecoquest.arcarbontracker`
   - Click "Register app"
3. Download `google-services.json`
4. Save for Dreamflow integration

---

### 2. Deploy Firebase Security Rules (5 minutes)

**Firestore Rules**:
1. Navigate to Firestore → Rules tab
2. Paste content from `contracts/firebase-schema.md` (Firestore Rules section)
3. Click "Publish"

**Realtime Database Rules**:
1. Navigate to Realtime Database → Rules tab
2. Paste:
   ```json
   {
     "rules": {
       "leaderboard_cache": {
         ".read": "auth != null",
         ".write": "auth != null"
       }
     }
   }
   ```
3. Click "Publish"

**Storage Rules**:
1. Navigate to Storage → Rules tab
2. Paste content from `contracts/firebase-schema.md` (Storage Rules section)
3. Click "Publish"

---

### 3. Seed Firebase Data (10 minutes)

**Using Firebase Console**:

1. **Firestore - Create Collections**:
   - Collection: `challenges`
     - Document ID: `scan-plastic`
       ```json
       {
         "challengeId": "scan-plastic",
         "title": "Scan Plastic",
         "description": "Point camera at plastic item to detect and earn points",
         "arType": "scan",
         "pointValue": 50,
         "dailyLimit": 1,
         "iconUrl": "",
         "isActive": true
       }
       ```
     - Document ID: `plant-tree`
       ```json
       {
         "challengeId": "plant-tree",
         "title": "Plant a Tree",
         "description": "Tap ground in camera view to plant virtual tree",
         "arType": "place",
         "pointValue": 50,
         "dailyLimit": 1,
         "iconUrl": "",
         "isActive": true
       }
       ```
     - Document ID: `bike-route`
       ```json
       {
         "challengeId": "bike-route",
         "title": "Bike Route",
         "description": "Follow AR arrows for 2km eco-friendly path",
         "arType": "gps",
         "pointValue": 50,
         "dailyLimit": 1,
         "iconUrl": "",
         "isActive": true
       }
       ```

   - Collection: `badges`
     - Document ID: `streak-7`
       ```json
       {
         "badgeId": "streak-7",
         "title": "Week Warrior",
         "description": "Log activity for 7 consecutive days",
         "iconUrl": "",
         "criteria": { "type": "streak", "threshold": 7 },
         "isActive": true
       }
       ```
     - Document ID: `points-100`
       ```json
       {
         "badgeId": "points-100",
         "title": "Carbon Crusader",
         "description": "Earn 100 points from challenges",
         "iconUrl": "",
         "criteria": { "type": "points", "threshold": 100 },
         "isActive": true
       }
       ```
     - Document ID: `logs-50`
       ```json
       {
         "badgeId": "logs-50",
         "title": "Tracking Master",
         "description": "Log 50 activities",
         "iconUrl": "",
         "criteria": { "type": "logs", "threshold": 50 },
         "isActive": true
       }
       ```

2. **Realtime Database - Initialize Structure**:
   - Navigate to Realtime Database → Data tab
   - Click "+"
   - Key: `leaderboard_cache`
   - Value:
     ```json
     {
       "global": {},
       "last_updated": "2025-12-06T00:00:00Z"
     }
     ```

---

### 4. Dreamflow Project Setup (30 minutes)

**Create New Project**:
1. Log in to [Dreamflow AI](https://dreamflow.ai)
2. Click "New Project"
3. Project name: "EcoQuest AR Carbon Tracker"
4. Platform: Android
5. Template: Blank (Material 3)

**Configure Firebase Integration**:
1. In Dreamflow project settings → Integrations
2. Select "Firebase"
3. Upload `google-services.json` from Step 1
4. Enable modules:
   - Authentication (Google + Email/Password)
   - Cloud Firestore
   - Realtime Database
   - Storage
   - Cloud Messaging (for friend challenges)
5. Test connection → Should show "Connected"

**Set Theme**:
1. Navigate to Design → Theme
2. Primary color: `#4CAF50` (Green)
3. Secondary color: `#2196F3` (Ocean Blue)
4. Surface color: `#FFFFFF` (White)
5. Background: `#FAFAFA` (Light grey)
6. Corner radius: 20px
7. Typography: Roboto (default Material 3)

**Import Assets**:
1. Download assets from design resources:
   - Lottie animations:
     - `splash.json` (splash screen animation)
     - `confetti.json` (challenge completion)
   - Images:
     - Onboarding slides (3 images)
     - Challenge icons (3 icons)
     - Badge icons (3 icons)
2. Upload to Dreamflow Assets library
3. Organize in folders: `lottie/`, `onboarding/`, `icons/`

---

### 5. Build Screens (90 minutes)

Follow the component structure in `contracts/dreamflow-components.md` to build each screen:

**Order of Implementation** (prioritize P1 features):
1. ✅ **Splash Screen** (5 min)
   - Add Lottie animation component
   - Auto-navigate after 2 seconds
2. ✅ **Onboarding Screen** (10 min)
   - Add carousel with 3 slides
   - Add "Get Started" button
3. ✅ **Auth Screen** (15 min)
   - Add Google Sign-In button (Dreamflow Firebase Auth component)
   - Add email/password fields
   - Test authentication flow
4. ✅ **Profile Setup Screen** (15 min)
   - Add name input, city dropdown, commute radio
   - Create Firestore user document on submit
5. ✅ **Home Dashboard Screen** (20 min)
   - Add bottom navigation (4 tabs)
   - Add circular progress widget (bind to user.totalCO2Saved)
   - Add streak counter
   - Add 3 quick log cards
   - Add challenge card
   - Add top 3 leaderboard list
6. ✅ **Tracker History Screen** (15 min)
   - Add bar chart (Dreamflow chart component)
   - Add pie chart
   - Add activity list (Firestore query binding)
7. ✅ **AR Challenges Screen** (30 min) - **WOW FACTOR**
   - Add camera component with ML Kit
   - Add challenge selection bottom sheet
   - Implement challenge logic:
     - Scan: ML Kit object detection
     - Place: Tap gesture + sprite overlay
     - GPS: Location tracking + distance calculation
   - Add confetti animation on completion
8. ✅ **Social Screen** (20 min)
   - Add tab bar (Friends, City, Global)
   - Add search bar
   - Add leaderboard lists (RTDB binding)

**Testing Checkpoints**:
- After Auth Screen → Test login with test account
- After Profile Setup → Verify Firestore user document created
- After Home Dashboard → Verify data loads from Firestore
- After AR Challenges → Test at least 1 challenge completion

---

### 6. Implement Data Flows (30 minutes)

**Activity Logging**:
1. Create bottom sheet modal for Food/Transport/Energy
2. Add calculation logic:
   ```javascript
   // Food
   const foodFactors = { beef: 3000, chicken: 800, fish: 600, vegetarian: 300, vegan: 150 };
   co2Grams = foodFactors[mealType] * servings;

   // Transport
   const transportFactors = { car: 120, bus: 40, bike: 0, walk: 0 };
   co2Grams = transportFactors[mode] * distanceKm;

   // Energy
   const energyFactors = { electricity: 500, gas: 200 };
   co2Grams = energyFactors[source] * usageKwh;
   ```
3. On submit:
   - Create Firestore document in `logs` collection
   - Update `users/{uid}.totalCO2Saved += co2Grams`

**Challenge Completion**:
1. On AR challenge success:
   - Check daily limit: Query `challenge_completions` where `userId == uid` AND `challengeId == id` AND `dateKey == today`
   - If count < dailyLimit:
     - Create completion document
     - Update `users/{uid}.points += 50`
     - Show confetti animation

**Leaderboard Refresh**:
1. On pull-to-refresh:
   - Check RTDB `last_updated` timestamp
   - If older than 5 minutes:
     - Query Firestore `users` order by `points DESC` limit 100
     - Write to RTDB `leaderboard_cache/{global|city}`
     - Update `last_updated`

---

### 7. Build and Deploy APK (15 minutes)

**Generate APK**:
1. In Dreamflow → Build → Android
2. Build type: Release (signed)
3. Generate signing key (if first time)
4. Click "Build APK"
5. Wait 5-10 minutes for build to complete
6. Download APK file

**Test Installation**:
1. Enable "Install from Unknown Sources" on Android device
2. Transfer APK to device
3. Install and launch
4. Test full flow:
   - Onboarding → Auth → Profile Setup → Home
   - Log activity → View in tracker
   - Complete AR challenge → See points update
   - Check leaderboard → See rankings

---

## Demo Preparation

**Pre-populate Test Data** (for impressive demo):

1. Create 3 test accounts with Firebase Auth
2. For each account:
   - Complete profile setup
   - Log 10-20 activities (varied categories)
   - Complete 2-3 AR challenges
   - Add other test accounts as friends
3. Refresh leaderboards to show rankings
4. Take screenshots for presentation

**Demo Script** (30 seconds):
1. Launch app → Show splash + onboarding (5s)
2. Google Sign-In → Auto-login (2s)
3. Home dashboard → Show CO2 score, streak, leaderboard (5s)
4. Tap quick log → Log transport activity → Show calculation (5s)
5. Navigate to AR tab → Complete "Scan Plastic" challenge → Show confetti (8s)
6. Navigate to Social → Show leaderboard rankings (3s)
7. Navigate to Tracker → Show charts (2s)

**Total**: 30 seconds ✅

---

## Troubleshooting

**Issue: Firebase connection fails in Dreamflow**
- Solution: Re-upload `google-services.json`, ensure package name matches

**Issue: Google Sign-In not working**
- Solution: Add SHA-1 fingerprint in Firebase Console → Project Settings → Android app

**Issue: ML Kit object detection not detecting objects**
- Solution: Ensure good lighting, point at clear plastic items (bottles, bags)

**Issue: Leaderboard not updating**
- Solution: Manually refresh by pulling down, check RTDB rules allow writes

**Issue: Charts not displaying**
- Solution: Ensure at least 2 activity logs exist, check Firestore query bindings

---

## Next Steps

1. Implement all screens following component structure
2. Test each feature incrementally
3. Pre-populate demo data with test accounts
4. Generate APK and test on physical device
5. Record 30-second demo video
6. Prepare presentation slides highlighting:
   - Innovation (AR + sustainability)
   - Polish (Material 3 animations)
   - Impact (CO2 tracking data)
   - Demo-ready (working APK)

---

## Resources

- **Dreamflow Documentation**: https://docs.dreamflow.ai
- **Firebase Console**: https://console.firebase.google.com
- **Material 3 Design**: https://m3.material.io
- **ML Kit Documentation**: https://developers.google.com/ml-kit
- **Lottie Animations**: https://lottiefiles.com

---

## Support

For issues during implementation:
1. Check Dreamflow community forums
2. Review Firebase logs in console
3. Test with physical Android device (not emulator) for AR features
4. Refer to `contracts/dreamflow-components.md` for component details
