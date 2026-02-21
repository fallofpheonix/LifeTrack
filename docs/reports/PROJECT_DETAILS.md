# Project Details

## Project Name
LifeTrack

## Type
Modular health management application built with Flutter.

## Core Features
- Dashboard metrics (steps, hydration, sleep, calories)
- Modular logging for Activity, Nutrition, Vitals, and Hydration.
- Vitals tracking (blood pressure, heart rate, glucose, weight).
- Offline-first intelligence services for plateau detection and consistency analysis.
- Education layer with conditions, evidence, and research-backed insights.
- User profile management with medical details.

## Architecture Summary
- **Architecture**: Atomic backend-first modules with standardized repositories.
- **UI**: Feature-modular widgets using Flutter Material and Custom Painters.
- **State**: Riverpod-based reactive state management.
- **Storage**: SQLite local persistence via Drift (schema version 2).
- **Core Logic**: HealthAnalyticsService for cross-module trend aggregation.

## Data Domains
- User Profile
- Activity Logs
- Nutrition/Meal Records
- Vital Signs (BP, HR, Pulse, Glucose, Weight)
- Hydration Tracking
- Clinical/Educational JSON Datasets (Conditions, Pioneers, Quotes)

## Supported Platforms
- Android
- iOS
