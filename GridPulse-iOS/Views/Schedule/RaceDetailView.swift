import SwiftUI
import SwiftData

struct RaceDetailView: View {
    let race: Race
    @State private var viewModel = RaceViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: GridPulseSpacing.md) {
                raceHeader
                resultsSection
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

                HStack(spacing: GridPulseSpacing.xs) {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundStyle(.gridOnSurfaceSecondary)
                    Text(race.circuitId.replacingOccurrences(of: "_", with: " ").capitalized)
                        .font(GridPulseTypography.caption)
                        .foregroundStyle(.gridOnSurfaceSecondary)

                    Spacer()

                    Text(race.date, style: .date)
                        .font(GridPulseTypography.caption)
                        .foregroundStyle(.gridOnSurfaceSecondary)
                }

                if viewModel.isLoading {
                    ProgressView()
                        .tint(.gridAccent)
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

                if viewModel.results.isEmpty {
                    Text("No results yet")
                        .font(GridPulseTypography.caption)
                        .foregroundStyle(.gridOnSurfaceSecondary)
                } else {
                    ForEach(Array(viewModel.results.prefix(10))) { result in
                        HStack {
                            PositionChip(position: result.position, style: .circle)
                            Text(result.driverId.replacingOccurrences(of: "_", with: " "))
                                .font(GridPulseTypography.body)
                                .foregroundStyle(.gridOnSurface)
                            Spacer()
                            if !result.time.isEmpty {
                                Text(result.time)
                                    .font(GridPulseTypography.mono)
                                    .foregroundStyle(.gridOnSurfaceSecondary)
                            }
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
            season: 2026,
            round: 5
        ))
    }
    .modelContainer(for: [Race.self, CacheEntry.self])
}