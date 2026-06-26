import SwiftUI

struct TeamColorBadge: View {
    let constructorId: String
    let driverCode: String
    let driverNumber: Int
    let size: CGFloat

    init(
        constructorId: String,
        driverCode: String,
        driverNumber: Int = 0,
        size: CGFloat = 36
    ) {
        self.constructorId = constructorId
        self.driverCode = driverCode
        self.driverNumber = driverNumber
        self.size = size
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.teamColor(for: constructorId))
                .frame(width: size, height: size)

            #if compiler(>=6.2)
            Circle()
                .glassEffect(in: .circle)
                .frame(width: size, height: size)
            #endif

            Text(driverNumber > 0 ? "\(driverNumber)" : driverCode)
                .font(.system(size: size * 0.4, weight: .bold, design: .monospaced))
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.3), radius: 1)
        }
    }
}

// MARK: - Preview
#Preview {
    HStack(spacing: GridPulseSpacing.sm) {
        TeamColorBadge(constructorId: "red_bull", driverCode: "VER", driverNumber: 1)
        TeamColorBadge(constructorId: "ferrari", driverCode: "HAM", driverNumber: 44)
        TeamColorBadge(constructorId: "mclaren", driverCode: "NOR", driverNumber: 4)
        TeamColorBadge(constructorId: "mercedes", driverCode: "RUS", driverNumber: 63)
    }
    .padding()
}