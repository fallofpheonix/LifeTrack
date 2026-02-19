# Requirements

## Functional Requirements
- User profile CRUD
- Activity log CRUD with calories and duration
- Meal logging and calorie tracking
- Vitals logging (blood pressure, heart rate, glucose, weight)
- Recovery/health trend charts
- Reminder scheduling and tracking
- Medical details capture (allergies, history, emergency contact, insurance)
- Data export and retention-policy hooks
- Offline-first operation

## Non-Functional Requirements
- Local-first reliability with deterministic persistence
- Sensitive data encryption at rest
- Extensible architecture for sync and analytics
- Test coverage for critical provider/store flows
- Build compatibility for Android/iOS

## Toolchain Requirements
- Flutter `>=3.10.8` (tested on `3.38.9`)
- Java 21 for Android builds
- Android NDK `27.0.12077973`
- Android command-line tools `>=20.0`

## Compliance/Safety Requirements
- Clear separation between educational guidance and diagnosis
- Avoid medical claims implying clinical certainty
- Handle personal health data with least-exposure principles
