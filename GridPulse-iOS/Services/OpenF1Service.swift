import Foundation
import SwiftData

// MARK: - Errors
enum OpenF1Error: LocalizedError {
    case invalidURL
    case networkError(Error)
    case invalidResponse(statusCode: Int)
    case decodingError(Error)
    case noData
    case rateLimited(retryAfter: Int?)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .networkError(let error): return "Network error: \(error.localizedDescription)"
        case .invalidResponse(let code): return "Invalid response (HTTP \(code))"
        case .decodingError(let error): return "Decoding error: \(error.localizedDescription)"
        case .noData: return "No data returned"
        case .rateLimited(let retryAfter): return "Rate limited\(retryAfter.map { ", retry after \($0)s" } ?? "")"
        }
    }
}

// MARK: - DTOs (OpenF1 API)
struct MeetingDTO: Decodable, Sendable {
    let meetingKey: Int
    let meetingName: String?
    let meetingOfficialName: String?
    let location: String?
    let countryName: String?
    let countryCode: String?
    let circuitShortName: String?
    let year: Int?
    let dateStart: String?

    enum CodingKeys: String, CodingKey {
        case meetingKey = "meeting_key"
        case meetingName = "meeting_name"
        case meetingOfficialName = "meeting_official_name"
        case location
        case countryName = "country_name"
        case countryCode = "country_code"
        case circuitShortName = "circuit_short_name"
        case year
        case dateStart = "date_start"
    }
}

struct SessionDTO: Decodable, Sendable {
    let sessionKey: Int
    let sessionName: String?
    let sessionType: String?
    let meetingKey: Int?
    let dateStart: String?
    let dateEnd: String?
    let gmtOffset: String?
    let year: Int?
    let countryName: String?
    let circuitShortName: String?
    let location: String?

    enum CodingKeys: String, CodingKey {
        case sessionKey = "session_key"
        case sessionName = "session_name"
        case sessionType = "session_type"
        case meetingKey = "meeting_key"
        case dateStart = "date_start"
        case dateEnd = "date_end"
        case gmtOffset = "gmt_offset"
        case year
        case countryName = "country_name"
        case circuitShortName = "circuit_short_name"
        case location
    }
}

struct OpenF1DriverDTO: Decodable, Sendable {
    let driverNumber: Int?
    let fullName: String?
    let firstName: String?
    let lastName: String?
    let nameAcronym: String?
    let teamName: String?
    let teamColour: String?
    let headshotUrl: String?
    let countryCode: String?
    let sessionKey: Int?

    enum CodingKeys: String, CodingKey {
        case driverNumber = "driver_number"
        case fullName = "full_name"
        case firstName = "first_name"
        case lastName = "last_name"
        case nameAcronym = "name_acronym"
        case teamName = "team_name"
        case teamColour = "team_colour"
        case headshotUrl = "headshot_url"
        case countryCode = "country_code"
        case sessionKey = "session_key"
    }
}

struct SessionResultDTO: Decodable, Sendable {
    let sessionKey: Int?
    let driverNumber: Int?
    let position: Int?
    let fullName: String?
    let nameAcronym: String?
    let teamName: String?
    let teamColour: String?
    let gapToLeader: String?
    let lapCount: Int?

    enum CodingKeys: String, CodingKey {
        case sessionKey = "session_key"
        case driverNumber = "driver_number"
        case position
        case fullName = "full_name"
        case nameAcronym = "name_acronym"
        case teamName = "team_name"
        case teamColour = "team_colour"
        case gapToLeader = "gap_to_leader"
        case lapCount = "lap_count"
    }
}

struct StartingGridDTO: Decodable, Sendable {
    let sessionKey: Int?
    let driverNumber: Int?
    let position: Int?
    let fullName: String?
    let nameAcronym: String?
    let teamName: String?
    let teamColour: String?
    let lapCount: Int?
    let gapToLeader: String?

    enum CodingKeys: String, CodingKey {
        case sessionKey = "session_key"
        case driverNumber = "driver_number"
        case position
        case fullName = "full_name"
        case nameAcronym = "name_acronym"
        case teamName = "team_name"
        case teamColour = "team_colour"
        case lapCount = "lap_count"
        case gapToLeader = "gap_to_leader"
    }
}

struct LapDTO: Decodable, Sendable {
    let sessionKey: Int?
    let driverNumber: Int?
    let lapNumber: Int?
    let lapDuration: Double?
    let durationSector1: Double?
    let durationSector2: Double?
    let durationSector3: Double?
    let isPitOutLap: Bool?
    let segmentsSector1: [Int?]?
    let segmentsSector2: [Int?]?
    let segmentsSector3: [Int?]?

    enum CodingKeys: String, CodingKey {
        case sessionKey = "session_key"
        case driverNumber = "driver_number"
        case lapNumber = "lap_number"
        case lapDuration = "lap_duration"
        case durationSector1 = "duration_sector_1"
        case durationSector2 = "duration_sector_2"
        case durationSector3 = "duration_sector_3"
        case isPitOutLap = "is_pit_out_lap"
        case segmentsSector1 = "segments_sector_1"
        case segmentsSector2 = "segments_sector_2"
        case segmentsSector3 = "segments_sector_3"
    }
}

struct PitDTO: Decodable, Sendable {
    let sessionKey: Int?
    let driverNumber: Int?
    let lapNumber: Int?
    let pitDuration: Double?

    enum CodingKeys: String, CodingKey {
        case sessionKey = "session_key"
        case driverNumber = "driver_number"
        case lapNumber = "lap_number"
        case pitDuration = "pit_duration"
    }
}

struct WeatherDTO: Decodable, Sendable {
    let sessionKey: Int?
    let date: String?
    let airTemp: Double?
    let humidity: Double?
    let pressure: Double?
    let rainfall: Int?
    let trackTemp: Double?
    let windDirection: Int?
    let windSpeed: Double?

    enum CodingKeys: String, CodingKey {
        case sessionKey = "session_key"
        case date
        case airTemp = "air_temp"
        case humidity
        case pressure
        case rainfall
        case trackTemp = "track_temp"
        case windDirection = "wind_direction"
        case windSpeed = "wind_speed"
    }
}

struct RaceControlDTO: Decodable, Sendable {
    let sessionKey: Int?
    let date: String?
    let category: String?
    let flag: String?
    let message: String?
    let scope: String?

    enum CodingKeys: String, CodingKey {
        case sessionKey = "session_key"
        case date
        case category
        case flag
        case message
        case scope
    }
}

struct ChampionshipDriverDTO: Decodable, Sendable {
    let driverNumber: Int?
    let fullName: String?
    let nameAcronym: String?
    let teamName: String?
    let teamColour: String?
    let position: Int?
    let points: Double?
    let wins: Int?

    enum CodingKeys: String, CodingKey {
        case driverNumber = "driver_number"
        case fullName = "full_name"
        case nameAcronym = "name_acronym"
        case teamName = "team_name"
        case teamColour = "team_colour"
        case position
        case points
        case wins
    }
}

struct ChampionshipTeamDTO: Decodable, Sendable {
    let teamName: String?
    let teamColour: String?
    let position: Int?
    let points: Double?
    let wins: Int?

    enum CodingKeys: String, CodingKey {
        case teamName = "team_name"
        case teamColour = "team_colour"
        case position
        case points
        case wins
    }
}

// MARK: - Service
final class OpenF1Service: @unchecked Sendable {
    static let shared = OpenF1Service()

    private let baseURL = "https://api.openf1.org/v1"
    private let session: URLSession

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        self.session = URLSession(configuration: config)
    }

    // MARK: - Generic Fetch
    private func fetch<T: Decodable>(path: String, queryItems: [URLQueryItem] = []) async throws -> [T] {
        var components = URLComponents(string: "\(baseURL)/\(path)")
        if !queryItems.isEmpty {
            components?.queryItems = queryItems
        }

        guard let url = components?.url else {
            throw OpenF1Error.invalidURL
        }

        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await self.session.data(from: url)
        } catch {
            throw OpenF1Error.networkError(error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw OpenF1Error.invalidResponse(statusCode: 0)
        }

        if httpResponse.statusCode == 429 {
            let retryAfter = httpResponse.value(forHTTPHeaderField: "Retry-After").flatMap { Int($0) }
            throw OpenF1Error.rateLimited(retryAfter: retryAfter)
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw OpenF1Error.invalidResponse(statusCode: httpResponse.statusCode)
        }

        do {
            return try JSONDecoder().decode([T].self, from: data)
        } catch {
            throw OpenF1Error.decodingError(error)
        }
    }

    // MARK: - Meetings
    func fetchMeetings(year: Int? = nil) async throws -> [Meeting] {
        var items: [URLQueryItem] = []
        if let year { items.append(URLQueryItem(name: "year", value: String(year))) }
        let dtos: [MeetingDTO] = try await fetch(path: "meetings", queryItems: items)
        return dtos.map { $0.toModel() }
    }

    // MARK: - Sessions
    func fetchSessions(meetingKey: Int? = nil) async throws -> [Session] {
        var items: [URLQueryItem] = []
        if let key = meetingKey { items.append(URLQueryItem(name: "meeting_key", value: String(key))) }
        let dtos: [SessionDTO] = try await fetch(path: "sessions", queryItems: items)
        return dtos.map { $0.toModel() }
    }

    // MARK: - Drivers
    func fetchDrivers(sessionKey: Int? = nil) async throws -> [DriverInfo] {
        var items: [URLQueryItem] = []
        if let key = sessionKey { items.append(URLQueryItem(name: "session_key", value: String(key))) }
        let dtos: [OpenF1DriverDTO] = try await fetch(path: "drivers", queryItems: items)
        return dtos.map { $0.toModel() }
    }

    // MARK: - Session Results
    func fetchSessionResults(sessionKey: Int) async throws -> [SessionResult] {
        let items = [URLQueryItem(name: "session_key", value: String(sessionKey))]
        let dtos: [SessionResultDTO] = try await fetch(path: "session_result", queryItems: items)
        return dtos.map { $0.toModel() }
    }

    // MARK: - Starting Grid
    func fetchStartingGrid(sessionKey: Int) async throws -> [GridPosition] {
        let items = [URLQueryItem(name: "session_key", value: String(sessionKey))]
        let dtos: [StartingGridDTO] = try await fetch(path: "starting_grid", queryItems: items)
        return dtos.map { $0.toModel() }
    }

    // MARK: - Championship
    func fetchChampionshipDrivers(sessionKey: Int? = nil) async throws -> [DriverStanding] {
        var items: [URLQueryItem] = []
        if let key = sessionKey { items.append(URLQueryItem(name: "session_key", value: String(key))) }
        let dtos: [ChampionshipDriverDTO] = try await fetch(path: "championship_drivers", queryItems: items)
        return dtos.map { $0.toModel() }
    }

    func fetchChampionshipTeams(sessionKey: Int? = nil) async throws -> [ConstructorStanding] {
        var items: [URLQueryItem] = []
        if let key = sessionKey { items.append(URLQueryItem(name: "session_key", value: String(key))) }
        let dtos: [ChampionshipTeamDTO] = try await fetch(path: "championship_teams", queryItems: items)
        return dtos.map { $0.toModel() }
    }

    // MARK: - Laps
    func fetchLaps(sessionKey: Int, driverNumber: Int? = nil) async throws -> [LapData] {
        var items = [URLQueryItem(name: "session_key", value: String(sessionKey))]
        if let driver = driverNumber { items.append(URLQueryItem(name: "driver_number", value: String(driver))) }
        let dtos: [LapDTO] = try await fetch(path: "laps", queryItems: items)
        return dtos.map { $0.toModel() }
    }

    // MARK: - Pit Stops
    func fetchPitStops(sessionKey: Int, driverNumber: Int? = nil) async throws -> [PitStop] {
        var items = [URLQueryItem(name: "session_key", value: String(sessionKey))]
        if let driver = driverNumber { items.append(URLQueryItem(name: "driver_number", value: String(driver))) }
        let dtos: [PitDTO] = try await fetch(path: "pit", queryItems: items)
        return dtos.map { $0.toModel() }
    }

    // MARK: - Weather
    func fetchWeather(sessionKey: Int) async throws -> [WeatherInfo] {
        let items = [URLQueryItem(name: "session_key", value: String(sessionKey))]
        let dtos: [WeatherDTO] = try await fetch(path: "weather", queryItems: items)
        return dtos.map { $0.toModel() }
    }

    // MARK: - Race Control
    func fetchRaceControl(sessionKey: Int) async throws -> [RaceControlMessage] {
        let items = [URLQueryItem(name: "session_key", value: String(sessionKey))]
        let dtos: [RaceControlDTO] = try await fetch(path: "race_control", queryItems: items)
        return dtos.map { $0.toModel() }
    }
}

// MARK: - Model Types
struct Meeting: Identifiable, Codable, Hashable, Sendable {
    let id: Int
    let name: String
    let officialName: String
    let location: String
    let countryName: String
    let countryCode: String
    let circuitShortName: String
    let year: Int
    let dateStart: Date?
}

struct DriverInfo: Identifiable, Codable, Hashable, Sendable {
    let id: String
    let driverNumber: Int
    let fullName: String
    let firstName: String
    let lastName: String
    let code: String
    let teamName: String
    let teamColor: String
    let headshotUrl: String?
    let countryCode: String
}

struct SessionResult: Identifiable, Codable, Hashable, Sendable {
    let id: String
    let sessionKey: Int
    let driverNumber: Int
    let position: Int
    let driverName: String
    let driverCode: String
    let teamName: String
    let teamColor: String
    let gapToLeader: String?
    let lapCount: Int?
}

struct GridPosition: Identifiable, Codable, Hashable, Sendable {
    let id: String
    let sessionKey: Int
    let driverNumber: Int
    let position: Int
    let driverName: String
    let driverCode: String
    let teamName: String
    let teamColor: String
}

struct PitStop: Identifiable, Codable, Hashable, Sendable {
    let id: String
    let sessionKey: Int
    let driverNumber: Int
    let lapNumber: Int
    let pitDuration: Double?
}

struct WeatherInfo: Identifiable, Codable, Hashable, Sendable {
    let id: String
    let sessionKey: Int
    let date: String
    let airTemp: Double?
    let humidity: Double?
    let pressure: Double?
    let rainfall: Bool
    let trackTemp: Double?
    let windDirection: Int?
    let windSpeed: Double?
}

struct RaceControlMessage: Identifiable, Codable, Hashable, Sendable {
    let id: String
    let sessionKey: Int
    let date: String
    let category: String?
    let flag: String?
    let message: String?
    let scope: String?
}

// MARK: - DTO Mapping
extension MeetingDTO {
    func toModel() -> Meeting {
        let df = ISO8601DateFormatter()
        df.formatOptions = [.withFullDate, .withTime, .withColonSeparatorInTimeZone]
        return Meeting(
            id: meetingKey,
            name: meetingName ?? "",
            officialName: meetingOfficialName ?? meetingName ?? "",
            location: location ?? "",
            countryName: countryName ?? "",
            countryCode: countryCode ?? "",
            circuitShortName: circuitShortName ?? "",
            year: year ?? 2026,
            dateStart: dateStart.flatMap { df.date(from: $0) }
        )
    }
}

extension SessionDTO {
    func toModel() -> Session {
        let df = ISO8601DateFormatter()
        df.formatOptions = [.withFullDate, .withTime, .withColonSeparatorInTimeZone]
        return Session(
            id: String(sessionKey),
            raceId: meetingKey.map { String($0) } ?? "",
            type: SessionType(rawValue: sessionType ?? "race") ?? .race,
            date: dateStart.flatMap { df.date(from: $0) } ?? Date(),
            duration: nil
        )
    }
}

extension OpenF1DriverDTO {
    func toModel() -> DriverInfo {
        DriverInfo(
            id: "\(driverNumber ?? 0)-\(sessionKey ?? 0)",
            driverNumber: driverNumber ?? 0,
            fullName: fullName ?? "",
            firstName: firstName ?? "",
            lastName: lastName ?? "",
            code: nameAcronym ?? "",
            teamName: teamName ?? "",
            teamColor: teamColour ?? "666666",
            headshotUrl: headshotUrl,
            countryCode: countryCode ?? ""
        )
    }
}

extension SessionResultDTO {
    func toModel() -> SessionResult {
        SessionResult(
            id: "\(sessionKey ?? 0)-\(driverNumber ?? 0)",
            sessionKey: sessionKey ?? 0,
            driverNumber: driverNumber ?? 0,
            position: position ?? 0,
            driverName: fullName ?? "",
            driverCode: nameAcronym ?? "",
            teamName: teamName ?? "",
            teamColor: teamColour ?? "666666",
            gapToLeader: gapToLeader,
            lapCount: lapCount
        )
    }
}

extension StartingGridDTO {
    func toModel() -> GridPosition {
        GridPosition(
            id: "\(sessionKey ?? 0)-\(driverNumber ?? 0)-grid",
            sessionKey: sessionKey ?? 0,
            driverNumber: driverNumber ?? 0,
            position: position ?? 0,
            driverName: fullName ?? "",
            driverCode: nameAcronym ?? "",
            teamName: teamName ?? "",
            teamColor: teamColour ?? "666666"
        )
    }
}

extension ChampionshipDriverDTO {
    func toModel() -> DriverStanding {
        DriverStanding(
            id: "\(driverNumber ?? 0)-champ",
            driverId: nameAcronym ?? "",
            position: position ?? 0,
            points: points ?? 0,
            wins: wins ?? 0,
            constructorId: teamName ?? ""
        )
    }
}

extension ChampionshipTeamDTO {
    func toModel() -> ConstructorStanding {
        ConstructorStanding(
            id: teamName ?? "",
            constructorId: teamName ?? "",
            position: position ?? 0,
            points: points ?? 0,
            wins: wins ?? 0
        )
    }
}

extension LapDTO {
    func toModel() -> LapData {
        LapData(
            id: "\(sessionKey ?? 0)-\(driverNumber ?? 0)-\(lapNumber ?? 0)",
            driverNumber: driverNumber ?? 0,
            lapNumber: lapNumber ?? 0,
            lapDuration: lapDuration,
            sector1: durationSector1,
            sector2: durationSector2,
            sector3: durationSector3,
            isPitOutLap: isPitOutLap ?? false
        )
    }
}

extension PitDTO {
    func toModel() -> PitStop {
        PitStop(
            id: "\(sessionKey ?? 0)-\(driverNumber ?? 0)-\(lapNumber ?? 0)-pit",
            sessionKey: sessionKey ?? 0,
            driverNumber: driverNumber ?? 0,
            lapNumber: lapNumber ?? 0,
            pitDuration: pitDuration
        )
    }
}

extension WeatherDTO {
    func toModel() -> WeatherInfo {
        WeatherInfo(
            id: "\(sessionKey ?? 0)-\(date ?? "")",
            sessionKey: sessionKey ?? 0,
            date: date ?? "",
            airTemp: airTemp,
            humidity: humidity,
            pressure: pressure,
            rainfall: (rainfall ?? 0) == 1,
            trackTemp: trackTemp,
            windDirection: windDirection,
            windSpeed: windSpeed
        )
    }
}

extension RaceControlDTO {
    func toModel() -> RaceControlMessage {
        RaceControlMessage(
            id: "\(sessionKey ?? 0)-\(date ?? "")-\(category ?? "")",
            sessionKey: sessionKey ?? 0,
            date: date ?? "",
            category: category,
            flag: flag,
            message: message,
            scope: scope
        )
    }
}