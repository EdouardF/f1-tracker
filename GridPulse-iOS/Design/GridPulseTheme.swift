import SwiftUI

enum GridPulseTheme {
    // MARK: - Colors
    static let background = Color.black
    static let surface = Color(.systemGray6)
    static let onSurface = Color.white
    static let accent = Color(hex: "E10600") // F1 red
    static let onAccent = Color.white
    static let success = Color.green
    static let warning = Color.orange
    static let error = Color.red
    static let mutedText = Color(.systemGray2)
    static let cardBackground = Color.white.opacity(0.08)

    // MARK: - Typography
    static let heroTitle = Font.system(.largeTitle, weight: .heavy)
    static let sectionTitle = Font.system(.title2, weight: .bold)
    static let cardTitle = Font.system(.title3, weight: .semibold)
    static let body = Font.system(.body, weight: .regular)
    static let caption = Font.system(.caption, weight: .medium)
    static let mono = Font.system(.body, weight: .regular, design: .monospaced)

    // MARK: - Spacing
    static let paddingSmall: CGFloat = 8
    static let paddingMedium: CGFloat = 16
    static let paddingLarge: CGFloat = 24

    // MARK: - Corner Radius
    static let cornerRadiusSmall: CGFloat = 8
    static let cornerRadiusMedium: CGFloat = 12
    static let cornerRadiusLarge: CGFloat = 20

    // MARK: - Grid
    static let racePointPositions = 10
}

// MARK: - Color hex init (reuse from TeamColors)
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - View Modifiers
struct GlassBackground: ViewModifier {
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius))
    }
}

extension View {
    func glassBackground(cornerRadius: CGFloat = GridPulseTheme.cornerRadiusMedium) -> some View {
        modifier(GlassBackground(cornerRadius: cornerRadius))
    }

    func cardStyle() -> some View {
        self
            .padding(GridPulseTheme.paddingMedium)
            .glassBackground()
    }
}