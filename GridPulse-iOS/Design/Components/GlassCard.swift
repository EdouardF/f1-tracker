import SwiftUI

/// Glass card with Liquid Glass effect for iOS 26+
struct GlassCard<Content: View>: View {
    let content: Content
    let cornerRadius: CGFloat

    init(
        cornerRadius: CGFloat = GridPulseTheme.cornerRadiusMedium,
        @ViewBuilder content: () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.content = content()
    }

    var body: some View {
        content
            .padding(GridPulseTheme.paddingMedium)
            .background {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.ultraThinMaterial)
            }
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

// MARK: - Glass Effect Modifier
extension View {
    /// Applies Liquid Glass effect on iOS 26+, falls back to .ultraThinMaterial on older versions
    @ViewBuilder
    func glassEffect() -> some View {
        if #available(iOS 26, *) {
            self.glassEffect(in: .rect(cornerRadius: GridPulseTheme.cornerRadiusMedium))
        } else {
            self.background(
                RoundedRectangle(cornerRadius: GridPulseTheme.cornerRadiusMedium)
                    .fill(.ultraThinMaterial)
            )
        }
    }
}