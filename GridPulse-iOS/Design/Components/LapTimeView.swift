import SwiftUI

struct LapTimeView: View {
    let lapDuration: Double?
    let sector1: Double?
    let sector2: Double?
    let sector3: Double?
    let showSectors: Bool
    let isFastest: Bool
    let isPersonalBest: Bool

    init(
        lapDuration: Double?,
        sector1: Double? = nil,
        sector2: Double? = nil,
        sector3: Double? = nil,
        showSectors: Bool = false,
        isFastest: Bool = false,
        isPersonalBest: Bool = false
    ) {
        self.lapDuration = lapDuration
        self.sector1 = sector1
        self.sector2 = sector2
        self.sector3 = sector3
        self.showSectors = showSectors
        self.isFastest = isFastest
        self.isPersonalBest = isPersonalBest
    }

    var body: some View {
        VStack(alignment: .leading, spacing: GridPulseSpacing.xs) {
            // Main lap time
            HStack(spacing: GridPulseSpacing.xs) {
                Text(formatTime(lapDuration))
                    .font(GridPulseTypography.mono)
                    .foregroundStyle(timeColor)

                if isFastest {
                    Image(systemName: "star.fill")
                        .font(.caption2)
                        .foregroundStyle(.gridSuccess)
                } else if isPersonalBest {
                    Image(systemName: "star")
                        .font(.caption2)
                        .foregroundStyle(.gridWarning)
                }
            }

            // Sectors
            if showSectors {
                HStack(spacing: GridPulseSpacing.sm) {
                    sectorView(value: sector1, label: "S1")
                    sectorView(value: sector2, label: "S2")
                    sectorView(value: sector3, label: "S3")
                }
                .font(.caption)
            }
        }
    }

    // MARK: - Sector
    private func sectorView(value: Double?, label: String) -> some View {
        VStack(spacing: 2) {
            Text(label)
                .foregroundStyle(.gridOnSurfaceSecondary)
            Text(formatTime(value))
                .font(GridPulseTypography.mono)
                .foregroundStyle(.gridOnSurface)
        }
    }

    // MARK: - Time Color
    private var timeColor: Color {
        if isFastest { return .gridSuccess }
        if isPersonalBest { return .gridWarning }
        return .gridOnSurface
    }

    // MARK: - Format Time
    private func formatTime(_ seconds: Double?) -> String {
        guard let seconds else { return "--:--.---" }
        let minutes = Int(seconds) / 60
        let secs = seconds.truncatingRemainder(dividingBy: 60)
        if minutes > 0 {
            return String(format: "%d:%06.3f", minutes, secs)
        }
        return String(format: "%.3f", seconds)
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: GridPulseSpacing.md) {
        LapTimeView(lapDuration: 78.432, isFastest: true)
        LapTimeView(lapDuration: 79.105, isPersonalBest: true)
        LapTimeView(lapDuration: 80.567)
        LapTimeView(lapDuration: 78.432, sector1: 26.123, sector2: 27.456, sector3: 24.853, showSectors: true, isFastest: true)
        LapTimeView(lapDuration: nil)
    }
    .padding()
}