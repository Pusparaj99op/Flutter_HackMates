# ⚡ Quick Start Checklist - EcoQuest AR Carbon Tracker

**Goal**: Build hackathon MVP in 4 hours
**Platform**: Dreamflow Visual Builder (No-Code)
**Read Full Guide**: [IMPLEMENTATION_GUIDE.md](./IMPLEMENTATION_GUIDE.md)

---

## ✅ Pre-Implementation Setup (10 minutes)

- [ ] Create Firebase account at https://console.firebase.google.com
- [ ] Create Dreamflow account at https://dreamflow.ai (or platform URL)
- [ ] Download required assets:
  - [ ] App icon (512x512px green leaf logo)
  - [ ] Lottie animations: splash.json, confetti.json from https://lottiefiles.com
  - [ ] Onboarding images (3 slides) from https://undraw.co
- [ ] Prepare Android device for testing (enable USB debugging)
- [ ] Bookmark: [Firebase Console](https://console.firebase.google.com)
- [ ] Bookmark: [Dreamflow Dashboard](https://dreamflow.ai)

---

## 🚀 Hour 1: Foundation + Auth (60 minutes)

### Minutes 0-15: Project Setup
- [ ] **T001**: Dreamflow → New Project → "EcoQuest AR Carbon Tracker" → Android
- [ ] **T002**: Settings → Theme → Material 3 → Primary: #4CAF50 → Secondary: #2196F3
- [ ] **T003**: Assets → Upload app icon

### Minutes 15-30: Firebase Backend
- [ ] **T004**: Firebase Console → Add Project → "EcoQuest AR Carbon Tracker"
- [ ] **T005**: Enable Authentication (Google + Email/Password)
- [ ] **T006**: Create Firestore Database (production, us-central1)
- [ ] **T007**: Create Realtime Database (locked mode)
- [ ] **T008**: Enable Storage
- [ ] **T009**: Download google-services.json → Upload to Dreamflow

### Minutes 30-45: Onboarding Screens
- [ ] **T028**: Create Splash Screen → Lottie animation → 3s auto-navigate
- [ ] **T030**: Create Onboarding Screen → PageView → 3 slides → "Get Started" button

### Minutes 45-60: Auth Screen
- [ ] **T035**: Create Auth Screen → Google Sign-In button → Email/Password fields
- [ ] **T037**: Connect Firebase Auth → On success → Check Firestore users/{uid}
- [ ] **T044**: Navigate logic: Profile exists? → Home : Profile Setup

**✅ CHECKPOINT**: Test auth flow from splash to home

---

## 🏗️ Hour 2: Core MVP (60 minutes)

### Minutes 60-75: Profile & Home Setup
- [ ] **T046**: Create Profile Setup Modal → Name, City dropdown, Commute radio chips
- [ ] **T051**: On "Complete Setup" → Create Firestore users/{uid} document
- [ ] **T021**: Create BottomNavigationBar component (Home/Tracker/AR/Social)
- [ ] **T053**: Create Home Dashboard Screen → Add BottomNavBar

### Minutes 75-90: Dashboard Content
- [ ] **T054**: Add greeting: "Hello, {userName}! 👋" → Bind to Firestore users/{uid}.name
- [ ] **T055**: Add CircularProgressIndicator → Bind: totalCO2Saved / weeklyTarget
- [ ] **T057**: Add Streak Card: "🔥 {currentStreak} day streak"
- [ ] **T058**: Add RefreshIndicator for pull-to-refresh

### Minutes 90-105: Quick Log Cards
- [ ] **T060**: Add "Quick Log" section → 3 cards: Food 🍽️, Transport 🚗, Energy ⚡
- [ ] **T065**: Create Food Log Modal → RadioGroup (Beef/Chicken/Fish/Veg/Vegan)
- [ ] **T067**: Add Servings input (1-10) + Notes field
- [ ] **T069**: Calculate CO2: mealType × servings (Beef=3000, Chicken=800, etc.)

### Minutes 105-120: Save Logs Logic
- [ ] **T070**: On "Save Log" → Create Firestore logs document
- [ ] **T071**: Update users/{uid}.totalCO2Saved (transaction)
- [ ] **T074-T086**: Clone Food Modal for Transport and Energy (simpler)

**✅ CHECKPOINT**: Test log activity → See CO2 update on dashboard

---

## 📊 Hour 3: Charts + AR (60 minutes)

### Minutes 120-135: Tracker Screen
- [ ] **T148**: Create Tracker Screen → Add BottomNavBar (tab 1)
- [ ] **T151**: Add BarChart → Query logs (last 7 days) → Group by date → SUM co2Grams
- [ ] **T156**: Add PieChart → Query logs (all time) → Group by category → Show %

### Minutes 135-150: Activity List + Export
- [ ] **T161**: Add ListView → Display recent logs (category, co2Grams, timestamp)
- [ ] **T166**: Add FAB (floating button) → Capture screenshot → Share via Android

### Minutes 150-165: AR Screen Setup
- [ ] **T089**: Create AR Challenges Screen → Add BottomNavBar (tab 2)
- [ ] **T090**: Add challenge selection → Query Firestore challenges collection
- [ ] **T091**: Display Challenge Cards (title, description, points, status)

### Minutes 165-180: Implement 1 AR Challenge
- [ ] **T094**: Scan Plastic challenge → Camera Preview + ML Kit object detection
- [ ] **T096**: On detect "bottle" or "plastic" → Show green checkmark animation
- [ ] **T098**: Check daily limit: query challenge_completions (today)
- [ ] **T099**: If allowed → Create completion doc → Update users/{uid}.points += 50
- [ ] **T101**: Show confetti animation + "Challenge Complete! +50 points"

**✅ CHECKPOINT**: Complete 1 AR challenge → See points update

---

## 🎉 Hour 4: Social + Polish (60 minutes)

### Minutes 180-195: Social Leaderboards
- [ ] **T120**: Create Social Screen → Add BottomNavBar (tab 3) → TabBar (Friends/City/Global)
- [ ] **T131**: City Leaderboard → Query RTDB leaderboard_cache/{userCity} → Display ranked list
- [ ] **T138**: Global Leaderboard → Query RTDB leaderboard_cache/global
- [ ] **T143**: Add "Top 3 Leaderboard" to Home Dashboard → Query RTDB city top 3

### Minutes 195-210: Animations & Offline
- [ ] **T184**: Verify splash Lottie animation works (already done in T029)
- [ ] **T185**: Add confetti animation to AR challenge completion
- [ ] **T187**: Add haptic feedback to all buttons
- [ ] **T189**: Enable Firestore offline persistence in settings
- [ ] **T190**: Add offline indicator banner (show when no internet)

### Minutes 210-225: Data Seeding
- [ ] **T013**: Firestore → challenges collection → Add 3 documents (scan-plastic, plant-tree, bike-route)
- [ ] **T014**: Firestore → badges collection → Add 3 documents (streak-7, points-100, logs-50)
- [ ] **T015**: RTDB → leaderboard_cache/global → Initialize empty object
- [ ] **T019**: Firebase Auth → Create 3 test accounts (judge1/2/3@ecoquest.demo)
- [ ] Sign in as each test account → Complete setup → Log activities

### Minutes 225-235: Security & APK
- [ ] **T010**: Firestore Rules → Copy from contracts/firebase-schema.md → Publish
- [ ] **T011**: RTDB Rules → Copy from contracts/firebase-schema.md → Publish
- [ ] **T012**: Storage Rules → Copy from contracts/firebase-schema.md → Publish
- [ ] **T210**: Dreamflow → Build → Android Release → Generate APK (wait 5-10 min)
- [ ] **T211**: Download APK → Install on device → Test full flow

### Minutes 235-240: Demo Video
- [ ] **T212**: Start screen recording on device
- [ ] Execute 30s demo: Launch → Auth → Log activity → AR challenge → Leaderboard → Charts
- [ ] Save recording → Transfer to computer

**✅ FINAL CHECKPOINT**: APK installed + Demo video recorded = PROJECT COMPLETE! 🎉

---

## 🚨 If Running Out of Time (Priority Cuts)

**Skip in this order** (least to most important):

1. ❌ **Social features** → Use mock leaderboard data
2. ❌ **AR challenges 2 & 3** → Keep only Scan Plastic working
3. ❌ **Detailed analytics** → Show simple log list only
4. ❌ **Animations** → Remove Lottie, keep basic transitions
5. ⚠️ **Charts** → Use mock data JSON (don't query Firestore)

**Never skip**:
- ✅ Firebase setup (blocks everything)
- ✅ Auth flow (required for demo)
- ✅ Home dashboard (shows data)
- ✅ At least 1 log type working (proves concept)
- ✅ APK build (deliverable)

---

## 📱 Minimum Demo-Ready Requirements

To pass as "working MVP":

1. ✅ App launches without crash
2. ✅ User can sign in (Google OR email)
3. ✅ Home dashboard shows data (even if hardcoded)
4. ✅ Can log 1 activity type (food OR transport OR energy)
5. ✅ Dashboard updates after logging (real-time or refresh)
6. ✅ APK installs on Android device
7. ✅ 30-second screen recording exists

**Bonus points** (only if time permits):
- Charts display actual data
- AR challenge completes successfully
- Leaderboard shows real rankings
- Offline mode works

---

## 🐛 Quick Fixes

### Firebase not connecting?
```bash
# Verify package name matches
Dreamflow: com.ecoquest.carbontracker
Firebase: com.ecoquest.carbontracker (must match exactly)

# Re-download google-services.json
# Delete and re-upload to Dreamflow
```

### Auth not working?
```bash
# Enable Email/Password fallback
Firebase Console → Authentication → Sign-in method → Email/Password → Enable

# Test with simple account first
Email: test@demo.com
Password: Test123!
```

### Charts showing errors?
```javascript
// Use hardcoded mock data first
const mockData = [
  {date: "Mon", co2: 120},
  {date: "Tue", co2: 95},
  {date: "Wed", co2: 140},
  {date: "Thu", co2: 80},
  {date: "Fri", co2: 110},
  {date: "Sat", co2: 60},
  {date: "Sun", co2: 150}
];
// Replace Firestore query with mockData
```

### AR not detecting?
```javascript
// Fallback: Tap-to-complete challenge
// Remove ML Kit detection
// On screen tap → Award points immediately
// Still shows camera preview for visual effect
```

---

## 📞 Emergency Resources

- **Dreamflow Support**: Check platform docs or support chat
- **Firebase Status**: https://status.firebase.google.com
- **Quick Assets**: https://undraw.co (illustrations), https://lottiefiles.com (animations)
- **Test Data Generator**: Use ChatGPT to generate mock JSON data
- **APK Install Guide**: `adb install app.apk` OR transfer via USB and open on device

---

## 🎯 Success Metrics

**You WIN the hackathon if:**
- ✅ Demo flows smoothly in 30 seconds
- ✅ UI looks polished (Material 3 theme applied)
- ✅ At least 1 unique feature works (AR challenge or real-time charts)
- ✅ No crashes during demo
- ✅ Solves real problem (carbon tracking)

**Start NOW. Good luck! 🚀**
