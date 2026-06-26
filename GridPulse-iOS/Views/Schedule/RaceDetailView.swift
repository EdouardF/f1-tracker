import SwiftUI
import SwiftData

struct RaceDetailView: View {
    let race: Race
    @State private var viewModel = RaceViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: GridPulseSpacing.md) {
                // Race Header
                raceHeader

                // Sessions Timeline
                if !viewModel.sessions.isEmpty {
                    sessionsSection
                }

                // Starting Grid
                if !viewModel.grid.isEmpty {
                    gridSection
                }

                // Results
                if !viewModel.results.isEmpty {
                    resultsSection
                }

                // Weather
                if !viewModel.weather.isEmpty {
                    weatherSection
                }
            }
            .padding()
        }
        .background(Color.gridBackground)
        .navigationTitle(race.name)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadRaceDetail(raceId: race.id, season: race.season, round: race.round)
        }
    }

    // MARK: - Header
    private var raceHeader: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: GridPulseSpacing.sm) {
                Text(race.name)
                    .font(GridPulseTypography.heroTitle)
                    .foregroundStyle(.gridOnSurface)

                Label(race.circuitId.replacingOccurrences(of: "_", with: " ").capitalized, systemImage: "mappin.and.ellipse")
                    .font(GridPulseTypography.caption)
                    .foregroundStyle(.gridOnSurfaceSecondary)

                HStack {
                    Label(race.date, style: .date, systemImage: "calendar")
                        .font(GridPulseTypography.caption)
                        .foregroundStyle(.gridOnSurfaceSecondary)

                    if viewModel.isLoading {
                        ProgressView()
                            .tint(.gridAccent)
                    }
                }
            }
        }
    }

    // MARK: - Sessions
    private var sessionsSection: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: GridPulseSpacing.sm) {
                Label("SESSIONS", systemImage: "clock")
                    .font(GridPulseTypography.caption)
                    .foregroundStyle(.gridAccent)

                ForEach(viewModel.sessions) { session in
                    HStack {
                        Text(session.type.rawValue.uppercased())
                            .font(GridPulseTypography.caption)
                            .foregroundStyle(.gridOnSurface)
                        Spacer()
                        Text(session.date, style: .date)
                            .font(GridPulseTypography.mono)
                            .foregroundStyle(.gridOnSurfaceSecondary)
                    }
                }
            }
        }
    }

    // MARK: - Grid
    private var gridSection: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: GridPulseSpacing.sm) {
                Label("STARTING GRID", systemImage: "list.number")
                    .font(GridPulseTypography.caption)
                    .foregroundStyle(.gridAccent)

                ForEach(viewModel.grid.prefix(10)) { position in
                    HStack {
                        PositionChip(position: position.position, style: .circle)
                        Text(position.driverCode)
                            .font(GridPulseTypography.body)
                            .foregroundStyle(.gridOnSurface)
                        Spacer()
                        Text(position.teamName)
                            .font(GridPulseTypography.caption)
                            .foregroundStyle(.gridOnSurfaceSecondary)
                    }
                }
            }
        }
    }

    // MARK: - Results
    private var resultsSection: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: GridPulseSpacing.sm) {
                Label("RESULTS", systemImage: "trophy")
                    .font(GridPulseTypography.caption)
                    .foregroundStyle(.gridAccent)

                ForEach(viewModel.results.prefix(10)) { result in
                    HStack {
                        PositionChip(position: result.position, style: .circle)
                        Text(result.driverName)
                            .font(GridPulseTypography.body)
                            .foregroundStyle(.gridOnSurface)
                        Spacer()
                        if let gap = result.gapToLeader {
                            Text(gap)
                                .font(GridPulseTypography.mono)
                                .foregroundStyle(.gridOnSurfaceSecondary)
                        }
                    }
                }
            }
        }
    }

    // MARK: - Weather
    private var weatherSection: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: GridPulseSpacing.sm) {
                Label("WEATHER", systemImage: "cloud.sun")
                    .font(GridPulseTypography.caption)
                    .foregroundStyle(.gridAccent)

                if let currentWeather = viewModel.weather.first {
                    HStack(spacing: GridPulseSpacing.lg) {
                        if let trackTemp = currentWeather.trackTemp {
                            VStack {
                                Text("\(trackTemp, specifier: "%.0f")°")
                                    .font(GridPulseTypography.heroTitle)
                                    .foregroundStyle(.gridOnSurface)
                                Text("Track")
                                    .font(GridPulseTypography.caption)
                                    .foregroundStyle(.gridOnSurfaceSecondary)
                            }
                        }
                        if let airTemp = currentWeather.airTemp {
                            VStack {
                                Text("\(airTemp, specifier: "%.0f")°")
                                    .font(GridPulseTypography.heroTitle)
                                    .foregroundStyle(.gridOnSurface)
                                Text("Air")
                                    .font(GridPulseTypography.caption)
                                    .foregroundStyle(.gridOnSurfaceSecondary)
                            }
                        }
                        if currentWeather.rainfall {
                            Label("Rain", systemImage: "cloud.rain")
                                .foregroundStyle(.gridBlue)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        RaceDetailView(race: Race(
            id: "2026-5",
            name: "Monaco Grand Prix",
            circuitId: "monaco",
            date: Date(),
            sessions: [],
            season: 2026,
            round: 5
        ))
    }
    .modelContainer(for: [Race.self, CacheEntry.self])
}