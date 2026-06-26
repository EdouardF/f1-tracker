import SwiftUI

enum Team: String, CaseIterable, Sendable {
    case redBull = "red_bull"
    case ferrari = "ferrari"
    case mercedes = "mercedes"
    case mclaren = "mclaren"
    case astonMartin = "aston_martin"
    case alpine = "alpine"
    case williams = "williams"
    case rb = "rb"
    case sauber = "sauber"
    case haas = "haas"

    var primaryColor: Color {
        switch self {
        case .redBull: return Color(hex: "3671C6")
        case .ferrari: return Color(hex: "E8002D")
        case .mercedes: return Color(hex: "27F4D2")
        case .mclaren: return Color(hex: "FF8000")
        case .astonMartin: return Color(hex: "229971")
        case .alpine: return Color(hex: "FF87BC")
        case .williams: return Color(hex: "64C4FF")
        case .rb: return Color(hex: "6692FF")
        case .sauber: return Color(hex: "52E252")
        case .haas: return Color(hex: "B6BABD")
        }
    }

    var secondaryColor: Color {
        switch self {
        case .redBull: return Color(hex: "FFD700")
        case .ferrari: return Color(hex: "FFE100")
        case .mercedes: return Color(hex: "000000")
        case .mclaren: return Color(hex: "0057B8")
        case .astonMartin: return Color(hex: "006F62")
        case .alpine: return Color(hex: "0090FF")
        case .williams: return Color(hex: "005AFF")
        case .rb: return Color(hex: "FFFFFF")
        case .sauber: return Color(hex: "000000")
        case .haas: return Color(hex: "000000")
        }
    }

    var name: String {
        switch self {
        case .redBull: return "Red Bull"
        case .ferrari: return "Ferrari"
        case .mercedes: return "Mercedes"
        case .mclaren: return "McLaren"
        case .astonMartin: return "Aston Martin"
        case .alpine: return "Alpine"
        case .williams: return "Williams"
        case .rb: return "RB Racing"
        case .sauber: return "Sauber"
        case .haas: return "Haas"
        }
    }

    var fullName: String {
        switch self {
        case .redBull: return "Red Bull Racing"
        case .ferrari: return "Scuderia Ferrari"
        case .mercedes: return "Mercedes-AMG Petronas"
        case .mclaren: return "McLaren F1 Team"
        case .astonMartin: return "Aston Martin Aramco"
        case .alpine: return "Alpine F1 Team"
        case .williams: return "Williams Racing"
        case .rb: return "RB F1 Team"
        case .sauber: return "Sauber Motorsport"
        case .haas: return "Haas F1 Team"
        }
    }

    var base: String {
        return rawValue
    }

    var gradient: Gradient {
        return Gradient(colors: [primaryColor, secondaryColor])
    }

    static func badgeColor(for team: Team) -> Color {
        return team.primaryColor
    }
}

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let cleaned = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .uppercased()
        let scanner = Scanner(string: cleaned)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b)
    }

    static func teamColor(for constructorId: String) -> Color {
        Team(rawValue: constructorId)?.primaryColor ?? Color.gray.opacity(0.3)
    }
}