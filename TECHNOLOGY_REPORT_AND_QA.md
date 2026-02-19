# LifeTrack Project: Technology Report & Interview Preparation

This document outlines the technical architecture, challenges encountered, and potential interview questions related to the **LifeTrack** application.

## 1. Technology Stack

### Core Framework
*   **Framework**: Flutter (SDK ^3.10.8)
*   **Language**: Dart
*   **Architecture**: Service-Repository Pattern with Offline-First design.
*   **Current Runtime Model**: `LifeTrackStore` + Riverpod providers with encrypted local persistence.

### Key Libraries & Packages
*   **State Management**: 
    *   `flutter_riverpod` (^2.6.0): For dependency injection and reactive state management.
    *   `provider` (^6.0.5): Legacy/Base dependency injection usage combined with `ChangeNotifier` in `LifeTrackStore`.
*   **Local Storage**: 
    *   `shared_preferences`: Storing large JSON blobs for offline caching.
    *   `flutter_secure_storage`: Storing sensitive encryption keys/tokens.
*   **Data Handling**: `json_serializable` patterns (manual `toJson`/`fromJson`).
*   **Charts/Visualization**: `fl_chart`.
*   **Hardware/Sensors**: `pedometer` (Step counting).
*   **Utilities**: `intl` (Date formatting), `uuid` (Unique IDs), `encrypt` (Data encryption).

---

## 2. Technical Challenges & Solutions

### A. Offline-First Synchronization
**Problem**: Ensuring the user can interact with the app seamlessly without internet, while guaranteeing data is eventually synced to the backend.
**Solution**:
*   Implemented a **Sync Queue** (`SyncQueueService`) that persists operations (`Create`, `Update`, `Delete`) locally when offline.
*   Used **Optimistic UI Updates**: The `LifeTrackStore` updates the local in-memory lists immediately so the user sees the change instantly, while the sync operation is queued in the background.
*   **Versioning**: Entities have an `entityVersion` field to handle conflict resolution during synchronization.

### B. State Management Complexity
**Problem**: Managing complex global state (`HealthSnapshot`, `UserProfile`, `Activities`) efficiently.
**Solution**:
*   Used a **Centralized Store** (`LifeTrackStore`) that extends `ChangeNotifier`.
*   Wrapped this store with **Riverpod** (`StateNotifierProvider`) to expose specific slices of state (like `recordsProvider`) to the UI.
*   *Challenge*: Ensuring `notifyListeners()` is called correctly to trigger UI rebuilds without causing performance issues.

### C. Data Persistence & Performance
**Problem**: Storing complex objects (Medical Records, Daily Snapshots) in `SharedPreferences` can be slow if done on the main thread.
**Solution**:
*   **Encryption**: All sensitive data is encrypted using `SecureSerializer` before storage.
*   **Background Processing**: Heavy JSON decoding and encoding interactions should be offloaded to Isolates (via `BackgroundService`) to prevent UI jank (frame drops) during app startup.

### D. Data Governance
**Problem**: complying with data retention policies (e.g., "delete records older than X years").
**Solution**:
*   Implemented `DataGovernanceService` to enforce retention policies.
*   `enforceRetentionPolicy()` checks creation dates and automatically performs soft-deletes on expired data.

### E. Profile Domain Expansion
**Problem**: User profile lacked clinically useful context (allergies, emergency and insurance metadata).
**Solution**:
*   Extended `UserProfile` schema and serialization for medical metadata.
*   Added `MedicalDetailsSection` UI to manage profile medical fields.
*   Updated profile save paths to preserve newly added fields.

### F. Load/Stress Validation Data
**Problem**: Manual test data entry is too slow for stress testing charts and history pages.
**Solution**:
*   Added `PatientSeeder` service to generate 50-100 synthetic entries across weight, BP, HR, and activities.
*   Added profile-page Developer Option to trigger seeding directly from app UI.

---

## 3. Potential Placement/Interview Questions

### General Architecture
**Q: Can you explain the architecture of LifeTrack?**
*   **A**: It follows a layered architecture.
    *   **UI Layer**: Widgets that consume state via Riverpod providers.
    *   **State Layer**: `LifeTrackStore` acts as the central source of truth, holding in-memory data.
    *   **Service Layer**: Handles business logic (e.g., `ConsistencyService`, `SyncService`).
    *   **Repository Layer**: Abstracts data sources (`VitalsRepository`).
    *   **Data Layer**: Local storage (SharedPrefs) and Remote API.

**Q: Why did you choose Flutter?**
*   **A**: Cross-platform capability (iOS/Android) from a single codebase, hot reload for faster development, and high-performance rendering with Skia/Impeller.

### Technical & Code-Specific
**Q: How do you handle local data security?**
*   **A**: We use the `encrypt` package. Before saving to `SharedPreferences`, data is encrypted. The encryption key is stored securely using `flutter_secure_storage` (Keychain on iOS, Keystore on Android).

**Q: In `LifeTrackStore`, you mix `ChangeNotifier` with Riverpod. Why?**
*   **A**: `LifeTrackStore` manages a large mutable state object. `ChangeNotifier` is a simple way to broadcast updates. We wrap it in Riverpod to leverage Riverpod's dependency injection and ensuring the store is a singleton that can be easily mocked in tests.

**Q: How does the Pedometer integration work?**
*   **A**: We use a `StreamSubscription` to the `Pedometer` package. It provides real-time updates. We listen to this stream in `LifeTrackStore` and update the `HealthSnapshot` live.

**Q: How would you handle a "Sync Conflict" (e.g., user edits same item on two devices)?**
*   **A**: We use `entityVersion`. If the server receives an update with a version lower than what it has, it rejects it. On the client, we might implement a "Server Wins" or "Merge" strategy. Currently, we use optimistic updates with a sync queue.

### Scenario-Based
**Q: The app is lagging when loading data. How do you debug and fix it?**
*   **A**: I would use the Flutter DevTools Profiler to identify the bottleneck. If it's the JSON parsing of large history files, I would move the parsing to a compute isolate (`compute()`) to unblock the main thread.

**Q: How do you ensure the app works for a user who installs it today and keeps it for 3 years?**
*   **A**: Data Governance. We have a `DataGovernanceService` that can prune old data to keep the storage size manageable, while allowing the user to export their full history (`exportUserData`).

### Specific 'Gotchas' Encountered
*   **iOS Bundle Identifiers**: Ensuring unique bundle IDs for provisioning profiles.
*   **Build Runner**: Needing to run `flutter pub run build_runner build` when changing models if code generation is used.
*   ** Emulator Issues**: Graphics acceleration incompatibility with certain development machines.

---

## 4. Glossary of Terms
*   **Provider/Riverpod**: libraries for state management.
*   **Transient State**: State that dies when the app closes (if not persisted).
*   **Optimistic UI**: Showing a success state before the server confirms it.
*   **Soft Delete**: Marking an item as `deletedAt: Timestamp` instead of actually removing it from the database, allowing for recovery or audit trails.
