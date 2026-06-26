# 🏎️ GridPulse — Architecture

> F1 Tracker iOS — Écuries, Grands Prix, Classements

## App Name

**GridPulse** — le pulse du départ. Nom punchy, français-friendly, vibe F1.

## Stack

| Layer | Choix |
|-------|-------|
| Language | Swift 6 |
| UI | SwiftUI, iOS 26+ (Liquid Glass) |
| Min target | iOS 26.0 |
| Architecture | MVVM + Repository pattern |
| Network | URLSession + async/await |
| Cache | SwiftData (local DB) |
| APIs | Jolpica F1 (historique) + OpenF1 (live/rich) |
| CI/CD | Xcode Cloud (SANS EXCEPTION) |
| Widgets | WidgetKit + Live Activity |
| i18n | Localizable.xcstrings (EN base + FR) |

## Monorepo Structure

```
GridPulse/
├── GridPulse-iOS/              # Main iOS app target
│   ├── App/
│   │   ├── GridPulseApp.swift
│   │   └── AppDelegate.swift
│   ├── Views/
│   │   ├── Home/
│   │   │   ├── HomeView.swift
│   │   │   ├── NextRaceCard.swift
│   │   │   └── RecentResultsCard.swift
│   │   ├── Schedule/
│   │   │   ├── ScheduleView.swift
│   │   │   └── RaceDetailView.swift
│   │   ├── Standings/
│   │   │   ├── DriverStandingsView.swift
│   │   │   ├── ConstructorStandingsView.swift
│   │   │   └── DriverDetailView.swift
│   │   ├── Race/
│   │   │   ├── RaceWeekendView.swift
│   │   │   ├── SessionResultView.swift
│   │   │   └── StartingGridView.swift
│   │   └── Settings/
│   │       └── SettingsView.swift
│   ├── ViewModels/
│   │   ├── HomeViewModel.swift
│   │   ├── ScheduleViewModel.swift
│   │   ├── StandingsViewModel.swift
│   │   └── RaceViewModel.swift
│   ├── Models/
│   │   ├── Driver.swift
│   │   ├── Constructor.swift
│   │   ├── Circuit.swift
│   │   ├── Race.swift
│   │   ├── Session.swift
│   │   ├── Standing.swift
│   │   └── LapData.swift
│   ├── Services/
│   │   ├── JolpicaService.swift
│   │   ├── OpenF1Service.swift
│   │   └── CacheService.swift
│   ├── Design/
│   │   ├── TeamColors.swift
│   │   ├── GridPulseTheme.swift
│   │   └── Components/
│   │       ├── TeamColorBadge.swift
│   │       ├── PositionChip.swift
│   │       ├── LapTimeView.swift
│   │       └── GlassCard.swift
│   └── Resources/
│       ├── Assets.xcassets
│       └── Localizable.xcstrings
├── GridPulse-Widget/            # Home Screen + Lock Screen widgets
│   ├── NextRaceWidget.swift
│   ├── StandingsWidget.swift
│   └── GridPulseWidgetBundle.swift
├── GridPulse-LiveActivity/      # Live Activity for race weekends
│   ├── RaceLiveActivity.swift
│   └── RaceLiveActivityAttributes.swift
├── GridPulse-Shared/            # Shared models & services
│   ├── Models/
│   ├── Services/
│   └── Extensions/
├── GridPulse-Tests/
│   ├── UnitTests/
│   ├── UITests/
│   └── IntegrationTests/
├── ci_scripts/                  # Xcode Cloud CI
│   └── ci_post_clone.sh
├── fastlane/                    # Fastlane for test automation
├── docs/
│   ├── ARCHITECTURE.md
│   ├── TESTING.md
│   └── API.md
├── .gitignore
├── .swiftlint.yml
├── .swiftformat
└── README.md
```

## Screens & Navigation

```
TabView (Glass TabBar iOS 26)
├── 🏠 Home
│   ├── Next race countdown (hero card)
│   ├── Recent results
│   └── Current standings snapshot
├── 🏁 Schedule
│   ├── Season calendar (list + circuit map)
│   ├── Race detail
│   │   ├── Sessions (FP1/2/3, Q, Sprint, Race)
│   │   ├── Starting grid
│   │   └── Results per session
│   └── Circuit info (layout, stats)
├── 📊 Standings
│   ├── Drivers championship
│   │   └── Driver detail (bio, stats, season results)
│   └── Constructors championship
│       └── Constructor detail (car, drivers, stats)
└── ⚙️ Settings
    ├── Notifications (race start, results)
    ├── Favorite driver/constructor
    └── About
```

## Data Models

### Driver
```swift
struct Driver: Identifiable, Codable {
    let id: String // driver_number as String
    let number: Int
    let code: String // "VER", "HAM", etc.
    let firstName: String
    let lastName: String
    let nationality: String
    let teamColor: String // hex color
    let constructorId: String
}
```

### Constructor
```swift
struct Constructor: Identifiable, Codable {
    let id: String
    let name: String
    let fullName: String
    let nationality: String
    let color: String // primary team color (hex)
    let colorSecondary: String
}
```

### Circuit
```swift
struct Circuit: Identifiable, Codable {
    let id: String
    let name: String
    let locality: String
    let country: String
    let latitude: Double
    let longitude: Double
    let circuitLength: String // e.g. "5.412 km"
    let laps: Int
    let lapRecord: String
}
```

### Race (Meeting)
```swift
struct Race: Identifiable, Codable {
    let id: String // meeting_key or round number
    let name: String // "Monaco Grand Prix"
    let circuitId: String
    let date: Date
    let sessions: [Session]
    let season: Int
    let round: Int
}
```

### Session
```swift
struct Session: Identifiable, Codable {
    let id: String // session_key
    let raceId: String
    let type: SessionType // .fp1, .fp2, .fp3, .qualifying, .sprint, .race
    let date: Date
    let duration: TimeInterval?
}
enum SessionType: String, Codable {
    case fp1, fp2, fp3, qualifying, sprint, race
}
```

### Standing
```swift
struct DriverStanding: Identifiable, Codable {
    let id: String
    let driverId: String
    let position: Int
    let points: Double
    let wins: Int
    let constructorId: String
}

struct ConstructorStanding: Identifiable, Codable {
    let id: String
    let constructorId: String
    let position: Int
    let points: Double
    let wins: Int
}
```

### LapData (OpenF1 live)
```swift
struct LapData: Identifiable, Codable {
    let id: String
    let driverNumber: Int
    let lapNumber: Int
    let lapDuration: Double? // seconds
    let sector1: Double?
    let sector2: Double?
    let sector3: Double?
    let isPitOutLap: Bool
}
```

## API Layer

### Jolpica F1 API (Historical)
```
Base URL: https://api.jolpica.com/ergast/f1/

Endpoints:
GET /drivers/{driverId}/driverStandings.json    → Driver standings
GET /constructors/{constructorId}/constructorStandings.json → Constructor standings
GET /{season}/races.json                         → Race calendar
GET /{season}/{round}/results.json               → Race results
GET /{season}/{round}/qualifying.json            → Qualifying results
GET /{season}/{round}/sprint.json                → Sprint results
GET /circuits.json                               → All circuits
GET /drivers.json                                → All drivers
GET /constructors.json                           → All constructors
GET /current.json                                → Current season info
```

### OpenF1 API (Live & Rich)
```
Base URL: https://api.openf1.org/v1/

Endpoints (key ones):
GET /sessions?meeting_key=latest                  → Current/next session
GET /meetings?year=2026                           → Season meetings
GET /drivers?session_key=latest                   → Current drivers
GET /session_result?session_key=XXXX              → Session results
GET /starting_grid?session_key=XXXX               → Starting grid
GET /championship_drivers?session_key=XXXX         → Driver standings
GET /championship_teams?session_key=XXXX           → Constructor standings
GET /laps?session_key=XXXX&driver_number=1         → Lap times
GET /pit?session_key=XXXX                         → Pit stops
GET /weather?session_key=XXXX                      → Weather
GET /race_control?session_key=XXXX                 → Race control messages
GET /car_data?session_key=XXXX&driver_number=1     → Car telemetry
```

### Caching Strategy
- **SwiftData** local DB for all fetched data
- **TTL** :
  - Standings: 1 hour
  - Schedule: 24 hours
  - Session results: 5 min (during race weekend), 24h (otherwise)
  - Live telemetry: no cache (real-time)
- **Offline-first** : app fonctionne avec données en cache
- **Smart refresh** : background task + pull-to-refresh

## Design System — GridPulse Theme

### Philosophy
Minimalisme automobile. Lignes nettes, couleurs d'écurie comme accent, glass morphism iOS 26. Pas de chrome, pas de 3D — flat, bold, racing.

### Colors
```swift
// Team Colors (2026 season)
extension TeamColors {
    static let redBull = "#3671C6"      // Blue
    static let ferrari = "#E8002D"       // Red
    static let mercedes = "#27F4D2"      // Teal
    static let mclaren = "#FF8000"       // Papaya
    static let astonMartin = "#229971"   // British Racing Green
    static let alpine = "#FF87BC"        // Pink
    static let williams = "#64C4FF"      // Blue
    static let haas = "#B6BABD"          // Gray
    static let rb = "#6692FF"            // Blue
    static let sauber = "#52E252"        // Green
}

// App Palette
extension GridPulseTheme {
    static let background = Color.black
    static let surface = Color(.systemGray6) // Glass base
    static let onSurface = Color.white
    static let accent = Color("GridRed")     // F1 red accent
    static let onAccent = Color.white
    static let success = Color.green
    static let warning = Color.orange
    static let error = Color.red
}
```

### Typography
```swift
// SF Pro with racing weight hierarchy
extension GridPulseTypography {
    static let heroTitle = Font.system(.largeTitle, weight: .heavy, design: .default)
    static let sectionTitle = Font.system(.title2, weight: .bold)
    static let cardTitle = Font.system(.title3, weight: .semibold)
    static let body = Font.system(.body, weight: .regular)
    static let caption = Font.system(.caption, weight: .medium)
    static let mono = Font.system(.body, weight: .regular, design: .monospaced) // Lap times
}
```

### Liquid Glass Components
- `GlassCard` — `.glassEffect()` sur tous les cards
- `TeamColorBadge` — badge pilote avec couleur d'écurie
- `PositionChip` — P1, P2, P3 avec or/argent/bronze
- `LapTimeView` — temps formaté en monospaced
- `CountdownView` — countdown animé pour prochain GP

### Navigation
- `TabView` avec iOS 26 glass tab bar
- `NavigationStack` avec glass toolbar
- Transitions : `.navigationTransition(.zoom)` sur les cards

## Live Activity

```swift
struct RaceLiveActivityAttributes: ActivityAttributes {
    let raceName: String
    let circuitName: String
}

// Dynamic content:
// - Position changes
// - Lap count
// - Gap to leader
// - Pit stop alerts
// - Flag status (yellow, red, SC)
```

## Widgets

1. **NextRaceWidget** — countdown vers le prochain GP
2. **DriverStandingsWidget** — top 5 drivers avec team colors
3. **ConstructorStandingsWidget** — top 3 constructors
4. **RaceResultWidget** — résultat du dernier GP

## Phase de Développement

### Phase 1 — Foundation (v0.1.0)
- [ ] Xcode project setup (GridPulse-iOS, GridPulse-Shared, GridPulse-Tests)
- [ ] SwiftData models
- [ ] Jolpica API service (drivers, constructors, schedule, standings)
- [ ] Home tab (next race countdown, recent results, standings snapshot)
- [ ] Schedule tab (calendar list)
- [ ] Standings tab (drivers + constructors)
- [ ] Team colors design system
- [ ] Glass components (GlassCard, TeamColorBadge, PositionChip)

### Phase 2 — Race Weekend (v0.2.0)
- [ ] Race detail view (sessions, results)
- [ ] OpenF1 integration (session results, starting grid)
- [ ] Driver detail view (bio, stats)
- [ ] Constructor detail view
- [ ] Circuit info

### Phase 3 — Live (v0.3.0)
- [ ] OpenF1 live data (live positions, lap times, race control)
- [ ] Live Activity (race weekend)
- [ ] Push notifications (race start, results)
- [ ] Widgets (4 variants)

### Phase 4 — Polish (v1.0.0)
- [ ] i18n (EN + FR)
- [ ] Accessibility (VoiceOver, Dynamic Type)
- [ ] iPad adaptation
- [ ] App Store Connect setup
- [ ] TestFlight beta
- [ ] App Store submission

## Xcode Cloud CI/CD

**OBLIGATOIRE** pour tout l'écosystème Apple. Pas de GHA.

```yaml
# ci_scripts/ci_post_clone.sh
#!/bin/sh
set -e
brew install swiftlint swiftformat
swiftlint lint --quiet
swiftformat --lint .
```

## Conventions

- **Branches** : `feature/GRID-xxx-description`
- **Commits** : Conventional (`feat:`, `fix:`, `docs:`, `chore:`)
- **Co-authored** : chaque agent signe `Co-authored-by: Agent <agent@ef-engineering.corp>`
- **Tests** : Unit + UI + Integration, scaffold obligatoire pour chaque feature
- **iOS 26+** : Liquid Glass obligatoire, `#if compiler(>=6.2)` pour compat Xcode 16