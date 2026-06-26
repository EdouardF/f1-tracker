# Phase 1 — Foundation Checklist

> GridPulse v0.1.0 — Implementation checklist, ordered by dependency

## Status Legend
- [ ] = TODO
- [x] = DONE
- [~] = PARTIAL (needs work)

---

## 1. Models — SwiftData @Model ✅

All 7 models already have `@Model` macro and SwiftData conformance.

- [x] `Driver.swift` — @Model, unique id, all properties
- [x] `Constructor.swift` — @Model, unique id, team colors
- [x] `Circuit.swift` — @Model, unique id, coordinates
- [x] `Race.swift` — @Model, unique id, sessions array
- [x] `Session.swift` — @Model, SessionType enum, date
- [x] `Standing.swift` — @Model, DriverStanding + ConstructorStanding
- [x] `LapData.swift` — @Model, sectors, pit out lap flag

**Issue**: Models use `Date` and arrays which need SwiftData relationship annotations. Need `@Relationship(deleteRule: .cascade)` for Race↔Session, and `@Attribute(.transient)` for computed properties.

---

## 2. Services — API Implementation

### 2.1 JolpicaService (Historical Data) [~]
- [x] Error enum `JolpicaError` with LocalizedError
- [x] Base URL and URLSession setup
- [ ] **Real endpoints implementation** (currently stubs):
  - [ ] `fetchDrivers(season:)` → GET /drivers.json
  - [ ] `fetchConstructors(season:)` → GET /constructors.json
  - [ ] `fetchRaces(season:)` → GET /races.json
  - [ ] `fetchDriverStandings(season:)` → GET /driverStandings.json
  - [ ] `fetchConstructorStandings(season:)` → GET /constructorStandings.json
  - [ ] `fetchRaceResults(season:round:)` → GET /results.json
  - [ ] `fetchQualifyingResults(season:round:)` → GET /qualifying.json
  - [ ] `fetchCircuits()` → GET /circuits.json
- [ ] **Response DTOs** (JolpicaResponse, MRData, DriverTable, etc.)
- [ ] **Mapping** from DTOs → SwiftData @Model objects

### 2.2 OpenF1Service (Live Data) [~]
- [x] Error enum `OpenF1Error` with LocalizedError
- [x] Base URL and URLSession setup
- [ ] **Real endpoints implementation**:
  - [ ] `fetchMeetings(year:)` → GET /meetings
  - [ ] `fetchSessions(meetingKey:)` → GET /sessions
  - [ ] `fetchDrivers(sessionKey:)` → GET /drivers
  - [ ] `fetchSessionResult(sessionKey:)` → GET /session_result
  - [ ] `fetchStartingGrid(sessionKey:)` → GET /starting_grid
  - [ ] `fetchChampionshipDrivers(sessionKey:)` → GET /championship_drivers
  - [ ] `fetchChampionshipTeams(sessionKey:)` → GET /championship_teams
  - [ ] `fetchLaps(sessionKey:driverNumber:)` → GET /laps
  - [ ] `fetchPitStops(sessionKey:)` → GET /pit
  - [ ] `fetchWeather(sessionKey:)` → GET /weather
  - [ ] `fetchRaceControl(sessionKey:)` → GET /race_control
- [ ] **Response DTOs** for OpenF1 JSON responses
- [ ] **Mapping** from DTOs → SwiftData @Model objects

### 2.3 CacheService (SwiftData) [~]
- [x] ModelContainer setup
- [x] ModelContext injection
- [ ] **TTL logic** (1h standings, 24h schedule, 5min live)
- [ ] **Smart refresh** (background task + pull-to-refresh)
- [ ] **Offline-first** (return cached data if network fails)
- [ ] **Cache invalidation** on season year change

---

## 3. ViewModels — @Observable with Real Data Flow

### 3.1 HomeViewModel [ ]
- [ ] `@Observable` macro (not ObservableObject)
- [ ] `@ObservationIgnored` for non-reactive properties
- [ ] Load next race (Jolpica + OpenF1)
- [ ] Load recent results
- [ ] Load standings snapshot (top 5 drivers)
- [ ] Error state handling
- [ ] Loading state (async task group)
- [ ] Pull-to-refresh support

### 3.2 ScheduleViewModel [ ]
- [ ] `@Observable` macro
- [ ] Load season calendar from Jolpica
- [ ] Filter by season year
- [ ] Group races by month
- [ ] Error + loading states

### 3.3 StandingsViewModel [ ]
- [ ] `@Observable` macro
- [ ] Load driver standings (Jolpica)
- [ ] Load constructor standings (Jolpica)
- [ ] Toggle between drivers/constructors tab
- [ ] Error + loading states

### 3.4 RaceViewModel [ ]
- [ ] `@Observable` macro
- [ ] Load race detail (sessions, results)
- [ ] Load starting grid (OpenF1)
- [ ] Load lap data (OpenF1)
- [ ] Error + loading states

---

## 4. Views — Liquid Glass UI

### 4.1 HomeView [~]
- [x] Basic structure with ScrollView
- [ ] **Liquid Glass**: `.glassEffect()` on cards
- [ ] **NextRaceCard**: countdown timer, circuit image placeholder
- [ ] **RecentResultsCard**: top 3 with team colors
- [ ] **StandingsSnapshot**: top 5 drivers with PositionChip
- [ ] **Navigation links** to detail views

### 4.2 ScheduleView [~]
- [x] Basic List structure
- [ ] **Race row** with team color accent, circuit flag
- [ ] **Month grouping** with section headers
- [ ] **NavigationLink** to RaceDetailView
- [ ] **Pull-to-refresh**

### 4.3 StandingsView (Driver + Constructor) [~]
- [x] Basic List structure
- [ ] **Driver row**: position chip, team color badge, name, points
- [ ] **Constructor row**: team color, name, points
- [ ] **Segmented control** drivers/constructors
- [ ] **NavigationLink** to DriverDetailView

### 4.4 RaceDetailView [~]
- [x] Basic structure
- [ ] **Session tabs** (FP1/2/3, Qualifying, Sprint, Race)
- [ ] **Results list** with position, driver, time
- [ ] **Starting grid** visualization

### 4.5 DriverDetailView [~]
- [x] Basic structure
- [ ] **Driver header** with team color, number, name
- [ ] **Season stats** (points, wins, podiums)
- [ ] **Recent results** list

### 4.6 RaceWeekendView [~]
- [x] Basic structure
- [ ] **Timeline** of sessions
- [ ] **Live data** integration (when session is active)
- [ ] **Weather** card (OpenF1)

### 4.7 SettingsView [~]
- [x] Basic Form structure
- [ ] **Notification preferences** toggle
- [ ] **Favorite driver** picker
- [ ] **Favorite constructor** picker
- [ ] **About** section with app version

### 4.8 ContentView (TabView) [~]
- [x] Basic 4-tab structure
- [ ] **iOS 26 glass tab bar** styling
- [ ] **SF Symbols** for tab icons (house, flag.checkered, chart.bar, gearshape)

---

## 5. Design System — Liquid Glass Components

### 5.1 TeamColors [~]
- [x] Static color definitions for 10 teams
- [ ] **Color extension** for hex initialization
- [ ] **Gradient** support (primary → secondary)

### 5.2 GridPulseTheme [~]
- [x] Color palette defined
- [ ] **Liquid Glass** color variants (tinted glass for team colors)
- [ ] **Typography** system (heroTitle, sectionTitle, etc.)

### 5.3 GlassCard [~]
- [x] Basic ViewModifier structure
- [ ] **`.glassEffect()`** for iOS 26+ (with `#if compiler(>=6.2)`)
- [ ] **Fallback** for iOS < 26 (regular card with shadow)

### 5.4 TeamColorBadge [~]
- [x] Basic structure
- [ ] **Driver number** overlay on team color circle
- [ ] **Glass variant** with `.glassEffect()`

### 5.5 PositionChip [~]
- [x] Basic structure with gold/silver/bronze
- [ ] **Animated entrance** (scale + fade)
- [ ] **Glass background** variant

### 5.6 LapTimeView [~]
- [x] Monospaced formatting
- [ ] **Sector color coding** (purple = fastest, green = personal best)
- [ ] **Delta** comparison support

---

## 6. App Entry Point

### 6.1 GridPulseApp.swift [~]
- [x] @main App struct
- [x] WindowGroup with ContentView
- [ ] **SwiftData ModelContainer** configuration (all 7 models)
- [ ] **Schema migration** for future versions

### 6.2 ContentView.swift [~]
- [x] 4-tab TabView
- [ ] **Tab icons** (SF Symbols)
- [ ] **Tab colors** (accent per tab)

---

## 7. Localization (xcstrings) [ ]
- [ ] **English base strings** — all UI text
- [ ] **French translations** — all UI text
- [ ] **String keys** for team names, session types, error messages

---

## 8. Tests

### 8.1 Unit Tests [ ]
- [ ] `JolpicaServiceTests` — API response decoding, error handling
- [ ] `OpenF1ServiceTests` — API response decoding, error handling
- [ ] `CacheServiceTests` — TTL logic, offline-first, invalidation
- [ ] `HomeViewModelTests` — loading states, error handling
- [ ] `ScheduleViewModelTests` — filtering, grouping
- [ ] `StandingsViewModelTests` — data loading, toggling
- [ ] `RaceViewModelTests` — session loading, grid data
- [ ] `ModelTests` — SwiftData CRUD operations

### 8.2 UI Tests [ ]
- [ ] `HomeViewUITests` — navigation, pull-to-refresh
- [ ] `ScheduleViewUITests` — race list, detail navigation
- [ ] `StandingsViewUITests` — tab switching, driver detail
- [ ] `SettingsViewUITests` — toggle preferences

---

## 9. Documentation

### 9.1 README.md [~]
- [x] Basic structure
- [ ] **Setup instructions** (Xcode, XcodeGen)
- [ ] **Architecture overview**
- [ ] **API documentation** links

### 9.2 TESTING.md [ ]
- [ ] Test strategy (unit + UI + integration)
- [ ] How to run tests
- [ ] Coverage requirements

### 9.3 ARCHITECTURE.md [x]
- Already comprehensive

---

## Implementation Order (Priority)

1. **Services** → Everything depends on data
   - JolpicaService endpoints + DTOs
   - OpenF1Service endpoints + DTOs
   - CacheService TTL + offline-first

2. **ViewModels** → Connect services to views
   - HomeViewModel, ScheduleViewModel, StandingsViewModel, RaceViewModel

3. **Design System** → Views depend on components
   - GlassCard, TeamColorBadge, PositionChip, LapTimeView
   - GridPulseTheme colors + typography

4. **Views** → Final UI layer
   - HomeView, ScheduleView, StandingsView (tabs)
   - RaceDetailView, DriverDetailView, RaceWeekendView
   - SettingsView

5. **App Config** → Wire everything together
   - GridPulseApp.swift (ModelContainer)
   - ContentView.swift (TabView styling)

6. **Localization** → i18n strings
   - English base, French translations

7. **Tests** → Validate everything
   - Unit tests (services, viewmodels)
   - UI tests (navigation, interaction)

8. **Documentation** → README, TESTING.md