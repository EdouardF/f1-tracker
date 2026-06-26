import SwiftUI

struct GlassCard<Content: View>: View {
    let cornerRadius: CGFloat
    let padding: CGFloat
    @ViewBuilder let content: () -> Content

    init(
        cornerRadius: CGFloat = GridPulseSpacing.md,
        padding: CGFloat = GridPulseSpacing.md,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.content = content
    }

    var body: some View {
        content()
            .padding(padding)
            #if compiler(>=6.2)
            .glassEffect(in: .rect(cornerRadius: cornerRadius))
            #else
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius))
            #endif
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        Color.black.ignoresSafeArea()

        VStack(spacing: GridPulseSpacing.md) {
            GlassCard {
                VStack(alignment: .leading, spacing: GridPulseSpacing.xs) {
                    Text("Monaco Grand Prix")
                        .font(GridPulseTypography.sectionTitle)
                    Text("Round 8 • May 25, 2026")
                        .font(GridPulseTypography.caption)
                        .foregroundStyle(.gridOnSurfaceSecondary)
                }
            }

            GlassCard(cornerRadius: GridPulseSpacing.sm) {
                HStack {
                    Text("P1")
                        .font(GridPulseTypography.mono)
                        .foregroundStyle(PositionStyle.forPosition(1).color)
                    Text("VER")
                        .font(GridPulseTypography.body)
                }
            }
        }
        .padding()
    }
}