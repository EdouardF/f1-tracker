import SwiftUI

struct RaceWeekendView: View {
    @State private var viewModel = RaceViewModel()
    let race: Race

    var body: some View {
        ScrollView {
            VStack(spacing: GridPulseTheme.paddingMedium) {
                // MARK: - Race Header
                GlassCard {
                    VStack(alignment: .leading, spacing: GridPulseTheme.paddingSmall) {
                        Text("RACE WEEKEND")
                            .font(GridPulseTheme.caption)
                            .foregroundStyle(GridPulseTheme.accent)

                        Text(race.name)
                            .font(GridPulseTheme.heroTitle)
                            .foregroundStyle(.white)

                        Text(race.circuitId.replacingOccurrences(of: "_", with: " ").capitalized)
                            .font(GridPulseTheme.body)
                            .foregroundStyle(GridPulseTheme.mutedText)
                    }
                }

                // MARK: - Sessions Timeline
                sessionsTimeline

                // MARK: - Results (if available)
                if !viewModel.results.isEmpty {
                    resultsCard
                }

                // MARK: - Grid (if available)
                if !viewModel.grid.isEmpty {
                    gridCard
                }
            }
            .padding(.horizontal, GridPulseTheme.paddingMedium)
        }
        .background(GridPulseTheme.background)
        .navigationTitle("Race Weekend")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Sessions Timeline

    private var sessionsTimeline: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: GridPulseTheme.paddingSmall) {
                Text("SESSIONS")
                    .font(GridPulseTheme.caption)
                    .foregroundStyle(GridPulseTheme.accent)

                if viewModel.sessions.isEmpty {
                    Text("No session data available")
                        .font(GridPulseTheme.body)
                        .foregroundStyle(GridPulseTheme.mutedText)
                } else {
                    ForEach(viewModel.sessions) { session in
                        sessionRow(session: session)
                    }
                }
            }
        }
    }

    private func sessionRow(session: Session) -> some View {
        HStack(spacing: 12) {
            // Session type badge
            Text(session.type.shortName)
                .font(.system(.body, weight: .bold, design: .monospaced))
                .foregroundStyle(session.type.isRace ? GridPulseTheme.accent : .white)
                .frame(width: 56, alignment: .leading)

            VStack(alignment: .leading, spacing: 2) {
                Text(session.type.displayName)
                    .font(GridPulseTheme.body)
                    .foregroundStyle(.white)

                Text(session.date, style: .date)
                    .font(GridPulseTheme.caption)
                    .foregroundStyle(GridPulseTheme.mutedText)
            }

            Spacer()

            // Status indicator
            if session.date > Date() {
                Text("UPCOMING")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(GridPulseTheme.accent)
            } else {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(GridPulseTheme.success)
            }
        }
        .padding(.vertical, 4)
    }

    // MARK: - Results Card

    private var resultsCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: GridPulseTheme.paddingSmall) {
                Text("RESULTS")
                    .font(GridPulseTheme.caption)
                    .foregroundStyle(GridPulseTheme.accent)

                ForEach(viewModel.results.sorted(by: { ($0.position ?? 99) < ($1.position ?? 99) }).prefix(10)) { result in
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

    // MARK: - Grid Card

    private var gridCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: GridPulseTheme.paddingSmall) {
                Text("STARTING GRID")
                    .font(GridPulseTheme.caption)
                    .foregroundStyle(GridPulseTheme.accent)

                ForEach(viewModel.grid.sorted(by: { $0.position < $1.position }).prefix(10)) { entry in
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
}

// MARK: - Preview
#Preview {
    NavigationStack {
        RaceWeekendView(race: Race(
            id: "2026-1",
            name: "Bahrain Grand Prix",
            circuitId: "bahrain",
            date: Date(),
            season: 2026,
            round: 1
        ))
    }
    .preferredColorScheme(.dark)
}