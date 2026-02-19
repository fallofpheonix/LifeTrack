# Project Details

## Project Name
LifeTrack

## Type
Cross-platform mobile health management app (Flutter) for Android and iOS.

## Current Scope
- Dashboard metrics (steps, hydration, sleep, calories)
- Activity and nutrition logging
- Medical records and vitals tracking
- Recovery trend visualization
- Reminder workflows
- Profile management with medical details
- Local encryption and governance hooks

## Architecture Summary
- UI: feature-based Flutter widgets
- State: `LifeTrackStore` + Riverpod providers
- Storage: encrypted local persistence over shared preferences/files
- Domain services: intelligence, sync queue, governance, education

## Data Domains
- User profile
- Activities
- Nutrition
- Vitals (BP, heart rate, glucose, weight)
- Medication/reminders
- Education/research content

## Supported Platforms
- Android
- iOS
- Web/macOS are present in project scaffolding and partially supported
