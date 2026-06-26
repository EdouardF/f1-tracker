import SwiftUI

/// Position chip — P1 gold, P2 silver, P3 bronze, rest neutral
struct PositionChip: View {
    let position: Int
    let size: CGFloat

    init(position: Int, size: CGFloat = 36) {
        self.position = position
        self.size = size
    }

    private var backgroundColor: Color {
        switch position {
        case 1: return Color(hex: "FFD700") // Gold
        case 2: return Color(hex: "C0C0C0") // Silver
        case 3: return Color(hex: "CD7F32") // Bronze
        default: return Color.white.opacity(0.15)
        }
    }

    private var textColor: Color {
        switch position {
        case 1, 2, 3: return .black
        default: return .white
        }
    }

    var body: some View {
        Text("P\(position)")
            .font(.system(size: size * 0.4, weight: .heavy, design: .rounded))
            .foregroundStyle(textColor)
            .frame(width: size, height: size)
            .background(
                Circle()
                    .fill(backgroundColor)
            )
    }
}

// MARK: - Compact Position Label
struct PositionLabel: View {
    let position: Int

    var body: some View {
        HStack(spacing: 4) {
            PositionChip(position: position, size: 24)
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 8) {
        PositionChip(position: 1)
        PositionChip(position: 2)
        PositionChip(position: 3)
        PositionChip(position: 4)
        PositionChip(position: 10)
        PositionChip(position: 20)
    }
    .padding()
    .background(Color.black)
}