# 🏎️ GridPulse

> F1 Tracker — le pulse du départ

iOS app for tracking Formula 1: teams, grands prix, standings, live data.

## Features

- **Home**: Next race countdown, latest results, standings snapshot
- **Schedule**: Season calendar with month grouping
- **Standings**: Driver & constructor championships
- **Race Detail**: Sessions, starting grid, results, weather
- **Live Data**: Real-time laps, pit stops, race control (OpenF1)
- **Design**: Liquid Glass (iOS 26+), team color accents, dark-first

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

## Setup

### Prerequisites

- Xcode 26+ (or Xcode 16+ with `#if compiler(>=6.2)` compat)
- XcodeGen (`brew install xcodegen`)

### Build

```bash
# Generate Xcode project
xcodegen generate

# Open in Xcode
open GridPulse.xcodeproj

# Or build from command line
xcodebuild -project GridPulse.xcodeproj -scheme GridPulse -destination 'platform=iOS Simulator,name=iPhone 17'
```

### Project Structure

```
GridPulse/
├── GridPulse-iOS/
│   ├── App/           # GridPulseApp, ContentView
│   ├── Models/        # SwiftData @Model classes
│   ├── Services/      # JolpicaService, OpenF1Service, CacheService
│   ├── ViewModels/    # @Observable VMs
│   ├── Views/         # SwiftUI views (Home, Schedule, Standings, Race, Settings)
│   ├── Design/        # Theme, TeamColors, components
│   └── Resources/     # Assets, Localizable.xcstrings
├── GridPulse-Tests/   # Unit & UI tests
├── project.yml        # XcodeGen config
└── ci_scripts/        # Xcode Cloud CI
```

## APIs

### Jolpica F1 (Historical)
- Drivers, Constructors, Standings
- Race calendar, Results, Qualifying
- Base: `https://api.jolpica.com/ergast/f1/`

### OpenF1 (Live)
- Meetings, Sessions, Drivers
- Live positions, Lap times, Pit stops
- Weather, Race control messages
- Base: `https://api.openf1.org/v1/`

## Design System

- **Colors**: `Color.gridRed`, `Color.gridBlue`, `Color.gridAccent`, team colors via `Color.teamColor(for:)`
- **Typography**: `GridPulseTypography.heroTitle`, `.sectionTitle`, `.cardTitle`, `.body`, `.caption`, `.mono`
- **Spacing**: `GridPulseSpacing.xs/sm/md/lg/xl` (4/8/16/24/32)
- **Glass**: `.glassCard()` modifier (`.glassEffect()` iOS 26+, `.ultraThinMaterial` fallback)
- **Components**: `GlassCard`, `PositionChip`, `TeamColorBadge`, `LapTimeView`

## Team Colors (2026)

| Team | Primary | Secondary |
|------|---------|-----------|
| Red Bull | #3671C6 | #FFD700 |
| Ferrari | #E8002D | #FFE100 |
| McLaren | #FF8000 | #0057B8 |
| Mercedes | #27F4D2 | #000000 |
| Aston Martin | #229971 | #006F62 |
| Alpine | #FF87BC | #0090FF |
| Williams | #64C4FF | #005AFF |
| RB | #6692FF | #FFFFFF |
| Sauber | #52E252 | #000000 |
| Haas | #B6BABD | #000000 |

## License

Private — © EF Engineering Corporation