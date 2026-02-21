# PROJECT_REQUIREMENTS.md

## 1. Project Name
LifeTrack

## 2. Problem Statement
Users track health data across fragmented tools. A single offline-first application is required to combine:
- Daily health logging
- Medical awareness
- Longitudinal tracking
- Educational context

## 3. Goal
Build an offline-capable personal health tracker that:
1. Records lifestyle and vitals
2. Shows trends
3. Rotates medical educational content
4. Demonstrates structured engineering architecture for academic evaluation

## 4. Non-Goals
Do not build:
- Clinical decision system
- Diagnosis engine
- Live hospital integration
- AI medical recommendations

## 5. Core Capabilities
1. Log daily activity (steps, exercise)
2. Log hydration and nutrition
3. Record vitals manually
4. Display health trends visually
5. Show rotating disease knowledge
6. Show research-style insights from static datasets
7. Work completely offline
8. Store all data locally

## 6. User Type
Single-user personal tracking system. No multi-user support.

## 7. Academic Evaluation Criteria
- Clean architecture separation
- Explicit data modeling
- Persistence strategy
- UI modularity
- Offline reliability

## 8. Constraints
- Launch under 2 seconds target
- Minimal memory footprint
- No network dependency for core features
- Avoid heavy compute in UI thread

## 9. Testing Requirements
- Data save/load cycle
- Persistence across app restart
- Empty-state behavior
- Rotation behavior for medical content

## 10. Future Extension (Out of Scope)
- Cloud sync
- Wearable integration
- Advanced analytics
