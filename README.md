# LifeTrack

> Revolutionising Physical Health Management with a personalized, privacy-first approach.

[![Flutter](https://img.shields.io/badge/Flutter-3.10.8-02569B?logo=flutter)](https://flutter.dev/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com)

## Overview

**LifeTrack** is a mobile health companion designed to empower users in managing their daily wellness and chronic conditions. By combining activity tracking, nutritional logging, and medical record-keeping into a single, cohesive interface, LifeTrack helps users build healthier habits and monitor their recovery progress.

Whether you are managing diabetes, hypertension, or just aiming for a healthier lifestyle, LifeTrack provides the tools you need to stay on top of your health.

## Key Features

### 📊 Dashboard
Your daily health at a glance. Visualise key metrics instantly:
- **Steps**: Track your daily movement.
- **Hydration**: Log water intake with a simple tap.
- **Sleep**: Monitor your rest patterns.
- **Calories**: Keep an eye on your energy balance.

### 🏃 Activity & Nutrition
- **Quick Logging**: Easily add exercises and meals.
- **Calorie Tracking**: Input calorie counts for accurate daily totals.
- **History**: Review past activities to stay motivated.

### 🏥 Medical Hub
A dedicated space for managing chronic conditions:
- **Disease Guide**: Access educational information on symptoms and precautions for various conditions.
- **Health Records**: Securely store dated records of your condition, vitals, and notes.
- **Recovery Graph**: Visualize your health trends (e.g., Fasting vs. Post-Meal Glucose) to see your progress over time.
- **Medical Profile Details**: Store allergies, medical history, emergency contact, and insurance metadata.

### ⏰ Smart Reminders
Never miss a beat with customizable alerts:
- **Medication**: Timely reminders to take your medicine.
- **Hydration**: Nudges to drink water throughout the day.
- **Routine**: Alerts for exercise or other health-related activities.

### 🧠 Intelligence Engine
- **Consistency Tracker**: Visualizes your adherence to logging habits.
- **Plateau Detection**: Identifies weight stagnation periods to suggest routine changes.
- **Smart Suggestions**: Context-aware tips based on your recent activity and vitals.

### 📚 Education Layer
- **Disease Guide**: Comprehensive info on common conditions.
- **Evidence-Based**: Access clinical reasoning and research summaries.
- **Scientist Profiles**: Learn about pioneers in medical history (e.g., Pasteur, Fleming).

### 🔒 Privacy Focused
- **Local Encryption**: Sensitive data is encrypted on-device.
- **Data Governance**: Automatic retention policies and full data export capabilities.
- **Offline First**: Full functionality without internet connection.
- **Developer Seeder**: Optional synthetic patient data generation for stress/performance testing.

## Tech Stack

- **Framework**: [Flutter](https://flutter.dev/) (Dart)
- **State Management**: `flutter_riverpod` + `provider` (`LifeTrackStore` as central state holder)
- **Local Storage**: `shared_preferences`
- **Security**: `flutter_secure_storage`, `encrypt`
- **Visualization**: `fl_chart`
- **Architecture**: Domain-driven feature separation.

## Getting Started

### Prerequisites
- **Flutter SDK**: `>=3.10.8` (tested on `3.38.9`)
- **Dart SDK**: Compatible with Flutter version.
- **IDE**: Android Studio / VS Code / IntelliJ.
- **Java**: 21 (required for Android toolchain reliability).

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

3.  **Run the app**:
    ```bash
    flutter run
    ```

## Project Structure

Feature/domain-oriented structure (within `lib/`):

- **`app/`**: App shell and navigation.
- **`core/`**: Shared services, state providers, storage, encryption, sync/intelligence utilities.
- **`data/`**: Models and repositories.
- **`domain/`**: Education content and domain providers.
- **`features/`**: UI features (`dashboard`, `activity`, `nutrition`, `medical`, `profile`, `settings`, `vitals`, `hydration`).
- **`main.dart`**: Initialization, secure serializer wiring, app bootstrap.

## Documentation

- **Master Index**: [DOCUMENTATION_INDEX.md](DOCUMENTATION_INDEX.md)
- **Project**: [PROJECT_DETAILS.md](PROJECT_DETAILS.md), [MOTIVE_AND_OBJECTIVES.md](MOTIVE_AND_OBJECTIVES.md), [REQUIREMENTS.md](REQUIREMENTS.md), [CURRENT_STATUS.md](CURRENT_STATUS.md), [TASK_TRACKER.md](TASK_TRACKER.md)
- **Technical**: [TECHNOLOGIES.md](TECHNOLOGIES.md), [INTERVIEW_QUESTIONS.md](INTERVIEW_QUESTIONS.md), [TECHNOLOGY_REPORT_AND_QA.md](TECHNOLOGY_REPORT_AND_QA.md), [SETUP.md](SETUP.md)
- **Roadmap/Strategy**: [FUTURE_SCOPE.md](FUTURE_SCOPE.md), [FUTURE_CHANGES.md](FUTURE_CHANGES.md), [POTENTIAL_AND_IMPACT.md](POTENTIAL_AND_IMPACT.md), [FUTURE_WORKS.md](FUTURE_WORKS.md)
- **History**: [CHANGELOG.md](CHANGELOG.md)

## Contributing

Contributions are welcome! Please read our [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
