import SwiftUI

struct DriverStandingsView: View {
    @State private var viewModel = StandingsViewModel()

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.driverStandings.isEmpty {
                ProgressView("Loading standings...")
                    .foregroundStyle(.white)
            } else if let error = viewModel.errorMessage {
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundStyle(GridPulseTheme.warning)
                    Text(error)
                        .font(GridPulseTheme.body)
                        .foregroundStyle(GridPulseTheme.mutedText)
                    Button("Retry") {
                        Task { await viewModel.loadStandings() }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(GridPulseTheme.accent)
                }
            } else {
                standingsList
            }
        }
        .background(GridPulseTheme.background)
        .task {
            await viewModel.loadStandings()
        }
        .refreshable {
            await viewModel.loadStandings()
        }
    }

    // MARK: - Standings List

    private var standingsList: some View {
        List(viewModel.driverStandings) { standing in
            NavigationLink(value: standing) {
                driverRow(standing: standing)
            }
            .listRowBackground(Color.clear)
            .listRowSeparatorTint(Color.white.opacity(0.1))
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .navigationDestination(for: DriverStanding.self) { standing in
            DriverDetailView(standing: standing, viewModel: viewModel)
        }
    }

    // MARK: - Driver Row

    private func driverRow(standing: DriverStanding) -> some View {
        HStack(spacing: 12) {
            PositionChip(position: standing.position, size: 32)

            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.driverName(for: standing.driverId))
                    .font(GridPulseTheme.cardTitle)
                    .foregroundStyle(.white)

                Text(standing.constructorId.replacingOccurrences(of: "_", with: " ").capitalized)
                    .font(GridPulseTheme.caption)
                    .foregroundStyle(Color.teamColor(for: standing.constructorId))
            }

            Spacer()

            VStack(alignment: .trailing) {
                Text("\(Int(standing.points))")
                    .font(.system(.title3, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)

                Text("pts")
                    .font(GridPulseTheme.caption)
                    .foregroundStyle(GridPulseTheme.mutedText)
            }

            // Wins badge
            if standing.wins > 0 {
                Text("🏆 \(standing.wins)")
                    .font(GridPulseTheme.caption)
                    .foregroundStyle(GridPulseTheme.warning)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        DriverStandingsView()
    }
    .preferredColorScheme(.dark)
}