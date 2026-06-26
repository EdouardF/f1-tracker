# Architecture — GridPulse

## Tech Stack

| Layer | Choice |
|-------|--------|
| Language | Swift 6 |
| UI | SwiftUI, iOS 26+ (Liquid Glass) |
| Architecture | MVVM + Repository |
| Network | URLSession + async/await |
| Cache | SwiftData (offline-first) |
| APIs | Jolpica F1 (historical) + OpenF1 (live) |
| CI/CD | Xcode Cloud |
| i18n | Localizable.xcstrings (EN + FR) |

## Module Structure

```
GridPulse-iOS/
├── App/
│   ├── GridPulseApp.swift      # Entry point, ModelContainer
│   └── ContentView.swift        # TabView (Home, Schedule, Standings, Settings)
├── Models/
│   ├── Driver.swift             # @Model driver data
│   ├── Constructor.swift        # @Model constructor data
│   ├── Circuit.swift            # @Model circuit data
│   ├── Race.swift               # @Model race data
│   ├── Session.swift            # @Model + SessionType enum
│   ├── Standing.swift           # @Model DriverStanding, ConstructorStanding
│   └── LapData.swift            # @Model lap data
├── Services/
│   ├── JolpicaService.swift     # Historical F1 API (DTOs + mapping)
│   ├── OpenF1Service.swift      # Live F1 API (DTOs + mapping)
│   └── CacheService.swift       # SwiftData TTL cache
├── ViewModels/
│   ├── HomeViewModel.swift      # @MainActor @Observable
│   ├── ScheduleViewModel.swift   # @MainActor @Observable
│   ├── StandingsViewModel.swift   # @MainActor @Observable
│   └── RaceViewModel.swift       # @MainActor @Observable
├── Views/
│   ├── Home/HomeView.swift
│   ├── Schedule/ScheduleView.swift, RaceDetailView.swift
│   ├── Standings/StandingsTabView.swift, DriverStandingsView.swift,
│   │   ConstructorStandingsView.swift, DriverDetailView.swift
│   ├── Race/RaceWeekendView.swift
│   └── Settings/SettingsView.swift
├── Design/
│   ├── GridPulseTheme.swift     # Colors, Typography, Spacing, Animation
│   ├── TeamColors.swift          # Team enum + Color(hex:) + teamColor(for:)
│   └── Components/
│       ├── GlassCard.swift
│       ├── PositionChip.swift
│       ├── TeamColorBadge.swift
│       └── LapTimeView.swift
└── Resources/
    ├── Assets.xcassets
    ├── Localizable.xcstrings
    ├── Info.plist
    └── GridPulse.entitlements
```

## API Strategy

### Jolpica F1 (Historical)
- Base URL: `https://api.jolpica.com/ergast/f1/`
- Endpoints: drivers, constructors, standings, races, results, qualifying, circuits
- Data: Season standings, race calendar, historical results

### OpenF1 (Live)
- Base URL: `https://api.openf1.org/v1/`
- Endpoints: meetings, sessions, drivers, results, grid, laps, pits, weather, race_control
- Data: Real-time session data, positions, lap times, weather

### Cache Strategy (CacheService)
- SwiftData-backed with TTL
- Offline-first: cache → network → expired cache fallback
- TTL: standings 1h, schedule 24h, results 24h, live data no cache

## Design System

### Colors (Dark-first)
- `gridBackground` #0A0A0A
- `gridSurface` #1C1C1E
- `gridCard` #2C2C2E
- `gridAccent` #3671C6 (F1 Blue)
- `gridRed` #E10600 (F1 Red)
- `gridOnSurface` #FFFFFF
- `gridOnSurfaceSecondary` #8E8E93
- `gridSuccess` #34C759
- `gridWarning` #FF9500

### Typography
- `heroTitle` 32pt heavy
- `sectionTitle` 24pt bold
- `cardTitle` 20pt semibold
- `body` 16pt regular
- `caption` 14pt medium
- `mono` 14pt monospaced

### Spacing
- xs=4, sm=8, md=16, lg=24, xl=32

### Liquid Glass (iOS 26+)
- `GlassCard` component: `.glassEffect()` iOS 26+, `.ultraThinMaterial` fallback
- `TabView` with `.glassTabView()` iOS 26+

## Concurrency
- Swift 6 strict concurrency (`SWIFT_STRICT_CONCURRENCY=complete`)
- ViewModels: `@MainActor @Observable`
- Services: `@unchecked Sendable` (URLSession is thread-safe)
- Models: `@Model` (non-Sendable, confined to MainActor)

## Build Info
- Bundle ID: `com.ef-engineering.gridpulse`
- Team: `Z2PN67EL4F`
- Min deployment: iOS 26.0
- Swift version: 6
- XcodeGen: `project.yml`