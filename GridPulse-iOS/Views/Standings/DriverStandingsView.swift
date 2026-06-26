import SwiftUI
import SwiftData

struct DriverStandingsView: View {
    @State private var viewModel = StandingsViewModel()

    var body: some View {
        List {
            if viewModel.isLoading && viewModel.driverStandings.isEmpty {
                ProgressView()
                    .tint(.gridAccent)
            } else {
                ForEach(viewModel.driverStandings) { standing in
                    NavigationLink(value: standing) {
                        driverRow(standing: standing)
                    }
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .task {
            await viewModel.loadData()
        }
    }

    private func driverRow(standing: DriverStanding) -> some View {
        HStack(spacing: GridPulseSpacing.sm) {
            PositionChip(position: standing.position, style: .circle)

            TeamColorBadge(
                constructorId: standing.constructorId,
                driverCode: standing.driverId,
                size: 32
            )

            VStack(alignment: .leading, spacing: 2) {
                Text(standing.driverId.replacingOccurrences(of: "_", with: " "))
                    .font(GridPulseTypography.body)
                    .foregroundStyle(.gridOnSurface)

                Text(standing.constructorId.replacingOccurrences(of: "_", with: " ").capitalized)
                    .font(GridPulseTypography.caption)
                    .foregroundStyle(.gridOnSurfaceSecondary)
            }

            Spacer()

            VStack(alignment: .trailing) {
                Text("\(standing.points, specifier: "%.0f")")
                    .font(GridPulseTypography.mono)
                    .foregroundStyle(.gridOnSurface)

                if standing.wins > 0 {
                    Text("\(standing.wins) win\(standing.wins > 1 ? "s" : "")")
                        .font(GridPulseTypography.caption)
                        .foregroundStyle(.gridWarning)
                }
            }
        }
        .padding(.vertical, GridPulseSpacing.xs)
    }
}

#Preview {
    DriverStandingsView()
        .modelContainer(for: [Driver.self, CacheEntry.self])
}