# Contributing to LifeTrack

Thanks for contributing to LifeTrack.

## Getting Started
- Fork the repository and create a feature branch.
- Keep changes focused and atomic.
- Run checks locally before submitting:
  - `flutter analyze`
  - `flutter test`

## Documentation and Repository Layout
- **All new documentation must go under `docs/`.** Do not add planning, research, or other non–build-critical documentation at the repository root.
- **The repository root must contain only build-critical files** (e.g. `pubspec.yaml`, `analysis_options.yaml`, `README.md`, platform project files). Reject patterns that introduce planning or research files at root.

## Pull Request Guidelines
- Add a clear title and summary.
- Describe the motivation and expected behavior changes.
- Include screenshots/videos for UI updates.
- Reference related issues when available.

## Health Data and Safety
- Do not present app output as clinical diagnosis.
- Keep wording educational and support-focused.
- Use anonymized/sample data for demos and tests.

## Code Style
- Follow existing Flutter/Dart project conventions.
- Prefer readable, modular widgets over large monolithic files.
- Add tests for new logic and bug fixes.

## Reporting Issues
- Include platform details (Android/iOS/web/macos).
- Provide reproduction steps and expected vs actual behavior.
- Attach logs/errors where possible.
