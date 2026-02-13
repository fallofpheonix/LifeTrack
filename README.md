# LifeTrack: Revolutionizing Physical Health Management

## Team Members
- **Member 1**: Dr. Gaurav Soni, SCOPE, VIT Bhopal University, Kothri, India, gaurav.soni@vitbhopal.ac.in
- **Member 2**: Ishita Gautam, SCOPE, VIT Bhopal University, Kothri, India, ishita.23bce11316@vitbhopal.ac.in
- **Member 3**: Ujjwal Singh, SCOPE, VIT Bhopal University, Kothri, India, ujjwal.23bce10578@vitbhopal.ac.in
- **Member 4**: Prince Negi, SCOPE, VIT Bhopal University, Kothri, India, prince.23bce10687@vitbhopal.ac.in
- **Member 5**: Priyanshu, SCOPE, VIT Bhopal University, Kothri, India, priyanshu.23bce10601@vitbhopal.ac.in
- **Member 6**: Vanshika Khatri, SCOPE, VIT Bhopal University, Kothri, India, vanshika.23bce10465@vitbhopal.ac.in

## Abstract
LifeTrack is a mobile health application designed to support personalized wellness management through fitness tracking, nutrition guidance, disease awareness, reminders, and progress analytics. The app supports both manual logging and future wearable integration to improve consistency in health monitoring. By combining personalized plans, records, and social motivation concepts, LifeTrack aims to improve physical activity, nutrition adherence, and long-term healthy behavior formation, especially for users managing chronic conditions such as diabetes.

## Keywords
Health app, personalized wellness, fitness tracking, nutrition management, wearable integration, progress monitoring, chronic disease support, medication adherence, preventive care, digital health

## 1. Introduction
LifeTrack is built as a personal health companion that helps users track key health metrics and maintain healthier routines. It focuses on practical daily actions: activity tracking, meal logging, hydration, sleep awareness, reminders, and medical record maintenance.

### Problem Statement
Chronic conditions, especially diabetes and hypertension, require ongoing monitoring and lifestyle consistency. Traditional one-size-fits-all health guidance often fails to match individual needs. LifeTrack addresses this gap with a personalized and data-driven approach.

### Objectives
- Track health indicators such as steps, sleep, calories, hydration, and basic medical observations.
- Provide reminders for medication, hydration, and routine activities.
- Offer disease-awareness guidance with symptoms and precautions.
- Maintain date-wise health records for patient follow-up.
- Show trend-based analytics for recovery monitoring.

### Scope
The app is intended for general wellness users and people managing chronic conditions. Current implementation is an MVP with modular architecture suitable for extending into wearable sync, predictive analytics, and clinician-facing reports.

## 2. Literature Review (Summary)
Research on mobile health systems emphasizes:
- Real-time tracking improves behavior correction and self-awareness.
- Personalization increases adherence compared to generic recommendations.
- Wearable integration improves passive data capture and engagement.
- Gamification and social support improve long-term retention.
- Data privacy and trust are critical for health-app adoption.

LifeTrack incorporates these findings through personalized dashboards, reminders, records, and trend visualization.

## 3. Methodology
### 3.1 Requirement Gathering
- User-centric needs were identified from chronic-care and wellness use cases.
- Core needs: personalization, easy logging, reminders, disease guidance, and progress insights.

### 3.2 System Design
- Flutter cross-platform architecture for Android and iOS compatibility.
- Modular screen design for dashboard, activity, nutrition, reminders, and medical management.

### 3.3 Development Approach
- Iterative MVP rebuilding from recovered requirements.
- Stateless/stateful widget composition with reusable data models.
- Progressive enhancement strategy: core flows first, persistence and integration next.

### 3.4 Evaluation Plan
- Functional verification through static analysis and widget tests.
- Future metrics: DAU/MAU, retention, adherence rates, and outcome improvements.

## 4. Results and Current Implementation
The recreated LifeTrack MVP currently includes:
- Dashboard: steps, hydration, sleep, calories.
- Activity: daily logs with quick-add entries.
- Nutrition: meal-based calorie overview.
- Reminders: toggles for medicine/hydration/activity.
- Medical module:
  - Disease guide (symptoms + precautions).
  - Health records (date-wise condition/vitals/notes).
  - Recovery graph (fasting and post-meal glucose trend).

### Sample Recovery Trend Data
| Month | Fasting Glucose (mg/dL) | Post-Meal Glucose (mg/dL) |
|---|---:|---:|
| M1 | 168 | 238 |
| M2 | 149 | 212 |
| M3 | 136 | 194 |
| M4 | 124 | 176 |

Interpretation: The sample trend shows progressive reduction in both fasting and post-meal glucose values, indicating improved control over time.

## 5. Discussion
The rebuilt app now aligns with the project vision and supports disease-aware tracking. The strongest current value is integrated daily management: users can view guidance, track data, and monitor recovery trends in one place.

Gaps to move from MVP to production:
- Persistent storage (SQLite/local secure store).
- Input forms with validation and edit/delete workflows.
- Auth + backend sync.
- Wearable/device integration.
- Compliance hardening and consent workflows.

## 6. Conclusion
LifeTrack demonstrates a practical and extensible digital health framework for physical health management. Even at MVP stage, it supports meaningful user actions and recovery monitoring. With persistence, integrations, and stronger analytics, the platform can evolve into a robust chronic-care and preventive-wellness solution.

## 7. References
1. Brown, J. (2020). *Health and Wellness in the Digital Age* (2nd ed.). HealthTech Publishing.
2. Smith, J. A., & Harris, L. M. (2019). The Impact of Mobile Health Apps on User Behavior and Health Outcomes. *Journal of Health Informatics, 12*(3), 234-246.
3. Williams, D. F., & Lee, H. R. (2022). *Innovations in Health Technology: From Wearables to Mobile Apps*. FutureHealth Press.
4. Wikipedia contributors. Health App. https://en.wikipedia.org/wiki/Health_app

## 8. Build and Verification Notes
- Flutter analysis: passing.
- Widget tests: passing.
- Android release build on this machine is currently blocked by local Android SDK/NDK toolchain inconsistency and requires environment cleanup (Java toolchain pinning + stable cmdline-tools/NDK installation).

## 9. Next Technical Upgrades
1. Add full CRUD record forms with validation.
2. Persist data locally using SQLite.
3. Add search/filter for diseases and records.
4. Export reports to PDF/CSV.
5. Add authentication and cloud sync.
6. Add Google Fit / HealthKit integration.
7. Add role-specific views (patient/doctor).

## 10. Open Source
LifeTrack is open source and available for community contributions.

### License
This project is licensed under the MIT License. See the `LICENSE` file for details.

### Contributing
Please read `CONTRIBUTING.md` before opening issues or pull requests.

### Notes for Contributors
- Keep health guidance informational and avoid diagnosis claims.
- Validate new metrics and trends with realistic sample data.
- Include tests for feature behavior and edge cases.
