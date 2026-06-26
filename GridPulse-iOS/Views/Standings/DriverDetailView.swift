import SwiftUI
import SwiftData

struct DriverDetailView: View {
    let driverId: String
    let constructorId: String
    let driverCode: String
    let driverNumber: Int
    @State private var viewModel = StandingsViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: GridPulseSpacing.md) {
                // Driver Header
                driverHeader

                // Stats would go here (needs API data)
                statsPlaceholder
            }
            .padding()
        }
        .background(Color.gridBackground)
        .navigationTitle(driverCode)
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Header
    private var driverHeader: some View {
        GlassCard {
            HStack(spacing: GridPulseSpacing.md) {
                TeamColorBadge(
                    constructorId: constructorId,
                    driverCode: driverCode,
                    driverNumber: driverNumber,
                    size: 64
                )

                VStack(alignment: .leading, spacing: GridPulseSpacing.xs) {
                    Text(driverId.replacingOccurrences(of: "_", with: " "))
                        .font(GridPulseTypography.heroTitle)
                        .foregroundStyle(.gridOnSurface)

                    Text(constructorId.replacingOccurrences(of: "_", with: " ").capitalized)
                        .font(GridPulseTypography.caption)
                        .foregroundStyle(.gridOnSurfaceSecondary)
                }

                Spacer()

                Text("#\(driverNumber)")
                    .font(GridPulseTypography.heroTitle)
                    .foregroundStyle(Color.teamColor(for: constructorId))
            }
        }
    }

    // MARK: - Stats Placeholder
    private var statsPlaceholder: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: GridPulseSpacing.sm) {
                Label("SEASON STATS", systemImage: "chart.bar")
                    .font(GridPulseTypography.caption)
                    .foregroundStyle(.gridAccent)

                Text("Stats will be available once the 2026 season starts")
                    .font(GridPulseTypography.caption)
                    .foregroundStyle(.gridOnSurfaceSecondary)
            }
        }
    }
}

#Preview {
    NavigationStack {
        DriverDetailView(
            driverId: "max_verstappen",
            constructorId: "red_bull",
            driverCode: "VER",
            driverNumber: 1
        )
    }
    .modelContainer(for: [Driver.self, CacheEntry.self])
}