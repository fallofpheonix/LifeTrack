# Task Tracker

## Completed
- Added medical profile schema fields and persistence.
- Added `MedicalDetailsSection` UI and profile integration.
- Added `PatientSeeder` synthetic data generation service.
- Updated markdown documentation set and changelog.
- Fixed stale unit tests for validator/model contract alignment.

## In Progress
- Android build environment stabilization in all local setups.
- Lint cleanup for non-blocking analyzer warnings (`tool/perf_guard.dart`, underscore style hints).

## Pending
- CI workflow for analyze/test/build.
- Additional tests for medical profile section behaviors.
- End-to-end regression suite for logging + chart rendering.
- Documentation drift checks in CI.

## Blockers
- None repo-level at this time; environment-specific Android toolchain drift remains a local risk.
