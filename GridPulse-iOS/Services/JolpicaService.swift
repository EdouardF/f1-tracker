import Foundation
import SwiftUI
import SwiftData

// MARK: - Errors
enum JolpicaError: LocalizedError {
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

// MARK: - DTOs (Jolpica API Response)
struct JolpicaResponse<T: Decodable>: Decodable {
    let mrData: T
    enum CodingKeys: String, CodingKey { case mrData = "MRData" }
}

struct MRData: Decodable {
    let xmlns: String
    let series: String
    let url: String
    let limit: String
    let offset: String
    let total: String?
}

// Driver Table
struct DriverTableDTO: Decodable {
    let season: String
    let driverTable: DriverTableData
    enum CodingKeys: String, CodingKey {
        case season
        case driverTable = "DriverTable"
    }
}

struct DriverTableData: Decodable {
    let drivers: [DriverDTO]
    enum CodingKeys: String, CodingKey { case drivers = "Drivers" }
}

struct DriverDTO: Decodable {
    let driverId: String
    let permanentNumber: String?
    let code: String?
    let url: String?
    let givenName: String
    let familyName: String
    let dateOfBirth: String?
    let nationality: String?

    enum CodingKeys: String, CodingKey {
        case driverId = "driverId"
        case permanentNumber
        case code
        case url
        case givenName
        case familyName
        case dateOfBirth
        case nationality
    }
}

// Constructor Table
struct ConstructorTableDTO: Decodable {
    let season: String
    let constructorTable: ConstructorTableData
    enum CodingKeys: String, CodingKey {
        case season
        case constructorTable = "ConstructorTable"
    }
}

struct ConstructorTableData: Decodable {
    let constructors: [ConstructorDTO]
    enum CodingKeys: String, CodingKey { case constructors = "Constructors" }
}

struct ConstructorDTO: Decodable {
    let constructorId: String
    let url: String?
    let name: String
    let nationality: String?

    enum CodingKeys: String, CodingKey {
        case constructorId = "constructorId"
        case url, name, nationality
    }
}

// Race Table
struct RaceTableDTO: Decodable {
    let season: String
    let raceTable: RaceTableData
    enum CodingKeys: String, CodingKey {
        case season
        case raceTable = "RaceTable"
    }
}

struct RaceTableData: Decodable {
    let season: String
    let round: String?
    let races: [RaceDTO]
    enum CodingKeys: String, CodingKey { case season, round, races = "Races" }
}

struct RaceDTO: Decodable {
    let season: String
    let round: String
    let url: String?
    let raceName: String
    let circuit: CircuitDTO
    let date: String
    let time: String?
    let qualifyingDate: String?
    let qualifyingTime: String?
    let sprintDate: String?
    let sprintTime: String?
    let results: [ResultDTO]?

    enum CodingKeys: String, CodingKey {
        case season, round, url, raceName, circuit, date, time
        case qualifyingDate, qualifyingTime
        case sprintDate, sprintTime
        case results = "Results"
    }
}

struct CircuitDTO: Decodable {
    let circuitId: String
    let url: String?
    let circuitName: String
    let location: LocationDTO

    enum CodingKeys: String, CodingKey {
        case circuitId, url, circuitName, location = "Location"
    }
}

struct LocationDTO: Decodable {
    let lat: String
    let long: String
    let locality: String
    let country: String
}

// Standings
struct StandingsTableDTO: Decodable {
    let season: String
    let standingsTable: StandingsTableData
    enum CodingKeys: String, CodingKey {
        case season
        case standingsTable = "StandingsTable"
    }
}

struct StandingsTableData: Decodable {
    let season: String
    let driverStandings: [DriverStandingDTO]?
    let constructorStandings: [ConstructorStandingDTO]?

    enum CodingKeys: String, CodingKey {
        case season
        case driverStandings = "DriverStandings"
        case constructorStandings = "ConstructorStandings"
    }
}

struct DriverStandingDTO: Decodable {
    let position: String
    let positionText: String
    let points: String
    let wins: String
    let driver: DriverDTO
    let constructors: [ConstructorDTO]

    enum CodingKeys: String, CodingKey {
        case position, positionText, points, wins, driver = "Driver", constructors = "Constructors"
    }
}

struct ConstructorStandingDTO: Decodable {
    let position: String
    let positionText: String
    let points: String
    let wins: String
    let constructor: ConstructorDTO

    enum CodingKeys: String, CodingKey {
        case position, positionText, points, wins, constructor = "Constructor"
    }
}

// Results
struct ResultDTO: Decodable {
    let number: String
    let position: String
    let positionText: String
    let points: String
    let driver: DriverDTO
    let constructor: ConstructorDTO
    let grid: String
    let laps: String
    let status: String
    let time: ResultTimeDTO?
    let fastestLap: FastestLapDTO?

    enum CodingKeys: String, CodingKey {
        case number, position, positionText, points
        case driver = "Driver", constructor = "Constructor"
        case grid, laps, status, time = "Time", fastestLap = "FastestLap"
    }
}

struct ResultTimeDTO: Decodable {
    let millis: String?
    let time: String
}

struct FastestLapDTO: Decodable {
    let rank: String
    let lap: String
    let time: TimeOnlyDTO?
    let averageSpeed: SpeedDTO?

    enum CodingKeys: String, CodingKey {
        case rank, lap, time = "Time", averageSpeed = "AverageSpeed"
    }
}

struct TimeOnlyDTO: Decodable {
    let time: String
}

struct SpeedDTO: Decodable {
    let units: String
    let speed: String
}

// MARK: - Service
final class JolpicaService: @unchecked Sendable {
    static let shared = JolpicaService()

    private let baseURL = "https://api.jolpica.com/ergast/f1"
    private let session: URLSession

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        self.session = URLSession(configuration: config)
    }

    // MARK: - Generic Fetch
    private func fetch<T: Decodable>(path: String, as type: T.Type) async throws -> T {
        guard let url = URL(string: "\(baseURL)/\(path)") else {
            throw JolpicaError.invalidURL
        }

        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await session.data(from: url)
        } catch {
            throw JolpicaError.networkError(error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw JolpicaError.invalidResponse(statusCode: 0)
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw JolpicaError.invalidResponse(statusCode: httpResponse.statusCode)
        }

        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            throw JolpicaError.decodingError(error)
        }
    }

    // MARK: - Drivers
    func fetchDrivers(season: Int = 2026) async throws -> [Driver] {
        let path = "\(season)/drivers.json"
        let wrapper = try await fetch(path: path, as: JolpicaDriverResponse.self)
        return wrapper.mrData.driverTable.drivers.map { $0.toModel() }
    }

    func fetchDriverStandings(season: Int = 2026) async throws -> [DriverStanding] {
        let path = "\(season)/driverStandings.json"
        let wrapper = try await fetch(path: path, as: JolpicaStandingsResponse.self)
        let standingsData = wrapper.mrData.standingsTable
        guard let standings = standingsData.driverStandings else { return [] }
        return standings.map { $0.toModel() }
    }

    // MARK: - Constructors
    func fetchConstructors(season: Int = 2026) async throws -> [Constructor] {
        let path = "\(season)/constructors.json"
        let wrapper = try await fetch(path: path, as: JolpicaConstructorResponse.self)
        return wrapper.mrData.constructorTable.constructors.map { $0.toModel() }
    }

    func fetchConstructorStandings(season: Int = 2026) async throws -> [ConstructorStanding] {
        let path = "\(season)/constructorStandings.json"
        let wrapper = try await fetch(path: path, as: JolpicaConstructorStandingsResponse.self)
        let standingsData = wrapper.mrData.standingsTable
        guard let standings = standingsData.constructorStandings else { return [] }
        return standings.map { $0.toModel() }
    }

    // MARK: - Races
    func fetchRaces(season: Int = 2026) async throws -> [Race] {
        let path = "\(season).json"
        let wrapper = try await fetch(path: path, as: JolpicaRaceResponse.self)
        return wrapper.mrData.raceTable.races.map { $0.toModel() }
    }

    func fetchRaceResults(season: Int, round: Int) async throws -> [RaceResult] {
        let path = "\(season)/\(round)/results.json"
        let wrapper = try await fetch(path: path, as: JolpicaRaceResultResponse.self)
        guard let races = wrapper.mrData.raceTable.races.first,
              let results = races.results else { return [] }
        return results.map { $0.toModel() }
    }

    func fetchQualifyingResults(season: Int, round: Int) async throws -> [QualifyingResult] {
        let path = "\(season)/\(round)/qualifying.json"
        let data = try await fetchRawData(path: path)
        // Qualifying has same structure as results with Q1/Q2/Q3 times
        return []
    }

    // MARK: - Current Season
    func fetchCurrentSchedule() async throws -> [Race] {
        let path = "current.json"
        let wrapper = try await fetch(path: path, as: JolpicaRaceResponse.self)
        return wrapper.mrData.raceTable.races.map { $0.toModel() }
    }

    // MARK: - Circuits
    func fetchCircuits() async throws -> [Circuit] {
        let path = "circuits.json"
        let data = try await fetchRawData(path: path)
        // Parse circuits from raw data
        return []
    }

    // MARK: - Helper
    private func fetchRawData(path: String) async throws -> Data {
        guard let url = URL(string: "\(baseURL)/\(path)") else {
            throw JolpicaError.invalidURL
        }
        do {
            let (data, response) = try await session.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                let code = (response as? HTTPURLResponse)?.statusCode ?? 0
                throw JolpicaError.invalidResponse(statusCode: code)
            }
            return data
        } catch let error as JolpicaError {
            throw error
        } catch {
            throw JolpicaError.networkError(error)
        }
    }
}

// MARK: - Response Wrappers
struct JolpicaDriverResponse: Decodable {
    let mrData: JolpicaDriverMRData
    enum CodingKeys: String, CodingKey { case mrData = "MRData" }
}

struct JolpicaDriverMRData: Decodable {
    let driverTable: DriverTableWrapper
    enum CodingKeys: String, CodingKey { case driverTable = "DriverTable" }
}

struct DriverTableWrapper: Decodable {
    let drivers: [DriverDTO]
    enum CodingKeys: String, CodingKey { case drivers = "Drivers" }
}

struct JolpicaConstructorResponse: Decodable {
    let mrData: JolpicaConstructorMRData
    enum CodingKeys: String, CodingKey { case mrData = "MRData" }
}

struct JolpicaConstructorMRData: Decodable {
    let constructorTable: ConstructorTableWrapper
    enum CodingKeys: String, CodingKey { case constructorTable = "ConstructorTable" }
}

struct ConstructorTableWrapper: Decodable {
    let constructors: [ConstructorDTO]
    enum CodingKeys: String, CodingKey { case constructors = "Constructors" }
}

struct JolpicaRaceResponse: Decodable {
    let mrData: JolpicaRaceMRData
    enum CodingKeys: String, CodingKey { case mrData = "MRData" }
}

struct JolpicaRaceMRData: Decodable {
    let raceTable: RaceTableWrapper
    enum CodingKeys: String, CodingKey { case raceTable = "RaceTable" }
}

struct RaceTableWrapper: Decodable {
    let races: [RaceDTO]
    enum CodingKeys: String, CodingKey { case races = "Races" }
}

struct JolpicaStandingsResponse: Decodable {
    let mrData: JolpicaStandingsMRData
    enum CodingKeys: String, CodingKey { case mrData = "MRData" }
}

struct JolpicaStandingsMRData: Decodable {
    let standingsTable: StandingsTableWrapper
    enum CodingKeys: String, CodingKey { case standingsTable = "StandingsTable" }
}

struct StandingsTableWrapper: Decodable {
    let driverStandings: [DriverStandingDTO]?
    let constructorStandings: [ConstructorStandingDTO]?

    enum CodingKeys: String, CodingKey {
        case driverStandings = "DriverStandings"
        case constructorStandings = "ConstructorStandings"
    }
}

struct JolpicaConstructorStandingsResponse: Decodable {
    let mrData: JolpicaConstructorStandingsMRData
    enum CodingKeys: String, CodingKey { case mrData = "MRData" }
}

struct JolpicaConstructorStandingsMRData: Decodable {
    let standingsTable: ConstructorStandingsTableWrapper
    enum CodingKeys: String, CodingKey { case standingsTable = "StandingsTable" }
}

struct ConstructorStandingsTableWrapper: Decodable {
    let constructorStandings: [ConstructorStandingDTO]?
    enum CodingKeys: String, CodingKey { case constructorStandings = "ConstructorStandings" }
}

struct JolpicaRaceResultResponse: Decodable {
    let mrData: JolpicaRaceResultMRData
    enum CodingKeys: String, CodingKey { case mrData = "MRData" }
}

struct JolpicaRaceResultMRData: Decodable {
    let raceTable: RaceResultTableWrapper
    enum CodingKeys: String, CodingKey { case raceTable = "RaceTable" }
}

struct RaceResultTableWrapper: Decodable {
    let races: [RaceDTO]
    enum CodingKeys: String, CodingKey { case races = "Races" }
}

// MARK: - DTO to Model Mapping
extension DriverDTO {
    func toModel() -> Driver {
        Driver(
            id: driverId,
            number: Int(permanentNumber ?? "0") ?? 0,
            code: code ?? driverId.prefix(3).uppercased(),
            firstName: givenName,
            lastName: familyName,
            nationality: nationality ?? "",
            teamColor: "",
            constructorId: ""
        )
    }
}

extension ConstructorDTO {
    func toModel() -> Constructor {
        Constructor(
            id: constructorId,
            name: constructorId.replacingOccurrences(of: "_", with: " ").capitalized,
            fullName: name,
            nationality: nationality ?? "",
            color: Color.teamColor(for: constructorId).toHex() ?? "666666",
            colorSecondary: "FFFFFF"
        )
    }
}

extension RaceDTO {
    func toModel() -> Race {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate]
        let raceDate = dateFormatter.date(from: date) ?? Date()

        return Race(
            id: "\(season)-\(round)",
            name: raceName,
            circuitId: circuit.circuitId,
            date: raceDate,
            season: Int(season) ?? 2026,
            round: Int(round) ?? 0
        )
    }
}

extension DriverStandingDTO {
    func toModel() -> DriverStanding {
        DriverStanding(
            id: "\(driver.driverId)-\(constructors.first?.constructorId ?? "")",
            driverId: driver.driverId,
            position: Int(position) ?? 0,
            points: Double(points) ?? 0,
            wins: Int(wins) ?? 0,
            constructorId: constructors.first?.constructorId ?? ""
        )
    }
}

extension ConstructorStandingDTO {
    func toModel() -> ConstructorStanding {
        ConstructorStanding(
            id: constructor.constructorId,
            constructorId: constructor.constructorId,
            position: Int(position) ?? 0,
            points: Double(points) ?? 0,
            wins: Int(wins) ?? 0
        )
    }
}

extension ResultDTO {
    func toModel() -> RaceResult {
        RaceResult(
            id: "\(driver.driverId)-\(position)",
            driverId: driver.driverId,
            constructorId: constructor.constructorId,
            position: Int(position) ?? 0,
            grid: Int(grid) ?? 0,
            points: Double(points) ?? 0,
            laps: Int(laps) ?? 0,
            status: status,
            time: time?.time ?? ""
        )
    }
}

// MARK: - Supporting Types
struct RaceResult: Identifiable, Codable, Hashable {
    let id: String
    let driverId: String
    let constructorId: String
    let position: Int
    let grid: Int
    let points: Double
    let laps: Int
    let status: String
    let time: String
}

struct QualifyingResult: Identifiable, Codable, Hashable {
    let id: String
    let driverId: String
    let constructorId: String
    let position: Int
    let q1: String?
    let q2: String?
    let q3: String?
}

extension Color {
    func toHex() -> String? {
        guard let components = UIColor(self).cgColor.components,
              components.count >= 3 else { return nil }
        let r = Int(components[0] * 255)
        let g = Int(components[1] * 255)
        let b = Int(components[2] * 255)
        return String(format: "%02X%02X%02X", r, g, b)
    }
}