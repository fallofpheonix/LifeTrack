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
- Comprehensive documentation suite:
  - `DOCUMENTATION_INDEX.md`
  - `MOTIVE_AND_OBJECTIVES.md`
  - `PROJECT_DETAILS.md`
  - `REQUIREMENTS.md`
  - `TECHNOLOGIES.md`
  - `INTERVIEW_QUESTIONS.md`
  - `FUTURE_SCOPE.md`
  - `FUTURE_CHANGES.md`
  - `POTENTIAL_AND_IMPACT.md`
  - `TASK_TRACKER.md`
  - `CURRENT_STATUS.md`
- Offline Medical Hub dataset pack under `assets/medical/`:
  - `diseases.json`, `research.json`, `pioneers.json`, `mock_records.json`, `facts.json`
  - Pioneer portraits under `assets/medical/pioneers/`
- Education domain models for Medical Hub content:
  - `lib/domain/education/models/disease.dart`
  - `lib/domain/education/models/research_item.dart`
  - `lib/domain/education/models/pioneer.dart`
  - `lib/domain/education/models/mock_health_record.dart`
- Single JSON asset loader:
  - `lib/data/education/education_data_source.dart`
- Medical Hub provider graph:
  - `lib/presentation/medical/providers/medical_providers.dart`
  - `personalLogProvider`, `rotatingDiseaseProvider`, `insightsFeedProvider`, `pioneersProvider`, `didYouKnowProvider`
- Medical Hub isolation tests using fake repository injection:
  - `test/fakes/fake_education_repository.dart`
  - `test/medical/medical_providers_test.dart`
  - `test/medical/health_library_tab_test.dart`

### Changed
- `lib/features/profile/profile_page.dart`
  - Integrated `MedicalDetailsSection` into profile page layout
  - Preserved extended medical fields during profile save flow
  - Added Developer Options action to trigger patient data generation from UI
- Medical Hub tabs are now fully provider-driven (no feature-local JSON loader/FutureBuilder data source):
  - `lib/features/medical/tabs/my_records_tab.dart`
  - `lib/features/medical/tabs/learn_tab.dart`
  - `lib/features/medical/tabs/research_tab.dart`
- Medical Hub labels finalized for presentation framing:
  - `Records` -> `Personal Log`
  - `Learn` -> `Health Library`
  - `Research` -> `Insights`
- Education repository/service extended for offline rotating content:
  - `lib/domain/education/repositories/education_repository.dart`
  - `lib/domain/education/repositories/education_repository_impl.dart`
  - `lib/domain/education/services/education_service.dart`
- Theme/UI polish and interaction updates:
  - Clinical palette and semantic surfaces in `lib/core/theme/app_theme.dart`
  - Card micro-interaction scale effect in `lib/core/ui/base_card.dart`
- Minor lint-hardening updates:
  - `tool/perf_guard.dart`
  - `lib/features/dashboard/dashboard_page.dart`

### Removed
- Removed feature-local duplicate medical content loader:
  - `lib/features/medical/data/offline_medical_content.dart`
- Removed profile developer seeding action from UI surface:
  - `lib/features/profile/profile_page.dart` (Developer Options card/button)
- `lib/data/models/user_profile.dart`
  - Extended constructor, fields, `toJson`, and `fromJson` for medical/contact/insurance persistence
- `test/temp_verification_test.dart`
  - Updated assertions to match current `DataSource` enum and `ValidationResult` API
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
