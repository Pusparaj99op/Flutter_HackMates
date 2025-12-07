# Phase 1: Setup Implementation Guide

**Duration**: 45 minutes
**Tasks**: T001-T020
**Status**: 🟡 IN PROGRESS

---

## 📋 Checklist Progress

### Group 1: Dreamflow Project Creation (15 minutes)

- [ ] **T001** - Create new Dreamflow project
  - **Action**: Go to [Dreamflow Dashboard](https://dreamflow.ai) → New Project
  - **Name**: "EcoQuest AR Carbon Tracker"
  - **Platform**: Android
  - **Verification**: Project appears in dashboard

- [ ] **T002** - Configure Material 3 theme [PARALLEL]
  - **Action**: Project Settings → Theme → Material 3
  - **Primary Color**: #4CAF50 (green)
  - **Secondary Color**: #2196F3 (blue)
  - **Verification**: Preview shows green/blue color scheme

- [ ] **T003** - Upload app icon [PARALLEL]
  - **Action**: Assets → Icons → Upload
  - **File**: Green leaf + "EQ" logo (512x512px)
  - **Path**: assets/icons/app-icon.png
  - **Verification**: Icon visible in assets panel
  - **Fallback**: Use temporary icon from https://www.flaticon.com/free-icon/leaf_628283

---

### Group 2: Firebase Backend Setup (20 minutes)

- [ ] **T004** - Create Firebase project
  - **Action**: Go to [Firebase Console](https://console.firebase.google.com) → Add Project
  - **Name**: "EcoQuest AR Carbon Tracker"
  - **Enable Google Analytics**: Yes (optional)
  - **Verification**: Project dashboard loads

- [ ] **T005** - Enable Firebase Authentication
  - **Action**: Firebase Console → Authentication → Get Started
  - **Enable**: Google Sign-In provider
  - **Enable**: Email/Password provider
  - **Verification**: Both providers show "Enabled" status

- [ ] **T006** - Enable Firestore Database
  - **Action**: Firebase Console → Firestore Database → Create Database
  - **Mode**: Production mode
  - **Location**: us-central1
  - **Verification**: Database shows "Cloud Firestore" tab

- [ ] **T007** - Enable Realtime Database
  - **Action**: Firebase Console → Realtime Database → Create Database
  - **Mode**: Locked mode
  - **Location**: us-central1
  - **Verification**: Database shows empty JSON tree

- [ ] **T008** - Enable Firebase Storage
  - **Action**: Firebase Console → Storage → Get Started
  - **Mode**: Production mode
  - **Verification**: Storage bucket created (gs://...)

- [ ] **T009** - Download google-services.json
  - **Action**: Firebase Console → Project Settings → Your apps → Add Android app
  - **Package Name**: com.ecoquest.carbontacker (or Dreamflow default)
  - **Download**: google-services.json file
  - **Upload**: To Dreamflow → Project Settings → Firebase → Upload Config
  - **Verification**: Dreamflow shows "Firebase Connected"

- [ ] **T010** - Deploy Firestore security rules
  - **Action**: Open [FIREBASE_SETUP_REFERENCE.md](./FIREBASE_SETUP_REFERENCE.md) → Copy Section 1 rules
  - **Paste**: Firebase Console → Firestore → Rules tab
  - **Click**: Publish
  - **Verification**: Rules show last published timestamp

- [ ] **T011** - Deploy RTDB security rules [PARALLEL]
  - **Action**: Open FIREBASE_SETUP_REFERENCE.md → Copy Section 2 rules
  - **Paste**: Firebase Console → Realtime Database → Rules tab
  - **Click**: Publish
  - **Verification**: Rules show published state

- [ ] **T012** - Deploy Storage security rules [PARALLEL]
  - **Action**: Open FIREBASE_SETUP_REFERENCE.md → Copy Section 3 rules
  - **Paste**: Firebase Console → Storage → Rules tab
  - **Click**: Publish
  - **Verification**: Rules show published timestamp

---

### Group 3: Data Seeding (10 minutes)

- [ ] **T013** - Seed challenges collection
  - **Action**: Firebase Console → Firestore → Start Collection
  - **Collection ID**: `challenges`
  - **Add 3 Documents**: Open FIREBASE_SETUP_REFERENCE.md Section 5
  - **Doc 1 ID**: `scan-plastic` (copy JSON from reference)
  - **Doc 2 ID**: `plant-tree` (copy JSON from reference)
  - **Doc 3 ID**: `bike-route` (copy JSON from reference)
  - **Verification**: 3 documents visible in Firestore challenges collection

- [ ] **T014** - Seed badges collection [PARALLEL]
  - **Action**: Firestore → Start Collection
  - **Collection ID**: `badges`
  - **Add 3 Documents**: Open FIREBASE_SETUP_REFERENCE.md Section 6
  - **Doc 1 ID**: `streak-7` (copy JSON)
  - **Doc 2 ID**: `points-100` (copy JSON)
  - **Doc 3 ID**: `logs-50` (copy JSON)
  - **Verification**: 3 documents visible in badges collection

- [ ] **T015** - Initialize RTDB leaderboard_cache [PARALLEL]
  - **Action**: Firebase Console → Realtime Database → Data tab
  - **Copy**: FIREBASE_SETUP_REFERENCE.md Section 7 JSON structure
  - **Paste**: Into root of RTDB (replace empty {})
  - **Verification**: RTDB shows leaderboard_cache with 11 city nodes

---

### Group 4: Asset Uploads (5 minutes - PARALLEL)

- [ ] **T016** - Upload Lottie animations [PARALLEL]
  - **Action**: Download splash.json from https://lottiefiles.com/animations/splash-screen
  - **Download**: confetti.json from https://lottiefiles.com/animations/confetti
  - **Upload**: To Dreamflow → Assets → Lottie → Upload both files
  - **Path**: assets/lottie/splash.json, assets/lottie/confetti.json
  - **Verification**: Both files visible in Lottie assets folder

- [ ] **T017** - Upload onboarding slide images [PARALLEL]
  - **Action**: Download 3 SVG illustrations from https://undraw.co
  - **Topics**: "scan habits" (search: scanning), "AR challenges" (search: augmented reality), "competition" (search: winners)
  - **Convert**: SVG to PNG (1080x1920px) using online converter
  - **Upload**: To Dreamflow → Assets → Images → Upload 3 files
  - **Path**: assets/onboarding/slide1.png, slide2.png, slide3.png
  - **Verification**: 3 images visible in onboarding folder

- [ ] **T018** - Upload challenge icons [PARALLEL]
  - **Action**: Download 3 icon PNGs from https://www.flaticon.com
  - **Icons**: Magnifying glass (scan), Tree (plant), Bicycle (route)
  - **Size**: 512x512px PNG
  - **Upload**: To Dreamflow → Assets → Icons
  - **Path**: assets/icons/scan.png, tree.png, bike.png
  - **Verification**: 3 icons visible in icons folder

---

### Group 5: Test Accounts & Verification (5 minutes)

- [ ] **T019** - Create test accounts [PARALLEL]
  - **Action**: Firebase Console → Authentication → Users → Add User
  - **Account 1**:
    - Email: judge1@ecoquest.demo
    - Password: Demo123!
    - Click: Add User
  - **Account 2**:
    - Email: judge2@ecoquest.demo
    - Password: Demo123!
  - **Account 3**:
    - Email: judge3@ecoquest.demo
    - Password: Demo123!
  - **Verification**: 3 users visible in Authentication → Users tab

- [ ] **T020** - Test Firebase connection
  - **Action**: Dreamflow → Project Settings → Firebase → Test Connection
  - **Click**: "Test Firestore" button
  - **Expected**: Success message "Connected to Firestore"
  - **If fails**: Re-upload google-services.json, verify package name matches
  - **Verification**: Green checkmark showing Firebase integration active

---

## ⚡ Parallel Execution Strategy

**Execute these tasks simultaneously to save time:**

### Batch 1 (After T001 complete):
- T002 (theme config)
- T003 (app icon upload)

### Batch 2 (After T009 complete):
- T010 (Firestore rules)
- T011 (RTDB rules)
- T012 (Storage rules)

### Batch 3 (After T012 complete):
- T013 (challenges seed)
- T014 (badges seed)
- T015 (RTDB init)

### Batch 4 (While Batch 3 runs):
- T016 (Lottie animations)
- T017 (onboarding images)
- T018 (challenge icons)
- T019 (test accounts)

---

## 🔍 Verification Checklist

After completing all 20 tasks, verify:

- [ ] Dreamflow project created with correct name
- [ ] Material 3 theme shows green/blue colors in preview
- [ ] App icon uploaded (temporary or final)
- [ ] Firebase project exists in console
- [ ] Authentication enabled (Google + Email/Password)
- [ ] Firestore database created with 2 collections (challenges, badges)
- [ ] Realtime Database has leaderboard_cache structure
- [ ] Storage bucket created
- [ ] google-services.json uploaded to Dreamflow
- [ ] All 3 security rules published (Firestore, RTDB, Storage)
- [ ] 3 challenge documents exist in Firestore
- [ ] 3 badge documents exist in Firestore
- [ ] 11 city nodes exist in RTDB leaderboard_cache
- [ ] 2 Lottie animation files uploaded
- [ ] 3 onboarding slide images uploaded
- [ ] 3 challenge icon images uploaded
- [ ] 3 test accounts created in Firebase Auth
- [ ] Firebase connection test passes in Dreamflow

---

## 🚨 Common Issues & Solutions

### Issue: "Firebase connection failed"
**Solution**:
1. Verify google-services.json matches package name
2. Check Firebase project has billing enabled (free tier OK)
3. Wait 5 minutes for Firebase backend propagation
4. Re-download google-services.json and re-upload

### Issue: "Firestore rules syntax error"
**Solution**:
1. Copy rules EXACTLY from FIREBASE_SETUP_REFERENCE.md (including line breaks)
2. Verify `rules_version = '2';` at top
3. Check all curly braces match

### Issue: "Cannot find assets in Dreamflow"
**Solution**:
1. Verify file formats: .json for Lottie, .png for images/icons
2. Check file size limits (<5MB per file)
3. Refresh Dreamflow assets panel
4. Re-upload with exact paths listed above

### Issue: "Test accounts not appearing"
**Solution**:
1. Verify Email/Password provider is enabled in Auth
2. Check password meets requirements (6+ chars, 1 number)
3. Wait 30 seconds for Auth propagation
4. Refresh Authentication → Users tab

---

## ⏱️ Time Breakdown

| Group | Tasks | Est. Time | Parallel? |
|-------|-------|-----------|-----------|
| Dreamflow Project | T001-T003 | 15 min | Yes (T002-T003) |
| Firebase Backend | T004-T012 | 20 min | Yes (T010-T012) |
| Data Seeding | T013-T015 | 10 min | Yes (all 3) |
| Asset Uploads | T016-T018 | 5 min | Yes (all 3) |
| Test & Verify | T019-T020 | 5 min | Yes (T019) |
| **TOTAL** | **20 tasks** | **45 min** | **12 parallel** |

With parallel execution, actual time: **30-35 minutes**

---

## ✅ Mark Task Complete

**After completing each task, mark it in tasks.md:**

```bash
# Example: After completing T001
- [X] T001 Create new Dreamflow project named "EcoQuest AR Carbon Tracker" with Android platform selection
```

**Or use this command to mark all Phase 1 complete at once:**
(I'll update tasks.md automatically after you confirm completion)

---

## 🎯 Next Steps After Phase 1

Once all 20 tasks are ✅ complete:

1. **Verify**: Run through verification checklist above
2. **Screenshot**: Capture Dreamflow dashboard + Firebase console for reference
3. **Proceed**: Move to Phase 2 (Foundational) - T021-T027
4. **Update**: I'll mark all Phase 1 tasks as [X] in tasks.md

---

**Ready to begin? Start with T001 in Dreamflow Dashboard!**

Reference documents:
- [FIREBASE_SETUP_REFERENCE.md](./FIREBASE_SETUP_REFERENCE.md) - All configs ready to copy/paste
- [IMPLEMENTATION_GUIDE.md](./IMPLEMENTATION_GUIDE.md) - Detailed hour-by-hour plan
- [QUICKSTART_CHECKLIST.md](./QUICKSTART_CHECKLIST.md) - Complete 4-hour roadmap
