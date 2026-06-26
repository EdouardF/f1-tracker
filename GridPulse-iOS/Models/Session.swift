import Foundation
import SwiftData

enum SessionType: String, Codable, CaseIterable {
    case fp1 = "fp1"
    case fp2 = "fp2"
    case fp3 = "fp3"
    case qualifying = "qualifying"
    case sprint = "sprint"
    case race = "race"

    var displayName: String {
        switch self {
        case .fp1: return "Practice 1"
        case .fp2: return "Practice 2"
        case .fp3: return "Practice 3"
        case .qualifying: return "Qualifying"
        case .sprint: return "Sprint"
        case .race: return "Race"
        }
    }

    var shortName: String {
        switch self {
        case .fp1: return "FP1"
        case .fp2: return "FP2"
        case .fp3: return "FP3"
        case .qualifying: return "Q"
        case .sprint: return "Sprint"
        case .race: return "Race"
        }
    }

    var isRace: Bool { self == .race }
    var isQualifying: Bool { self == .qualifying }
    var isPractice: Bool { [.fp1, .fp2, .fp3].contains(self) }
}

@Model
final class Session {
    @Attribute(.unique) var id: String
    var raceId: String
    var type: SessionType
    var date: Date
    var duration: TimeInterval?

    init(
        id: String,
        raceId: String,
        type: SessionType,
        date: Date,
        duration: TimeInterval? = nil
    ) {
        self.id = id
        self.raceId = raceId
        self.type = type
        self.date = date
        self.duration = duration
    }
}

// MARK: - OpenF1 Session DTO
struct OpenF1SessionDTO: Codable, Identifiable {
    let sessionKey: Int
    let sessionName: String
    let sessionType: String
    let dateStart: String
    let dateEnd: String
    let year: Int?
    let countryName: String?
    let countryKey: Int?
    let circuitShortName: String?
    let meetingKey: Int?

    var id: String { String(sessionKey) }

    enum CodingKeys: String, CodingKey {
        case sessionKey = "session_key"
        case sessionName = "session_name"
        case sessionType = "session_type"
        case dateStart = "date_start"
        case dateEnd = "date_end"
        case year, countryName, countryKey, circuitShortName, meetingKey
    }
}

extension Session {
    convenience init(from dto: OpenF1SessionDTO) {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let parsedDate = formatter.date(from: dto.dateStart) ?? Date.distantPast

        let sessionType: SessionType
        switch dto.sessionType {
        case "practice_1", "FP1": sessionType = .fp1
        case "practice_2", "FP2": sessionType = .fp2
        case "practice_3", "FP3": sessionType = .fp3
        case "qualifying": sessionType = .qualifying
        case "sprint": sessionType = .sprint
        default: sessionType = .race
        }

        self.init(
            id: String(dto.sessionKey),
            raceId: String(dto.meetingKey ?? 0),
            type: sessionType,
            date: parsedDate
        )
    }
}