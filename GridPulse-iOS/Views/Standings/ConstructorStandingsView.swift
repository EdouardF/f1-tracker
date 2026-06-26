import SwiftUI
import SwiftData

struct ConstructorStandingsView: View {
    @State private var viewModel = StandingsViewModel()

    var body: some View {
        List {
            if viewModel.isLoading && viewModel.constructorStandings.isEmpty {
                ProgressView()
                    .tint(.gridAccent)
            } else {
                ForEach(viewModel.constructorStandings) { standing in
                    constructorRow(standing: standing)
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .task {
            await viewModel.loadData()
        }
    }

    private func constructorRow(standing: ConstructorStanding) -> some View {
        HStack(spacing: GridPulseSpacing.sm) {
            PositionChip(position: standing.position, style: .circle)

            Circle()
                .fill(Color.teamColor(for: standing.constructorId))
                .frame(width: 24, height: 24)

            Text(standing.constructorId.replacingOccurrences(of: "_", with: " ").capitalized)
                .font(GridPulseTypography.body)
                .foregroundStyle(.gridOnSurface)

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
    ConstructorStandingsView()
        .modelContainer(for: [Constructor.self, CacheEntry.self])
}