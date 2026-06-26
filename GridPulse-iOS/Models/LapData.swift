import Foundation
import SwiftData

@Model
final class LapData {
    @Attribute(.unique) var id: String
    var driverNumber: Int
    var lapNumber: Int
    var lapDuration: Double?
    var sector1: Double?
    var sector2: Double?
    var sector3: Double?
    var isPitOutLap: Bool

    init(
        id: String,
        driverNumber: Int,
        lapNumber: Int,
        lapDuration: Double? = nil,
        sector1: Double? = nil,
        sector2: Double? = nil,
        sector3: Double? = nil,
        isPitOutLap: Bool = false
    ) {
        self.id = id
        self.driverNumber = driverNumber
        self.lapNumber = lapNumber
        self.lapDuration = lapDuration
        self.sector1 = sector1
        self.sector2 = sector2
        self.sector3 = sector3
        self.isPitOutLap = isPitOutLap
    }

    var formattedLapTime: String {
        guard let duration = lapDuration else { return "--:--.---" }
        return LapData.formatLapTime(duration)
    }

    static func formatLapTime(_ seconds: Double) -> String {
        let minutes = Int(seconds) / 60
        let remainingSeconds = seconds - Double(minutes * 60)
        if minutes > 0 {
            return String(format: "%d:%06.3f", minutes, remainingSeconds)
        } else {
            return String(format: "%.3f", remainingSeconds)
        }
    }
}

// MARK: - OpenF1 Lap DTO
struct OpenF1LapDTO: Codable, Identifiable {
    let driverNumber: Int
    let lapNumber: Int
    let lapDuration: Double?
    let durationSector1: Double?
    let durationSector2: Double?
    let durationSector3: Double?
    let isPitOutLap: Bool?
    let sessionKey: Int
    let date: String?

    var id: String { "\(sessionKey)-\(driverNumber)-\(lapNumber)" }

    enum CodingKeys: String, CodingKey {
        case driverNumber = "driver_number"
        case lapNumber = "lap_number"
        case lapDuration = "lap_duration"
        case durationSector1 = "duration_sector_1"
        case durationSector2 = "duration_sector_2"
        case durationSector3 = "duration_sector_3"
        case isPitOutLap = "is_pit_out_lap"
        case sessionKey = "session_key"
        case date
    }
}

extension LapData {
    convenience init(from dto: OpenF1LapDTO) {
        self.init(
            id: "\(dto.sessionKey)-\(dto.driverNumber)-\(dto.lapNumber)",
            driverNumber: dto.driverNumber,
            lapNumber: dto.lapNumber,
            lapDuration: dto.lapDuration,
            sector1: dto.durationSector1,
            sector2: dto.durationSector2,
            sector3: dto.durationSector3,
            isPitOutLap: dto.isPitOutLap ?? false
        )
    }
}