import SwiftUI

struct HomeView: View {
    @State private var viewModel = HomeViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: GridPulseTheme.paddingMedium) {
                    // MARK: - Next Race Countdown
                    nextRaceSection

                    // MARK: - Standings Snapshot
                    standingsSection

                    // MARK: - Recent Results
                    recentResultsSection
                }
                .padding(.horizontal, GridPulseTheme.paddingMedium)
            }
            .background(GridPulseTheme.background)
            .navigationTitle("GridPulse")
        }
        .task {
            await viewModel.loadAll()
        }
        .refreshable {
            await viewModel.loadAll()
        }
    }

    // MARK: - Next Race

    @ViewBuilder
    private var nextRaceSection: some View {
        if let race = viewModel.nextRace {
            GlassCard {
                VStack(alignment: .leading, spacing: GridPulseTheme.paddingSmall) {
                    Text("NEXT RACE")
                        .font(GridPulseTheme.caption)
                        .foregroundStyle(GridPulseTheme.accent)

                    Text(race.name)
                        .font(GridPulseTheme.heroTitle)
                        .foregroundStyle(.white)

                    Text(race.circuitId.replacingOccurrences(of: "_", with: " ").capitalized)
                        .font(GridPulseTheme.body)
                        .foregroundStyle(GridPulseTheme.mutedText)

                    Text(viewModel.countdownString)
                        .font(.system(size: 48, weight: .heavy, design: .monospaced))
                        .foregroundStyle(.white)
                }
            }
        } else if viewModel.isLoading {
            GlassCard {
                ProgressView()
                    .frame(maxWidth: .infinity)
            }
        } else {
            GlassCard {
                Text("No upcoming race")
                    .foregroundStyle(GridPulseTheme.mutedText)
                    .frame(maxWidth: .infinity)
            }
        }
    }

    // MARK: - Standings Snapshot

    private var standingsSection: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: GridPulseTheme.paddingSmall) {
                Text("DRIVERS STANDINGS")
                    .font(GridPulseTheme.caption)
                    .foregroundStyle(GridPulseTheme.accent)

                ForEach(viewModel.driverStandings.prefix(5)) { standing in
                    HStack {
                        PositionChip(position: standing.position, size: 28)
                        Text(standing.driverId.replacingOccurrences(of: "_", with: " ").capitalized)
                            .font(GridPulseTheme.body)
                            .foregroundStyle(.white)
                        Spacer()
                        Text("\(Int(standing.points)) pts")
                            .font(GridPulseTheme.mono)
                            .foregroundStyle(GridPulseTheme.mutedText)
                    }
                }

                NavigationLink {
                    DriverStandingsView()
                } label: {
                    Text("View Full Standings")
                        .font(GridPulseTheme.caption)
                        .foregroundStyle(GridPulseTheme.accent)
                }
            }
        }
    }

    // MARK: - Recent Results

    private var recentResultsSection: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: GridPulseTheme.paddingSmall) {
                Text("RECENT RESULTS")
                    .font(GridPulseTheme.caption)
                    .foregroundStyle(GridPulseTheme.accent)

                if viewModel.recentResults.isEmpty {
                    Text("No recent results")
                        .font(GridPulseTheme.body)
                        .foregroundStyle(GridPulseTheme.mutedText)
                } else {
                    ForEach(viewModel.recentResults.prefix(5)) { result in
                        HStack {
                            PositionChip(position: result.position, size: 28)
                            Text(result.driverId.replacingOccurrences(of: "_", with: " ").capitalized)
                                .font(GridPulseTheme.body)
                                .foregroundStyle(.white)
                            Spacer()
                            Text(result.time ?? "—")
                                .font(GridPulseTheme.mono)
                                .foregroundStyle(GridPulseTheme.mutedText)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    HomeView()
        .preferredColorScheme(.dark)
}