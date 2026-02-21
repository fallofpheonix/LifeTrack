# DESIGN_DOCUMENTATION.md

## 1. Design Objective
Deliver a calm, data-focused health interface that feels:
- Clinical but not hospital-like
- Modern but not flashy
- Informational, not gamified
- Lightweight for long-term use

Visual communication target: Stability -> Awareness -> Personal Tracking

## 2. Inspiration
Primary style: modern glassmorphism dashboard patterns (Dribbble-like).

Adopt:
- Soft layered cards
- Muted gradients
- Frosted surfaces
- Tight hierarchy and spacing discipline

Avoid:
- Bright fitness color schemes
- Gamification-heavy visuals
- Illustration-heavy surfaces

## 3. Design Principles
1. Information-first
2. Low cognitive load (screen understood in <2s)
3. Soft depth over hard separators
4. Calm color behavior
5. Modular replaceability

## 4. Color System
| Role | Value |
|---|---|
| Primary | #2F4858 |
| Accent | #6FA3A9 |
| Background Light | #F4F7F8 |
| Background Dark | #1C2328 |
| Card Surface | Adaptive semantic token |
| Text Primary | Adaptive high-contrast semantic token |
| Text Secondary | Adaptive muted semantic token |

Rules:
- No raw RGB in feature widgets
- No pure black/white blocks
- Use semantic tokens only

## 5. Typography
Preferred stack:
- Inter
- SF Pro
- Roboto fallback

Scale:
- Page title: 22-24
- Section header: 16-18
- Body: 14-15
- Meta: 12-13

## 6. Layout Rules
Base spacing unit = 8px.
Allowed spacing multiples: 8, 16, 24, 32, 48.

Screen layout contract:
Scaffold -> SafeArea -> Section layout -> Reusable components

### 7. Core Component Set
Mandatory reusable components available in `lib/design_system/components/` and `lib/core/ui/`:
- **ScreenScaffold**: Root layout wrapper with safe area and background handling.
- **GlassCard**: Semi-transparent elevated surface.
- **MetricCard**: Container for summary metrics.
- **MetricItem**: Data visualization unit for individual metrics (Steps, Sleep, etc.).
- **ActionCard**: Interactive card for suggestions and insights.
- **SectionHeader**: Standardized header for layout blocks.
- **EmptyState**: Standardized placeholder for empty data views.

### 8. Layout Rules
- **Viewports**: All pages use `ScreenScaffold` -> `AppPageLayout` -> `ListView/Column`.
- **Bottom Navigation**: Primary access to Home, Vitals, Activity, Nutrition, Medical, and Profile.
- **Spacing**: Rigid adherence to 8pt increments via `AppSpacing` tokens.
- **Routing**: Use named routes via `AppRouter`; avoid direct widget push coupling.

## 9. Motion
Allowed:
- Fade-in ~150-250ms
- Scale 0.98 -> 1.0

Forbidden:
- Bounce / elastic / long transitions / parallax

## 10. Data Visualization
- Emphasize trend readability
- Use muted accent tone
- Avoid chart clutter
- Prefer sparkline-like summaries over dense dashboards

## 11. Empty State Tone
Use neutral continuity messaging, e.g.:
"No data recorded yet. Your tracking will appear here."

## 12. Replaceability Requirement
UI must depend only on ViewState models.
UI must not access repositories/services/storage directly.
