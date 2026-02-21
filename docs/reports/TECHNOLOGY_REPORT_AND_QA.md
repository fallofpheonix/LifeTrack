# Technology Report

## 1. System Architecture
The application uses a feature-modular architecture with a standardized repository pattern for health data.

### Core Framework
- **Framework**: Flutter (SDK ^3.10.8)
- **Language**: Dart
- **Pattern**: Atomic Backend-First Repositories.

### Persistence Layer
- **Local Database**: `drift` (SQLite).
- **Schema**: `HealthDatabase` (Schema Version 2).
- **Standardized Access**: `BaseRepository<T>` interface and `DriftBaseRepository` for generic CRUD operations.
- **Legacy Storage**: Secure `shared_preferences` for non-modular settings (to be deprecated).

### State Management
- **Riverpod**: Primary dependency injection and reactive state holder.
- **Services**: `HealthAnalyticsService` for cross-module data aggregation.

## 2. Implemented Modules
- **Vitals**: BP, Heart Rate, Glucose, Weight tracking.
- **Activity**: Movement and intensity logging.
- **Hydration**: Daily fluid intake monitoring.
- **Nutrition**: Meal categorized calorie tracking.
- **Medical**: Offline-first education layer with condition mappings.

## 3. Technical Implementation Details

### A. Atomic Repository Pattern
To ensure data integrity and modularity, each health domain is isolated into an "Atomic Module". These modules inherit from `DriftBaseRepository`, which provides:
- Automatic JSON conversion via Drift mappers.
- Standardized stream-based monitoring (`watchAll`).
- Type-safe `upsert` and `delete` operations.

### B. Cross-Module Analytics
The `HealthAnalyticsService` provides the intelligence layer by aggregating data from across modules. For example, `netCalorieBalance` is calculated by intersecting Nutrition (Calories In) and Activity (Calories Out).

### C. Offline-First Intelligence
Clinical intelligence (Consistency, Plateau detection) operates entirely on-device by analyzing local SQLite snapshots.

## 4. Technical QA Guidance

### Architecture Verification
**Q: How is data consistency enforced across different health metrics?**
**A**: Through the `BaseRepository` interface. Every health entry follows a standardized mapping from companion to domain models, and Drift’s transaction-safe SQLite integration ensures disk integrity.

**Q: How do you handle cross-module data dependencies?**
**A**: Dependencies are resolved at the Service/Provider layer. Analytics services depend on repository interfaces, not concrete implementations, allowing for independent testing and module replacement.

**Q: Why migrate from legacy Store to Atomic Repositories?**
**A**: To eliminate large JSON blob rewrites in SharedPrefs. Drift allows for granular row-level updates, better query performance for history, and schema-enforced data types.
