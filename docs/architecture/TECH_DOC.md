# System Architecture

## 1. System Type
Personal Health Tracking System with atomic backend-first modularity.

## 2. Architecture Pattern
Feature-first modular architecture with dependency-ordered integration.

Dependency direction:
UI -> State Providers -> Atomic Repositories -> Drift Database

## 3. Layer Map
- `lib/core/database/`: Drift database schema and mapping logic.
- `lib/core/database/repositories/`: Atomic repository interfaces and Drift implementations.
- `lib/domain/models/`: Core domain models and entities.
- `lib/features/`: Feature modules containing UI and business logic (Vitals, Activity, Hydration, Nutrition, Medical, Profile).
- `lib/state/providers/`: Riverpod providers for data access and analytics.
- `lib/design_system/`: Design tokens and UI primitives.

## 4. Data Flow
Input Flow:
User Input -> UI Feature -> State Provider -> Repository -> Drift Database

Analysis Flow:
Drift Database -> Repository -> HealthAnalyticsService -> State Provider -> UI Aggregates

## 5. Persistence Strategy
Local-only persistence via Drift (SQLite).
- Database: `HealthDatabase` (schema version 2)
- Atomic Tables: `VitalEntries`, `ActivityEntries`, `HydrationEntries`, `NutritionEntries`.
- Repository Pattern: Generic `BaseRepository` interface with `DriftBaseRepository` implementation.

## 6. State Management
Riverpod-based reactive state exposure.
- Providers for Repositories and Services.
- FutureProviders/StreamProviders for data streams and analytics computation.

## 7. Dependency Matrix
- **Core**: Flutter SDK
- **Persistence**: Drift, sqlite3_flutter_libs, path_provider, path
- **State**: flutter_riverpod
- **Utilities**: collection

## 8. Offline-First Policy
The system operates exclusively offline. All data is persisted locally in the device's SQLite database. No external network dependencies are present in the core module behavior.

## 9. Validation Matrix
- save/load correctness in Drift.
- repository-layer integrity.
- analytics aggregation correctness.
