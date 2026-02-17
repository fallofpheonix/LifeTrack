# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2026-02-17

### Added
- Initial project structure.
- `CHANGELOG.md` file.

### Fixed
- Compilation errors in `lib/main.dart` regarding `ActivityLog` class definition and `HealthSnapshot` mutability.
- Missing callback parameters (`onDeleteActivity`, `onAddMeal`, `onDeleteMeal`) in `ActivityPage` and `NutritionPage`.
- UI bug in `ActivityPage` where delete button was misplaced.

### Changed
- Upgraded project dependencies using `flutter pub upgrade`.
- Moved `MainActivity.kt` to correct package path `com.fallofpheonix.lifetrack`.
