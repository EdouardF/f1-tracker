import SwiftUI

struct RaceDetailView: View {
    let race: Race
    @State private var viewModel = RaceViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: GridPulseTheme.paddingMedium) {
                // MARK: - Race Header
                GlassCard {
                    VStack(alignment: .leading, spacing: GridPulseTheme.paddingSmall) {
                        Text("ROUND \(race.round)")
                            .font(GridPulseTheme.caption)
                            .foregroundStyle(GridPulseTheme.accent)

                        Text(race.name)
                            .font(GridPulseTheme.heroTitle)
                            .foregroundStyle(.white)

                        HStack {
                            Label(race.circuitId.replacingOccurrences(of: "_", with: " ").capitalized, systemImage: "location.fill")
                                .font(GridPulseTheme.body)
                                .foregroundStyle(GridPulseTheme.mutedText)

                            Spacer()

                            Label(race.date, style: .date, systemImage: "calendar")
                                .font(GridPulseTheme.body)
                                .foregroundStyle(GridPulseTheme.mutedText)
                        }
                    }
                }

                // MARK: - Sessions
                sessionsSection

                // MARK: - Starting Grid
                if !viewModel.grid.isEmpty {
                    gridSection
                }

                // MARK: - Results
                if !viewModel.results.isEmpty {
                    resultsSection
                }
            }
            .padding(.horizontal, GridPulseTheme.paddingMedium)
        }
        .background(GridPulseTheme.background)
        .navigationTitle(race.name)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if let sessionKey = Int(race.id) {
                await viewModel.loadSessionData(sessionKey: sessionKey)
            }
        }
    }

    // MARK: - Sessions Section

    private var sessionsSection: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: GridPulseTheme.paddingSmall) {
                Text("WEEKEND SCHEDULE")
                    .font(GridPulseTheme.caption)
                    .foregroundStyle(GridPulseTheme.accent)

                if viewModel.sessions.isEmpty {
                    Text("No session data available")
                        .font(GridPulseTheme.body)
                        .foregroundStyle(GridPulseTheme.mutedText)
                } else {
                    ForEach(viewModel.sessions) { session in
                        HStack {
                            Text(session.type.shortName)
                                .font(.system(.body, weight: .bold, design: .monospaced))
                                .foregroundStyle(.white)

                            Spacer()

                            Text(session.date, style: .date)
                                .font(GridPulseTheme.caption)
                                .foregroundStyle(GridPulseTheme.mutedText)
                        }
                    }
                }
            }
        }
    }

    // MARK: - Grid Section

    private var gridSection: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: GridPulseTheme.paddingSmall) {
                Text("STARTING GRID")
                    .font(GridPulseTheme.caption)
                    .foregroundStyle(GridPulseTheme.accent)

                ForEach(viewModel.grid.sorted(by: { $0.position < $1.position })) { entry in
                    HStack {
                        PositionChip(position: entry.position, size: 28)
                        Text(entry.broadcastName ?? "Driver \(entry.driverNumber)")
                            .font(GridPulseTheme.body)
                            .foregroundStyle(.white)
                        Spacer()
                    }
                }
            }
        }
    }

    // MARK: - Results Section

    private var resultsSection: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: GridPulseTheme.paddingSmall) {
                Text("RESULTS")
                    .font(GridPulseTheme.caption)
                    .foregroundStyle(GridPulseTheme.accent)

                ForEach(viewModel.results.sorted(by: { ($0.position ?? 99) < ($1.position ?? 99) })) { result in
                    HStack {
                        if let pos = result.position {
                            PositionChip(position: pos, size: 28)
                        }
                        Text(result.broadcastName ?? "Driver")
                            .font(GridPulseTheme.body)
                            .foregroundStyle(.white)
                        Spacer()
                        if let gap = result.gapToLeader {
                            GapView(gap: gap)
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
            id: "2026-1",
            name: "Bahrain Grand Prix",
            circuitId: "bahrain",
            date: Date().addingTimeInterval(86400 * 7),
            season: 2026,
            round: 1
        ))
    }
    .preferredColorScheme(.dark)
}