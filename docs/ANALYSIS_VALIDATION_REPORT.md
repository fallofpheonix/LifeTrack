# Analysis Validation Report

Generated from a workspace scan for unresolved symbols, stale indexes, and partial refactors. **No code was modified.**

---

## 1. Unresolved symbols and errors (`dart analyze lib/`)

**Total: 26 errors, 1 warning, 1 info.**

### A. Drift database layer (stale generated code)

| File | Issue |
|------|--------|
| `lib/core/database/health_database.dart` | `NutritionEntriesCompanion`, `NutritionEntryRecord` undefined. References to `id`, `date`, `mealType`, `title`, `calories` in nutrition extension fail because those record/companion types are not in the generated file. |
| `lib/core/database/health_database.g.dart` | **Stale**: Defines only `VitalEntries`, `ActivityEntries`, `HydrationEntries`. Does **not** define `NutritionEntries`, `NutritionEntryRecord`, `NutritionEntriesCompanion`, or `nutritionEntries` getter, although `health_database.dart` declares the `NutritionEntries` table and uses it in `@DriftDatabase(tables: [... NutritionEntries])`. |

**Cause**: Generated file is out of sync with source. The `NutritionEntries` table was added in `health_database.dart` but `health_database.g.dart` was not regenerated.

### B. Drift repositories (API / type mismatches)

| File | Issue |
|------|--------|
| `lib/core/database/repositories/drift_base_repository.dart` | `SimpleSelectable` undefined. Likely renamed or removed in current Drift API. |
| `lib/core/database/repositories/drift_activity_repository.dart` | `activityEntries` / `date` undefined for `DatabaseConnectionUser`; `OrderingTerm Function(ActivityEntries)` not assignable to `List<OrderClauseGenerator<HasResultSet>>`. |
| `lib/core/database/repositories/drift_hydration_repository.dart` | Same pattern: `hydrationEntries`, `date`, ordering type. |
| `lib/core/database/repositories/drift_nutrition_repository.dart` | `NutritionEntryRecord`, `NutritionEntriesCompanion` undefined (downstream of stale .g.dart); `nutritionEntries`, `date`, ordering type. |
| `lib/core/database/repositories/drift_vitals_repository.dart` | `vitalEntries`, `timestamp`, ordering type. |

**Cause**: Repositories assume a Drift API (e.g. `DatabaseConnectionUser`, `SimpleSelectable`, select/orderBy signatures) that may not match the current Drift version or the generated database class.

### C. Application UI (non–build‑critical)

| File | Issue |
|------|--------|
| `lib/features/activity/widgets/add_activity_dialog.dart` | Unused import `package:lifetrack/data/models/activity_log.dart`. Deprecated use of `value` (use `initialValue` per Flutter 3.33+). |

---

## 2. Stale indexes

- **`lib/core/database/health_database.g.dart`**: Out of date with `health_database.dart`. The source defines four tables (Vitals, Activity, Hydration, **Nutrition**); the generated file only includes three and omits all Nutrition-related types and the `nutritionEntries` accessor.

---

## 3. Partial refactors

- **Nutrition table**: Fully defined in `health_database.dart` (table class + domain mappers) but not present in generated code. Any code path that uses the Drift DB or the analytics/state layer that depends on it will hit the above errors.
- **Drift repository layer**: `lib/core/database/` and `lib/state/providers/health_analytics_providers.dart` depend on the database and repositories. These are **not** referenced from `lib/main.dart`; the app entrypoint uses `LifeTrackStore`, shared_preferences, and feature providers only. So the main app can still run, but any use of the analytics/database path (e.g. from a feature that wires in `health_analytics_providers` or the drift repos) will fail at compile/analysis.

---

## 4. Resync recommendations (for editor/CI consistency)

1. **Regenerate Drift code**  
   From project root:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
   This should repopulate `health_database.g.dart` with `NutritionEntries`, `NutritionEntryRecord`, `NutritionEntriesCompanion`, and the `nutritionEntries` getter, resolving the nutrition-related undefined symbols in `health_database.dart` and `drift_nutrition_repository.dart`.

2. **Align Drift API usage**  
   After regeneration, re-run `dart analyze lib/`. If errors remain in `drift_base_repository.dart` or the drift_*_repository files, check the current Drift package docs for:
   - Replacement for `SimpleSelectable` (or the correct type for table/select usage).
   - Correct type for the database parameter (e.g. whether it should be `GeneratedDatabase` or another interface instead of `DatabaseConnectionUser`).
   - Correct `orderBy` / `OrderingTerm` API (e.g. `OrderClauseGenerator<HasResultSet>` vs `OrderingTerm Function(Table)`).

3. **IDE / analysis server**  
   After regenerating and fixing Drift API usage:
   - Run `flutter pub get` (or `dart pub get`).
   - Restart the Dart Analysis Server (in VS Code/Cursor: “Dart: Restart Analysis Server”) so the editor’s index picks up the new .g.dart and updated types.

---

## 5. Summary

| Category | Count | Location |
|----------|--------|----------|
| Undefined class/type | 4 | health_database.dart, drift_nutrition_repository.dart, drift_base_repository.dart |
| Undefined getter/identifier | 14 | drift_*_repository.dart, health_database.dart (nutrition) |
| Type not assignable | 4 | drift_*_repository (orderBy) |
| Unused import | 1 | add_activity_dialog.dart |
| Deprecated member | 1 | add_activity_dialog.dart (value → initialValue) |

**Editor consistency**: The only stale artifact identified is **`health_database.g.dart`**. Resyncing analysis (regenerate + restart analysis server) will not fix API mismatches in the drift repositories; those require code/API updates. The main app entrypoint does not depend on the database or analytics layer, so runtime behavior of the current app is unchanged by these analysis issues.
