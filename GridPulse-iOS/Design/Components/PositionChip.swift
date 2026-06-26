import SwiftUI

struct PositionChip: View {
    let position: Int
    let style: PositionStyle.ChipStyle

    enum ChipStyle {
        case circle, pill, square
    }

    init(position: Int, style: PositionStyle.ChipStyle = .circle) {
        self.position = position
        self.style = style
    }

    private var positionColor: Color {
        PositionStyle.forPosition(position).color
    }

    var body: some View {
        switch style {
        case .circle:
            circleView
        case .pill:
            pillView
        case .square:
            squareView
        }
    }

    // MARK: - Circle
    private var circleView: some View {
        Text("\(position)")
            .font(.system(size: 14, weight: .bold, design: .monospaced))
            .foregroundStyle(.white)
            .frame(width: 28, height: 28)
            .background(positionColor)
            .clipShape(Circle())
            .shadow(color: positionColor.opacity(0.4), radius: 2, y: 1)
    }

    // MARK: - Pill
    private var pillView: some View {
        Text("P\(position)")
            .font(.system(size: 12, weight: .semibold, design: .monospaced))
            .foregroundStyle(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(positionColor)
            .clipShape(Capsule())
    }

    // MARK: - Square
    private var squareView: some View {
        Text("\(position)")
            .font(.system(size: 14, weight: .bold, design: .monospaced))
            .foregroundStyle(.white)
            .frame(width: 28, height: 28)
            .background(positionColor)
            .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: GridPulseSpacing.md) {
        HStack(spacing: GridPulseSpacing.sm) {
            PositionChip(position: 1, style: .circle)
            PositionChip(position: 2, style: .circle)
            PositionChip(position: 3, style: .circle)
            PositionChip(position: 4, style: .circle)
            PositionChip(position: 10, style: .circle)
        }

        HStack(spacing: GridPulseSpacing.sm) {
            PositionChip(position: 1, style: .pill)
            PositionChip(position: 2, style: .pill)
            PositionChip(position: 3, style: .pill)
        }

        HStack(spacing: GridPulseSpacing.sm) {
            PositionChip(position: 1, style: .square)
            PositionChip(position: 2, style: .square)
            PositionChip(position: 3, style: .square)
        }
    }
    .padding()
}