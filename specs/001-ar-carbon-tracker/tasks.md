# Tasks: EcoQuest AR Carbon Tracker

**Input**: Design documents from `/specs/001-ar-carbon-tracker/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: No test tasks included (not requested in feature specification)

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `- [ ] [ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

**NOTE**: This is a Dreamflow visual builder project. Tasks reference Dreamflow screens/components, not traditional file paths. All implementation is done through Dreamflow's visual interface.

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization, Firebase setup, and theme configuration

- [ ] T001 Create new Dreamflow project named "EcoQuest AR Carbon Tracker" with Android platform selection
- [ ] T002 [P] Configure Material 3 theme with primary color #4CAF50 (green) and secondary color #2196F3 (blue) in theme/material3.config
- [ ] T003 [P] Upload app icon (green leaf + "EQ" logo) to assets/icons/app-icon.png
- [ ] T004 Create Firebase project in Firebase Console named "EcoQuest AR Carbon Tracker"
- [ ] T005 Enable Firebase Authentication with Google Sign-In and Email/Password providers
- [ ] T006 Enable Firestore Database in production mode with us-central1 region
- [ ] T007 Enable Firebase Realtime Database in locked mode
- [ ] T008 Enable Firebase Storage in production mode
- [ ] T009 Download google-services.json and integrate with Dreamflow Firebase configuration
- [ ] T010 Deploy Firestore security rules from contracts/firebase-schema.md to Firestore Rules tab
- [ ] T011 [P] Deploy Realtime Database security rules from contracts/firebase-schema.md to RTDB Rules tab
- [ ] T012 [P] Deploy Storage security rules from contracts/firebase-schema.md to Storage Rules tab
- [ ] T013 Seed Firestore challenges collection with 3 documents (scan-plastic, plant-tree, bike-route) from contracts/firebase-schema.md
- [ ] T014 [P] Seed Firestore badges collection with 3 documents (streak-7, points-100, logs-50) from contracts/firebase-schema.md
- [ ] T015 [P] Initialize RTDB leaderboard_cache with empty global object and last_updated timestamp
- [ ] T016 [P] Upload Lottie animations (splash.json, confetti.json) to assets/lottie/ folder
- [ ] T017 [P] Upload onboarding slide images (3 slides) to assets/onboarding/ folder
- [ ] T018 [P] Upload challenge icons (3 icons) to assets/icons/ folder
- [ ] T019 [P] Create 3 test accounts in Firebase Auth Console (judge1@ecoquest.demo, judge2@ecoquest.demo, judge3@ecoquest.demo)
- [ ] T020 Test Firebase connection in Dreamflow using "Test Firestore" button to verify integration

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core reusable components and navigation structure required by all user stories

- [ ] T021 Create Bottom Navigation Bar component with 4 tabs (Home, Tracker, AR, Social) with Material 3 icons
- [ ] T022 [P] Create reusable Skeleton Loader component for list items with shimmer animation
- [ ] T023 [P] Create reusable Quick Log Card component with props (category, icon, title) in components/quick-log-card.component
- [ ] T024 [P] Create reusable Leaderboard Item component with props (rank, name, points, avatarUrl) in components/leaderboard-item.component
- [ ] T025 [P] Create reusable Challenge Card component with props (challenge, isCompleted) in components/challenge-card.component
- [ ] T026 [P] Create reusable Activity Log Item component with props (log object) in components/activity-log-item.component
- [ ] T027 Configure global state management with variables (currentUser, userProfile, selectedChallenge, todayCompletions, recentLogs, top3Friends)

---

## Phase 3: User Story 1 - Quick Onboarding and Daily Score (P1)

**Goal**: New user completes authentication, profile setup, and views home dashboard in under 30 seconds

**Independent Test**: Install app → complete sign-up flow → view home dashboard with initial carbon score (0g)

### Splash & Onboarding Flow

- [ ] T028 [US1] Create Splash Screen (splash.screen) with fullscreen container and Lottie animation player
- [ ] T029 [US1] Configure Lottie animation source to assets/lottie/splash.json with 2-second duration and auto-navigate to Onboarding
- [ ] T030 [US1] Create Onboarding Screen (onboarding.screen) with Carousel Slider component for 3 slides
- [ ] T031 [US1] Configure Slide 1 with image (assets/onboarding/slide1.png), title "Scan Your Habits", and description "Track your carbon footprint by scanning receipts and activities"
- [ ] T032 [US1] Configure Slide 2 with image (assets/onboarding/slide2.png), title "AR Challenges", and description "Complete fun AR challenges to earn points and make a difference"
- [ ] T033 [US1] Configure Slide 3 with image (assets/onboarding/slide3.png), title "Beat Your Friends", and description "Compete on leaderboards and challenge friends to save more CO2"
- [ ] T034 [US1] Add "Get Started" primary button at bottom of Onboarding Screen with navigation to Auth Screen on tap

### Authentication

- [ ] T035 [US1] Create Auth Screen (auth.screen) with centered logo image at top
- [ ] T036 [US1] Add Google Sign-In button with Material 3 elevated style, Google logo icon, and "Continue with Google" text
- [ ] T037 [US1] Configure Google Sign-In button to trigger Firebase Auth Google Sign-In on tap
- [ ] T038 [US1] Add divider with "OR" text below Google button
- [ ] T039 [US1] Add Email input field with email format validation and email keyboard type
- [ ] T040 [US1] Add Password input field with obscure text enabled and minimum 6 character validation
- [ ] T041 [US1] Add "Sign In with Email" primary button to trigger Firebase Auth Email/Password Sign-In
- [ ] T042 [US1] Add "Create Account" text button to trigger Firebase Auth Email/Password Register
- [ ] T043 [US1] Configure auth success handler to check if user profile exists in Firestore users/{uid}
- [ ] T044 [US1] Navigate to Profile Setup Screen if no profile exists, or Home Dashboard if profile exists
- [ ] T045 [US1] Add error snackbar display for auth failures with error message

### Profile Setup

- [ ] T046 [US1] Create Profile Setup Screen (profile-setup.screen) as bottom sheet modal
- [ ] T047 [US1] Add Name text field with 50 character max length and required validation (2+ characters)
- [ ] T048 [US1] Add City dropdown field with 10 city options (New York, Los Angeles, London, Paris, Tokyo, Sydney, Mumbai, Berlin, Toronto, Singapore)
- [ ] T049 [US1] Add Commute Mode radio group with 4 options (Car, Bus, Bike, Walk) with transport icons
- [ ] T050 [US1] Add "Complete Setup" primary button enabled only when all fields are valid
- [ ] T051 [US1] Configure button to create Firestore document in users/{uid} collection with profile data (name, email, city, commuteMode, totalCO2Saved=0, points=0, currentStreak=0, weeklyTarget=500, badges=[], friendIds=[], timestamps)
- [ ] T052 [US1] Navigate to Home Dashboard Screen on successful profile creation

### Home Dashboard

- [ ] T053 [US1] Create Home Dashboard Screen (home-dashboard.screen) with Bottom Navigation component (default Home tab selected)
- [ ] T054 [US1] Add greeting text at top "Hello, {userName}!" with data binding to Firestore users/{currentUser.uid}.name
- [ ] T055 [US1] Add Circular Progress widget below greeting showing totalCO2Saved / weeklyTarget percentage
- [ ] T056 [US1] Configure Circular Progress center text to display "{totalCO2Saved}g CO2 saved 🌿" with green color #4CAF50
- [ ] T057 [US1] Add Streak Counter card with flame emoji 🔥 and text "{currentStreak} day streak" data-bound to user.currentStreak
- [ ] T058 [US1] Add pull-to-refresh functionality on Home Dashboard to reload all data sources
- [ ] T059 [US1] Configure skeleton loaders for all list views while data is loading

---

## Phase 4: User Story 2 - Log Carbon Activities (P1)

**Goal**: User logs activities (food/transport/energy) and sees CO2 calculations reflected in daily score

**Independent Test**: Tap quick log cards → enter activity details → verify logs appear in tracker with CO2 values → see daily score update

### Quick Log UI

- [ ] T060 [US2] Add Horizontal Scroll View to Home Dashboard below streak counter for Quick Log cards
- [ ] T061 [US2] Add Food Quick Log Card with food icon 🍽️, title "Food", using quick-log-card.component
- [ ] T062 [US2] Add Transport Quick Log Card with car icon 🚗, title "Transport", using quick-log-card.component
- [ ] T063 [US2] Add Energy Quick Log Card with energy icon ⚡, title "Energy", using quick-log-card.component
- [ ] T064 [US2] Configure Quick Log Card taps to open respective category bottom sheet modal

### Food Log Modal

- [ ] T065 [US2] Create Food Log Bottom Sheet modal with meal type radio group (Beef, Chicken, Fish, Vegetarian, Vegan)
- [ ] T066 [US2] Add servings number input (1-10 range) with increment/decrement buttons
- [ ] T067 [US2] Add optional notes text field with 200 character maximum
- [ ] T068 [US2] Add optional camera button to capture receipt photo (saves to Firebase Storage users/{uid}/receipts/)
- [ ] T069 [US2] Implement CO2 calculation logic: co2Grams = mealType factor × servings (beef=3000, chicken=800, fish=600, vegetarian=300, vegan=150)
- [ ] T070 [US2] Add "Save Log" button to create Firestore document in logs collection with userId, timestamp, category=food, co2Grams, details{mealType, servings}, notes, photoUrl
- [ ] T071 [US2] Update user totalCO2Saved by adding co2Grams to Firestore users/{uid}.totalCO2Saved using transaction
- [ ] T072 [US2] Update user lastActivityAt timestamp to current time for streak calculation
- [ ] T073 [US2] Close modal and show success snackbar with "{co2Grams}g CO2 logged!"

### Transport Log Modal

- [ ] T074 [US2] Create Transport Log Bottom Sheet modal with mode radio group (Car, Bus, Bike, Walk)
- [ ] T075 [US2] Add distance number input (km) with decimal support
- [ ] T076 [US2] Add optional notes text field with 200 character maximum
- [ ] T077 [US2] Implement CO2 calculation logic: co2Grams = mode factor × distanceKm (car=120, bus=40, bike=0, walk=0)
- [ ] T078 [US2] Add "Save Log" button to create Firestore document in logs collection with userId, timestamp, category=transport, co2Grams, details{mode, distanceKm}, notes
- [ ] T079 [US2] Update user totalCO2Saved and lastActivityAt using transaction as in T071-T072
- [ ] T080 [US2] Close modal and show success snackbar

### Energy Log Modal

- [ ] T081 [US2] Create Energy Log Bottom Sheet modal with usage number input (kWh) and source radio group (Electricity, Gas)
- [ ] T082 [US2] Add optional notes text field with 200 character maximum
- [ ] T083 [US2] Implement CO2 calculation logic: co2Grams = source factor × usageKwh (electricity=500, gas=200)
- [ ] T084 [US2] Add "Save Log" button to create Firestore document in logs collection with userId, timestamp, category=energy, co2Grams, details{usageKwh, source}, notes
- [ ] T085 [US2] Update user totalCO2Saved and lastActivityAt using transaction as in T071-T072
- [ ] T086 [US2] Close modal and show success snackbar

### Real-time Updates

- [ ] T087 [US2] Configure Home Dashboard Circular Progress to use StreamBuilder with real-time Firestore listener on users/{uid} document
- [ ] T088 [US2] Update daily score circle display to reflect new totalCO2Saved value immediately after log creation

---

## Phase 5: User Story 3 - Complete AR Challenges (P1)

**Goal**: User launches 3 AR challenge types (Scan Plastic, Plant Tree, Bike Route), completes them, and earns points

**Independent Test**: Navigate to AR tab → start each challenge → complete successfully → see points update and confetti animation

### AR Challenges Screen Setup

- [ ] T089 [US3] Create AR Challenges Screen (ar-challenges.screen) with Camera Preview component and ML Kit integration enabled
- [ ] T090 [US3] Add challenge selection bottom sheet with list of Challenge Cards data-bound to Firestore challenges collection query
- [ ] T091 [US3] Configure Challenge Cards to show challenge icon, title, description, point value, and completion status ("Completed today" or "Start Challenge")
- [ ] T092 [US3] Query Firestore challenge_completions where userId == currentUser.uid AND dateKey == today to get todayCompletions array
- [ ] T093 [US3] Compute completion status for each challenge by checking if challengeId exists in todayCompletions with count < dailyLimit

### Challenge 1: Scan Plastic

- [ ] T094 [US3] Configure "Start Challenge" button tap for scan-plastic to initialize camera preview with ML Kit object detection
- [ ] T095 [US3] Add ML Kit object detection overlay to display detected object labels in real-time on camera feed
- [ ] T096 [US3] Implement detection success logic: when ML Kit detects label containing "bottle" or "plastic", trigger success event
- [ ] T097 [US3] Display green checkmark Lottie animation overlay on camera preview when plastic object detected
- [ ] T098 [US3] Before awarding points, check daily limit: query challenge_completions where userId AND challengeId == "scan-plastic" AND dateKey == today
- [ ] T099 [US3] If count < 1 (daily limit), create Firestore document in challenge_completions collection with userId, challengeId, completedAt, dateKey, pointsAwarded=50
- [ ] T100 [US3] Update users/{uid}.points by adding 50 points using Firestore transaction
- [ ] T101 [US3] Show completion modal with confetti Lottie animation and "+50 points" text

### Challenge 2: Plant Tree

- [ ] T102 [US3] Configure "Start Challenge" button tap for plant-tree to initialize camera preview with tap gesture detector
- [ ] T103 [US3] Implement tap gesture handler: when user taps on camera preview (ground area), capture tap coordinates
- [ ] T104 [US3] Display 2D tree sprite at tap location with 5-frame grow animation sequence (tree grows from sapling to full tree)
- [ ] T105 [US3] Before awarding points, check daily limit for plant-tree challenge as in T098
- [ ] T106 [US3] If count < 1, create challenge_completions document and update user points by 50 as in T099-T100
- [ ] T107 [US3] Show completion modal with confetti animation

### Challenge 3: Bike Route

- [ ] T108 [US3] Configure "Start Challenge" button tap for bike-route to initialize camera preview with GPS location tracking
- [ ] T109 [US3] Request location permissions from user; if denied, show error message and return to challenge selection
- [ ] T110 [US3] Capture user's starting GPS coordinates when challenge begins
- [ ] T111 [US3] Add directional arrow overlay on camera preview pointing toward predefined route waypoints
- [ ] T112 [US3] Continuously calculate distance traveled from starting point using GPS coordinates
- [ ] T113 [US3] When distance >= 2km (2000 meters), trigger challenge completion event
- [ ] T114 [US3] Before awarding points, check daily limit for bike-route challenge as in T098
- [ ] T115 [US3] If count < 1, create challenge_completions document and update user points by 50 as in T099-T100
- [ ] T116 [US3] Show completion modal with confetti animation

### Challenge Progress

- [ ] T117 [US3] Add challenge progress indicator at top of AR Challenges screen showing "X/3 challenges complete today" with data binding to todayCompletions.length
- [ ] T118 [US3] Add total points earned display showing sum of pointsAwarded from todayCompletions array
- [ ] T119 [US3] Add "Today's AR Challenge" card to Home Dashboard showing 1 active challenge with tap to navigate to AR screen

---

## Phase 6: User Story 4 - Social Leaderboards and Friend Challenges (P1)

**Goal**: User views leaderboards (city/global), adds friends, sees rankings updated in real-time

**Independent Test**: Create 2+ test accounts → add as friends → log activities → view leaderboards → see updated rankings

### Social Screen Setup

- [ ] T120 [US4] Create Social Screen (social.screen) with Tab Bar component (Friends, City Leaderboard, Global Leaderboard tabs)
- [ ] T121 [US4] Configure bottom navigation to navigate to Social Screen when Social tab tapped

### Friends Tab

- [ ] T122 [US4] Add search bar to Friends tab with placeholder "Search by email"
- [ ] T123 [US4] Implement search functionality: on input change, query Firestore users where email == searchInput (exclude current user and existing friends)
- [ ] T124 [US4] Display search results with user avatar, name, email, and "Add Friend" button
- [ ] T125 [US4] Configure "Add Friend" button to create Firestore document in friendships collection with userId1 (min UID), userId2 (max UID), status=pending, requestedBy=currentUser.uid, createdAt=now
- [ ] T126 [US4] Add Friends List view below search bar showing accepted friendships
- [ ] T127 [US4] Query friendships where (userId1 == currentUser.uid OR userId2 == currentUser.uid) AND status == accepted
- [ ] T128 [US4] For each friendship, query users collection to get friend's profile data (name, points, totalCO2Saved, avatarUrl)
- [ ] T129 [US4] Display friends list using Leaderboard Item component showing friend avatar, name, points, and totalCO2Saved
- [ ] T130 [US4] Add "Challenge Friend" button for each friend to send Firebase Cloud Messaging notification (notification includes challenge invitation text)

### City Leaderboard Tab

- [ ] T131 [US4] Query RTDB leaderboard_cache/{userCity} order by points DESC to get city rankings
- [ ] T132 [US4] Display city leaderboard list using Leaderboard Item component with rank badge (gold/silver/bronze for top 3)
- [ ] T133 [US4] Add pull-to-refresh functionality to manually update leaderboard cache
- [ ] T134 [US4] On refresh: check RTDB last_updated timestamp; if older than 5 minutes, query Firestore users where city == userCity order by points DESC limit 100
- [ ] T135 [US4] Sort query results by points DESC, assign ranks (1-indexed), write to RTDB leaderboard_cache/{city}/{userId: {name, points, rank}}
- [ ] T136 [US4] Update RTDB last_updated timestamp to current time
- [ ] T137 [US4] If user's city has no other users, show message "Be the first in your city!" and display global leaderboard instead

### Global Leaderboard Tab

- [ ] T138 [US4] Query RTDB leaderboard_cache/global order by points DESC to get global rankings
- [ ] T139 [US4] Display global leaderboard list using Leaderboard Item component with rank, name, points, and city
- [ ] T140 [US4] Add pull-to-refresh functionality to manually update global leaderboard cache
- [ ] T141 [US4] On refresh: query Firestore users order by points DESC limit 100, assign ranks, write to RTDB leaderboard_cache/global/{userId: {name, points, city, rank}}
- [ ] T142 [US4] Update RTDB last_updated timestamp

### Top 3 Leaderboard on Home

- [ ] T143 [US4] Add "Top 3 Leaderboard" section to Home Dashboard below Quick Log cards
- [ ] T144 [US4] Query RTDB leaderboard_cache/{userCity} order by points DESC limit 3
- [ ] T145 [US4] Display top 3 using Leaderboard Item component with rank badges (gold, silver, bronze)
- [ ] T146 [US4] Add "View All" button at bottom to navigate to Social Screen (City Leaderboard tab)
- [ ] T147 [US4] Configure real-time updates using StreamBuilder to listen for RTDB leaderboard_cache changes

---

## Phase 7: User Story 5 - View Analytics and Export Reports (P2)

**Goal**: User views weekly CO2 charts, category breakdowns, and exports screenshot report for sharing

**Independent Test**: Log 5+ activities over multiple days → navigate to Tracker tab → view charts → tap export → see screenshot shared

### Tracker History Screen

- [ ] T148 [US5] Create Tracker History Screen (tracker-history.screen) accessible via bottom navigation Tracker tab
- [ ] T149 [US5] Query Firestore logs where userId == currentUser.uid AND timestamp >= 7 days ago order by timestamp DESC
- [ ] T150 [US5] Group query results by date (YYYY-MM-DD) and sum co2Grams per day for bar chart data

### Weekly Bar Chart

- [ ] T151 [US5] Add Weekly Bar Chart widget to Tracker History screen using Dreamflow Charts component
- [ ] T152 [US5] Configure X-axis with days of week (Mon-Sun) labels
- [ ] T153 [US5] Configure Y-axis with CO2 grams scale (auto-scale based on max value)
- [ ] T154 [US5] Plot bars showing actual CO2 per day from grouped query data with green color #4CAF50
- [ ] T155 [US5] Add target line overlay at weeklyTarget / 7 days (e.g., 500g / 7 = 71.4g per day)

### Category Pie Chart

- [ ] T156 [US5] Query Firestore logs where userId == currentUser.uid (all-time) and group by category
- [ ] T157 [US5] Sum co2Grams per category (transport, food, energy) to get total emissions for each
- [ ] T158 [US5] Add Pie Chart widget below bar chart using Dreamflow Charts component
- [ ] T159 [US5] Configure pie slices with percentages and colors: Transport (green #4CAF50), Food (orange #FF9800), Energy (blue #2196F3)
- [ ] T160 [US5] Add labels showing percentage + category name for each slice

### Activity List

- [ ] T161 [US5] Add "Recent Activity" section below charts with list view
- [ ] T162 [US5] Display logs query results using Activity Log Item component showing category icon, "{category} - {co2Grams}g CO2", timestamp, details
- [ ] T163 [US5] Add edit icon button on each log item to open edit modal
- [ ] T164 [US5] Create edit modal as bottom sheet with pre-filled log data allowing user to modify details
- [ ] T165 [US5] On save, update Firestore logs/{logId} document with new values and recalculate user totalCO2Saved

### Export Report

- [ ] T166 [US5] Add Floating Action Button (FAB) to Tracker History screen with export icon
- [ ] T167 [US5] Configure FAB tap to capture screenshot of charts section using Dreamflow screenshot component
- [ ] T168 [US5] Add watermark/branding overlay to screenshot with app name "EcoQuest" and date range
- [ ] T169 [US5] Open Android share sheet with captured screenshot image to allow sharing via social media, email, messaging apps

---

## Phase 8: User Story 6 - Share Achievements (P2)

**Goal**: User shares badges, challenge completions, and reports to social media with deep links

**Independent Test**: Earn badge/complete challenge → tap share button → see pre-formatted post with deep link → share successfully

### Badge Achievements

- [ ] T170 [US6] Implement badge earning logic: after each log creation or challenge completion, check badge criteria
- [ ] T171 [US6] For streak-7 badge: if user.currentStreak >= 7 AND "streak-7" not in user.badges array, award badge
- [ ] T172 [US6] For points-100 badge: if user.points >= 100 AND "points-100" not in user.badges array, award badge
- [ ] T173 [US6] For logs-50 badge: query count of logs where userId == currentUser.uid; if count >= 50 AND "logs-50" not in badges, award badge
- [ ] T174 [US6] On badge award: add badgeId to users/{uid}.badges array, show badge notification modal with badge icon and "Share Achievement" button

### Share Badge

- [ ] T175 [US6] Create badge achievement modal with badge icon, title, description, and "Share Achievement" button
- [ ] T176 [US6] Configure share button to generate pre-formatted social media post: "{userName} earned {badgeTitle} on EcoQuest! Join me in saving the planet. {appDeepLink}"
- [ ] T177 [US6] Create Firebase Dynamic Link for app download page (or direct app open if installed)
- [ ] T178 [US6] Open Android share sheet with pre-formatted text and app deep link

### Share AR Challenge

- [ ] T179 [US6] Add "Share" button to challenge completion modal (T101, T107, T116)
- [ ] T180 [US6] Configure share button to capture screenshot of AR camera preview with success overlay (checkmark/tree/arrow)
- [ ] T181 [US6] Generate pre-formatted post: "I just completed {challengeTitle} on EcoQuest and earned {points} points! {appDeepLink}"
- [ ] T182 [US6] Open Android share sheet with screenshot and pre-formatted text

### Share Report (Already covered in T166-T169)

- [ ] T183 [US6] Verify FAB share from T166-T169 includes deep link in share sheet extras for app promotion

---

## Phase 9: Polish & Cross-Cutting Concerns

**Purpose**: Animations, accessibility, offline support, error handling, and final testing

### Animations

- [ ] T184 Configure Lottie splash animation (splash.json) with 2-second duration on Splash Screen
- [ ] T185 [P] Configure Lottie confetti animation (confetti.json) on challenge completion modals with 3-second duration
- [ ] T186 [P] Add hero animations between Home Dashboard cards and detail screens (log modal, challenge screen)
- [ ] T187 [P] Add haptic feedback on all button taps using Dreamflow haptic component
- [ ] T188 [P] Configure skeleton loaders for all list views (friends, leaderboards, activity logs) with shimmer animation

### Offline Support

- [ ] T189 Enable Firestore offline persistence in Dreamflow Firebase configuration settings
- [ ] T190 Add offline indicator banner at top of app when no internet connection detected
- [ ] T191 Test offline mode: disconnect internet → log activity → verify local save → reconnect → verify Firebase sync
- [ ] T192 Pre-load common queries on app launch to populate local cache (users/{uid}, challenges, badges)

### Error Handling

- [ ] T193 Add error snackbar component for network failures with retry button
- [ ] T194 Add error handling for camera permission denial: show message "Camera required for AR challenges. Enable in Settings." and disable AR features
- [ ] T195 Add error handling for location permission denial: show message "Location required for Bike Route challenge" and disable GPS challenge
- [ ] T196 Add error handling for invalid receipt scans: show "Could not detect items. Please enter manually." and open manual log modal
- [ ] T197 Add input validation error messages for all form fields (name, city, distance, servings, etc.)

### Accessibility

- [ ] T198 Verify all buttons have minimum 48dp touch target size per Material 3 standards
- [ ] T199 Verify color contrast ratios meet 4.5:1 standard for all text on backgrounds
- [ ] T200 Add content descriptions to all icons and images for screen reader support
- [ ] T201 Test app with TalkBack screen reader to ensure navigation and controls are accessible

### Testing & Deployment

- [ ] T202 Test full onboarding flow with new test account: splash → onboarding → auth → profile → home (verify <30s completion)
- [ ] T203 Test activity logging: create 3 logs (food, transport, energy) → verify CO2 calculations → check tracker history display
- [ ] T204 Test AR challenges: complete all 3 challenge types → verify points awarded → check daily limit enforcement
- [ ] T205 Test social features: with 2 test accounts, add friend → log activities → verify leaderboard updates → test challenge friend notification
- [ ] T206 Test analytics: with 5+ logs over 2+ days, verify bar chart shows daily values → verify pie chart shows category breakdown
- [ ] T207 Test export: capture chart screenshot → share via Android share sheet → verify watermark and branding
- [ ] T208 Test badge awards: trigger each badge criteria → verify badge modal → test share functionality
- [ ] T209 Test offline mode: disable network → log activity → verify local save → enable network → verify sync
- [ ] T210 Generate Android APK from Dreamflow Build menu with release configuration
- [ ] T211 Install APK on physical Android device (Android 8.0+ / API 26+) and test full flow
- [ ] T212 Record 30-second demo video: auth → log activity → complete AR challenge → view leaderboard → share
- [ ] T213 Pre-populate test accounts with sample data: 10-20 logs, 2-3 challenges completed, friends added, points earned
- [ ] T214 Create demo presentation slides highlighting innovation (AR + sustainability), polish (Material 3 animations), impact (CO2 data), and demo-ready APK

---

## Dependencies

### User Story Completion Order

```
Phase 1 (Setup) → Phase 2 (Foundational)
    ↓
Phase 3 (US1: Onboarding) → MUST complete first (authentication required for all other features)
    ↓
Phase 4 (US2: Logging) → MUST complete before US5 (analytics needs log data)
    ↓
Phase 5 (US3: AR Challenges) ← Can run in parallel with Phase 4 (independent of logging)
    ↓
Phase 6 (US4: Social) ← Depends on US1 (user profiles) and US2/US3 (points data)
    ↓
Phase 7 (US5: Analytics) ← Depends on US2 (log data)
    ↓
Phase 8 (US6: Sharing) ← Depends on US3 (challenges) and US5 (reports)
    ↓
Phase 9 (Polish) → Final touches
```

### Critical Path (Must complete for MVP)

1. Setup (T001-T020): Firebase + Dreamflow project
2. Foundational (T021-T027): Navigation + reusable components
3. US1 (T028-T059): Onboarding + Auth + Home Dashboard
4. US2 (T060-T088): Activity logging
5. US3 (T089-T119): AR challenges (at least 1 challenge functional)
6. US4 (T120-T147): Leaderboards (at least city or global)

**MVP = Phases 1-6 complete = ~150 minutes (2.5 hours)**

### Parallel Execution Opportunities

**During Setup (Phase 1)**:
- T002, T003, T016, T017, T018 (asset uploads) can run in parallel
- T010, T011, T012 (security rules deployment) can run in parallel after T009
- T013, T014, T015 (data seeding) can run in parallel after T006-T008
- T019 (test accounts) can run in parallel with T013-T015

**During Foundational (Phase 2)**:
- T022-T026 (reusable components) can all be created in parallel

**During US2 (Activity Logging)**:
- T065-T073 (Food modal), T074-T080 (Transport modal), T081-T086 (Energy modal) can be built in parallel after T064

**During US3 (AR Challenges)**:
- T094-T101 (Scan Plastic), T102-T107 (Plant Tree), T108-T116 (Bike Route) can be built in parallel after T089-T093

**During US6 (Sharing)**:
- T170-T174 (badge logic), T175-T178 (share badge), T179-T182 (share challenges) can be developed in parallel

**During Polish (Phase 9)**:
- T185-T188 (animations), T189-T192 (offline), T193-T197 (errors), T198-T201 (accessibility) can all be worked on in parallel

---

## Implementation Strategy

### MVP First (P1 User Stories)

Focus on completing **Phases 1-6** to deliver core functionality:
- ✅ User can sign up and view dashboard (US1)
- ✅ User can log activities and see CO2 calculations (US2)
- ✅ User can complete at least 1 AR challenge (US3)
- ✅ User can view leaderboards (US4)

**Target**: 150 minutes (2.5 hours)

### Incremental Delivery (P2 User Stories)

After MVP is functional, add enhancement features:
- 📊 Analytics and export (US5): +30 minutes
- 🎉 Sharing and badges (US6): +30 minutes

**Target**: +60 minutes (1 hour)

### Polish & Testing

Final 30 minutes for animations, offline support, error handling, and demo preparation:
- 🎨 Animations (T184-T188)
- 📱 Offline mode (T189-T192)
- ⚠️ Error handling (T193-T197)
- ♿ Accessibility (T198-T201)
- 🧪 Testing (T202-T214)

**Total Time**: 240 minutes (4 hours) ✅

---

## Task Summary

- **Total Tasks**: 214
- **Setup**: 20 tasks (45 minutes)
- **Foundational**: 7 tasks (15 minutes)
- **US1 (P1)**: 32 tasks (60 minutes)
- **US2 (P1)**: 29 tasks (45 minutes)
- **US3 (P1)**: 31 tasks (60 minutes)
- **US4 (P1)**: 28 tasks (45 minutes)
- **US5 (P2)**: 22 tasks (30 minutes)
- **US6 (P2)**: 14 tasks (20 minutes)
- **Polish**: 31 tasks (30 minutes)

**Parallel Opportunities**: 45+ tasks can be executed in parallel (asset uploads, component creation, modal implementations, animations)

**MVP Scope** (P1 only): Tasks T001-T147 = 150 minutes (2.5 hours)
**Full Scope** (P1 + P2 + Polish): All 214 tasks = 240 minutes (4 hours)

---

## Next Steps

1. Begin with **Phase 1: Setup** (T001-T020) to establish Firebase and Dreamflow foundation
2. Create **Phase 2: Foundational** components (T021-T027) for reuse across all screens
3. Implement **Phase 3: US1** (T028-T059) for onboarding flow - BLOCKING for all other features
4. Proceed with **Phase 4-6** (US2-US4) for MVP completion
5. Add **Phase 7-8** (US5-US6) for P2 enhancements
6. Finish with **Phase 9: Polish** for demo readiness

Execute tasks in order within each phase. Use parallel execution opportunities to accelerate development where possible.
