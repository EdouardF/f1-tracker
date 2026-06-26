import SwiftUI
import SwiftData

struct StandingsTabView: View {
    @State private var viewModel = StandingsViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Segmented Control
                Picker("Standings", selection: $viewModel.selectedTab) {
                    ForEach(StandingsViewModel.StandingsTab.allCases, id: \.self) { tab in
                        Text(tab.rawValue).tag(tab)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.top, GridPulseSpacing.sm)

                // Content
                Group {
                    switch viewModel.selectedTab {
                    case .drivers:
                        driverStandingsList
                    case .constructors:
                        constructorStandingsList
                    }
                }
                .background(Color.gridBackground)
            }
            .navigationTitle("Standings")
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

    // MARK: - Driver Standings
    private var driverStandingsList: some View {
        List {
            if viewModel.isLoading && viewModel.driverStandings.isEmpty {
                ProgressView()
                    .tint(.gridAccent)
            } else {
                ForEach(viewModel.driverStandings) { standing in
                    HStack(spacing: GridPulseSpacing.sm) {
                        PositionChip(position: standing.position, style: .circle)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(standing.driverId.replacingOccurrences(of: "_", with: " "))
                                .font(GridPulseTypography.body)
                                .foregroundStyle(.gridOnSurface)

                            Text(standing.constructorId.replacingOccurrences(of: "_", with: " ").capitalized)
                                .font(GridPulseTypography.caption)
                                .foregroundStyle(.gridOnSurfaceSecondary)
                        }

                        Spacer()

                        Text("\(standing.points, specifier: "%.0f")")
                            .font(GridPulseTypography.mono)
                            .foregroundStyle(.gridOnSurface)
                        + Text(" pts")
                            .font(GridPulseTypography.caption)
                            .foregroundStyle(.gridOnSurfaceSecondary)

                        if standing.wins > 0 {
                            Text("W\(standing.wins)")
                                .font(GridPulseTypography.caption)
                                .foregroundStyle(.gridWarning)
                        }
                    }
                    .padding(.vertical, GridPulseSpacing.xs)
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }

    // MARK: - Constructor Standings
    private var constructorStandingsList: some View {
        List {
            if viewModel.isLoading && viewModel.constructorStandings.isEmpty {
                ProgressView()
                    .tint(.gridAccent)
            } else {
                ForEach(viewModel.constructorStandings) { standing in
                    HStack(spacing: GridPulseSpacing.sm) {
                        PositionChip(position: standing.position, style: .circle)

                        Text(standing.constructorId.replacingOccurrences(of: "_", with: " ").capitalized)
                            .font(GridPulseTypography.body)
                            .foregroundStyle(.gridOnSurface)

                        Spacer()

                        Text("\(standing.points, specifier: "%.0f")")
                            .font(GridPulseTypography.mono)
                            .foregroundStyle(.gridOnSurface)
                        + Text(" pts")
                            .font(GridPulseTypography.caption)
                            .foregroundStyle(.gridOnSurfaceSecondary)

                        if standing.wins > 0 {
                            Text("W\(standing.wins)")
                                .font(GridPulseTypography.caption)
                                .foregroundStyle(.gridWarning)
                        }
                    }
                    .padding(.vertical, GridPulseSpacing.xs)
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
}

// MARK: - Preview
#Preview {
    StandingsTabView()
        .modelContainer(for: [Driver.self, Constructor.self, CacheEntry.self])
}