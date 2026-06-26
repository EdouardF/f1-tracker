import SwiftUI
import SwiftData

struct DriverDetailView: View {
    let driver: DriverStanding
    @State private var selectedSeason = 2026

    var body: some View {
        ScrollView {
            VStack(spacing: GridPulseSpacing.md) {
                driverHeader
                statsGrid
                recentResults
            }
            .padding()
        }
        .background(Color.gridBackground)
        .navigationTitle(driverCode)
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Driver Code
    private var driverCode: String {
        let parts = driver.driverId.split(separator: "_")
        if parts.count >= 2 {
            return String(parts[1]).prefix(3).uppercased()
        }
        return driver.driverId.prefix(3).uppercased()
    }

    // MARK: - Header
    private var driverHeader: some View {
        GlassCard {
            HStack(spacing: GridPulseSpacing.md) {
                TeamColorBadge(
                    constructorId: driver.constructorId,
                    driverCode: driverCode,
                    size: 64
                )

                VStack(alignment: .leading, spacing: GridPulseSpacing.xs) {
                    Text(driver.driverId.replacingOccurrences(of: "_", with: " "))
                        .font(GridPulseTypography.heroTitle)
                        .foregroundStyle(.gridOnSurface)

                    Text(driver.constructorId.replacingOccurrences(of: "_", with: " ").capitalized)
                        .font(GridPulseTypography.caption)
                        .foregroundStyle(.gridOnSurfaceSecondary)
                }

                Spacer()

                PositionChip(position: driver.position, style: .circle)
            }
        }
    }

    // MARK: - Stats Grid
    private var statsGrid: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: GridPulseSpacing.sm) {
                Label("SEASON STATS", systemImage: "chart.bar")
                    .font(GridPulseTypography.caption)
                    .foregroundStyle(.gridAccent)

                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: GridPulseSpacing.md) {
                    statItem(value: String(format: "%.0f", driver.points), label: "Points")
                    statItem(value: "\(driver.wins)", label: "Wins")
                    statItem(value: "P\(driver.position)", label: "Position")
                }
            }
        }
    }

    private func statItem(value: String, label: String) -> some View {
        VStack(spacing: GridPulseSpacing.xs) {
            Text(value)
                .font(GridPulseTypography.heroTitle)
                .foregroundStyle(.gridOnSurface)
            Text(label)
                .font(GridPulseTypography.caption)
                .foregroundStyle(.gridOnSurfaceSecondary)
        }
    }

    // MARK: - Recent Results
    private var recentResults: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: GridPulseSpacing.sm) {
                Label("RECENT RESULTS", systemImage: "flag.checkered")
                    .font(GridPulseTypography.caption)
                    .foregroundStyle(.gridAccent)

                Text("Results will appear here during the season")
                    .font(GridPulseTypography.caption)
                    .foregroundStyle(.gridOnSurfaceSecondary)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        DriverDetailView(driver: DriverStanding(
            id: "verstappen",
            driverId: "max_verstappen",
            position: 1,
            points: 25,
            wins: 1,
            constructorId: "red_bull"
        ))
    }
    .modelContainer(for: [Driver.self, CacheEntry.self])
}