import SwiftUI

struct ConstructorStandingsView: View {
    @State private var viewModel = StandingsViewModel()

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.constructorStandings.isEmpty {
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
                constructorsList
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

    // MARK: - Constructors List

    private var constructorsList: some View {
        List(viewModel.constructorStandings) { standing in
            constructorRow(standing: standing)
                .listRowBackground(Color.clear)
                .listRowSeparatorTint(Color.white.opacity(0.1))
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }

    // MARK: - Constructor Row

    private func constructorRow(standing: ConstructorStanding) -> some View {
        HStack(spacing: 12) {
            PositionChip(position: standing.position, size: 32)

            // Team color bar
            RoundedRectangle(cornerRadius: 3)
                .fill(Color.teamColor(for: standing.constructorId))
                .frame(width: 6, height: 40)

            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.constructorName(for: standing.constructorId))
                    .font(GridPulseTheme.cardTitle)
                    .foregroundStyle(.white)

                Text("\(standing.wins) wins")
                    .font(GridPulseTheme.caption)
                    .foregroundStyle(GridPulseTheme.mutedText)
            }

            Spacer()

            Text("\(Int(standing.points))")
                .font(.system(.title3, weight: .heavy, design: .rounded))
                .foregroundStyle(.white)

            Text("pts")
                .font(GridPulseTheme.caption)
                .foregroundStyle(GridPulseTheme.mutedText)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        ConstructorStandingsView()
    }
    .preferredColorScheme(.dark)
}