# Research: EcoQuest AR Carbon Tracker

**Feature**: 001-ar-carbon-tracker
**Date**: 2025-12-06
**Purpose**: Resolve technical unknowns and document platform decisions

## Research Areas

### 1. Dreamflow Platform Capabilities

**Question**: Can Dreamflow visual builder support all required features (Firebase, ML Kit, AR, Charts)?

**Research Findings**:
- **Dreamflow Visual Builder**: No-code/low-code platform designed for rapid mobile app development
- **Firebase Integration**: Native support for Firebase Auth, Firestore, Storage, Realtime Database, Cloud Messaging through visual connectors
- **ML Kit Support**: Built-in camera component with ML Kit integration for object detection and image labeling
- **AR Capabilities**: Limited to camera overlays and 2D augmented elements (no complex 3D rendering like ARCore/ARKit)
- **Charts Library**: Built-in chart components including bar charts, pie charts, line charts, and circular progress indicators
- **Material 3**: Full Material Design 3 theming support with customizable color schemes
- **Lottie Animations**: Native support for Lottie JSON animations
- **APK Export**: Direct Android APK build and export functionality

**Decision**: Dreamflow platform is SUITABLE for all MVP requirements within constitutional constraints.

**Rationale**: All required features are available through Dreamflow's built-in components and integrations. AR limitations (camera overlays only) align with constitutional constraint "simple AR via camera overlays."

**Alternatives Considered**:
- Flutter + custom code: Rejected due to constitutional requirement "100% Dreamflow Native"
- React Native + Expo: Rejected due to constitutional requirement "100% Dreamflow Native"
- Native Android: Rejected due to 4-hour build time constraint

---

### 2. Firebase Architecture for Offline-First

**Question**: How to implement offline-first architecture with Firebase within Dreamflow constraints?

**Research Findings**:
- **Firestore Offline Persistence**: Firestore SDK includes built-in offline caching (automatically enabled in Dreamflow)
- **Local Cache**: SQLite-backed cache stores queries and documents locally
- **Sync Strategy**: Automatic sync when connection restored, with conflict resolution (last-write-wins)
- **Realtime Database Offline**: Firebase RTDB supports offline mode with local disk persistence
- **Cache Size Limits**: Default 100MB cache (sufficient for MVP scope)
- **Query Limitations**: Only previously executed queries are cached (pre-populate common queries on first load)

**Decision**: Use Firestore with automatic offline persistence + RTDB for real-time leaderboards.

**Rationale**: Firestore's automatic offline support meets constitutional "offline-first with sync" requirement without custom code. RTDB provides real-time updates for leaderboards (<3s sync requirement).

**Implementation Notes**:
- Enable Firestore offline persistence in Dreamflow Firebase config
- Pre-load leaderboard queries on home screen to populate cache
- Use RTDB for leaderboard_cache collection (faster reads)
- Use Firestore for users, logs, challenges (richer queries)

**Alternatives Considered**:
- Local SQLite only: Rejected due to lack of cloud sync
- Firebase RTDB only: Rejected due to limited querying capabilities for complex logs
- Custom sync logic: Rejected due to constitutional "no custom code" constraint

---

### 3. CO2 Emission Factor Standards

**Question**: What emission factors should be used for carbon calculations?

**Research Findings**:
- **Transport Emission Factors** (per km):
  - Car: 120g CO2/km (average gasoline vehicle, EPA standard)
  - Bus: 40g CO2/km per passenger (IPCC guidelines)
  - Bike: 0g CO2/km (zero emissions)
  - Walk: 0g CO2/km (zero emissions)
- **Food Emission Factors** (per serving):
  - Beef: 3000g CO2/serving (27kg CO2/kg beef)
  - Chicken: 800g CO2/serving
  - Fish: 600g CO2/serving
  - Vegetarian: 300g CO2/serving
  - Vegan: 150g CO2/serving
- **Energy Emission Factors** (per kWh):
  - Electricity: 500g CO2/kWh (US average grid mix)
  - Natural Gas: 200g CO2/kWh equivalent

**Decision**: Use simplified emission factors hardcoded in Dreamflow's calculation logic.

**Rationale**: Hardcoded factors provide fast calculations without external API dependencies. Values are conservative estimates based on EPA/IPCC standards suitable for educational/gamification purposes (not scientific precision).

**Implementation Notes**:
- Store emission factors in Dreamflow's global variables
- Transport: distance (km) × mode factor
- Food: serving count × meal type factor
- Energy: usage (kWh) × electricity factor
- Display results with educational disclaimers

**Alternatives Considered**:
- External API (Carbon Interface): Rejected due to API costs and offline requirement
- User-provided factors: Rejected due to UX complexity
- Regional-specific factors: Rejected due to scope/time constraints (city selection for leaderboards only)

---

### 4. ML Kit Object Detection for Receipt Scanning

**Question**: Can ML Kit detect receipt items accurately enough for automatic CO2 logging?

**Research Findings**:
- **ML Kit Object Detection**: Pre-trained models for common objects (bottles, bags, food items)
- **Image Labeling**: Text recognition for receipt OCR with ~80% accuracy
- **Limitations**: Cannot extract structured data (prices, quantities) reliably without custom training
- **Latency**: 200-500ms per scan on mid-range Android devices
- **Offline Support**: ML Kit models can be bundled for offline use

**Decision**: Use ML Kit for VISUAL object detection (plastic items) but NOT for receipt OCR parsing. Provide manual entry as primary method with camera as "quick scan" helper.

**Rationale**: ML Kit is sufficient for "Scan Plastic" AR challenge (detect plastic bottle → award points) but not reliable enough for receipt parsing. Manual entry ensures data accuracy while camera provides engagement/novelty.

**Implementation Notes**:
- AR Challenge: ML Kit object detection → detect "bottle" label → trigger success animation
- Receipt scan: Camera preview → capture image → store in Firebase Storage → user manually enters items
- Fallback: Always provide manual entry option (constitutional accessibility compliance)

**Alternatives Considered**:
- Google Vision API for OCR: Rejected due to cost and constitutional "no complex custom ML"
- Custom ML model: Rejected due to constitutional constraint
- Barcode scanning only: Rejected due to limited scope (not all products have barcodes)

---

### 5. AR Challenge Implementation Strategies

**Question**: How to implement 3 AR challenge types within Dreamflow's camera overlay limitations?

**Research Findings**:
- **Dreamflow AR Capabilities**:
  - Camera preview with real-time ML Kit overlay
  - 2D sprite/image overlays on camera feed
  - Tap gesture detection on screen
  - GPS location access for coordinate-based triggers
- **Not Supported**: 3D models, plane detection, motion tracking (ARCore/ARKit features)

**Decision**: Implement simplified AR challenges using camera overlays + ML Kit + GPS:

1. **Scan Plastic**: ML Kit object detection → detect "bottle" or "plastic" → overlay green checkmark animation → +50 points
2. **Plant Tree**: Camera preview → user taps ground area → overlay 2D tree sprite with grow animation → +50 points
3. **Bike Route**: GPS tracking → camera preview with directional arrow overlay → distance target (2km) → +50 points

**Rationale**: Each challenge type demonstrates different AR interaction (detection, placement, navigation) while staying within Dreamflow's 2D overlay capabilities. User engagement achieved through visual feedback and gamification.

**Implementation Notes**:
- Use Dreamflow's camera component with ML Kit integration
- Overlay assets: green checkmark PNG, tree sprite sequence (5 frames), arrow directional PNG
- GPS: Use location component with distance calculation trigger
- Daily limit: Check Firestore for userId + challengeId + date before awarding points

**Alternatives Considered**:
- Full ARCore integration: Rejected due to constitutional "simple AR via camera overlays" constraint
- Single challenge type: Rejected due to spec requirement for 3 challenge types
- Video-based AR (no real camera): Rejected due to poor user experience

---

### 6. Leaderboard Scalability with Firebase Free Tier

**Question**: How to implement city and global leaderboards within Firebase free tier limits?

**Research Findings**:
- **Firebase Free Tier Limits**:
  - Firestore: 50k reads/day, 20k writes/day, 1GB storage
  - RTDB: 10GB storage, 100 simultaneous connections, 1GB/month bandwidth
- **Leaderboard Query Patterns**:
  - Global top 10: 1 query per user per load (high read volume)
  - City leaderboards: Filtered query per city (moderate read volume)
  - Friend rankings: Query userId array (low read volume)
- **Optimization Strategies**:
  - Cache leaderboards in RTDB (faster reads, lower Firestore usage)
  - Update rankings with Cloud Functions triggered on point changes
  - Limit leaderboard to top 100 per category (reduce query size)

**Decision**: Use hybrid approach - Firestore for writes, RTDB for cached leaderboard reads.

**Architecture**:
- **Write Path**: User earns points → Update Firestore users/{uid}/points
- **Read Path**: Query RTDB leaderboard_cache/{city or global}/{top100}
- **Cache Update**: Manual refresh in Dreamflow (button trigger) or time-based (check last update timestamp)

**Rationale**: RTDB provides faster reads and lower costs for frequent leaderboard queries. Firestore remains source of truth for user data. Cache updates can be throttled to stay within free tier.

**Implementation Notes**:
- RTDB structure: `leaderboard_cache/global/{userId: points}`, `leaderboard_cache/{city}/{userId: points}`
- Refresh logic: On home screen load, check if cache older than 5 minutes → trigger manual sync
- Top 3 display: Query top 3 from RTDB cache
- Full leaderboard: Query top 100 with pagination

**Alternatives Considered**:
- Firestore only with client-side sorting: Rejected due to high read costs (50k limit easily exceeded)
- Cloud Functions for real-time updates: Rejected due to free tier limitations (125k invocations/month)
- Pre-compute rankings in background: Rejected due to Dreamflow's lack of background job support

---

### 7. PDF Report Generation

**Question**: How to generate PDF reports with charts within Dreamflow?

**Research Findings**:
- **Dreamflow PDF Capabilities**: No native PDF generation component
- **Workaround Options**:
  - Screenshot chart canvas → convert to image → embed in document
  - Use third-party PDF API (jsPDF, PDFKit) via custom code (violates constitution)
  - Export data as CSV instead of PDF
  - Use Firebase Cloud Functions to generate PDF (requires Blaze plan)

**Decision**: Simplify to "Export Data" feature with CSV download OR screenshot-based image sharing instead of PDF.

**Rationale**: PDF generation requires custom code or paid Firebase plan, both violating constitutional constraints. CSV export provides data portability, screenshot sharing achieves social media goal.

**Implementation**:
- **Option A (Recommended)**: "Share Report" button → capture screenshot of charts screen → share via Android share sheet with image
- **Option B**: "Export Data" button → generate CSV string → save to device downloads → share via file picker

**Alternatives Considered**:
- Cloud Functions PDF generation: Rejected due to Firebase free tier (Blaze plan required)
- Custom PDF library: Rejected due to constitutional "no custom code" constraint
- Web-based PDF generation: Rejected due to complexity and offline requirement

**Implementation Notes**:
- Use Dreamflow's screenshot component to capture Tracker History screen
- Add watermark/branding to screenshot (app name, date range)
- Share via Android's native share sheet (supports social media, email, messaging)

---

## Summary of Key Decisions

| Area | Decision | Rationale |
|------|----------|-----------|
| Platform | Dreamflow visual builder with Firebase backend | Constitutional requirement, all features supported |
| Offline-First | Firestore offline persistence + RTDB for leaderboards | Automatic sync, no custom code needed |
| CO2 Calculations | Hardcoded emission factors (EPA/IPCC standards) | Fast, offline, educational accuracy |
| Receipt Scanning | ML Kit for visual detection only, manual entry primary | Reliability over automation |
| AR Challenges | 2D camera overlays + ML Kit + GPS | Meets constraints, engaging UX |
| Leaderboards | Hybrid Firestore writes + RTDB cached reads | Scalable within free tier |
| PDF Export | Screenshot sharing instead of PDF generation | Avoids custom code, achieves social goal |

## Risks and Mitigations

| Risk | Impact | Mitigation |
|------|--------|-----------|
| ML Kit accuracy too low | Users frustrated with scan failures | Provide manual entry fallback, clear UI messaging |
| Firebase free tier exceeded during demo | Leaderboards fail to load | Pre-populate cache, test with <100 users |
| AR challenges feel gimmicky | Judges unimpressed | Focus on visual polish, smooth animations |
| 4-hour build time insufficient | Incomplete MVP | Prioritize P1 user stories, defer P2 features |
| Dreamflow platform bugs | Blocker during development | Test each component early, have fallback manual workflows |

## Next Steps

Proceed to **Phase 1: Design & Contracts**:
1. Generate `data-model.md` with entity schemas
2. Create Firebase schema in `contracts/firebase-schema.md`
3. Document Dreamflow component structure in `contracts/dreamflow-components.md`
4. Create `quickstart.md` for setup instructions
5. Update agent context with technology decisions
