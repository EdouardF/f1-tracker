import SwiftUI

/// Badge showing driver code with team color stripe
struct TeamColorBadge: View {
    let driverCode: String
    let teamColor: Color
    let fontSize: CGFloat

    init(
        driverCode: String,
        teamColor: Color,
        fontSize: CGFloat = 14
    ) {
        self.driverCode = driverCode
        self.teamColor = teamColor
        self.fontSize = fontSize
    }

    var body: some View {
        HStack(spacing: 6) {
            // Team color stripe
            RoundedRectangle(cornerRadius: 2)
                .fill(teamColor)
                .frame(width: 4, height: 20)

            // Driver code
            Text(driverCode)
                .font(.system(size: fontSize, weight: .bold, design: .monospaced))
                .foregroundStyle(.white)
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 12) {
        TeamColorBadge(driverCode: "VER", teamColor: .redBull)
        TeamColorBadge(driverCode: "HAM", teamColor: .ferrari)
        TeamColorBadge(driverCode: "NOR", teamColor: .mclaren)
        TeamColorBadge(driverCode: "LEC", teamColor: .ferrari)
        TeamColorBadge(driverCode: "ALO", teamColor: .astonMartin)
    }
    .padding()
    .background(Color.black)
}