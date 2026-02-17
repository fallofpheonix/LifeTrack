# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2026-02-17

### Added
- Initial project structure.
- `CHANGELOG.md` file.
- Real-time step counting using `pedometer` package.
- Manual sleep tracker with start and end time logging.
- Calorie calculator for meals and activities.
- User profile management (name, age, weight, height).
- Ability to delete activity, meal, and sleep entries.

### Fixed
- Compilation errors in `lib/main.dart` regarding `ActivityLog` class definition and `HealthSnapshot` mutability.
- Missing callback parameters (`onDeleteActivity`, `onAddMeal`, `onDeleteMeal`) in `ActivityPage` and `NutritionPage`.
- UI bug in `ActivityPage` where delete button was misplaced.
- iOS build error: `Framework 'Pods_Runner' not found` resolved by cleaning build and reinstalling pods.

### Changed
- Upgraded project dependencies using `flutter pub upgrade`.
- Moved `MainActivity.kt` to correct package path `com.fallofpheonix.lifetrack`.
