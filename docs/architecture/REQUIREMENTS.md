### 1. Functional Requirements

#### 🩺 Vitals Logging
- **Metric Support**: Record BP, heart rate, glucose, and weight via generic `VitalEntry` snapshots.
- **Categorization**: Use `metricType` strings for extensible health tracking.
- **History**: Display last 15 entries for trend analysis.

#### 🏃 Activity & Nutrition
- **Activity**: Record type, duration, and calories burned.
- **Nutrition**: Record meal type (breakfast, lunch, etc.), title, and calories.

#### 💧 Hydration Logging
- **Unit**: Record volume of water consumed in glasses.
- **Tracking**: Daily aggregate calculation.

#### 🏥 Medical Education
- **Condition Guide**: Offline access to common medical condition datasets.
- **Clinical Evidence**: Versioned research insights.
- **Scientific Pioneers**: Biographical datasets.

### 2. Technical Requirements

#### 💾 Persistence
- **Storage**: Drift (SQLite) for all health metrics.
- **Modularity**: Standalone atomic repositories for each health domain.
- **Schema**: Versioned SQL schema (v2).

#### 🛡️ Privacy & Security
- **Local Ownership**: Zero-cloud by default.
- **On-Device Insights**: Analysis performed via local `HealthAnalyticsService`.
- **Cross-Platform Compatibility**: Supports Android and iOS.

## Data Governance
- Local-only data retention.
- Zero external data leakage (all compute happens on-device).
- Separation of medical data from educational guidance.
