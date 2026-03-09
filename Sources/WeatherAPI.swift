import Foundation
import os

public protocol WeatherAPIProtocol: Sendable {
    func fetchPoints(for coordinate: Coordinate) async throws -> PointsResponse
    func fetchForecast(for coordinate: Coordinate) async throws -> ForecastResponse
    func fetchHourlyForecast(for coordinate: Coordinate) async throws -> ForecastResponse
    func fetchAlerts(for coordinate: Coordinate) async throws -> AlertsResponse
}

public struct WeatherAPI: WeatherAPIProtocol {

    private let session: URLSession
    private let baseComponents: URLComponents
    private let appId: String
    private let logger = Logger(subsystem: "Weather", category: "WeatherAPI")

    public init(appId: String, session: URLSession = .shared) {
        self.appId = appId
        self.session = session
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.weather.gov"
        self.baseComponents = components
    }

    // MARK: - Public

    public func fetchPoints(for coordinate: Coordinate) async throws -> PointsResponse {
        var components = baseComponents
        components.path = "/points/\(coordinate.latitude),\(coordinate.longitude)"
        return try await fetch(components: components)
    }

    public func fetchForecast(for coordinate: Coordinate) async throws -> ForecastResponse {
        let points = try await fetchPoints(for: coordinate)
        let p = points.properties
        var components = baseComponents
        components.path = "/gridpoints/\(p.gridId)/\(p.gridX),\(p.gridY)/forecast"
        return try await fetch(components: components)
    }

    public func fetchHourlyForecast(for coordinate: Coordinate) async throws -> ForecastResponse {
        let points = try await fetchPoints(for: coordinate)
        let p = points.properties
        var components = baseComponents
        components.path = "/gridpoints/\(p.gridId)/\(p.gridX),\(p.gridY)/forecast/hourly"
        return try await fetch(components: components)
    }

    public func fetchAlerts(for coordinate: Coordinate) async throws -> AlertsResponse {
        var components = baseComponents
        components.path = "/alerts/active"
        components.queryItems = [
            URLQueryItem(name: "point", value: "\(coordinate.latitude),\(coordinate.longitude)")
        ]
        return try await fetch(components: components)
    }

    // MARK: - Private

    private func fetch<T: Decodable>(components: URLComponents) async throws -> T {
        guard let url = components.url else {
            throw WeatherError.invalidURL
        }

        var request = URLRequest(url: url)
        request.setValue(appId, forHTTPHeaderField: "User-Agent")
        request.setValue("application/geo+json", forHTTPHeaderField: "Accept")

        logger.debug("GET \(url.absoluteString)")

        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw WeatherError.networkError(error.localizedDescription)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw WeatherError.networkError("Response was not HTTP.")
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            logger.error("HTTP \(httpResponse.statusCode) for \(url.absoluteString)")
            throw WeatherError.httpError(statusCode: httpResponse.statusCode)
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            logger.error("Decoding failed: \(error.localizedDescription)")
            throw WeatherError.decodingFailed
        }
    }
}
