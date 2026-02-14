# LifeTrack

> A personalized, privacy-first mobile health companion for daily wellness and chronic condition management.

[![Flutter](https://img.shields.io/badge/Flutter-3.10.8-02569B?logo=flutter)](https://flutter.dev/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com)

---

## 📋 Overview

**LifeTrack** is a comprehensive mobile health application that empowers users to take control of their wellness journey. By seamlessly integrating activity tracking, nutritional logging, and medical record-keeping, LifeTrack helps you build healthier habits and monitor your progress—whether you're managing chronic conditions like diabetes and hypertension or simply working towards a healthier lifestyle.

---

## ✨ Key Features

### 📊 **Dashboard**
Your daily health overview at a glance:
- **Steps Tracker** - Monitor your daily movement
- **Hydration Logger** - Simple tap to log water intake
- **Sleep Monitor** - Track your rest patterns
- **Calorie Counter** - Keep tabs on your energy balance

### 🏃 **Activity & Nutrition**
Complete fitness and diet management:
- Quick logging for exercises and meals
- Accurate calorie tracking with daily totals
- Historical data to keep you motivated

### 🏥 **Medical Hub**
Comprehensive chronic condition management:
- **Disease Guide** - Educational resources on symptoms and precautions
- **Health Records** - Secure storage for vitals, conditions, and notes
- **Recovery Graphs** - Visual trends (e.g., glucose levels over time)

### ⏰ **Smart Reminders**
Never miss important health tasks:
- Medication reminders
- Hydration alerts throughout the day
- Exercise and routine notifications

### 🔒 **Privacy Focused**
Your health data stays with you:
- Local-only storage using `shared_preferences`
- No cloud sync in MVP version
- Complete data privacy

---

## 🛠️ Tech Stack

| Component | Technology |
|-----------|------------|
| **Framework** | [Flutter](https://flutter.dev/) (Dart) |
| **State Management** | `setState` with Modular Widgets |
| **Local Storage** | `shared_preferences` |
| **Architecture** | Domain-driven feature separation |

---

## 🚀 Getting Started

### Prerequisites

Ensure you have the following installed:
- **Flutter SDK**: `^3.10.8`
- **Dart SDK**: Compatible with Flutter version
- **IDE**: Android Studio, VS Code, or IntelliJ

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/fallofpheonix/LifeTrack.git
   cd LifeTrack
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

---

## 📁 Project Structure

The project follows a clean, feature-based architecture within the `lib/` directory:

```
lib/
├── main.dart           # Application entry point
├── DashboardPage       # Main health overview screen
├── ActivityPage        # Activity logging and history
├── NutritionPage       # Meal and calorie tracking
├── MedicalPage         # Disease guide and health records
└── ReminderPage        # Reminder settings and management
```

---

## 🤝 Contributing

We welcome contributions from the community! 

To get started:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

Please read our [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines on our code of conduct and the pull request process.

---

## 📄 License

This project is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for complete details.

---

## 📚 References

1. Brown, J. (2020). *Health and Wellness in the Digital Age* (2nd ed.). HealthTech Publishing.
2. Smith, J. A., & Harris, L. M. (2019). The Impact of Mobile Health Apps on User Behavior and Health Outcomes. *Journal of Health Informatics, 12*(3), 234-246.
3. Williams, D. F., & Lee, H. R. (2022). *Innovations in Health Technology: From Wearables to Mobile Apps*. FutureHealth Press.
4. Wikipedia contributors. (2024). Health App. Retrieved from https://en.wikipedia.org/wiki/Health_app

---

<p align="center">Made with ❤️ for better health management</p>