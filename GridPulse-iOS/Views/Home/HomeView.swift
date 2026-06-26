import SwiftUI
import SwiftData

struct HomeView: View {
    @State private var viewModel = HomeViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: GridPulseSpacing.md) {
                    if viewModel.isLoading && viewModel.nextRace == nil {
                        loadingView
                    } else {
                        nextRaceSection
                        recentResultsSection
                        standingsSnapshot
                    }
                }
                .padding()
            }
            .background(Color.gridBackground)
            .navigationTitle("GridPulse")
            .refreshable {
                await viewModel.refresh()
            }
            .task {
                await viewModel.loadData()
            }
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") { viewModel.errorMessage = nil }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }

    // MARK: - Loading
    private var loadingView: some View {
        VStack(spacing: GridPulseSpacing.md) {
            ProgressView()
                .tint(.gridAccent)
            Text("Loading race data...")
                .font(GridPulseTypography.caption)
                .foregroundStyle(.gridOnSurfaceSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, GridPulseSpacing.xl)
    }

    // MARK: - Next Race
    private var nextRaceSection: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: GridPulseSpacing.sm) {
                Label("NEXT RACE", systemImage: "flag.checkered")
                    .font(GridPulseTypography.caption)
                    .foregroundStyle(.gridAccent)

                if let race = viewModel.nextRace {
                    Text(race.name)
                        .font(GridPulseTypography.heroTitle)
                        .foregroundStyle(.gridOnSurface)

                    HStack {
                        Label(race.circuitId.replacingOccurrences(of: "_", with: " ").capitalized, systemImage: "mappin.and.ellipse")
                            .font(GridPulseTypography.caption)
                            .foregroundStyle(.gridOnSurfaceSecondary)

                        Spacer()

                        Text(race.date, style: .date)
                            .font(GridPulseTypography.mono)
                            .foregroundStyle(.gridRed)
                    }
                } else {
                    Text("No upcoming races")
                        .font(GridPulseTypography.sectionTitle)
                        .foregroundStyle(.gridOnSurfaceSecondary)
                }
            }
        }
    }

    // MARK: - Recent Results
    private var recentResultsSection: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: GridPulseSpacing.sm) {
                Label("LATEST RESULT", systemImage: "trophy")
                    .font(GridPulseTypography.caption)
                    .foregroundStyle(.gridAccent)

                if viewModel.recentResults.isEmpty {
                    Text("No results available")
                        .font(GridPulseTypography.caption)
                        .foregroundStyle(.gridOnSurfaceSecondary)
                } else {
                    ForEach(Array(viewModel.recentResults.prefix(3))) { result in
                        HStack {
                            PositionChip(position: result.position, style: .circle)
                            Text(result.driverId.replacingOccurrences(of: "_", with: " "))
                                .font(GridPulseTypography.body)
                                .foregroundStyle(.gridOnSurface)
                            Spacer()
                            Text(result.time)
                                .font(GridPulseTypography.mono)
                                .foregroundStyle(.gridOnSurfaceSecondary)
                        }
                    }
                }
            }
        }
    }

    // MARK: - Standings Snapshot
    private var standingsSnapshotSection: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: GridPulseSpacing.sm) {
                Label("DRIVERS STANDINGS", systemImage: "chart.bar")
                    .font(GridPulseTypography.caption)
                    .foregroundStyle(.gridAccent)

                if viewModel.topDrivers.isEmpty {
                    Text("No standings available")
                        .font(GridPulseTypography.caption)
                        .foregroundStyle(.gridOnSurfaceSecondary)
                } else {
                    ForEach(Array(viewModel.topDrivers.prefix(5))) { standing in
                        HStack {
                            PositionChip(position: standing.position, style: .circle)
                            Text(standing.driverId.replacingOccurrences(of: "_", with: " "))
                                .font(GridPulseTypography.body)
                                .foregroundStyle(.gridOnSurface)
                            Spacer()
                            Text("\(standing.points, specifier: "%.0f") pts")
                                .font(GridPulseTypography.mono)
                                .foregroundStyle(.gridOnSurfaceSecondary)
                        }
                    }
                }
            }
        }
    }

    // MARK: - Computed
    private var standingsSnapshot: some View {
        standingsSnapshotSection
    }
}

// MARK: - Preview
#Preview {
    HomeView()
        .modelContainer(for: [Driver.self, Constructor.self, Race.self, CacheEntry.self])
}