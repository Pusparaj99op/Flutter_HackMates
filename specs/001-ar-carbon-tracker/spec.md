# Feature Specification: EcoQuest AR Carbon Tracker

**Feature Branch**: `001-ar-carbon-tracker`  
**Created**: 2025-12-06  
**Status**: Draft  
**Input**: User description: "Detailed App Specification: EcoQuest AR Carbon Tracker - Build a hackathon-winning Android app using Dreamflow AI only that gamifies carbon footprint tracking with AR challenges, social leaderboards, and real-time analytics"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Quick Onboarding and Daily Score (Priority: P1)

A new user downloads the app and wants to immediately see their environmental impact without complex setup. They complete authentication, basic profile setup, and view their initial carbon footprint dashboard within 30 seconds.

**Why this priority**: First impression is critical for hackathon judges and user retention. Demonstrates the core value proposition instantly.

**Independent Test**: Can be fully tested by installing the app, completing sign-up flow, and viewing the home dashboard. Delivers immediate value by showing the user interface and initial carbon score (even if zero).

**Acceptance Scenarios**:

1. **Given** a new user opens the app for the first time, **When** they view the 3-slide onboarding carousel, **Then** they see "Scan your habits", "AR Challenges", and "Beat your friends" slides with corresponding visuals
2. **Given** a user completes onboarding, **When** they choose Google Sign-In, **Then** they are authenticated via Firebase and directed to profile setup
3. **Given** a user is on profile setup, **When** they enter name, select city from dropdown, and choose daily commute mode (Car/Bus/Bike/Walk), **Then** their profile is saved and they reach the home dashboard
4. **Given** a user reaches the home dashboard, **When** the dashboard loads, **Then** they see a greeting, daily score circle (starting at 0g CO2 saved), and 7-day streak counter
5. **Given** the entire onboarding flow, **When** timed from app launch to dashboard, **Then** the process completes in under 30 seconds

---

### User Story 2 - Log Carbon Activities (Priority: P1)

A user wants to track their daily carbon footprint by quickly logging activities like meals, transportation, or energy usage. They can manually log activities or use the camera to scan receipts/items for automatic CO2 calculation.

**Why this priority**: Core functionality that generates the data for all other features (analytics, challenges, leaderboards). Without logging, the app has no content.

**Independent Test**: Can be fully tested by logging various activity types and verifying they appear in the tracker history with calculated CO2 values. Delivers value by providing carbon footprint awareness.

**Acceptance Scenarios**:

1. **Given** a user is on the home dashboard, **When** they tap a "Quick Log" card (Food/Transport/Energy), **Then** a bottom sheet opens with category-specific input fields
2. **Given** a user selects Food category, **When** they enter meal type and serving size, **Then** the system calculates estimated CO2 emissions and saves the log entry
3. **Given** a user selects Transport category, **When** they enter distance and mode (Car/Bus/Bike/Walk), **Then** the system calculates CO2 based on standard emission factors
4. **Given** a user taps camera icon on a log card, **When** they scan a receipt or product, **Then** the system uses image recognition to extract items and auto-populate CO2 estimates
5. **Given** a user has logged activities, **When** they view their daily score circle, **Then** the displayed CO2 value updates to reflect all logged activities for the day

---

### User Story 3 - Complete AR Challenges (Priority: P1)

A user wants to engage with gamified environmental challenges using augmented reality. They access daily AR challenges like scanning plastic items, planting virtual trees, or following bike routes with AR overlays.

**Why this priority**: The "wow factor" differentiator for hackathon judges. Showcases innovation by combining AR technology with sustainability goals.

**Independent Test**: Can be fully tested by launching each of the 3 AR challenge types and completing them. Delivers value through engaging, interactive environmental education and point rewards.

**Acceptance Scenarios**:

1. **Given** a user navigates to the AR Challenges tab, **When** the camera preview loads, **Then** they see available challenges with descriptions and point values
2. **Given** a user starts "Scan Plastic" challenge, **When** they point camera at plastic item, **Then** ML Kit detects the object, displays AR overlay confirming detection, and awards 50 points
3. **Given** a user starts "Plant Tree" challenge, **When** they tap on the ground in camera view, **Then** a virtual tree appears and grows with animation, awarding points upon completion
4. **Given** a user starts "Bike Route" challenge, **When** they enable GPS, **Then** AR directional arrows overlay camera view to guide them along a 2km eco-friendly path
5. **Given** a user completes challenges, **When** they view the progress indicator, **Then** they see "3/7 challenges complete" and total points earned (e.g., 245 points)

---

### User Story 4 - Social Leaderboards and Friend Challenges (Priority: P1)

A user wants to see how their environmental efforts compare to friends and their community. They can view leaderboards, add friends, and send challenge notifications to motivate competitive engagement.

**Why this priority**: Social features drive user retention and viral growth, critical for demonstrating hackathon impact potential. Judges can test with multiple accounts.

**Independent Test**: Can be fully tested with 2+ test accounts by adding friends, logging activities, and viewing updated leaderboards. Delivers value through social motivation and community building.

**Acceptance Scenarios**:

1. **Given** a user is on the home dashboard, **When** they scroll to the bottom section, **Then** they see "Top 3 Leaderboard" showing their position and top 2 friends with points
2. **Given** a user navigates to the Social tab, **When** they search for a friend by email, **Then** they can send a friend request
3. **Given** a user has accepted friend connections, **When** they view the Friends List, **Then** they see each friend's current points and total CO2 saved
4. **Given** a user selects a friend, **When** they tap "Challenge Friend", **Then** a notification is sent to that friend inviting them to compete
5. **Given** multiple users in the same city log activities, **When** they view City Leaderboards, **Then** they see ranked list of users with highest points in their city
6. **Given** a user wants broader comparison, **When** they switch to Global Leaderboard, **Then** they see top users worldwide

---

### User Story 5 - View Analytics and Export Reports (Priority: P2)

A user wants to understand their carbon footprint trends over time and share their progress. They can view charts showing daily/weekly patterns, category breakdowns, and export PDF reports for sharing or personal records.

**Why this priority**: Enhances user engagement and provides shareable content for social media amplification. Secondary to core MVP but valuable for demo polish.

**Independent Test**: Can be fully tested by logging activities over multiple days and viewing/exporting the analytics. Delivers value through insights and actionable feedback.

**Acceptance Scenarios**:

1. **Given** a user navigates to Tracker History tab, **When** the analytics load, **Then** they see a weekly bar chart comparing actual CO2 to target
2. **Given** a user views the analytics, **When** they scroll down, **Then** they see a pie chart breaking down emissions by category (Transport 45%, Food 30%, Energy 25%)
3. **Given** a user has historical logs, **When** they view the list view section, **Then** they see yesterday and today's logs with edit buttons
4. **Given** a user wants to export data, **When** they tap the "Export PDF Report" floating action button, **Then** a PDF is generated with weekly summary, charts, and insights
5. **Given** the exported PDF, **When** the user views it, **Then** it includes their name, date range, total CO2 saved, category breakdown, and trend analysis

---

### User Story 6 - Share Achievements (Priority: P2)

A user wants to share their environmental accomplishments to social media platforms to inspire others and showcase their commitment. They can share badges, milestones, challenge completions, and reports with pre-formatted social media posts.

**Why this priority**: Drives organic growth and demonstrates viral potential to judges. Not critical for MVP but strong enhancement for demo impact.

**Independent Test**: Can be fully tested by earning achievements and using share functionality to generate social media posts. Delivers value through social recognition and app promotion.

**Acceptance Scenarios**:

1. **Given** a user completes a significant milestone (e.g., 7-day streak), **When** they receive a badge notification, **Then** they see a "Share Achievement" button
2. **Given** a user taps share on an achievement, **When** they choose a social platform, **Then** a pre-formatted post is generated with achievement image, stats, and app link
3. **Given** a user completes an AR challenge, **When** they tap share from the results screen, **Then** an AR screenshot with overlay graphics is prepared for sharing
4. **Given** a user exports a PDF report, **When** they tap share icon, **Then** they can share the PDF via email, messaging apps, or social media
5. **Given** shared content includes deep links, **When** someone clicks the link, **Then** they are directed to the app download page or directly into the app if installed

---

### Edge Cases

- What happens when a user loses internet connection while logging activities? (System must save locally and sync when connection is restored)
- How does the system handle invalid or duplicate receipt scans? (Display error message and allow manual entry)
- What happens when a user tries to complete the same AR challenge multiple times in one day? (System enforces daily limit of 1 per challenge type)
- How does the app handle users in cities with no other users for local leaderboards? (Show message "Be the first in your city!" and display global leaderboard)
- What happens when GPS is unavailable for Bike Route challenge? (Display error message requiring location access and provide fallback option)
- How does the system handle users who don't grant camera permissions? (Disable AR features gracefully, allow manual activity logging only)
- What happens when Firebase backend is temporarily unavailable? (Display offline mode indicator, queue operations locally, retry when connection restored)

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST allow users to authenticate using Google Sign-In or email/password via Firebase Authentication
- **FR-002**: System MUST require profile setup including name, city selection (dropdown), and daily commute mode (Car/Bus/Bike/Walk) on first launch
- **FR-003**: System MUST display onboarding carousel with 3 slides explaining core features before authentication
- **FR-004**: System MUST complete full onboarding flow (splash to dashboard) in under 30 seconds
- **FR-005**: System MUST display home dashboard with greeting, daily CO2 score circle, and 7-day streak counter
- **FR-006**: System MUST provide quick log cards for three categories: Food, Transport, and Energy
- **FR-007**: System MUST calculate CO2 emissions for logged activities using standard emission factors (transport mode, food type, energy consumption)
- **FR-008**: System MUST support camera-based receipt/item scanning with automatic CO2 estimation using ML Kit image recognition
- **FR-009**: System MUST display a "Today's AR Challenge" card on home dashboard with current active challenge
- **FR-010**: System MUST provide 3 AR challenge types: Scan Plastic (object detection), Plant Tree (tap-to-place), and Bike Route (GPS + AR directions)
- **FR-011**: System MUST award points for completed AR challenges (50 points per challenge)
- **FR-012**: System MUST enforce daily limit of 1 completion per challenge type
- **FR-013**: System MUST display challenge progress indicator showing completed vs total daily challenges and total points earned
- **FR-014**: System MUST show Top 3 Leaderboard on home dashboard with user position and top 2 friends
- **FR-015**: System MUST provide Social tab with Friends List, search by email, and friend request functionality
- **FR-016**: System MUST display City Leaderboard and Global Leaderboard with ranked users and points
- **FR-017**: System MUST support "Challenge Friend" feature sending notifications via Firebase Cloud Messaging
- **FR-018**: System MUST provide Tracker History tab with weekly bar chart (actual vs target CO2) and pie chart (category breakdown)
- **FR-019**: System MUST display list view of historical logs with edit functionality
- **FR-020**: System MUST generate exportable PDF reports with weekly summary, charts, and insights
- **FR-021**: System MUST support sharing achievements, AR challenge completions, and reports to social media platforms
- **FR-022**: System MUST include deep links in shared content directing to app download or app content
- **FR-023**: System MUST implement offline-first architecture with local data persistence and automatic sync when online
- **FR-024**: System MUST persist user data including profile, logs, points, streaks, and badges
- **FR-025**: System MUST use Firebase Realtime Database for real-time leaderboard updates and friend activity
- **FR-026**: System MUST use Firestore for user profiles, activity logs, and challenge data
- **FR-027**: System MUST implement Material 3 design system with primary color green (#4CAF50) and ocean blue accent
- **FR-028**: System MUST include micro-animations (Lottie) for splash screen, achievements, and confetti effects
- **FR-029**: System MUST support responsive design for various Android screen sizes
- **FR-030**: System MUST implement pull-to-refresh on home dashboard with skeleton loaders
- **FR-031**: System MUST comply with accessibility standards (screen reader support, sufficient contrast, touch target sizes)
- **FR-032**: System MUST handle camera permission denial gracefully, disabling AR features but maintaining manual logging
- **FR-033**: System MUST handle location permission denial gracefully, disabling GPS-based challenges
- **FR-034**: System MUST display appropriate error messages for network failures, invalid inputs, and permission denials
- **FR-035**: System MUST deploy as Android APK compatible with Android 8.0+ devices

### Key Entities

- **User**: Represents an app user with attributes including unique ID, name, city, profile picture, commute mode, total CO2 saved, points, current streak, earned badges, weekly CO2 target, and friend list
- **Activity Log**: Represents a carbon-generating activity with attributes including timestamp, user ID, category (transport/food/energy), CO2 grams, optional notes, and optional photo URL
- **Challenge**: Represents an AR challenge with attributes including unique ID, title, AR type (scan/place/gps), point value, daily completion limit, and description
- **Friendship**: Represents a connection between two users with attributes including user IDs, status (pending/accepted), and timestamp
- **Badge/Achievement**: Represents earned accomplishments with attributes including badge ID, title, description, icon URL, criteria (e.g., 7-day streak), and earned timestamp
- **Leaderboard Entry**: Represents a user's ranking with attributes including user ID, username, points, total CO2 saved, and rank position (city or global context)

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can complete full onboarding (app launch to dashboard) in under 30 seconds
- **SC-002**: APK builds successfully from Dreamflow and installs on Android 8.0+ devices without crashes
- **SC-003**: Complete demo flow (authentication → scan → AR challenge → leaderboard → share) executes in 30 seconds or less
- **SC-004**: Test accounts function correctly for hackathon judges with pre-populated data
- **SC-005**: App maintains smooth 60fps animations during normal operation
- **SC-006**: App supports offline mode with automatic sync upon reconnection
- **SC-007**: All UI elements meet Material 3 accessibility standards (4.5:1 contrast ratio, 48dp touch targets)
- **SC-008**: Users successfully complete at least one AR challenge in their first session (80% success rate goal)
- **SC-009**: Leaderboard updates reflect new activity within 3 seconds (real-time sync)
- **SC-010**: PDF report generation completes in under 5 seconds
- **SC-011**: Social sharing generates properly formatted posts with deep links that successfully direct users to app
- **SC-012**: App maintains visual polish with green (#4CAF50) and ocean blue theme consistently applied across all screens
- **SC-013**: Zero critical bugs or crashes during 30-second judge demo
- **SC-014**: App demonstrates measurable carbon savings impact through clear data visualization

## Assumptions

- **Dreamflow Platform Capabilities**: Assume Dreamflow's visual builder supports all required features including Firebase integration, Material 3 theming, ML Kit for camera, charts library, and Lottie animations
- **CO2 Emission Factors**: Assume standard emission factor databases are available or can be hardcoded (e.g., car = 120g CO2/km, bus = 40g CO2/km, beef meal = 3kg CO2, etc.)
- **AR Implementation**: Assume AR features can be implemented using camera overlays and ML Kit within Dreamflow constraints (no complex 3D models or custom ML training)
- **Firebase Free Tier**: Assume Firebase free tier limits are sufficient for hackathon demo (up to 100 test users, limited storage and database reads/writes)
- **Test Data**: Assume test accounts will be pre-populated with sample activities, friendships, and achievements for judge demonstration
- **4-Hour Build Time**: Assume the feature scope is achievable within 4 hours using Dreamflow's no-code/low-code approach
- **Android-Only**: iOS support is explicitly optional and not included in MVP scope
- **City Database**: Assume a predefined list of major cities for dropdown selection (can be static list, not comprehensive global database)
- **Image Recognition**: Assume ML Kit's object detection and image labeling models are sufficient for receipt/item scanning (pre-trained models, no custom training)
- **Deep Link Setup**: Assume Firebase Dynamic Links or similar service is available through Dreamflow for social sharing deep links
