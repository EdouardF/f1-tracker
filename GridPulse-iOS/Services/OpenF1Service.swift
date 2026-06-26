import Foundation

enum OpenF1Error: LocalizedError {
    case invalidURL
    case networkError(Error)
    case invalidResponse(statusCode: Int)
    case decodingError(Error)
    case noData

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .networkError(let error): return "Network error: \(error.localizedDescription)"
        case .invalidResponse(let code): return "Invalid response (HTTP \(code))"
        case .decodingError(let error): return "Decoding error: \(error.localizedDescription)"
        case .noData: return "No data returned"
        }
    }
}

actor OpenF1Service {
    static let shared = OpenF1Service()

    private let baseURL = "https://api.openf1.org/v1"
    private let session: URLSession

    private init(session: URLSession = .shared) {
        self.session = session
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

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw OpenF1Error.invalidResponse(statusCode: 0)
            }

            guard httpResponse.statusCode == 200 else {
                throw OpenF1Error.invalidResponse(statusCode: httpResponse.statusCode)
            }

            do {
                return try JSONDecoder().decode([T].self, from: data)
            } catch {
                throw OpenF1Error.decodingError(error)
            }
        } catch let error as OpenF1Error {
            throw error
        } catch {
            throw OpenF1Error.networkError(error)
        }
    }

    // MARK: - Meetings

    func fetchMeetings(year: Int = 2026) async throws -> [OpenF1MeetingDTO] {
        try await fetch(path: "meetings", queryItems: [
            URLQueryItem(name: "year", value: String(year))
        ])
    }

    // MARK: - Sessions

    func fetchSessions(meetingKey: Int) async throws -> [OpenF1SessionDTO] {
        try await fetch(path: "sessions", queryItems: [
            URLQueryItem(name: "meeting_key", value: String(meetingKey))
        ])
    }

    // MARK: - Drivers

    func fetchDrivers(sessionKey: Int) async throws -> [OpenF1DriverDTO] {
        try await fetch(path: "drivers", queryItems: [
            URLQueryItem(name: "session_key", value: String(sessionKey))
        ])
    }

    // MARK: - Session Results

    func fetchSessionResults(sessionKey: Int) async throws -> [OpenF1ResultDTO] {
        try await fetch(path: "session_result", queryItems: [
            URLQueryItem(name: "session_key", value: String(sessionKey))
        ])
    }

    // MARK: - Starting Grid

    func fetchStartingGrid(sessionKey: Int) async throws -> [OpenF1GridDTO] {
        try await fetch(path: "starting_grid", queryItems: [
            URLQueryItem(name: "session_key", value: String(sessionKey))
        ])
    }

    // MARK: - Championship Standings

    func fetchDriverStandings(sessionKey: Int) async throws -> [OpenF1ChampionshipDTO] {
        try await fetch(path: "championship_drivers", queryItems: [
            URLQueryItem(name: "session_key", value: String(sessionKey))
        ])
    }

    func fetchConstructorStandings(sessionKey: Int) async throws -> [OpenF1ChampionshipDTO] {
        try await fetch(path: "championship_teams", queryItems: [
            URLQueryItem(name: "session_key", value: String(sessionKey))
        ])
    }

    // MARK: - Lap Data

    func fetchLaps(sessionKey: Int, driverNumber: Int? = nil) async throws -> [OpenF1LapDTO] {
        var queryItems = [URLQueryItem(name: "session_key", value: String(sessionKey))]
        if let driver = driverNumber {
            queryItems.append(URLQueryItem(name: "driver_number", value: String(driver)))
        }
        return try await fetch(path: "laps", queryItems: queryItems)
    }

    // MARK: - Pit Stops

    func fetchPitStops(sessionKey: Int) async throws -> [OpenF1PitDTO] {
        try await fetch(path: "pit", queryItems: [
            URLQueryItem(name: "session_key", value: String(sessionKey))
        ])
    }

    // MARK: - Weather

    func fetchWeather(sessionKey: Int) async throws -> [OpenF1WeatherDTO] {
        try await fetch(path: "weather", queryItems: [
            URLQueryItem(name: "session_key", value: String(sessionKey))
        ])
    }

    // MARK: - Race Control Messages

    func fetchRaceControl(sessionKey: Int) async throws -> [OpenF1RaceControlDTO] {
        try await fetch(path: "race_control", queryItems: [
            URLQueryItem(name: "session_key", value: String(sessionKey))
        ])
    }

    // MARK: - Car Telemetry

    func fetchCarData(sessionKey: Int, driverNumber: Int) async throws -> [OpenF1CarDTO] {
        try await fetch(path: "car_data", queryItems: [
            URLQueryItem(name: "session_key", value: String(sessionKey)),
            URLQueryItem(name: "driver_number", value: String(driverNumber))
        ])
    }
}

// MARK: - OpenF1 DTOs

struct OpenF1MeetingDTO: Codable, Identifiable {
    let meetingKey: Int
    let meetingName: String
    let meetingOfficialName: String?
    let year: Int
    let location: String
    let countryKey: Int?
    let countryName: String?
    let circuitKey: Int?
    let circuitShortName: String?
    let dateStart: String?
    let gmtOffset: String?

    var id: Int { meetingKey }

    enum CodingKeys: String, CodingKey {
        case meetingKey = "meeting_key"
        case meetingName = "meeting_name"
        case meetingOfficialName = "meeting_official_name"
        case year, location
        case countryKey = "country_key"
        case countryName = "country_name"
        case circuitKey = "circuit_key"
        case circuitShortName = "circuit_short_name"
        case dateStart = "date_start"
        case gmtOffset = "gmt_offset"
    }
}

struct OpenF1ResultDTO: Codable, Identifiable {
    let driverNumber: Int
    let position: Int?
    let broadcastName: String?
    let fullName: String?
    let teamName: String?
    let teamColour: String?
    let gapToLeader: String?
    let laps: Int?
    let points: Double?
    let status: String?

    var id: String { "\(driverNumber)-\(position ?? 0)" }

    enum CodingKeys: String, CodingKey {
        case driverNumber = "driver_number"
        case position, broadcastName, fullName, teamName, teamColour
        case gapToLeader = "gap_to_leader"
        case laps, points, status
    }
}

struct OpenF1GridDTO: Codable, Identifiable {
    let driverNumber: Int
    let position: Int
    let broadcastName: String?

    var id: String { "\(driverNumber)-\(position)" }

    enum CodingKeys: String, CodingKey {
        case driverNumber = "driver_number"
        case position
        case broadcastName = "broadcast_name"
    }
}

struct OpenF1ChampionshipDTO: Codable, Identifiable {
    let driverNumber: Int?
    let position: Int?
    let points: Double?
    let teamName: String?

    var id: String { "\(driverNumber ?? 0)-\(position ?? 0)" }

    enum CodingKeys: String, CodingKey {
        case driverNumber = "driver_number"
        case position, points
        case teamName = "team_name"
    }
}

struct OpenF1PitDTO: Codable, Identifiable {
    let driverNumber: Int
    let lapNumber: Int
    let pitDuration: Double?
    let date: String?

    var id: String { "\(driverNumber)-\(lapNumber)" }

    enum CodingKeys: String, CodingKey {
        case driverNumber = "driver_number"
        case lapNumber = "lap_number"
        case pitDuration = "pit_duration"
        case date
    }
}

struct OpenF1WeatherDTO: Codable, Identifiable {
    let date: String
    let sessionKey: Int
    let airTemp: Double?
    let humidity: Double?
    let pressure: Double?
    let rainfall: Int?
    let trackTemp: Double?
    let windDirection: Int?
    let windSpeed: Double?

    var id: String { "\(sessionKey)-\(date)" }

    enum CodingKeys: String, CodingKey {
        case date, sessionKey
        case airTemp = "air_temp"
        case humidity, pressure, rainfall
        case trackTemp = "track_temp"
        case windDirection = "wind_direction"
        case windSpeed = "wind_speed"
    }
}

struct OpenF1RaceControlDTO: Codable, Identifiable {
    let date: String
    let category: String?
    let flag: String?
    let message: String?
    let scope: String?

    var id: String { "\(date)-\(category ?? "")" }
}

struct OpenF1CarDTO: Codable, Identifiable {
    let date: String
    let driverNumber: Int
    let rpm: Int?
    let speed: Int?
    let gear: Int?
    let throttle: Int?
    let brake: Int?
    let drs: Int?

    var id: String { "\(driverNumber)-\(date)" }

    enum CodingKeys: String, CodingKey {
        case date, driverNumber, rpm, speed, gear, throttle, brake, drs
    }
}