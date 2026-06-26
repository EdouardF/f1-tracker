import SwiftUI

// MARK: - Typography
enum GridPulseTypography {
    static let heroTitle = Font.system(size: 32, weight: .heavy, design: .default)
    static let sectionTitle = Font.system(size: 24, weight: .bold, design: .default)
    static let cardTitle = Font.system(size: 20, weight: .semibold, design: .default)
    static let body = Font.system(size: 16, weight: .regular, design: .default)
    static let caption = Font.system(size: 14, weight: .medium, design: .default)
    static let mono = Font.system(size: 14, weight: .regular, design: .monospaced)
}

// MARK: - Spacing
enum GridPulseSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
}

// MARK: - Animation
enum GridPulseAnimation {
    static let spring = Animation.spring(response: 0.35, dampingFraction: 0.75)
    static let easeInOut = Animation.easeInOut(duration: 0.3)
    static let gentleSpring = Animation.spring(response: 0.5, dampingFraction: 0.85)
}

// MARK: - App Colors
extension ShapeStyle where Self == Color {
    static var gridBackground: Color { Color(hex: "0A0A0A") }
    static var gridSurface: Color { Color(hex: "1C1C1E") }
    static var gridCard: Color { Color(hex: "2C2C2E") }
    static var gridSeparator: Color { Color(hex: "38383A") }
    static var gridRed: Color { Color(hex: "E10600") }
    static var gridBlue: Color { Color(hex: "3671C6") }
    static var gridAccent: Color { Color(hex: "3671C6") }
    static var gridOnSurface: Color { Color(hex: "FFFFFF") }
    static var gridOnSurfaceSecondary: Color { Color(hex: "8E8E93") }
    static var gridSuccess: Color { Color(hex: "34C759") }
    static var gridWarning: Color { Color(hex: "FF9500") }
    static var gridError: Color { Color(hex: "FF3B30") }
}

// MARK: - Glass Effect Modifier
extension View {
    @ViewBuilder
    func glassCard() -> some View {
        #if compiler(>=6.2)
        self.glassEffect(in: .rect(cornerRadius: GridPulseSpacing.md))
        #else
        self.background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: GridPulseSpacing.md))
        #endif
    }

    @ViewBuilder
    func glassCard(cornerRadius: CGFloat) -> some View {
        #if compiler(>=6.2)
        self.glassEffect(in: .rect(cornerRadius: cornerRadius))
        #else
        self.background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius))
        #endif
    }
}

// MARK: - Position Colors
enum PositionStyle {
    case gold, silver, bronze, standard

    var color: Color {
        switch self {
        case .gold: return Color(hex: "FFD700")
        case .silver: return Color(hex: "C0C0C0")
        case .bronze: return Color(hex: "CD7F32")
        case .standard: return Color(hex: "666666")
        }
    }

    static func forPosition(_ position: Int) -> PositionStyle {
        switch position {
        case 1: return .gold
        case 2: return .silver
        case 3: return .bronze
        default: return .standard
        }
    }
}