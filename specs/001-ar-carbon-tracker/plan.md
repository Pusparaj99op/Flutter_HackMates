# Implementation Plan: EcoQuest AR Carbon Tracker

**Branch**: `001-ar-carbon-tracker` | **Date**: 2025-12-06 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/001-ar-carbon-tracker/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command. See `.specify/templates/commands/plan.md` for the execution workflow.

## Summary

Build a hackathon-winning Android app using Dreamflow AI's no-code visual builder that gamifies carbon footprint tracking with AR challenges, social leaderboards, and real-time analytics. The app must complete onboarding in under 30 seconds, provide 3 AR challenge types, support offline-first data sync, and deploy as an APK within a 4-hour development window. Technical approach: Dreamflow visual builder with Firebase backend (Auth, Firestore, Storage, RTDB), Material 3 theming, ML Kit for AR overlays, and built-in chart components.

## Technical Context

**Language/Version**: Dreamflow AI visual builder (no-code/low-code platform), Android SDK 8.0+ (API level 26+)  
**Primary Dependencies**: Firebase SDK (Auth, Firestore, Storage, Realtime Database, Cloud Messaging), ML Kit (object detection, image labeling), Material 3 Components, Lottie animations, Charts library (built-in to Dreamflow)  
**Storage**: Firebase Firestore (user profiles, activity logs, challenges, friendships), Firebase Realtime Database (leaderboards, real-time updates), Firebase Storage (profile pictures, receipt images), Local SQLite cache (offline-first architecture)  
**Testing**: Manual testing with 2+ test accounts, APK installation testing on Android 8.0+ devices, 30-second demo flow validation  
**Target Platform**: Android 8.0+ (API 26+), optimized for phones and tablets, portrait orientation primary  
**Project Type**: Mobile application (Android-only, Dreamflow visual builder project structure)  
**Performance Goals**: 60fps UI animations, <30s onboarding flow, <3s leaderboard sync, <5s PDF generation, <200ms tap feedback  
**Constraints**: 4-hour build time, Firebase free tier limits (100 concurrent users, 1GB Firestore storage, 10GB RTDB storage), Dreamflow platform limitations (no custom ML models, camera overlays only for AR, no complex 3D rendering), Offline-first with sync required  
**Scale/Scope**: MVP with 5 main screens (Onboarding, Home, Tracker, AR Challenges, Social), 35 functional requirements, 6 user stories, target 10-100 hackathon judges/testers

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### ✅ 100% Dreamflow Native
- **Status**: PASS
- **Compliance**: All features implemented using Dreamflow visual builder, Firebase integration, and built-in components
- **No violations**: No custom code planned, only configuration and visual design

### ✅ Hackathon Judge Focus
- **Status**: PASS
- **Innovation**: AR + sustainability combination (unique)
- **Polish**: Material 3 UI with micro-animations planned
- **Impact**: Clear carbon savings metrics and data visualization
- **Demo-ready**: 30-second flow achievable within 4-hour build

### ✅ MVP + Wow Factor
- **Status**: PASS
- **Core tracking**: Activity logging with CO2 calculations ✓
- **3 AR challenges**: Scan Plastic, Plant Tree, Bike Route ✓
- **Leaderboards**: City and Global rankings ✓
- **Complete experience**: All P1 user stories covered

### ✅ Visual Excellence
- **Status**: PASS
- **Theme**: Green #4CAF50 / Ocean blue #2196F3 confirmed
- **Animations**: Lottie splash, confetti, skeleton loaders planned
- **Responsive**: Material 3 adaptive layouts for various screen sizes

### ✅ Data-Driven
- **Status**: PASS
- **Firebase backend**: Firestore + RTDB configured
- **Realtime sync**: Leaderboards, friend activity
- **Charts**: Bar chart (weekly CO2), Pie chart (categories)
- **Exportable reports**: PDF generation with charts

### ✅ Success Metrics Alignment
- **APK deployment**: Dreamflow APK build confirmed available ✓
- **30-second demo**: Flow designed for rapid demonstration ✓
- **Test accounts**: Firebase Auth supports multiple test accounts ✓
- **UI quality**: Material 3 + animations = professional polish ✓

### ✅ Constraints Compliance
- **Dreamflow limitations**: AR via camera overlays (ML Kit) only, no custom ML ✓
- **4-hour build**: Scope designed for rapid no-code development ✓
- **Firebase free tier**: Collections and queries optimized for limits ✓
- **Android only**: No iOS scope planned ✓

### ✅ Non-Negotiables
- **Onboarding <30s**: 3-slide carousel + Google Auth designed for speed ✓
- **Offline-first**: Local SQLite cache with Firebase sync ✓
- **Shareable achievements**: Firebase Dynamic Links for deep linking ✓
- **Accessibility**: Material 3 components include screen reader support, 48dp touch targets, 4.5:1 contrast ✓

**GATE RESULT**: ✅ **PASS** - All constitutional principles satisfied. Proceed to Phase 0.

## Project Structure

### Documentation (this feature)

```text
specs/001-ar-carbon-tracker/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
│   ├── firebase-schema.md
│   └── dreamflow-components.md
└── tasks.md             # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### Source Code (repository root)

**NOTE**: This is a Dreamflow visual builder project. There is NO traditional source code structure. All implementation is done through Dreamflow's visual interface, which generates the underlying Android code automatically.

```text
dreamflow-project/
├── screens/
│   ├── splash.screen
│   ├── onboarding.screen
│   ├── auth.screen
│   ├── profile-setup.screen
│   ├── home-dashboard.screen
│   ├── tracker-history.screen
│   ├── ar-challenges.screen
│   └── social.screen
├── components/
│   ├── bottom-nav.component
│   ├── quick-log-card.component
│   ├── leaderboard-item.component
│   ├── challenge-card.component
│   └── activity-log-item.component
├── firebase/
│   ├── auth.config
│   ├── firestore.rules
│   ├── storage.rules
│   └── database.rules
├── assets/
│   ├── lottie/
│   │   ├── splash.json
│   │   └── confetti.json
│   └── images/
│       ├── onboarding-slides/
│       └── icons/
└── theme/
    ├── material3.config
    ├── colors.config
    └── typography.config
```

**Structure Decision**: Selected **Dreamflow visual builder project structure** because the project constitution mandates "100% Dreamflow Native - No custom code, only Dreamflow's visual builder." Traditional mobile app directory structures (ios/, android/, src/) do not apply. All screens, components, and logic are configured through Dreamflow's visual interface, which manages the underlying native code generation automatically.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

**No violations**: All constitutional principles are satisfied. No complexity justifications required.
