import SwiftUI

extension Color {
    // MARK: - 2026 Team Colors
    static let redBull = Color(hex: "3671C6")
    static let ferrari = Color(hex: "E8002D")
    static let mercedes = Color(hex: "27F4D2")
    static let mclaren = Color(hex: "FF8000")
    static let astonMartin = Color(hex: "229971")
    static let alpine = Color(hex: "FF87BC")
    static let williams = Color(hex: "64C4FF")
    static let haas = Color(hex: "B6BABD")
    static let rb = Color(hex: "6692FF")
    static let sauber = Color(hex: "52E252")

    // MARK: - Hex Init
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

    // MARK: - Team Color Lookup
    static func teamColor(for constructorId: String) -> Color {
        switch constructorId.lowercased() {
        case "red_bull", "redbull": return .redBull
        case "ferrari": return .ferrari
        case "mercedes": return .mercedes
        case "mclaren": return .mclaren
        case "aston_martin", "astonmartin": return .astonMartin
        case "alpine": return .alpine
        case "williams": return .williams
        case "haas": return .haas
        case "rb", "visa_cash_app_rb": return .rb
        case "sauber", "kick_sauber": return .sauber
        default: return Color(hex: "666666")
        }
    }
}