# EcoQuest AR Carbon Tracker - Implementation Guide

**Project Type**: Dreamflow Visual Builder (No-Code Platform)
**Target**: 4-hour hackathon MVP
**Status**: Ready for manual execution in Dreamflow

---

## ⚠️ CRITICAL: Manual Implementation Required

This project uses **Dreamflow AI's visual builder** - a no-code platform. All implementation tasks must be executed manually through Dreamflow's web interface at https://dreamflow.ai (or similar platform URL).

**You cannot automate this implementation through code generation.**

---

## 🚀 Rapid 25-Task Implementation Plan

### Phase 1: Foundation (15 minutes) - DO THIS FIRST

#### Task 1-3: Project & Theme Setup
```
✅ T001: Open Dreamflow → Click "New Project"
  - Project Name: "EcoQuest AR Carbon Tracker"
  - Platform: Android
  - Min SDK: API 26 (Android 8.0)

✅ T002: Configure Theme
  - Settings → Theme → Material 3
  - Primary Color: #4CAF50 (green)
  - Secondary Color: #2196F3 (ocean blue)
  - Color Scheme: Light mode

✅ T003: Upload App Icon
  - Assets → Icons → Upload
  - File: Green leaf with "EQ" text logo
  - Size: 512x512px PNG with transparency
```

**Time Check**: 5 minutes elapsed

#### Task 4-6: Firebase Backend Setup
```
✅ T004-T009: Firebase Project
  1. Open Firebase Console: https://console.firebase.google.com
  2. Click "Add Project" → Name: "EcoQuest AR Carbon Tracker"
  3. Enable Google Analytics: YES (for demo metrics)
  4. Create Project (wait 30-60 seconds)

  5. Authentication Setup:
     - Build → Authentication → Get Started
     - Sign-in method → Google → Enable
     - Sign-in method → Email/Password → Enable

  6. Firestore Database:
     - Build → Firestore Database → Create Database
     - Start in: Production mode
     - Location: us-central1 (or nearest region)

  7. Realtime Database:
     - Build → Realtime Database → Create Database
     - Start in: Locked mode

  8. Storage:
     - Build → Storage → Get Started
     - Start in: Production mode

  9. Download Config:
     - Project Settings → Your Apps → Add Android App
     - Package Name: com.ecoquest.carbontracker
     - Download google-services.json
     - In Dreamflow: Settings → Firebase → Upload google-services.json
```

**Time Check**: 15 minutes elapsed

---

### Phase 2: Auth Flow (15 minutes)

#### Task 7-9: Onboarding Screens
```
✅ T028-T034: Splash & Onboarding
  1. Create Splash Screen:
     - Screens → Add Screen → Name: "Splash"
     - Add Container (fullscreen, center alignment)
     - Add Lottie Animation component
     - Animation source: assets/lottie/splash.json (placeholder: use loading spinner)
     - Duration: 3 seconds
     - On Complete → Navigate to: Onboarding Screen

  2. Create Onboarding Screen:
     - Screens → Add Screen → Name: "Onboarding"
     - Add PageView component (horizontal scroll)
     - Add 3 Container widgets as slides:

       Slide 1:
         - Image: assets/onboarding/slide1.png (placeholder: camera icon)
         - Title: "Scan Your Habits"
         - Text: "Track carbon footprint by scanning activities"

       Slide 2:
         - Image: assets/onboarding/slide2.png (placeholder: AR cube icon)
         - Title: "AR Challenges"
         - Text: "Complete fun AR challenges to earn points"

       Slide 3:
         - Image: assets/onboarding/slide3.png (placeholder: trophy icon)
         - Title: "Beat Your Friends"
         - Text: "Compete on leaderboards to save more CO2"

     - Add Button at bottom: "Get Started"
     - On Tap → Navigate to: Auth Screen
```

#### Task 10-12: Authentication Screen
```
✅ T035-T045: Auth Screen
  1. Create Auth Screen:
     - Screens → Add Screen → Name: "Auth"
     - Add Column (center alignment)
     - Add Image: Logo (placeholder: green circle)
     - Add Spacer (20px)

     - Add Button: "Continue with Google"
       - Style: Elevated
       - Icon: Google logo
       - On Tap → Firebase Auth → Google Sign-In
       - On Success → Check Firestore: users/{uid}
       - If EXISTS → Navigate to: Home Dashboard
       - If NOT EXISTS → Navigate to: Profile Setup

     - Add Divider with Text: "OR"

     - Add TextField: Email
       - Keyboard Type: Email
       - Validation: Email format

     - Add TextField: Password
       - Obscure Text: true
       - Min Length: 6

     - Add Button: "Sign In with Email"
       - On Tap → Firebase Auth → Email Sign-In
       - Same navigation logic as Google

     - Add TextButton: "Create Account"
       - On Tap → Firebase Auth → Email Register
       - Same navigation logic

     - On Error → Show SnackBar with error message
```

**Time Check**: 30 minutes elapsed

---

### Phase 3: Core MVP (45 minutes) - CRITICAL PATH

#### Task 13-15: Profile Setup & Home Dashboard
```
✅ T046-T052: Profile Setup Bottom Sheet
  1. Create Profile Setup Screen (as Modal):
     - Screens → Add Screen → Name: "ProfileSetup"
     - Presentation: Bottom Sheet (60% height)

     - Add TextField: Name
       - Max Length: 50
       - Min Length: 2
       - Validation: Required

     - Add DropdownButton: City
       - Options: ["New York", "Los Angeles", "London", "Paris",
                   "Tokyo", "Sydney", "Mumbai", "Berlin",
                   "Toronto", "Singapore"]

     - Add Wrap (Radio Chips): Commute Mode
       - Options: [
           {icon: "🚗", value: "car", label: "Car"},
           {icon: "🚌", value: "bus", label: "Bus"},
           {icon: "🚴", value: "bike", label: "Bike"},
           {icon: "🚶", value: "walk", label: "Walk"}
         ]

     - Add Button: "Complete Setup"
       - Enabled: when all fields valid
       - On Tap → Firestore Create:
         Collection: users
         Document ID: {currentUser.uid}
         Data: {
           uid: currentUser.uid,
           name: nameField.text,
           email: currentUser.email,
           city: cityDropdown.value,
           commuteMode: commuteChips.selected,
           totalCO2Saved: 0,
           points: 0,
           currentStreak: 0,
           longestStreak: 0,
           weeklyTarget: 500,
           badges: [],
           friendIds: [],
           createdAt: serverTimestamp(),
           lastLoginAt: serverTimestamp(),
           lastActivityAt: serverTimestamp()
         }
       - On Success → Navigate to: Home Dashboard

✅ T021: Bottom Navigation Bar
  - Components → Create Component → Name: "BottomNavBar"
  - Add BottomNavigationBar widget
  - Items: [
      {icon: "home", label: "Home"},
      {icon: "bar_chart", label: "Tracker"},
      {icon: "camera", label: "AR"},
      {icon: "people", label: "Social"}
    ]
  - On Tap → Navigate to respective screen

✅ T053-T059: Home Dashboard Screen
  1. Create Home Dashboard:
     - Screens → Add Screen → Name: "Home"
     - Add BottomNavBar component
     - Selected Tab: 0 (Home)

     - Add AppBar:
       - Title: "" (empty, custom content below)

     - Add SingleChildScrollView:
       - Add Column:

         1. Greeting Section:
            - Add Text: "Hello, {userName}! 👋"
            - Data Binding: Firestore Stream users/{currentUser.uid}.name
            - Font Size: 24, Weight: Bold

         2. Daily Score Circle:
            - Add CircularProgressIndicator (custom)
            - Data Binding: Firestore Stream users/{currentUser.uid}
            - Value: totalCO2Saved / weeklyTarget * 100
            - Center Text: "{totalCO2Saved}g CO2 saved 🌿"
            - Color: #4CAF50 (green)

         3. Streak Counter:
            - Add Card:
              - Leading Icon: 🔥
              - Title: "{currentStreak} day streak"
              - Subtitle: "Keep it going!"
              - Data Binding: users/{uid}.currentStreak

         4. Pull-to-Refresh:
            - Wrap Column in RefreshIndicator
            - On Refresh → Reload all Firestore streams
```

**Time Check**: 60 minutes elapsed (1 hour)

#### Task 16-20: Quick Log Modals
```
✅ T060-T073: Quick Log Cards & Food Modal
  1. Add Quick Log Section to Home:
     - Add Text: "Quick Log"
     - Add Horizontal ListView (3 cards):

       Card 1: Food 🍽️
         - On Tap → Show Modal: FoodLogModal

       Card 2: Transport 🚗
         - On Tap → Show Modal: TransportLogModal

       Card 3: Energy ⚡
         - On Tap → Show Modal: EnergyLogModal

  2. Create Food Log Modal:
     - Screens → Add Screen → Name: "FoodLogModal"
     - Presentation: Bottom Sheet (70% height)

     - Add RadioGroup: Meal Type
       - Options: ["Beef", "Chicken", "Fish", "Vegetarian", "Vegan"]

     - Add Number Input: Servings (1-10)
       - Add IconButton: - (decrement)
       - Add Text: servings
       - Add IconButton: + (increment)

     - Add TextField: Notes (optional, 200 char max)

     - Add IconButton: Camera (optional photo)
       - On Tap → Image Picker → Upload to Storage: users/{uid}/receipts/

     - Add Button: "Save Log"
       - Calculate CO2:
         co2Grams = mealType * servings
         where mealType = {
           "Beef": 3000,
           "Chicken": 800,
           "Fish": 600,
           "Vegetarian": 300,
           "Vegan": 150
         }

       - On Tap → Firestore Transaction:
         1. Create document in logs collection:
            {
              logId: auto-generated,
              userId: currentUser.uid,
              timestamp: serverTimestamp(),
              category: "food",
              co2Grams: calculated value,
              details: {
                mealType: selected,
                servings: input value
              },
              notes: textField.text,
              photoUrl: uploaded URL or null
            }

         2. Update users/{uid}:
            - totalCO2Saved = totalCO2Saved + co2Grams
            - lastActivityAt = serverTimestamp()

       - On Success:
         - Close modal
         - Show SnackBar: "{co2Grams}g CO2 logged! 🌿"

✅ T074-T080: Transport Log Modal
  - Similar structure to Food Modal
  - RadioGroup: Mode ["Car", "Bus", "Bike", "Walk"]
  - Number Input: Distance (km, decimal allowed)
  - CO2 Calculation:
    co2Grams = mode * distanceKm
    where mode = {"Car": 120, "Bus": 40, "Bike": 0, "Walk": 0}

✅ T081-T086: Energy Log Modal
  - Number Input: Usage (kWh)
  - RadioGroup: Source ["Electricity", "Gas"]
  - CO2 Calculation:
    co2Grams = source * usageKwh
    where source = {"Electricity": 500, "Gas": 200}
```

**Time Check**: 90 minutes elapsed (1.5 hours)

---

### Phase 4: Charts & AR (45 minutes) - JUDGE IMPRESSER

#### Task 21-23: Tracker History Screen
```
✅ T148-T165: Tracker Screen with Charts
  1. Create Tracker Screen:
     - Screens → Add Screen → Name: "Tracker"
     - Add BottomNavBar component
     - Selected Tab: 1 (Tracker)

     - Add AppBar:
       - Title: "Activity History"

     - Add SingleChildScrollView:
       - Add Column:

         1. Weekly Bar Chart:
            - Add Chart component: BarChart
            - Data Source: Firestore Query
              Collection: logs
              Where: userId == currentUser.uid
              Where: timestamp >= 7 days ago
              Order By: timestamp DESC

            - Data Transformation:
              Group by: date (YYYY-MM-DD)
              Aggregate: SUM(co2Grams) per day

            - X-Axis: Day labels (Mon-Sun)
            - Y-Axis: CO2 grams
            - Bar Color: #4CAF50 (green)
            - Add Line: Weekly Target (weeklyTarget / 7)

         2. Category Pie Chart:
            - Add Chart component: PieChart
            - Data Source: Same Firestore Query

            - Data Transformation:
              Group by: category
              Aggregate: SUM(co2Grams) per category

            - Slices:
              - Transport: Green #4CAF50
              - Food: Orange #FF9800
              - Energy: Blue #2196F3

            - Show Percentages: true
            - Show Labels: true

         3. Recent Activity List:
            - Add Text: "Recent Activity"
            - Add ListView.Builder:
              - Data Source: Same Firestore Query
              - Item Template: Activity Log Item component
              - Fields: category icon, co2Grams, timestamp, details
              - On Tap Item → Show Edit Modal (optional)

         4. Export FAB:
            - Add FloatingActionButton (bottom-right)
            - Icon: share
            - On Tap:
              - Capture Screenshot of charts section
              - Add Watermark: "EcoQuest | {date range}"
              - Open Android Share Sheet
              - Share as: Image
```

#### Task 24-25: AR Challenges Screen
```
✅ T089-T119: AR Challenges
  1. Create AR Screen:
     - Screens → Add Screen → Name: "ARChallenges"
     - Add BottomNavBar component
     - Selected Tab: 2 (AR)

     - Add AppBar:
       - Title: "AR Challenges"
       - Subtitle: "Complete challenges to earn points"

     - Add Challenge Progress Card:
       - Text: "{completedCount}/3 challenges today"
       - Data Binding: Firestore Query
         Collection: challenge_completions
         Where: userId == currentUser.uid
         Where: dateKey == today (format: YYYY-MM-DD)
       - Count documents

     - Add Total Points Card:
       - Text: "{totalPoints} points earned today"
       - Calculate: SUM(pointsAwarded) from above query

  2. Add Challenge List:
     - Add ListView:
       - Data Source: Firestore Collection "challenges"
       - For each challenge:

         Challenge Card:
           - Icon: challenge.icon
           - Title: challenge.title
           - Description: challenge.description
           - Point Value: "+{challenge.pointValue} points"
           - Status:
             - IF completed today: "Completed ✓"
             - ELSE: "Start Challenge" button

  3. Challenge 1: Scan Plastic
     - On "Start Challenge" Tap:
       - Open Camera Preview (fullscreen)
       - Enable ML Kit Object Detection
       - Add Overlay: "Scan a plastic item..."

       - On ML Kit Detects "bottle" OR "plastic":
         - Show Green Checkmark Animation (2s)
         - Before awarding points:
           - Query: challenge_completions
             Where: userId == uid
             Where: challengeId == "scan-plastic"
             Where: dateKey == today
           - IF count < 1:
             - Create challenge_completion document
             - Update users/{uid}.points += 50
             - Show Confetti Animation
             - Show Modal: "Challenge Complete! +50 points 🎉"
           - ELSE:
             - Show Modal: "Daily limit reached! Try tomorrow."

  4. Challenge 2: Plant Tree
     - On "Start Challenge" Tap:
       - Open Camera Preview
       - Add Overlay: "Tap to plant a tree..."

       - On Screen Tap:
         - Play 2D Tree Grow Animation at tap location
         - 5 frames: seedling → small tree → full tree (2s)
         - Award points (same logic as Challenge 1)

  5. Challenge 3: Bike Route
     - On "Start Challenge" Tap:
       - Request Location Permission
       - IF denied: Show error, return
       - IF granted:
         - Open Camera Preview
         - Capture starting GPS coordinates
         - Add Overlay: Directional Arrow + "Distance: 0.0 km"

         - Continuously:
           - Get current GPS
           - Calculate distance from start
           - Update overlay text

         - When distance >= 2.0 km:
           - Award points (same logic as Challenge 1)
```

**Time Check**: 135 minutes elapsed (2.25 hours)

---

### Phase 5: Social & Polish (60 minutes) - WINNER POLISH

#### Task 26-28: Social Leaderboards
```
✅ T120-T147: Social Screen
  1. Create Social Screen:
     - Screens → Add Screen → Name: "Social"
     - Add BottomNavBar component
     - Selected Tab: 3 (Social)

     - Add TabBar (3 tabs):
       - Tab 1: "Friends"
       - Tab 2: "City"
       - Tab 3: "Global"

  2. Friends Tab:
     - Add SearchBar: "Search by email"
     - On Search:
       - Query: Firestore users
       - Where: email LIKE searchInput
       - Exclude: currentUser
       - Show Results:
         - Avatar, Name, Email
         - Button: "Add Friend"
         - On Tap → Create friendship document

     - Add Friends List:
       - Query: friendships
       - Where: (userId1 == uid OR userId2 == uid)
       - Where: status == "accepted"
       - Show:
         - Friend avatar, name, points, totalCO2Saved
         - Button: "Challenge Friend" → Send FCM notification

  3. City Leaderboard Tab:
     - Data Source: RTDB leaderboard_cache/{userCity}
     - Order By: points DESC
     - Limit: 100

     - Add ListView.Builder:
       - Item Template: Leaderboard Item
       - Fields: rank badge (🥇🥈🥉 for top 3), name, points, city

     - Add Pull-to-Refresh:
       - Check RTDB last_updated timestamp
       - IF older than 5 minutes:
         - Query Firestore users
         - Where: city == userCity
         - Order By: points DESC
         - Limit: 100
         - Assign ranks (1-indexed)
         - Write to RTDB: leaderboard_cache/{city}/{uid: {name, points, rank}}
         - Update last_updated

  4. Global Leaderboard Tab:
     - Same structure as City, but:
       - Data Source: RTDB leaderboard_cache/global
       - Firestore Query: users (all cities)
       - Show: rank, name, points, city

✅ T143-T147: Top 3 on Home Dashboard
  - Add "Top 3 Leaderboard" section to Home Screen
  - Query: RTDB leaderboard_cache/{userCity}
  - Order By: points DESC
  - Limit: 3
  - Show rank badges (🥇🥈🥉)
  - Add Button: "View All" → Navigate to Social Screen (City tab)
  - Use StreamBuilder for real-time updates
```

#### Task 29-31: Animations & Offline Support
```
✅ T184-T188: Animations
  1. Lottie Animations:
     - Splash Screen: Already configured (T029)
     - Confetti: On challenge completion (T101, T107, T116)
     - Duration: 3 seconds

  2. Hero Animations:
     - Quick Log Cards → Log Modals
     - Challenge Cards → AR Camera View
     - Add Hero widget wrapper with unique tags

  3. Haptic Feedback:
     - On all button taps
     - Add: HapticFeedback.lightImpact()

  4. Skeleton Loaders:
     - Add to Friends List, Leaderboards, Activity List
     - Show while Firestore query loading
     - Component: Shimmer effect (gray → white gradient)

✅ T189-T192: Offline Support
  1. Enable Firestore Persistence:
     - Settings → Firebase → Firestore
     - Enable Offline Persistence: true
     - Cache Size: 100 MB

  2. Add Offline Indicator:
     - Add AppBar banner (top of Home Screen)
     - Show when: no internet connection
     - Text: "Offline Mode - Data will sync when online"
     - Color: Orange #FF9800

  3. Pre-load Queries:
     - On App Launch (main.dart equivalent):
       - Query: users/{uid}
       - Query: challenges
       - Query: badges
       - Query: leaderboard_cache/{city}
     - These populate local cache

✅ T193-T197: Error Handling
  1. Network Errors:
     - Add SnackBar component for all Firestore operations
     - On Error: Show "Network error. Retrying..." with Retry button

  2. Camera Permission:
     - On AR Screen load: Request camera permission
     - IF denied:
       - Show Dialog: "Camera required for AR. Enable in Settings?"
       - Disable AR tab
       - Allow manual logging only

  3. Location Permission:
     - On Bike Route challenge start
     - IF denied: Show error, disable GPS challenges

  4. Form Validation:
     - All text fields: Show red error text below
     - Examples:
       - "Name must be 2+ characters"
       - "Email format invalid"
       - "Password must be 6+ characters"
```

**Time Check**: 195 minutes elapsed (3.25 hours)

---

### Phase 6: Demo Preparation (45 minutes) - FINAL PUSH

#### Task 32-34: Firebase Data Seeding
```
✅ T013-T015, T019: Seed Data & Test Accounts
  1. Seed Challenges (Firestore Console):
     - Collection: challenges

     Document 1:
       challengeId: "scan-plastic"
       title: "Scan Plastic"
       description: "Find and scan a plastic item"
       arType: "scan"
       pointValue: 50
       dailyLimit: 1
       icon: "🔍"

     Document 2:
       challengeId: "plant-tree"
       title: "Plant Tree"
       description: "Tap to plant a virtual tree"
       arType: "place"
       pointValue: 50
       dailyLimit: 1
       icon: "🌳"

     Document 3:
       challengeId: "bike-route"
       title: "Bike Route"
       description: "Complete a 2km bike route"
       arType: "gps"
       pointValue: 50
       dailyLimit: 1
       icon: "🚴"

  2. Seed Badges:
     - Collection: badges

     Document 1:
       badgeId: "streak-7"
       title: "Week Warrior"
       description: "7-day streak"
       criteria: {type: "streak", threshold: 7}
       icon: "🔥"

     Document 2:
       badgeId: "points-100"
       title: "Century Club"
       description: "100 points earned"
       criteria: {type: "points", threshold: 100}
       icon: "💯"

     Document 3:
       badgeId: "logs-50"
       title: "Dedicated Logger"
       description: "50 activities logged"
       criteria: {type: "logs", threshold: 50}
       icon: "📊"

  3. Initialize RTDB Leaderboard:
     - Realtime Database → Data Tab
     - Create: leaderboard_cache/global/
       {
         last_updated: {".sv": "timestamp"}
       }

  4. Create Test Accounts (Firebase Auth Console):
     - Authentication → Users → Add User

     Account 1:
       Email: judge1@ecoquest.demo
       Password: Demo123!

     Account 2:
       Email: judge2@ecoquest.demo
       Password: Demo123!

     Account 3:
       Email: judge3@ecoquest.demo
       Password: Demo123!

  5. Pre-populate Test Data:
     - Sign in as judge1@ecoquest.demo
     - Complete profile setup
     - Log 10 activities (mix of food, transport, energy)
     - Complete 2 AR challenges
     - Repeat for judge2 and judge3
     - Add friendships between accounts
```

#### Task 35-37: Security Rules & APK Build
```
✅ T010-T012: Deploy Security Rules
  1. Firestore Rules:
     - Firebase Console → Firestore → Rules Tab
     - Copy from: specs/001-ar-carbon-tracker/contracts/firebase-schema.md
     - Paste and Publish

  2. Realtime Database Rules:
     - Firebase Console → RTDB → Rules Tab
     - Copy from: contracts/firebase-schema.md
     - Paste and Publish

  3. Storage Rules:
     - Firebase Console → Storage → Rules Tab
     - Copy from: contracts/firebase-schema.md
     - Paste and Publish

✅ T210-T211: Generate APK
  1. Build APK:
     - Dreamflow → Build → Android
     - Build Type: Release
     - Version: 1.0.0
     - Build Number: 1
     - Click "Generate APK"
     - Wait 5-10 minutes for build

  2. Download APK:
     - Save to: Downloads/ecoquest-v1.0.0.apk

  3. Test Install:
     - Connect Android device (USB debugging enabled)
     - adb install ecoquest-v1.0.0.apk
     - OR: Transfer APK to device → Open → Install

  4. Test Full Flow:
     - Launch app → Onboarding → Google Auth → Profile Setup
     - View Home Dashboard (verify data loads)
     - Log activity → Verify CO2 updates
     - Complete AR challenge → Verify points
     - View Tracker charts
     - View Social leaderboards
     - Test offline mode (airplane mode)
```

#### Task 38: Record Demo Video
```
✅ T212: 30-Second Demo Video
  1. Screen Recording Setup:
     - Android device: Quick Settings → Screen Record
     - OR: ADB screenrecord: adb shell screenrecord /sdcard/demo.mp4

  2. Demo Script (30 seconds):
     [0:00-0:05] Launch app → Splash → Onboarding swipe → Get Started
     [0:05-0:10] Google Sign-In (pre-authed) → Dashboard appears
     [0:10-0:15] Tap Food card → Select Beef, 1 serving → Save → See +3000g CO2
     [0:15-0:20] Tap AR tab → Tap "Scan Plastic" → Point at bottle → Success animation
     [0:20-0:25] Tap Social tab → See City Leaderboard with rankings
     [0:25-0:30] Tap Tracker → See charts → Tap Export → Share sheet opens

  3. Save & Export:
     - Save recording
     - Transfer to computer
     - Upload to Google Drive / YouTube (unlisted)
     - Add to demo presentation
```

**Time Check**: 240 minutes elapsed (4 hours) ✅

---

## 🎯 MVP Checklist - VALIDATION BEFORE DEMO

```
FOUNDATION:
✅ [ ] Dreamflow project created
✅ [ ] Firebase project connected (test write/read works)
✅ [ ] Material 3 theme applied (#4CAF50 green)
✅ [ ] Bottom navigation switches between screens

AUTH FLOW:
✅ [ ] Splash screen shows for 3s
✅ [ ] Onboarding carousel has 3 slides
✅ [ ] Google Sign-In works
✅ [ ] Profile setup saves to Firestore
✅ [ ] Home Dashboard loads after auth

CORE FEATURES:
✅ [ ] Quick log cards open modals
✅ [ ] Food/Transport/Energy modals calculate CO2
✅ [ ] Logs save to Firestore
✅ [ ] Home dashboard circular progress updates in real-time
✅ [ ] Streak counter shows current streak

AR CHALLENGES:
✅ [ ] AR tab shows 3 challenge cards
✅ [ ] At least 1 challenge completes successfully
✅ [ ] Points awarded on challenge completion
✅ [ ] Confetti animation plays on success
✅ [ ] Daily limit enforced (can't repeat same challenge)

SOCIAL:
✅ [ ] City leaderboard shows rankings
✅ [ ] Top 3 appear on Home Dashboard
✅ [ ] Friend search works
✅ [ ] Real-time updates when new data added

ANALYTICS:
✅ [ ] Tracker screen shows weekly bar chart
✅ [ ] Category pie chart displays percentages
✅ [ ] Recent activity list populates
✅ [ ] Export screenshot works

POLISH:
✅ [ ] Animations smooth (60fps)
✅ [ ] Offline indicator shows when no internet
✅ [ ] Error messages display for failures
✅ [ ] App works offline (data syncs when online)

DEMO READY:
✅ [ ] 3 test accounts created with data
✅ [ ] APK installs on Android device
✅ [ ] 30-second demo flow completes successfully
✅ [ ] Screen recording saved
```

---

## 📁 Asset Requirements

You'll need to create or download these assets before implementation:

### Required Assets:

1. **App Icon** (`assets/icons/app-icon.png`):
   - 512x512px PNG with transparency
   - Green leaf with "EQ" text logo
   - Source: Create in Canva or Figma

2. **Lottie Animations**:
   - `assets/lottie/splash.json`: Loading/leaf animation
   - `assets/lottie/confetti.json`: Celebration animation
   - Source: https://lottiefiles.com (search "loading leaf" and "confetti")

3. **Onboarding Slides**:
   - `assets/onboarding/slide1.png`: Camera/scanning illustration
   - `assets/onboarding/slide2.png`: AR cube illustration
   - `assets/onboarding/slide3.png`: Trophy/leaderboard illustration
   - Size: 1080x1920px (portrait)
   - Source: Undraw.co or Storyset.com

4. **Challenge Icons** (optional, can use emojis):
   - `assets/icons/scan-plastic.png`: 🔍 magnifying glass
   - `assets/icons/plant-tree.png`: 🌳 tree
   - `assets/icons/bike-route.png`: 🚴 bicycle

### Quick Asset Creation:

If you're short on time, use **emoji placeholders** in Dreamflow:
- Onboarding slides: Use large emoji (📸 📱 🏆) with text below
- Challenge icons: Use emoji directly in Dreamflow text widgets
- App icon: Use Material Icons "eco" icon with green background

---

## 🚨 Troubleshooting Guide

### Problem: Firebase connection fails
**Solution**:
- Verify google-services.json uploaded correctly
- Check Firebase project region matches Dreamflow settings
- Ensure Android package name matches (com.ecoquest.carbontracker)
- Test with: Settings → Firebase → Test Connection button

### Problem: AR challenges not working
**Solution**:
- Fallback: Use static image challenges (tap to complete)
- For ML Kit: Ensure camera permissions granted
- For GPS: Test in outdoor environment with clear sky
- Simplify: Award points on tap instead of actual detection

### Problem: Charts loading slowly
**Solution**:
- Use mock data JSON first (hardcoded arrays)
- Limit query to last 7 days only
- Add skeleton loaders while loading
- Cache chart data in app state

### Problem: Authentication stuck
**Solution**:
- Check Firebase Auth providers enabled (Google + Email)
- Use Email/Password fallback if Google fails
- Verify SHA-1 fingerprint registered in Firebase Console
- Test with incognito browser first

### Problem: Running out of time
**Solution**:
- **PRIORITY**: Get Home Dashboard + Logging working (T001-T020)
- **SKIP**: Social features (use mock leaderboard data)
- **SKIP**: Detailed analytics (show simple list instead)
- **SIMPLIFY**: AR to tap-to-complete instead of detection
- **FOCUS**: Demo-ready APK with 1-2 core features working flawlessly

---

## 📊 Time Allocation Breakdown

| Phase | Tasks | Time | Cumulative | Critical? |
|-------|-------|------|------------|-----------|
| Foundation | T001-T009 | 15 min | 0:15 | 🔥 YES |
| Auth Flow | T028-T045 | 30 min | 0:45 | 🔥 YES |
| Home Dashboard | T046-T059 | 30 min | 1:15 | 🔥 YES |
| Quick Logging | T060-T086 | 45 min | 2:00 | 🔥 YES |
| Charts | T148-T165 | 30 min | 2:30 | ⭐ HIGH |
| AR Challenges | T089-T119 | 45 min | 3:15 | ⭐ HIGH |
| Social | T120-T147 | 30 min | 3:45 | 💡 NICE |
| Polish | T184-T201 | 15 min | 4:00 | 💡 NICE |

**🔥 CRITICAL = Must have for MVP**
**⭐ HIGH = Needed for judge impression**
**💡 NICE = Bonus if time permits**

---

## 🏁 Definition of Done

Project is **COMPLETE** when:

1. ✅ APK builds successfully from Dreamflow
2. ✅ APK installs on Android 8.0+ device without crashes
3. ✅ 30-second demo video recorded showing:
   - Auth flow (0-10s)
   - Log activity (10-15s)
   - Complete AR challenge (15-20s)
   - View leaderboard (20-25s)
   - Show charts (25-30s)
4. ✅ 3 test accounts created with sample data
5. ✅ Firebase backend deployed with security rules
6. ✅ All critical MVP checklist items marked ✅

---

## 📞 Support Resources

- **Dreamflow Documentation**: https://docs.dreamflow.ai (check platform-specific docs)
- **Firebase Console**: https://console.firebase.google.com
- **Firebase Security Rules**: https://firebase.google.com/docs/rules
- **ML Kit Android**: https://developers.google.com/ml-kit
- **Material 3 Design**: https://m3.material.io
- **Lottie Files**: https://lottiefiles.com

---

## 🎓 Key Learnings for Next Hackathon

1. **Start with Firebase setup first** - It's the most time-consuming blocker
2. **Use emojis for icons** - Saves design time
3. **Test auth flow immediately** - Auth bugs waste hours
4. **Simplify AR** - Tap-to-complete > complex detection
5. **Mock data is OK** - Hardcoded leaderboards work for demos
6. **APK build takes 10 minutes** - Budget time accordingly
7. **Record demo early** - Do a practice run at 3-hour mark

---

**You've got this! Follow the tasks in order, don't skip Firebase setup, and prioritize the critical path. Good luck! 🚀**
