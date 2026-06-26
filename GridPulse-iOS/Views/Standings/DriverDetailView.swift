import SwiftUI

struct DriverDetailView: View {
    let standing: DriverStanding
    let viewModel: StandingsViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: GridPulseTheme.paddingMedium) {
                // MARK: - Driver Header
                GlassCard {
                    VStack(spacing: GridPulseTheme.paddingSmall) {
                        // Position badge
                        PositionChip(position: standing.position, size: 56)

                        Text(viewModel.driverName(for: standing.driverId))
                            .font(GridPulseTheme.heroTitle)
                            .foregroundStyle(.white)

                        Text(standing.constructorId.replacingOccurrences(of: "_", with: " ").capitalized)
                            .font(GridPulseTheme.sectionTitle)
                            .foregroundStyle(Color.teamColor(for: standing.constructorId))
                    }
                }

                // MARK: - Stats
                GlassCard {
                    VStack(spacing: GridPulseTheme.paddingMedium) {
                        StatRow(label: "Points", value: "\(Int(standing.points))")
                        StatRow(label: "Wins", value: "\(standing.wins)")
                        StatRow(label: "Position", value: "P\(standing.position)")
                    }
                }

                // MARK: - Team Color Badge
                GlassCard {
                    HStack {
                        Text("Team")
                            .font(GridPulseTheme.body)
                            .foregroundStyle(GridPulseTheme.mutedText)

                        Spacer()

                        TeamColorBadge(
                            driverCode: standing.driverId.prefix(3).uppercased(),
                            teamColor: Color.teamColor(for: standing.constructorId)
                        )
                    }
                }
            }
            .padding(.horizontal, GridPulseTheme.paddingMedium)
        }
        .background(GridPulseTheme.background)
        .navigationTitle(viewModel.driverName(for: standing.driverId))
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Stat Row
private struct StatRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(GridPulseTheme.body)
                .foregroundStyle(GridPulseTheme.mutedText)

            Spacer()

            Text(value)
                .font(.system(.body, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        DriverDetailView(
            standing: DriverStanding(
                id: "verstappen",
                driverId: "verstappen",
                position: 1,
                points: 25,
                wins: 1,
                constructorId: "red_bull"
            ),
            viewModel: StandingsViewModel()
        )
    }
    .preferredColorScheme(.dark)
}