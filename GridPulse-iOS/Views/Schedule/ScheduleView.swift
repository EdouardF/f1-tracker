import SwiftUI
import SwiftData

struct ScheduleView: View {
    @State private var viewModel = ScheduleViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.races.isEmpty {
                    ProgressView("Loading schedule...")
                        .tint(.gridAccent)
                } else if viewModel.races.isEmpty {
                    ContentUnavailableView(
                        "No Races",
                        systemImage: "flag.checkered",
                        description: Text("Could not load the race calendar")
                    )
                } else {
                    raceList
                }
            }
            .background(Color.gridBackground)
            .navigationTitle("Schedule")
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

    // MARK: - Race List
    private var raceList: some View {
        List {
            ForEach(viewModel.racesByMonth, id: \.0) { month, races in
                Section(month) {
                    ForEach(races) { race in
                        NavigationLink(value: race) {
                            raceRow(race: race)
                        }
                    }
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .navigationDestination(for: Race.self) { race in
            RaceDetailView(race: race)
        }
    }

    // MARK: - Race Row
    private func raceRow(race: Race) -> some View {
        HStack(spacing: GridPulseSpacing.sm) {
            // Round number
            Text("R\(race.round)")
                .font(GridPulseTypography.mono)
                .foregroundStyle(.gridOnSurfaceSecondary)
                .frame(width: 36)

            VStack(alignment: .leading, spacing: GridPulseSpacing.xs) {
                Text(race.name)
                    .font(GridPulseTypography.cardTitle)
                    .foregroundStyle(.gridOnSurface)

                Text(race.circuitId.replacingOccurrences(of: "_", with: " ").capitalized)
                    .font(GridPulseTypography.caption)
                    .foregroundStyle(.gridOnSurfaceSecondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: GridPulseSpacing.xs) {
                Text(race.date, style: .date)
                    .font(GridPulseTypography.caption)
                    .foregroundStyle(.gridOnSurfaceSecondary)
            }
        }
        .padding(.vertical, GridPulseSpacing.xs)
    }
}

// MARK: - Preview
#Preview {
    ScheduleView()
        .modelContainer(for: [Race.self, CacheEntry.self])
}