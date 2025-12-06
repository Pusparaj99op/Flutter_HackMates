# Data Model: EcoQuest AR Carbon Tracker

**Feature**: 001-ar-carbon-tracker
**Date**: 2025-12-06
**Purpose**: Define entity schemas and relationships

## Entity Schemas

### User

Represents an app user with their profile, stats, and preferences.

**Attributes**:
- `uid` (string, PK): Firebase Auth user ID
- `name` (string, required): Display name
- `email` (string, required): Email address from Firebase Auth
- `city` (string, required): Selected city from dropdown (e.g., "New York", "London")
- `profilePicUrl` (string, optional): Firebase Storage URL for profile picture
- `commuteMode` (enum, required): Daily commute mode - "car" | "bus" | "bike" | "walk"
- `totalCO2Saved` (number, default: 0): Cumulative grams of CO2 saved
- `points` (number, default: 0): Gamification points from challenges and activities
- `currentStreak` (number, default: 0): Consecutive days with activity logged
- `longestStreak` (number, default: 0): Record streak
- `weeklyTarget` (number, default: 500): Weekly CO2 savings goal in grams
- `badges` (array<string>, default: []): Array of earned badge IDs
- `friendIds` (array<string>, default: []): Array of accepted friend user IDs
- `createdAt` (timestamp): Account creation date
- `lastLoginAt` (timestamp): Last login timestamp
- `lastActivityAt` (timestamp): Last activity log timestamp (for streak calculation)

**Relationships**:
- Has many: ActivityLog (one-to-many via userId)
- Has many: Friendship (one-to-many via userId1 or userId2)
- Has many: Badge (many-to-many via badges array)

**Validation Rules**:
- `name`: 2-50 characters, no special characters except spaces, hyphens, apostrophes
- `city`: Must match predefined city list
- `commuteMode`: Must be one of enum values
- `totalCO2Saved`, `points`, `currentStreak`: Non-negative integers
- `weeklyTarget`: 100-10000 range (reasonable weekly goal)

**Indexes** (Firestore):
- `city` + `points` DESC (for city leaderboards)
- `points` DESC (for global leaderboard)
- `email` (for friend search)

---

### ActivityLog

Represents a single carbon-generating activity logged by a user.

**Attributes**:
- `logId` (string, PK): Auto-generated Firestore document ID
- `userId` (string, FK, required): Reference to User.uid
- `timestamp` (timestamp, required): When activity occurred (user-selected or current time)
- `category` (enum, required): "transport" | "food" | "energy"
- `co2Grams` (number, required): Calculated CO2 emissions in grams
- `details` (object, required): Category-specific details
  - **Transport**: `{ mode: "car"|"bus"|"bike"|"walk", distanceKm: number }`
  - **Food**: `{ mealType: "beef"|"chicken"|"fish"|"vegetarian"|"vegan", servings: number }`
  - **Energy**: `{ usageKwh: number, source: "electricity"|"gas" }`
- `notes` (string, optional): User-provided notes (max 200 characters)
- `photoUrl` (string, optional): Firebase Storage URL for receipt/item photo
- `createdAt` (timestamp): Log entry creation time

**Relationships**:
- Belongs to: User (many-to-one via userId)

**Validation Rules**:
- `category`: Must be one of enum values
- `co2Grams`: Non-negative number, max 50000 (reasonable single activity limit)
- `details`: Must contain required fields for selected category
- `notes`: Max 200 characters
- `timestamp`: Cannot be future date, max 30 days in past

**Indexes** (Firestore):
- `userId` + `timestamp` DESC (for user activity history)
- `userId` + `category` + `timestamp` DESC (for category filtering)

**Calculated Fields** (computed in Dreamflow):
- `co2Grams` = emission factor × quantity (see research.md for factors)

---

### Challenge

Represents an AR challenge available to users.

**Attributes**:
- `challengeId` (string, PK): Unique challenge identifier (e.g., "scan-plastic", "plant-tree", "bike-route")
- `title` (string, required): Display title (e.g., "Scan Plastic", "Plant a Tree")
- `description` (string, required): Challenge instructions (max 100 characters)
- `arType` (enum, required): "scan" | "place" | "gps"
- `pointValue` (number, required): Points awarded on completion (default: 50)
- `dailyLimit` (number, required): Max completions per user per day (default: 1)
- `iconUrl` (string, required): Firebase Storage URL for challenge icon
- `isActive` (boolean, default: true): Whether challenge is currently available

**Relationships**:
- Has many: ChallengeCompletion (one-to-many via challengeId)

**Validation Rules**:
- `challengeId`: Lowercase, hyphenated, unique
- `title`: 5-30 characters
- `description`: 10-100 characters
- `arType`: Must be one of enum values
- `pointValue`: 10-100 range
- `dailyLimit`: 1-10 range

**Pre-populated Data** (seeded on first launch):
```json
[
  {
    "challengeId": "scan-plastic",
    "title": "Scan Plastic",
    "description": "Point camera at plastic item to detect and earn points",
    "arType": "scan",
    "pointValue": 50,
    "dailyLimit": 1,
    "isActive": true
  },
  {
    "challengeId": "plant-tree",
    "title": "Plant a Tree",
    "description": "Tap ground in camera view to plant virtual tree",
    "arType": "place",
    "pointValue": 50,
    "dailyLimit": 1,
    "isActive": true
  },
  {
    "challengeId": "bike-route",
    "title": "Bike Route",
    "description": "Follow AR arrows for 2km eco-friendly path",
    "arType": "gps",
    "pointValue": 50,
    "dailyLimit": 1,
    "isActive": true
  }
]
```

---

### ChallengeCompletion

Tracks individual challenge completions by users (for daily limit enforcement).

**Attributes**:
- `completionId` (string, PK): Auto-generated Firestore document ID
- `userId` (string, FK, required): Reference to User.uid
- `challengeId` (string, FK, required): Reference to Challenge.challengeId
- `completedAt` (timestamp, required): Completion timestamp
- `dateKey` (string, required): Date in YYYY-MM-DD format (for daily limit queries)
- `pointsAwarded` (number, required): Points given (denormalized from Challenge.pointValue)

**Relationships**:
- Belongs to: User (many-to-one via userId)
- Belongs to: Challenge (many-to-one via challengeId)

**Validation Rules**:
- `userId` + `challengeId` + `dateKey`: Composite uniqueness check (enforce daily limit)
- `pointsAwarded`: Must match Challenge.pointValue at time of completion

**Indexes** (Firestore):
- `userId` + `dateKey` (for daily completion queries)
- `userId` + `challengeId` + `dateKey` (for specific challenge daily limit check)

**Business Logic**:
- Before creating: Query count where userId + challengeId + dateKey (today) < Challenge.dailyLimit
- On create: Increment User.points by pointsAwarded

---

### Friendship

Represents friend connections between users.

**Attributes**:
- `friendshipId` (string, PK): Auto-generated Firestore document ID
- `userId1` (string, FK, required): First user ID (alphabetically lower)
- `userId2` (string, FK, required): Second user ID (alphabetically higher)
- `status` (enum, required): "pending" | "accepted" | "blocked"
- `requestedBy` (string, required): User ID who initiated request
- `createdAt` (timestamp): Request creation time
- `acceptedAt` (timestamp, optional): When request was accepted

**Relationships**:
- Belongs to: User (many-to-one via userId1)
- Belongs to: User (many-to-one via userId2)

**Validation Rules**:
- `userId1` < `userId2` (alphabetical ordering for consistency)
- `userId1` + `userId2`: Composite uniqueness (prevent duplicate friendships)
- `status`: Must be one of enum values

**Indexes** (Firestore):
- `userId1` + `status` (for user's friends query)
- `userId2` + `status` (for reverse friends query)
- `userId2` + `status: "pending"` (for incoming requests)

**Business Logic**:
- Friend search: Query users by email, exclude already-friends and self
- Accept request: Update status to "accepted", set acceptedAt timestamp
- Get friends list: Query where (userId1 = currentUser OR userId2 = currentUser) AND status = "accepted"

---

### Badge

Represents achievement badges that users can earn.

**Attributes**:
- `badgeId` (string, PK): Unique badge identifier (e.g., "streak-7", "points-100")
- `title` (string, required): Badge display name (e.g., "Week Warrior", "Carbon Crusader")
- `description` (string, required): How to earn badge (max 100 characters)
- `iconUrl` (string, required): Firebase Storage URL for badge icon
- `criteria` (object, required): Earning conditions
  - `type` (enum): "streak" | "points" | "logs" | "challenges"
  - `threshold` (number): Target value (e.g., 7 days, 100 points)
- `isActive` (boolean, default: true): Whether badge is currently achievable

**Relationships**:
- Referenced by: User.badges array (many-to-many)

**Pre-populated Data** (seeded on first launch):
```json
[
  {
    "badgeId": "streak-7",
    "title": "Week Warrior",
    "description": "Log activity for 7 consecutive days",
    "criteria": { "type": "streak", "threshold": 7 },
    "isActive": true
  },
  {
    "badgeId": "points-100",
    "title": "Carbon Crusader",
    "description": "Earn 100 points from challenges",
    "criteria": { "type": "points", "threshold": 100 },
    "isActive": true
  },
  {
    "badgeId": "logs-50",
    "title": "Tracking Master",
    "description": "Log 50 activities",
    "criteria": { "type": "logs", "threshold": 50 },
    "isActive": true
  }
]
```

---

### LeaderboardEntry (RTDB Cache)

Cached leaderboard data in Firebase Realtime Database for fast reads.

**Structure** (RTDB JSON):
```json
{
  "leaderboard_cache": {
    "global": {
      "userId1": { "name": "Alice", "points": 245, "city": "New York", "rank": 1 },
      "userId2": { "name": "Bob", "points": 180, "city": "London", "rank": 2 }
    },
    "new-york": {
      "userId1": { "name": "Alice", "points": 245, "rank": 1 },
      "userId3": { "name": "Charlie", "points": 120, "rank": 2 }
    },
    "last_updated": "2025-12-06T12:00:00Z"
  }
}
```

**Attributes** (per entry):
- `name` (string): User display name (denormalized)
- `points` (number): Current points total (denormalized)
- `city` (string): User city (for global leaderboard only)
- `rank` (number): Position in leaderboard (1-indexed)

**Update Strategy**:
- Manual refresh triggered by user (pull-to-refresh on leaderboard screen)
- Check `last_updated` timestamp; if older than 5 minutes, query Firestore for top 100 users by points
- Sort by points DESC, assign ranks, write to RTDB cache
- Limit to top 100 per leaderboard type to control data size

---

## Relationships Diagram

```
User (1) ──── (N) ActivityLog
  │
  │ (N) ────────── (N) User [via Friendship]
  │
  │ (N) ────────── (N) Badge [via User.badges array]
  │
  │ (1) ──── (N) ChallengeCompletion
                      │
                      │ (N) ──── (1) Challenge
```

## Data Size Estimates

**Per User** (1 month active usage):
- User profile: ~500 bytes
- ActivityLog: 30 logs/month × 300 bytes = ~9 KB
- ChallengeCompletion: 90 completions/month × 200 bytes = ~18 KB
- Friendships: 20 friends × 150 bytes = ~3 KB

**Total per user**: ~30 KB/month

**100 Users** (hackathon demo scale): ~3 MB Firestore storage (well within 1GB free tier)

## Next Steps

1. Create Firebase schema in `contracts/firebase-schema.md`
2. Document Firestore rules for security
3. Define Dreamflow component data bindings
