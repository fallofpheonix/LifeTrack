# LifeTrack

> Personal, privacy-first health management with atomic backend-first modularity.

[![Flutter](https://img.shields.io/badge/Flutter-3.10.8-02569B?logo=flutter)](https://flutter.dev/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Overview

**LifeTrack** is an offline-first health companion designed for granular wellness management. It employs a modular architecture to strictly separate domain logic from persistent storage, ensuring lightweight performance and local data ownership.

## Key Features

### 📊 Dashboard
- **Consolidated Metrics**: Steps, Vitlas, Hydration, Sleep, and Calories at a glance.
- **Analytics Aggregation**: Cross-module insights (e.g., Net Calorie Balance).

### 🏃 Activity & Nutrition
- **Atomic Logging**: Independent modules for tracking energy expenditure and intake.
- **Drift Persistence**: Reliable SQLite storage for recovery and trend analysis.

### 🏥 Medical & Vitals
- **Vitals Tracking**: Granular logs for BP, heart rate, glucose, and weight.
- **Support Layer**: Offline education datasets for medical conditions and evidence-based insights.
- **Medical Profile**: Secure storage for history, allergies, and emergency metadata.

### 🧠 Intelligence Engine
- **Consistency Analysis**: Scoring of adherence to tracking habits.
- **Plateau Detection**: Identification of metabolic stagnation for actionable insights.
- **Suggestion Service**: Context-aware guidance based on historical data.

### 🔒 Privacy First
- **Zero-Cloud Architecture**: All data resides exclusively in the local Drift (SQLite) database.
- **Atomic Modularity**: Features are isolated to minimize side effects during scaling.

## Tech Stack

- **Framework**: [Flutter](https://flutter.dev/)
- **State Management**: `flutter_riverpod` (Reactive State)
- **Persistence**: `drift` (SQLite)
- **Visualization**: `fl_chart`
- **Design System**: Atomic UI primitives with dark-mode focus.

## Getting Started

### Prerequisites
- **Flutter SDK**: `>=3.10.8`
- **Dart SDK**: Compatible with Flutter version.
- **Java**: 21 (Required for Android toolchain stability).

### Installation

1.  **Clone the repository**:
    ```bash
    git clone https://github.com/fallofpheonix/LifeTrack.git
    cd LifeTrack
    ```

2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Run code generation**:
    ```bash
    dart run build_runner build
    ```

4.  **Run the app**:
    ```bash
    flutter run
    ```

## Project Structure

Feature-modular structure within `lib/`:

- **`core/database/`**: Drift schema, migrations, and atomic mapping logic.
- **`core/database/repositories/`**: Standardized `BaseRepository` implementations for all health modules.
- **`domain/models/`**: POJO domain entities for modular logic.
- **`features/`**: UI-facing modules (Vitals, Activity, Hydration, Nutrition, Medical, Profile).
- **`state/providers/`**: Riverpod providers for repository access and analytics computation.

## License

This project is licensed under the MIT License.
