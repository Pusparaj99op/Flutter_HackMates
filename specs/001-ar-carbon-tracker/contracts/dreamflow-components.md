# Dreamflow Components: EcoQuest AR Carbon Tracker

**Feature**: 001-ar-carbon-tracker
**Date**: 2025-12-06
**Purpose**: Document Dreamflow visual builder component structure and data bindings

## Screen Components

### 1. Splash Screen (`splash.screen`)

**Components**:
- Lottie Animation Player
  - Source: `assets/lottie/splash.json`
  - Loop: false
  - Duration: 2 seconds
  - Auto-navigate: → `onboarding.screen` on complete

**Data Bindings**: None

**Actions**:
- On animation complete → Navigate to Onboarding

---

### 2. Onboarding Screen (`onboarding.screen`)

**Components**:
- Carousel Slider
  - Items: 3 slides
  - Slide 1:
    - Image: `assets/onboarding/slide1.png`
    - Title: "Scan Your Habits"
    - Description: "Track your carbon footprint by scanning receipts and activities"
  - Slide 2:
    - Image: `assets/onboarding/slide2.png`
    - Title: "AR Challenges"
    - Description: "Complete fun AR challenges to earn points and make a difference"
  - Slide 3:
    - Image: `assets/onboarding/slide3.png`
    - Title: "Beat Your Friends"
    - Description: "Compete on leaderboards and challenge friends to save more CO2"
- Primary Button: "Get Started"
  - On tap → Navigate to Auth Screen

**Data Bindings**: None

**Actions**:
- Button tap → Navigate to `auth.screen`

---

### 3. Auth Screen (`auth.screen`)

**Components**:
- Logo Image (centered)
- Google Sign-In Button
  - Style: Material 3, elevated
  - Icon: Google logo
  - Text: "Continue with Google"
  - On tap → Firebase Auth Google Sign-In
- Divider with "OR" text
- Email Input Field
  - Validation: Email format
  - Keyboard: Email type
- Password Input Field
  - Obscure text: true
  - Min length: 6
- Primary Button: "Sign In with Email"
  - On tap → Firebase Auth Email/Password Sign-In
- Text Button: "Create Account"
  - On tap → Firebase Auth Email/Password Register

**Data Bindings**:
- Email Input → `emailVar` (string)
- Password Input → `passwordVar` (string)

**Actions**:
- On successful auth → Check if profile exists
  - If no profile → Navigate to `profile-setup.screen`
  - If profile exists → Navigate to `home-dashboard.screen`
- On auth error → Show error snackbar

**Firebase Integration**:
- Auth provider: Google OAuth + Email/Password
- On auth state change → Update current user state

---

### 4. Profile Setup Screen (`profile-setup.screen`)

**Components**:
- Text Field: Name
  - Max length: 50
  - Validation: Required, 2+ characters
- Dropdown: City Selection
  - Options: ["New York", "Los Angeles", "London", "Paris", "Tokyo", "Sydney", "Mumbai", "Berlin", "Toronto", "Singapore"]
  - Default: None (force selection)
- Radio Group: Commute Mode
  - Options: "Car", "Bus", "Bike", "Walk"
  - Icons: Respective transport icons
  - Default: None (force selection)
- Primary Button: "Complete Setup"
  - Enabled: When all fields valid
  - On tap → Create user document in Firestore

**Data Bindings**:
- Name Field → `nameVar` (string)
- City Dropdown → `cityVar` (string)
- Commute Radio → `commuteModeVar` (string)

**Actions**:
- Button tap → Create Firestore document:
  - Collection: `users`
  - Document ID: `currentUser.uid`
  - Data:
    ```javascript
    {
      uid: currentUser.uid,
      name: nameVar,
      email: currentUser.email,
      city: cityVar,
      commuteMode: commuteModeVar,
      totalCO2Saved: 0,
      points: 0,
      currentStreak: 0,
      longestStreak: 0,
      weeklyTarget: 500,
      badges: [],
      friendIds: [],
      createdAt: Timestamp.now(),
      lastLoginAt: Timestamp.now(),
      lastActivityAt: null
    }
    ```
- On success → Navigate to `home-dashboard.screen`

---

### 5. Home Dashboard Screen (`home-dashboard.screen`)

**Components**:

#### Bottom Navigation Bar
- Tabs: Home (active), Tracker, AR, Social
- Icons: Material 3 icons
- On tap → Navigate to respective screen

#### Hero Section
- Greeting Text: "Hello, {userName}!" (data-bound)
- Circular Progress Widget
  - Value: `totalCO2Saved / weeklyTarget` (percentage)
  - Center text: "{totalCO2Saved}g CO2 saved 🌿"
  - Color: Green (#4CAF50)
- Streak Counter Card
  - Icon: Flame emoji 🔥
  - Text: "{currentStreak} day streak"

#### Quick Log Section
- Horizontal Scroll View
  - Quick Log Card: Food
    - Icon: 🍽️
    - Title: "Food"
    - On tap → Open food log modal
  - Quick Log Card: Transport
    - Icon: 🚗
    - Title: "Transport"
    - On tap → Open transport log modal
  - Quick Log Card: Energy
    - Icon: ⚡
    - Title: "Energy"
    - On tap → Open energy log modal

#### Today's Challenge Section
- Challenge Card Component
  - Data-bound to active challenge from Firestore
  - Title: Challenge title
  - Icon: Challenge icon
  - Progress: "0/1 completed today"
  - On tap → Navigate to `ar-challenges.screen` with challenge ID

#### Top 3 Leaderboard Section
- Title: "Top Friends"
- List View (3 items)
  - Leaderboard Item Component (repeated)
    - Rank number (1, 2, 3)
    - Avatar image
    - Name
    - Points
  - Data-bound to RTDB `/leaderboard_cache/{city}` query top 3
- View All Button → Navigate to `social.screen` (leaderboard tab)

**Data Bindings**:
- Firestore document: `users/{currentUser.uid}` → Auto-binding
  - `userName` = document.name
  - `totalCO2Saved` = document.totalCO2Saved
  - `weeklyTarget` = document.weeklyTarget
  - `currentStreak` = document.currentStreak
- Firestore query: `challenges` where `isActive == true` limit 1 → `todayChallenge`
- RTDB query: `leaderboard_cache/{userCity}` order by points DESC limit 3 → `top3Friends`

**Actions**:
- Pull to refresh → Reload all data sources
- Quick log card tap → Open bottom sheet modal with respective form

---

### 6. Tracker History Screen (`tracker-history.screen`)

**Components**:

#### Charts Section
- Weekly Bar Chart Widget
  - Data source: Firestore query `logs` where `userId == currentUser.uid` and `timestamp >= 7 days ago`
  - X-axis: Days of week (Mon-Sun)
  - Y-axis: CO2 grams
  - Bars: Actual CO2 per day
  - Line overlay: Weekly target line (500g / 7 days)
- Pie Chart Widget
  - Data source: Aggregated from logs query grouped by category
  - Slices:
    - Transport: Green (#4CAF50)
    - Food: Orange (#FF9800)
    - Energy: Blue (#2196F3)
  - Labels: Percentage + category name

#### Activity List Section
- Title: "Recent Activity"
- List View (scrollable)
  - Activity Log Item Component (repeated)
    - Category icon
    - Title: "{category} - {co2Grams}g CO2"
    - Subtitle: "{timestamp} - {details}"
    - Edit icon button → Open edit modal
  - Data-bound to Firestore query `logs` where `userId == currentUser.uid` order by `timestamp` DESC limit 50

#### Floating Action Button
- Icon: Export icon
- On tap → Capture screenshot of charts section → Share via Android share sheet

**Data Bindings**:
- Firestore query: `logs/{userId}` order by timestamp DESC → `recentLogs`
- Computed: Group logs by date for bar chart
- Computed: Group logs by category for pie chart

**Actions**:
- Edit button → Open bottom sheet with log details, allow edit, save to Firestore
- FAB tap → Screenshot + Share

---

### 7. AR Challenges Screen (`ar-challenges.screen`)

**Components**:

#### Camera Preview
- Camera Component
  - ML Kit integration: Object detection enabled
  - Overlay canvas for AR elements

#### Challenge Selection (Bottom Sheet)
- List of Challenge Cards
  - Data-bound to Firestore `challenges` collection
  - Each card:
    - Challenge icon
    - Title
    - Description
    - Point value
    - Completion status: "Completed today" or "Start Challenge" button

#### Active Challenge Overlay (when challenge started)
- Challenge type: Scan Plastic
  - ML Kit object labels overlay
  - When "bottle" or "plastic" detected:
    - Show green checkmark animation (Lottie)
    - Award points
    - Save completion to Firestore
- Challenge type: Plant Tree
  - Tap gesture detector on camera preview
  - On tap → Display tree sprite at tap location
  - Animate tree growth (5 frames)
  - Award points after animation
- Challenge type: Bike Route
  - GPS location tracking
  - Distance calculation from start point
  - Directional arrow overlay pointing toward route
  - When 2km reached → Award points

#### Completion Modal
- Confetti animation (Lottie)
- Points earned: "+50 points"
- Primary button: "Share Achievement" → Android share sheet with screenshot
- Secondary button: "Close" → Return to challenge selection

**Data Bindings**:
- Firestore collection: `challenges` → `availableChallenges`
- Firestore query: `challenge_completions` where `userId == currentUser.uid` and `dateKey == today` → `todayCompletions`
- Computed: Filter challenges to show completion status

**Actions**:
- Start challenge → Initialize respective AR mode (ML Kit / GPS / Tap)
- On success → Create Firestore document:
  - Collection: `challenge_completions`
  - Data:
    ```javascript
    {
      userId: currentUser.uid,
      challengeId: selectedChallenge.id,
      completedAt: Timestamp.now(),
      dateKey: formatDate(new Date(), 'YYYY-MM-DD'),
      pointsAwarded: selectedChallenge.pointValue
    }
    ```
- Update user points: `users/{uid}.points += pointsAwarded`

---

### 8. Social Screen (`social.screen`)

**Components**:

#### Tab Bar
- Friends Tab (default)
- City Leaderboard Tab
- Global Leaderboard Tab

#### Friends Tab
- Search Bar
  - Placeholder: "Search by email"
  - On input → Firestore query `users` where `email == searchInput`
- Friends List View
  - Friend Item Component (repeated)
    - Avatar
    - Name
    - Points
    - "Challenge" button → Send notification
  - Data-bound to Firestore query:
    - Get `users/{currentUser.uid}.friendIds` array
    - Query `users` where `uid in friendIds`

#### City Leaderboard Tab
- Pull to refresh → Update RTDB cache
- List View (top 100)
  - Leaderboard Item Component (repeated)
    - Rank number
    - Avatar
    - Name
    - Points
  - Data-bound to RTDB `leaderboard_cache/{userCity}` order by points DESC

#### Global Leaderboard Tab
- Same as City but data from RTDB `leaderboard_cache/global`

**Data Bindings**:
- Firestore document: `users/{currentUser.uid}` → Get `friendIds` array
- Firestore query: `users` where `uid in friendIds` → `friendsList`
- RTDB query: `leaderboard_cache/{city}` → `cityLeaderboard`
- RTDB query: `leaderboard_cache/global` → `globalLeaderboard`

**Actions**:
- Search → Query Firestore users by email
- Add friend → Create Firestore document in `friendships`:
  ```javascript
  {
    userId1: min(currentUser.uid, friendUid),  // Alphabetically lower
    userId2: max(currentUser.uid, friendUid),  // Alphabetically higher
    status: 'pending',
    requestedBy: currentUser.uid,
    createdAt: Timestamp.now()
  }
  ```
- Challenge friend → Firebase Cloud Messaging notification

---

## Reusable Components

### Quick Log Card Component (`quick-log-card.component`)

**Props**:
- `category` (string): "food" | "transport" | "energy"
- `icon` (string): Icon name
- `title` (string): Display title

**UI**:
- Material 3 Card (elevated)
- Icon (centered, large)
- Title text (below icon)
- On tap → Emit event to parent

---

### Leaderboard Item Component (`leaderboard-item.component`)

**Props**:
- `rank` (number): Position (1, 2, 3, ...)
- `name` (string): User name
- `points` (number): Points total
- `avatarUrl` (string, optional): Profile picture URL

**UI**:
- List tile layout
- Leading: Rank badge (circular, colored: gold/silver/bronze for top 3)
- Title: Name
- Trailing: Points with trophy icon

---

### Challenge Card Component (`challenge-card.component`)

**Props**:
- `challenge` (object): Challenge data from Firestore
- `isCompleted` (boolean): Today's completion status

**UI**:
- Material 3 Card
- Challenge icon (top)
- Title + description
- Point value badge
- Button: "Start Challenge" or "Completed" (disabled if complete)

---

### Activity Log Item Component (`activity-log-item.component`)

**Props**:
- `log` (object): Log data from Firestore

**UI**:
- List tile
- Leading: Category icon (transport/food/energy)
- Title: "{category} - {co2Grams}g CO2"
- Subtitle: "{timestamp} - {details summary}"
- Trailing: Edit icon button

---

## Bottom Sheet Modals

### Food Log Modal

**Fields**:
- Meal Type Radio: Beef, Chicken, Fish, Vegetarian, Vegan
- Servings Number Input (1-10)
- Notes Text Field (optional)
- Camera Button → Capture photo

**Calculation**:
```javascript
const factors = { beef: 3000, chicken: 800, fish: 600, vegetarian: 300, vegan: 150 };
co2Grams = factors[mealType] * servings;
```

**Submit Action**:
- Create Firestore document in `logs` collection
- Update user's `totalCO2Saved` (if reduction logged)
- Close modal

---

### Transport Log Modal

**Fields**:
- Mode Radio: Car, Bus, Bike, Walk
- Distance Number Input (km)
- Notes Text Field (optional)

**Calculation**:
```javascript
const factors = { car: 120, bus: 40, bike: 0, walk: 0 };
co2Grams = factors[mode] * distanceKm;
```

**Submit Action**: Same as food log

---

### Energy Log Modal

**Fields**:
- Usage Number Input (kWh)
- Source Radio: Electricity, Gas
- Notes Text Field (optional)

**Calculation**:
```javascript
const factors = { electricity: 500, gas: 200 };
co2Grams = factors[source] * usageKwh;
```

**Submit Action**: Same as food log

---

## Theme Configuration (`theme/material3.config`)

**Colors**:
```yaml
primary: #4CAF50          # Green
onPrimary: #FFFFFF        # White text on primary
secondary: #2196F3        # Ocean blue
onSecondary: #FFFFFF
background: #FAFAFA       # Light grey
surface: #FFFFFF
error: #F44336
```

**Typography**:
```yaml
headlineLarge: Roboto 32sp Bold
headlineMedium: Roboto 24sp Bold
titleLarge: Roboto 20sp Medium
bodyLarge: Roboto 16sp Regular
bodyMedium: Roboto 14sp Regular
labelLarge: Roboto 14sp Medium (buttons)
```

**Shapes**:
```yaml
cornerRadius: 20px
elevation: 4dp (cards), 8dp (FAB)
```

---

## Global State Variables

**In Dreamflow's state management**:
```javascript
currentUser: FirebaseUser | null
userProfile: UserDocument | null
selectedChallenge: Challenge | null
todayCompletions: ChallengeCompletion[]
recentLogs: ActivityLog[]
top3Friends: LeaderboardEntry[]
```

---

## Navigation Flow

```
splash.screen
  → onboarding.screen
    → auth.screen
      → profile-setup.screen (if new user)
      → home-dashboard.screen
        ├─ Bottom Nav → tracker-history.screen
        ├─ Bottom Nav → ar-challenges.screen
        └─ Bottom Nav → social.screen
```

---

## Next Steps

1. Create Dreamflow project with screens
2. Configure Firebase integration (Auth, Firestore, Storage, RTDB)
3. Import Lottie animations and image assets
4. Set Material 3 theme colors
5. Bind components to Firebase data sources
6. Implement action handlers (log creation, challenge completion, etc.)
7. Test full flow with test accounts
