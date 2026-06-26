import SwiftUI

struct ScheduleView: View {
    @State private var viewModel = ScheduleViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.races.isEmpty {
                    ProgressView("Loading schedule...")
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
                            Task { await viewModel.loadSchedule() }
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(GridPulseTheme.accent)
                    }
                } else {
                    raceList
                }
            }
            .background(GridPulseTheme.background)
            .navigationTitle("Schedule")
            .task {
                await viewModel.loadSchedule()
            }
            .refreshable {
                await viewModel.loadSchedule()
            }
        }
    }

    // MARK: - Race List

    private var raceList: some View {
        List(viewModel.races, id: \.id) { race in
            NavigationLink(value: race) {
                raceRow(race: race)
            }
            .listRowBackground(Color.clear)
            .listRowSeparatorTint(Color.white.opacity(0.1))
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .navigationDestination(for: Race.self) { race in
            RaceDetailView(race: race)
        }
    }

    // MARK: - Race Row

    private func raceRow(race: Race) -> some View {
        HStack(spacing: 12) {
            // Round number
            Text("\(race.round)")
                .font(.system(size: 20, weight: .heavy, design: .rounded))
                .foregroundStyle(race.isUpcoming ? GridPulseTheme.accent : GridPulseTheme.mutedText)
                .frame(width: 36)

            VStack(alignment: .leading, spacing: 2) {
                Text(race.name)
                    .font(GridPulseTheme.cardTitle)
                    .foregroundStyle(.white)

                Text(race.circuitId.replacingOccurrences(of: "_", with: " ").capitalized)
                    .font(GridPulseTheme.caption)
                    .foregroundStyle(GridPulseTheme.mutedText)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text(race.date, style: .date)
                    .font(GridPulseTheme.caption)
                    .foregroundStyle(GridPulseTheme.mutedText)

                if race.isUpcoming {
                    Text("UPCOMING")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(GridPulseTheme.accent)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Preview
#Preview {
    ScheduleView()
        .preferredColorScheme(.dark)
}