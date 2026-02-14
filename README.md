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

### ⏰ Smart Reminders
Never miss a beat with customizable alerts:
- **Medication**: Timely reminders to take your medicine.
- **Hydration**: Nudges to drink water throughout the day.
- **Routine**: Alerts for exercise or other health-related activities.

### 🔒 Privacy Focused
- **Local Storage**: All your health data is stored locally on your device using `shared_preferences`.
- **No Cloud Sync (MVP)**: Your data stays with you.

## Tech Stack

- **Framework**: [Flutter](https://flutter.dev/) (Dart)
- **State Management**: `setState` (MVP Architecture) / Modular Widgets
- **Local Storage**: `shared_preferences`
- **Architecture**: Domain-driven feature separation.

## Getting Started

### Prerequisites
- **Flutter SDK**: `^3.10.8`
- **Dart SDK**: Compatible with Flutter version.
- **IDE**: Android Studio / VS Code / IntelliJ.

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

The project follows a clean, feature-based directory structure (within `lib/`):

- **`main.dart`**: Entry point and core app logic.
- **`DashboardPage`**: Main overview screen.
- **`ActivityPage`**: Activity logging and history.
- **`NutritionPage`**: Meal and calorie tracking.
- **`MedicalPage`**: Disease guide and health records.
- **`ReminderPage`**: Reminder settings and management.

## Contributing

Contributions are welcome! Please read our [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## References

1.  Brown, J. (2020). *Health and Wellness in the Digital Age* (2nd ed.). HealthTech Publishing.
2.  Smith, J. A., & Harris, L. M. (2019). The Impact of Mobile Health Apps on User Behavior and Health Outcomes. *Journal of Health Informatics, 12*(3), 234-246.
3.  Williams, D. F., & Lee, H. R. (2022). *Innovations in Health Technology: From Wearables to Mobile Apps*. FutureHealth Press.
4.  Wikipedia contributors. Health App. https://en.wikipedia.org/wiki/Health_app