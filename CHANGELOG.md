# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- `UserProfile` medical metadata fields:
  - `medicalHistory`, `allergies`
  - `emergencyContactName`, `emergencyContactPhone`, `emergencyContactRelation`
  - `insuranceProvider`, `insurancePolicyNumber`
- New profile UI widget: `lib/features/profile/widgets/medical_details_section.dart`
  - Editable emergency contact and insurance blocks
  - Editable allergy chips and medical history list
  - Persist updates through `LifeTrackStore.updateProfile(...)`
- New synthetic data generator: `lib/core/services/seeder/patient_seeder.dart`
  - Seeds 50-100 records for weight, blood pressure, heart rate, and activities
  - Uses store write APIs for persisted test/stress data

### Changed
- `lib/features/profile/profile_page.dart`
  - Integrated `MedicalDetailsSection` into profile page layout
  - Preserved extended medical fields during profile save flow
  - Added Developer Options action to trigger patient data generation from UI
- `lib/data/models/user_profile.dart`
  - Extended constructor, fields, `toJson`, and `fromJson` for medical/contact/insurance persistence
- Documentation alignment with current codebase:
  - Updated `README.md` (state model, stack, prerequisites, structure, medical/profile coverage)
  - Updated `SETUP.md` Flutter version guidance
  - Updated `TECHNOLOGY_REPORT_AND_QA.md` with profile-domain expansion + seeder notes
  - Updated `RESEARCH_SUMMARY.md` objectives/system highlights
  - Corrected wording in `FUTURE_WORKS.md` (`Appointment Scheduling`)

## [1.1.0] - 2026-02-18

### Added
- **Education Layer**: Dedicated tab for medical conditions, evidence-based research, and scientist profiles.
- **Intelligence Layer**:
  - `ConsistencyService` to track logging streaks.
  - `PlateauService` to detect weight stagnation.
  - `SuggestionService` for personalized health tips.
- **Cloud Sync (Beta)**:
  - Offline-first architecture with `SyncQueueService`.
  - Conflict resolution strategies using entity versioning.
- **Data Governance**:
  - Retention policies for medical records.
  - User data export functionality.
- **Security**:
  - Local data encryption using `flutter_secure_storage` and `encrypt` packages.

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
