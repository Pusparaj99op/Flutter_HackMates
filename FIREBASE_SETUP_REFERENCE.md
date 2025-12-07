# Firebase Setup Reference - EcoQuest AR Carbon Tracker

**Purpose**: Copy-paste ready configurations for Firebase Console setup
**Time to Complete**: 15 minutes
**Prerequisites**: Firebase account created

---

## 1. Firestore Security Rules

**Location**: Firebase Console → Firestore Database → Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Users collection
    match /users/{userId} {
      // Anyone authenticated can read (for leaderboards, friend search)
      allow read: if request.auth != null;

      // Users can only create/update their own profile
      allow create: if request.auth != null
        && request.auth.uid == userId
        && request.resource.data.uid == userId
        && request.resource.data.email == request.auth.token.email;

      allow update: if request.auth != null
        && request.auth.uid == userId
        && request.resource.data.uid == resource.data.uid
        && request.resource.data.email == resource.data.email;

      // No one can delete users
      allow delete: if false;
    }

    // Activity logs collection
    match /logs/{logId} {
      // Users can read their own logs
      allow read: if request.auth != null
        && request.auth.uid == resource.data.userId;

      // Users can create logs for themselves
      allow create: if request.auth != null
        && request.auth.uid == request.resource.data.userId
        && request.resource.data.timestamp == request.time;

      // Users can update/delete their own logs
      allow update, delete: if request.auth != null
        && request.auth.uid == resource.data.userId;
    }

    // Challenges collection (read-only for users, admin writes)
    match /challenges/{challengeId} {
      allow read: if request.auth != null;
      allow write: if false; // Only admin can modify via console
    }

    // Challenge completions
    match /challenge_completions/{completionId} {
      // Users can read their own completions
      allow read: if request.auth != null
        && request.auth.uid == resource.data.userId;

      // Users can create completions for themselves
      allow create: if request.auth != null
        && request.auth.uid == request.resource.data.userId
        && request.resource.data.completedAt == request.time;

      // No updates or deletes allowed
      allow update, delete: if false;
    }

    // Friendships collection
    match /friendships/{friendshipId} {
      // Users can read friendships they're part of
      allow read: if request.auth != null
        && (request.auth.uid == resource.data.userId1
            || request.auth.uid == resource.data.userId2);

      // Users can create friendship requests
      allow create: if request.auth != null
        && (request.auth.uid == request.resource.data.userId1
            || request.auth.uid == request.resource.data.userId2)
        && request.resource.data.requestedBy == request.auth.uid;

      // Users can update status to accept
      allow update: if request.auth != null
        && (request.auth.uid == resource.data.userId1
            || request.auth.uid == resource.data.userId2)
        && request.resource.data.status == 'accepted';

      // Users can delete friendships they're part of
      allow delete: if request.auth != null
        && (request.auth.uid == resource.data.userId1
            || request.auth.uid == resource.data.userId2);
    }

    // Badges collection (read-only for users)
    match /badges/{badgeId} {
      allow read: if request.auth != null;
      allow write: if false; // Only admin can modify via console
    }
  }
}
```

---

## 2. Realtime Database Security Rules

**Location**: Firebase Console → Realtime Database → Rules

```json
{
  "rules": {
    ".read": "auth != null",
    ".write": false,

    "leaderboard_cache": {
      ".read": "auth != null",
      ".write": "auth != null",

      "global": {
        ".indexOn": ["points"]
      },

      "$city": {
        ".indexOn": ["points"]
      }
    }
  }
}
```

---

## 3. Storage Security Rules

**Location**: Firebase Console → Storage → Rules

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {

    // User profile pictures
    match /users/{userId}/profile/{fileName} {
      allow read: if request.auth != null;
      allow write: if request.auth != null
        && request.auth.uid == userId
        && request.resource.size < 5 * 1024 * 1024 // 5MB max
        && request.resource.contentType.matches('image/.*');
    }

    // Activity log photos (receipts, items)
    match /users/{userId}/receipts/{fileName} {
      allow read: if request.auth != null
        && request.auth.uid == userId;
      allow write: if request.auth != null
        && request.auth.uid == userId
        && request.resource.size < 10 * 1024 * 1024 // 10MB max
        && request.resource.contentType.matches('image/.*');
    }

    // Deny all other paths
    match /{allPaths=**} {
      allow read, write: if false;
    }
  }
}
```

---

## 4. Firestore Indexes

**Location**: Firebase Console → Firestore Database → Indexes

**Composite Indexes** (create manually):

### Index 1: City Leaderboard
```
Collection ID: users
Fields indexed:
  - city (Ascending)
  - points (Descending)
Query scope: Collection
```

### Index 2: User Logs by Date
```
Collection ID: logs
Fields indexed:
  - userId (Ascending)
  - timestamp (Descending)
Query scope: Collection
```

### Index 3: Challenge Completions by Date
```
Collection ID: challenge_completions
Fields indexed:
  - userId (Ascending)
  - dateKey (Ascending)
Query scope: Collection
```

**Single Field Indexes** (auto-created on first query):
- `users.email` (Ascending)
- `users.points` (Descending)
- `logs.category` (Ascending)

---

## 5. Seed Data - Challenges Collection

**Location**: Firebase Console → Firestore Database → Start Collection

**Collection ID**: `challenges`

### Document 1:
```json
{
  "challengeId": "scan-plastic",
  "title": "Scan Plastic",
  "description": "Find and scan a plastic item to help track recycling",
  "arType": "scan",
  "pointValue": 50,
  "dailyLimit": 1,
  "icon": "🔍",
  "difficulty": "easy"
}
```

### Document 2:
```json
{
  "challengeId": "plant-tree",
  "title": "Plant Tree",
  "description": "Tap to plant a virtual tree and offset carbon emissions",
  "arType": "place",
  "pointValue": 50,
  "dailyLimit": 1,
  "icon": "🌳",
  "difficulty": "easy"
}
```

### Document 3:
```json
{
  "challengeId": "bike-route",
  "title": "Bike Route",
  "description": "Complete a 2km bike route to reduce carbon footprint",
  "arType": "gps",
  "pointValue": 50,
  "dailyLimit": 1,
  "icon": "🚴",
  "difficulty": "medium"
}
```

---

## 6. Seed Data - Badges Collection

**Collection ID**: `badges`

### Document 1:
```json
{
  "badgeId": "streak-7",
  "title": "Week Warrior",
  "description": "Logged activities for 7 consecutive days",
  "criteria": {
    "type": "streak",
    "threshold": 7
  },
  "icon": "🔥",
  "rarity": "common"
}
```

### Document 2:
```json
{
  "badgeId": "points-100",
  "title": "Century Club",
  "description": "Earned 100 total points from challenges and activities",
  "criteria": {
    "type": "points",
    "threshold": 100
  },
  "icon": "💯",
  "rarity": "uncommon"
}
```

### Document 3:
```json
{
  "badgeId": "logs-50",
  "title": "Dedicated Logger",
  "description": "Logged 50 activities to track your carbon footprint",
  "criteria": {
    "type": "logs",
    "threshold": 50
  },
  "icon": "📊",
  "rarity": "rare"
}
```

---

## 7. Realtime Database Initial Structure

**Location**: Firebase Console → Realtime Database → Data

```json
{
  "leaderboard_cache": {
    "global": {
      "last_updated": 0
    },
    "New York": {
      "last_updated": 0
    },
    "Los Angeles": {
      "last_updated": 0
    },
    "London": {
      "last_updated": 0
    },
    "Paris": {
      "last_updated": 0
    },
    "Tokyo": {
      "last_updated": 0
    },
    "Sydney": {
      "last_updated": 0
    },
    "Mumbai": {
      "last_updated": 0
    },
    "Berlin": {
      "last_updated": 0
    },
    "Toronto": {
      "last_updated": 0
    },
    "Singapore": {
      "last_updated": 0
    }
  }
}
```

---

## 8. Test Accounts

**Location**: Firebase Console → Authentication → Users → Add User

### Account 1: Demo Judge 1
```
Email: judge1@ecoquest.demo
Password: Demo123!
UID: (auto-generated)
```

### Account 2: Demo Judge 2
```
Email: judge2@ecoquest.demo
Password: Demo123!
UID: (auto-generated)
```

### Account 3: Demo Judge 3
```
Email: judge3@ecoquest.demo
Password: Demo123!
UID: (auto-generated)
```

---

## 9. Pre-populate Test Data (Manual Steps)

**For each test account**:

1. Sign in to app with test account
2. Complete profile setup:
   - Name: "Judge One" / "Judge Two" / "Judge Three"
   - City: "New York" (vary across accounts)
   - Commute: "Car" (vary: Bus, Bike, Walk)

3. Create sample logs (via app):
   - 5 food logs (mix of meal types)
   - 5 transport logs (different distances)
   - 3 energy logs (various kWh)

4. Complete AR challenges:
   - Scan Plastic: Complete once
   - Plant Tree: Complete once
   - Bike Route: Skip (GPS required)

5. Add friendships:
   - From judge1: Add judge2 and judge3
   - Accept all friend requests

**Expected Result**:
- 3 users in Firestore with ~500-800 points each
- 40-50 total activity logs across accounts
- 6 challenge completions (2 per user × 1 challenge)
- Leaderboard cache populated with rankings

---

## 10. Verification Checklist

After setup, verify:

- [ ] Firestore rules deployed (no syntax errors)
- [ ] RTDB rules deployed (no syntax errors)
- [ ] Storage rules deployed (no syntax errors)
- [ ] 3 challenges documents exist in Firestore
- [ ] 3 badges documents exist in Firestore
- [ ] RTDB leaderboard_cache has city nodes
- [ ] 3 test accounts created in Firebase Auth
- [ ] Test write to Firestore: `users/test123` (then delete)
- [ ] Test read from Firestore challenges (should succeed)
- [ ] Test read from RTDB leaderboard_cache (should succeed)

---

## 11. Common Issues & Fixes

### Issue: "Missing or insufficient permissions"
**Fix**: Re-deploy Firestore rules, ensure `allow read: if request.auth != null`

### Issue: "Document does not exist"
**Fix**: Create seed data documents (challenges, badges) manually in console

### Issue: "Index required for query"
**Fix**: Click auto-generated link in error message to create index

### Issue: "Quota exceeded"
**Fix**: Check Firebase Console → Usage tab → Reduce query frequency or upgrade plan

### Issue: "Auth domain not authorized"
**Fix**: Firebase Console → Authentication → Settings → Add app domain to authorized domains

---

## 12. Production Deployment Notes

**Before deploying to production**:

1. **Switch Firestore to locked mode temporarily**:
   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /{document=**} {
         allow read, write: if false;
       }
     }
   }
   ```

2. **Review security rules thoroughly** - Test all auth scenarios

3. **Enable App Check** (optional, prevents abuse):
   - Firebase Console → App Check → Register app
   - Requires Play Integrity API for Android

4. **Set up budget alerts**:
   - Firebase Console → Settings → Usage and billing
   - Set alert at 50% of free tier limits

5. **Monitor in real-time**:
   - Firebase Console → Performance Monitoring
   - Track slow queries and errors

---

**Setup complete! Return to [IMPLEMENTATION_GUIDE.md](./IMPLEMENTATION_GUIDE.md) to continue with Dreamflow configuration.**
