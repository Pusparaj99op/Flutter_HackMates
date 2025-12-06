# Firebase Schema: EcoQuest AR Carbon Tracker

**Feature**: 001-ar-carbon-tracker
**Date**: 2025-12-06
**Purpose**: Define Firestore collections, RTDB structure, and security rules

## Firestore Collections

### Collection: `users`

**Path**: `/users/{uid}`

**Schema**:
```typescript
{
  uid: string;              // Firebase Auth UID (document ID)
  name: string;             // Display name
  email: string;            // Email from Firebase Auth
  city: string;             // Selected city
  profilePicUrl?: string;   // Optional profile picture URL
  commuteMode: "car" | "bus" | "bike" | "walk";
  totalCO2Saved: number;    // Grams of CO2 saved
  points: number;           // Gamification points
  currentStreak: number;    // Consecutive days
  longestStreak: number;    // Record streak
  weeklyTarget: number;     // CO2 goal in grams
  badges: string[];         // Array of badge IDs
  friendIds: string[];      // Array of friend UIDs
  createdAt: Timestamp;
  lastLoginAt: Timestamp;
  lastActivityAt: Timestamp;
}
```

**Indexes**:
- `city` ASC, `points` DESC (for city leaderboards)
- `points` DESC (for global leaderboard)
- `email` ASC (for friend search)

**Security Rules**:
```javascript
match /users/{userId} {
  // Anyone can read user profiles (for leaderboards, friend search)
  allow read: if request.auth != null;

  // Users can only create their own profile
  allow create: if request.auth != null
    && request.auth.uid == userId
    && request.resource.data.uid == userId
    && request.resource.data.email == request.auth.token.email;

  // Users can only update their own profile
  allow update: if request.auth != null
    && request.auth.uid == userId
    && request.resource.data.uid == userId;  // Prevent UID change

  // No deletes allowed
  allow delete: if false;
}
```

---

### Collection: `logs`

**Path**: `/logs/{logId}`

**Schema**:
```typescript
{
  logId: string;           // Auto-generated document ID
  userId: string;          // FK to users
  timestamp: Timestamp;    // Activity occurrence time
  category: "transport" | "food" | "energy";
  co2Grams: number;        // Calculated emissions
  details: {
    // Transport
    mode?: "car" | "bus" | "bike" | "walk";
    distanceKm?: number;
    // Food
    mealType?: "beef" | "chicken" | "fish" | "vegetarian" | "vegan";
    servings?: number;
    // Energy
    usageKwh?: number;
    source?: "electricity" | "gas";
  };
  notes?: string;          // Optional user notes
  photoUrl?: string;       // Optional receipt photo
  createdAt: Timestamp;
}
```

**Indexes**:
- `userId` ASC, `timestamp` DESC
- `userId` ASC, `category` ASC, `timestamp` DESC

**Security Rules**:
```javascript
match /logs/{logId} {
  // Users can read their own logs
  allow read: if request.auth != null
    && request.auth.uid == resource.data.userId;

  // Users can create logs for themselves
  allow create: if request.auth != null
    && request.auth.uid == request.resource.data.userId
    && request.resource.data.co2Grams >= 0
    && request.resource.data.co2Grams <= 50000;

  // Users can update their own logs (edit functionality)
  allow update: if request.auth != null
    && request.auth.uid == resource.data.userId;

  // Users can delete their own logs
  allow delete: if request.auth != null
    && request.auth.uid == resource.data.userId;
}
```

---

### Collection: `challenges`

**Path**: `/challenges/{challengeId}`

**Schema**:
```typescript
{
  challengeId: string;     // Document ID (e.g., "scan-plastic")
  title: string;           // Display title
  description: string;     // Instructions
  arType: "scan" | "place" | "gps";
  pointValue: number;      // Points awarded
  dailyLimit: number;      // Max completions per day
  iconUrl: string;         // Challenge icon URL
  isActive: boolean;       // Availability flag
}
```

**Security Rules**:
```javascript
match /challenges/{challengeId} {
  // Anyone authenticated can read challenges
  allow read: if request.auth != null;

  // No client writes allowed (admin-only, seeded data)
  allow write: if false;
}
```

**Seed Data** (to be created manually in Firestore console or via script):
```json
[
  {
    "challengeId": "scan-plastic",
    "title": "Scan Plastic",
    "description": "Point camera at plastic item to detect and earn points",
    "arType": "scan",
    "pointValue": 50,
    "dailyLimit": 1,
    "iconUrl": "gs://bucket/icons/scan-plastic.png",
    "isActive": true
  },
  {
    "challengeId": "plant-tree",
    "title": "Plant a Tree",
    "description": "Tap ground in camera view to plant virtual tree",
    "arType": "place",
    "pointValue": 50,
    "dailyLimit": 1,
    "iconUrl": "gs://bucket/icons/plant-tree.png",
    "isActive": true
  },
  {
    "challengeId": "bike-route",
    "title": "Bike Route",
    "description": "Follow AR arrows for 2km eco-friendly path",
    "arType": "gps",
    "pointValue": 50,
    "dailyLimit": 1,
    "iconUrl": "gs://bucket/icons/bike-route.png",
    "isActive": true
  }
]
```

---

### Collection: `challenge_completions`

**Path**: `/challenge_completions/{completionId}`

**Schema**:
```typescript
{
  completionId: string;    // Auto-generated document ID
  userId: string;          // FK to users
  challengeId: string;     // FK to challenges
  completedAt: Timestamp;
  dateKey: string;         // YYYY-MM-DD format
  pointsAwarded: number;   // Denormalized from challenges
}
```

**Indexes**:
- `userId` ASC, `dateKey` DESC
- `userId` ASC, `challengeId` ASC, `dateKey` DESC (for daily limit check)

**Security Rules**:
```javascript
match /challenge_completions/{completionId} {
  // Users can read their own completions
  allow read: if request.auth != null
    && request.auth.uid == resource.data.userId;

  // Users can create completions for themselves (with daily limit validation in Dreamflow)
  allow create: if request.auth != null
    && request.auth.uid == request.resource.data.userId
    && request.resource.data.pointsAwarded > 0;

  // No updates or deletes (immutable records)
  allow update, delete: if false;
}
```

---

### Collection: `friendships`

**Path**: `/friendships/{friendshipId}`

**Schema**:
```typescript
{
  friendshipId: string;    // Auto-generated document ID
  userId1: string;         // Lower UID alphabetically
  userId2: string;         // Higher UID alphabetically
  status: "pending" | "accepted" | "blocked";
  requestedBy: string;     // UID who initiated
  createdAt: Timestamp;
  acceptedAt?: Timestamp;  // Optional, set when accepted
}
```

**Indexes**:
- `userId1` ASC, `status` ASC
- `userId2` ASC, `status` ASC

**Security Rules**:
```javascript
match /friendships/{friendshipId} {
  // Users can read friendships they're part of
  allow read: if request.auth != null
    && (request.auth.uid == resource.data.userId1
        || request.auth.uid == resource.data.userId2);

  // Users can create friend requests
  allow create: if request.auth != null
    && (request.auth.uid == request.resource.data.userId1
        || request.auth.uid == request.resource.data.userId2)
    && request.resource.data.requestedBy == request.auth.uid
    && request.resource.data.status == "pending";

  // Users can update friendship status (accept/block)
  allow update: if request.auth != null
    && (request.auth.uid == resource.data.userId1
        || request.auth.uid == resource.data.userId2)
    && resource.data.status == "pending";  // Can only update pending requests

  // No deletes allowed
  allow delete: if false;
}
```

---

### Collection: `badges`

**Path**: `/badges/{badgeId}`

**Schema**:
```typescript
{
  badgeId: string;         // Document ID (e.g., "streak-7")
  title: string;           // Badge name
  description: string;     // How to earn
  iconUrl: string;         // Badge icon URL
  criteria: {
    type: "streak" | "points" | "logs" | "challenges";
    threshold: number;
  };
  isActive: boolean;
}
```

**Security Rules**:
```javascript
match /badges/{badgeId} {
  // Anyone authenticated can read badges
  allow read: if request.auth != null;

  // No client writes allowed (admin-only, seeded data)
  allow write: if false;
}
```

**Seed Data**:
```json
[
  {
    "badgeId": "streak-7",
    "title": "Week Warrior",
    "description": "Log activity for 7 consecutive days",
    "iconUrl": "gs://bucket/badges/streak-7.png",
    "criteria": { "type": "streak", "threshold": 7 },
    "isActive": true
  },
  {
    "badgeId": "points-100",
    "title": "Carbon Crusader",
    "description": "Earn 100 points from challenges",
    "iconUrl": "gs://bucket/badges/points-100.png",
    "criteria": { "type": "points", "threshold": 100 },
    "isActive": true
  },
  {
    "badgeId": "logs-50",
    "title": "Tracking Master",
    "description": "Log 50 activities",
    "iconUrl": "gs://bucket/badges/logs-50.png",
    "criteria": { "type": "logs", "threshold": 50 },
    "isActive": true
  }
]
```

---

## Firebase Realtime Database Structure

### Path: `/leaderboard_cache`

**Structure**:
```json
{
  "leaderboard_cache": {
    "global": {
      "{userId}": {
        "name": "string",
        "points": "number",
        "city": "string",
        "rank": "number"
      }
    },
    "{cityName}": {
      "{userId}": {
        "name": "string",
        "points": "number",
        "rank": "number"
      }
    },
    "last_updated": "ISO8601 timestamp"
  }
}
```

**Example**:
```json
{
  "leaderboard_cache": {
    "global": {
      "user123": { "name": "Alice", "points": 245, "city": "New York", "rank": 1 },
      "user456": { "name": "Bob", "points": 180, "city": "London", "rank": 2 }
    },
    "new-york": {
      "user123": { "name": "Alice", "points": 245, "rank": 1 },
      "user789": { "name": "Charlie", "points": 120, "rank": 2 }
    },
    "london": {
      "user456": { "name": "Bob", "points": 180, "rank": 1 }
    },
    "last_updated": "2025-12-06T12:00:00Z"
  }
}
```

**Security Rules** (RTDB):
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

**Update Logic** (in Dreamflow):
1. User pulls to refresh on leaderboard screen
2. Check `last_updated` timestamp
3. If older than 5 minutes:
   - Query Firestore `/users` ordered by `points DESC` limit 100
   - For each city, filter users by city and rank
   - Write sorted results to RTDB `/leaderboard_cache/{global|city}`
   - Update `last_updated` timestamp

---

## Firebase Storage Structure

### Buckets

**Path**: `gs://{project-id}.appspot.com/`

**Folders**:
```
/users/{userId}/
  ├── profile.jpg          # Profile pictures
  └── receipts/
      └── {timestamp}.jpg  # Receipt/item photos

/assets/
  ├── icons/
  │   ├── scan-plastic.png
  │   ├── plant-tree.png
  │   └── bike-route.png
  ├── badges/
  │   ├── streak-7.png
  │   ├── points-100.png
  │   └── logs-50.png
  └── onboarding/
      ├── slide1.png
      ├── slide2.png
      └── slide3.png
```

**Security Rules**:
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Users can read their own files
    match /users/{userId}/{allPaths=**} {
      allow read: if request.auth != null && request.auth.uid == userId;
      allow write: if request.auth != null && request.auth.uid == userId;
    }

    // Anyone can read public assets
    match /assets/{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if false;  // Admin-only uploads
    }
  }
}
```

---

## Firebase Authentication Configuration

**Enabled Sign-In Methods**:
- Google Sign-In (primary, OAuth 2.0)
- Email/Password (fallback)

**OAuth Redirect URLs**:
- `https://{project-id}.firebaseapp.com/__/auth/handler` (auto-configured)

**Test Accounts** (for hackathon demo):
```
judge1@ecoquest.demo / TestPass123!
judge2@ecoquest.demo / TestPass123!
judge3@ecoquest.demo / TestPass123!
```

---

## Data Migration / Seeding Plan

**Step 1**: Create Firestore collections via Dreamflow Firebase integration
**Step 2**: Seed `challenges` collection with 3 challenges (use Firestore console or script)
**Step 3**: Seed `badges` collection with 3 badges
**Step 4**: Upload asset images to Firebase Storage `/assets/` folder
**Step 5**: Initialize RTDB `/leaderboard_cache` with empty structure
**Step 6**: Create test user accounts via Firebase Auth console

**Seed Script** (run once after Firebase setup):
```javascript
// Execute in Dreamflow's custom action or Firebase console
const challenges = [ /* data from above */ ];
const badges = [ /* data from above */ ];

challenges.forEach(c => db.collection('challenges').doc(c.challengeId).set(c));
badges.forEach(b => db.collection('badges').doc(b.badgeId).set(b));

db.ref('leaderboard_cache').set({ global: {}, last_updated: new Date().toISOString() });
```

---

## Firestore Composite Security Rules

**Complete `firestore.rules` file**:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Helper functions
    function isAuthenticated() {
      return request.auth != null;
    }

    function isOwner(userId) {
      return request.auth.uid == userId;
    }

    // Users collection
    match /users/{userId} {
      allow read: if isAuthenticated();
      allow create: if isAuthenticated() && isOwner(userId)
        && request.resource.data.uid == userId
        && request.resource.data.email == request.auth.token.email;
      allow update: if isAuthenticated() && isOwner(userId);
      allow delete: if false;
    }

    // Logs collection
    match /logs/{logId} {
      allow read: if isAuthenticated() && isOwner(resource.data.userId);
      allow create: if isAuthenticated() && isOwner(request.resource.data.userId)
        && request.resource.data.co2Grams >= 0
        && request.resource.data.co2Grams <= 50000;
      allow update: if isAuthenticated() && isOwner(resource.data.userId);
      allow delete: if isAuthenticated() && isOwner(resource.data.userId);
    }

    // Challenges collection (read-only for clients)
    match /challenges/{challengeId} {
      allow read: if isAuthenticated();
      allow write: if false;
    }

    // Challenge completions
    match /challenge_completions/{completionId} {
      allow read: if isAuthenticated() && isOwner(resource.data.userId);
      allow create: if isAuthenticated() && isOwner(request.resource.data.userId)
        && request.resource.data.pointsAwarded > 0;
      allow update, delete: if false;
    }

    // Friendships
    match /friendships/{friendshipId} {
      allow read: if isAuthenticated()
        && (isOwner(resource.data.userId1) || isOwner(resource.data.userId2));
      allow create: if isAuthenticated()
        && (isOwner(request.resource.data.userId1) || isOwner(request.resource.data.userId2))
        && request.resource.data.requestedBy == request.auth.uid
        && request.resource.data.status == "pending";
      allow update: if isAuthenticated()
        && (isOwner(resource.data.userId1) || isOwner(resource.data.userId2))
        && resource.data.status == "pending";
      allow delete: if false;
    }

    // Badges (read-only for clients)
    match /badges/{badgeId} {
      allow read: if isAuthenticated();
      allow write: if false;
    }
  }
}
```

---

## Next Steps

1. Configure Firebase project in Dreamflow
2. Deploy security rules to Firestore, RTDB, and Storage
3. Seed challenges and badges collections
4. Upload asset images to Storage
5. Create test accounts for demo
