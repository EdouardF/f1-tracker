import Foundation

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

actor JolpicaService {
    static let shared = JolpicaService()

    private let baseURL = "https://api.jolpica.com/ergast/f1"
    private let session: URLSession

    private init(session: URLSession = .shared) {
        self.session = session
    }

    // MARK: - Generic Fetch

    private func fetch<T: Decodable>(path: String) async throws -> T {
        guard let url = URL(string: "\(baseURL)/\(path)") else {
            throw JolpicaError.invalidURL
        }

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw JolpicaError.invalidResponse(statusCode: 0)
            }

            guard httpResponse.statusCode == 200 else {
                throw JolpicaError.invalidResponse(statusCode: httpResponse.statusCode)
            }

            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw JolpicaError.decodingError(error)
            }
        } catch let error as JolpicaError {
            throw error
        } catch {
            throw JolpicaError.networkError(error)
        }
    }

    // MARK: - Current Season

    func fetchCurrentSeason() async throws -> MRData {
        let result: ErgastResponse<MRData> = try await fetch(path: "current.json")
        return result.mrData
    }

    // MARK: - Driver Standings

    func fetchDriverStandings(season: Int = 2026) async throws -> [DriverStanding] {
        let result: ErgastResponse<DriverStandingsTableDTO> = try await fetch(
            path: "\(season)/driverStandings.json"
        )
        return result.mrData.standingsTable.standingsLists.first?.driverStandings.map {
            DriverStanding(from: $0)
        } ?? []
    }

    // MARK: - Constructor Standings

    func fetchConstructorStandings(season: Int = 2026) async throws -> [ConstructorStanding] {
        let result: ErgastResponse<ConstructorStandingsTableDTO> = try await fetch(
            path: "\(season)/constructorStandings.json"
        )
        return result.mrData.standingsTable.standingsLists.first?.constructorStandings.map {
            ConstructorStanding(from: $0)
        } ?? []
    }

    // MARK: - Race Schedule

    func fetchRaceSchedule(season: Int = 2026) async throws -> [Race] {
        struct RaceTableDTO: Codable {
            let raceTable: RaceTable
            struct RaceTable: Codable {
                let races: [RaceDTO]
            }
        }
        let result: ErgastResponse<RaceTableDTO> = try await fetch(
            path: "\(season).json"
        )
        return result.mrData.raceTable.races.map { Race(from: $0) }
    }

    // MARK: - Race Results

    func fetchRaceResults(season: Int, round: Int) async throws -> [RaceResult] {
        struct ResultsTableDTO: Codable {
            let resultsTable: RaceTable
            struct RaceTable: Codable {
                let season: String
                let round: String
                let races: [RaceWithResultsDTO]
            }
            struct RaceWithResultsDTO: Codable {
                let results: [RaceResultDTO]
            }
        }
        let result: ErgastResponse<ResultsTableDTO> = try await fetch(
            path: "\(season)/\(round)/results.json"
        )
        guard let race = result.mrData.resultsTable.races.first else { return [] }
        return race.results.map { RaceResult(from: $0) }
    }

    // MARK: - Constructors

    func fetchConstructors(season: Int = 2026) async throws -> [Constructor] {
        struct ConstructorTableDTO: Codable {
            let constructorTable: ConstructorTable
            struct ConstructorTable: Codable {
                let constructors: [ConstructorDTO]
            }
        }
        let result: ErgastResponse<ConstructorTableDTO> = try await fetch(
            path: "\(season)/constructors.json"
        )
        return result.mrData.constructorTable.constructors.map {
            Constructor(from: $0)
        }
    }

    // MARK: - Drivers

    func fetchDrivers(season: Int = 2026) async throws -> [Driver] {
        struct DriverTableDTO: Codable {
            let driverTable: DriverTable
            struct DriverTable: Codable {
                let drivers: [DriverDTO]
            }
        }
        let result: ErgastResponse<DriverTableDTO> = try await fetch(
            path: "\(season)/drivers.json"
        )
        // Note: Jolpica doesn't return team colors, so we'll merge with OpenF1 data
        return result.mrData.driverTable.drivers.map { dto in
            Driver(
                id: dto.driverId,
                number: Int(dto.permanentNumber) ?? 0,
                code: dto.code ?? dto.familyName.prefix(3).uppercased(),
                firstName: dto.givenName,
                lastName: dto.familyName,
                nationality: dto.nationality,
                teamColor: "#666666",
                constructorId: ""
            )
        }
    }
}

// MARK: - Ergast Response Wrapper
struct ErgastResponse<T: Codable>: Codable {
    let mrData: T
}

struct MRData: Codable {
    let xmlns: String?
    let series: String
    let url: String
    let limit: String
    let offset: String
    let total: String
}

// MARK: - Race Result Model
struct RaceResult: Identifiable {
    let id: String
    let position: Int
    let driverId: String
    let constructorId: String
    let time: String?
    let points: Double
    let grid: Int
    let laps: Int
    let status: String

    init(from dto: RaceResultDTO) {
        self.id = "\(dto.position)-\(dto.driver.driverId)"
        self.position = Int(dto.position) ?? 0
        self.driverId = dto.driver.driverId
        self.constructorId = dto.constructor.constructorId
        self.time = dto.time?.time
        self.points = Double(dto.points) ?? 0
        self.grid = Int(dto.grid) ?? 0
        self.laps = Int(dto.laps) ?? 0
        self.status = dto.status
    }
}

struct RaceResultDTO: Codable {
    let number: String
    let position: String
    let positionText: String?
    let points: String
    let driver: DriverDTO
    let constructor: ConstructorDTO
    let grid: String
    let laps: String
    let status: String
    let time: RaceTimeDTO?

    struct RaceTimeDTO: Codable {
        let millis: String?
        let time: String
    }
}