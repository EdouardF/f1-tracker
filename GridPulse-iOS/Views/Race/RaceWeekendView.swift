import SwiftUI

struct RaceWeekendView: View {
    let race: Race
    @State private var selectedSession: SessionType = .race

    var body: some View {
        ScrollView {
            VStack(spacing: GridPulseSpacing.md) {
                // Race Weekend Header
                raceWeekendHeader

                // Session Selector
                sessionPicker

                // Session Content
                sessionContent
            }
            .padding()
        }
        .background(Color.gridBackground)
        .navigationTitle(race.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Header
    private var raceWeekendHeader: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: GridPulseSpacing.sm) {
                Text(race.name)
                    .font(GridPulseTypography.heroTitle)
                    .foregroundStyle(.gridOnSurface)

                HStack {
                    Label(race.circuitId.replacingOccurrences(of: "_", with: " ").capitalized, systemImage: "mappin.and.ellipse")
                        .font(GridPulseTypography.caption)
                        .foregroundStyle(.gridOnSurfaceSecondary)

                    Spacer()

                    Text(race.date, style: .date)
                        .font(GridPulseTypography.caption)
                        .foregroundStyle(.gridOnSurfaceSecondary)
                }
            }
        }
    }

    // MARK: - Session Picker
    private var sessionPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: GridPulseSpacing.sm) {
                ForEach(SessionType.allCases, id: \.self) { session in
                    sessionPill(session: session)
                }
            }
        }
    }

    private func sessionPill(session: SessionType) -> some View {
        Button {
            withAnimation(GridPulseAnimation.spring) {
                selectedSession = session
            }
        } label: {
            Text(session.shortName)
                .font(GridPulseTypography.caption)
                .foregroundStyle(selectedSession == session ? .white : .gridOnSurfaceSecondary)
                .padding(.horizontal, GridPulseSpacing.sm)
                .padding(.vertical, GridPulseSpacing.xs)
                .background(
                    selectedSession == session
                        ? Color.gridAccent
                        : Color.gridCard
                )
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }

    // MARK: - Session Content
    private var sessionContent: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: GridPulseSpacing.sm) {
                Text(selectedSession.fullName)
                    .font(GridPulseTypography.sectionTitle)
                    .foregroundStyle(.gridOnSurface)

                Text("Session data will appear here")
                    .font(GridPulseTypography.caption)
                    .foregroundStyle(.gridOnSurfaceSecondary)
            }
        }
    }
}

// MARK: - SessionType Extension
extension SessionType {
    var shortName: String {
        switch self {
        case .fp1: return "FP1"
        case .fp2: return "FP2"
        case .fp3: return "FP3"
        case .qualifying: return "Q"
        case .sprint: return "Sprint"
        case .race: return "Race"
        }
    }

    var fullName: String {
        switch self {
        case .fp1: return "Free Practice 1"
        case .fp2: return "Free Practice 2"
        case .fp3: return "Free Practice 3"
        case .qualifying: return "Qualifying"
        case .sprint: return "Sprint Race"
        case .race: return "Grand Prix"
        }
    }

    static var allCases: [SessionType] {
        [.fp1, .fp2, .fp3, .qualifying, .sprint, .race]
    }
}

#Preview {
    NavigationStack {
        RaceWeekendView(race: Race(
            id: "2026-5",
            name: "Monaco Grand Prix",
            circuitId: "monaco",
            date: Date(),
            sessions: [],
            season: 2026,
            round: 5
        ))
    }
}