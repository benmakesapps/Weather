import Testing
import Foundation
@testable import Weather

@Suite("WeatherAPIProtocol")
struct WeatherAPIProtocolTests {

    private static let sampleCoordinate = Coordinate(latitude: 39.7456, longitude: -97.0892)

    private static var sampleGrid: GridResponse {
        get throws {
            try JSONDecoder().decode(GridResponse.self, from: Data(SampleJSON.points.utf8))
        }
    }

    private static var sampleForecast: ForecastResponse {
        get throws {
            try JSONDecoder().decode(ForecastResponse.self, from: Data(SampleJSON.forecast.utf8))
        }
    }

    private static var sampleAlerts: AlertsResponse {
        get throws {
            try JSONDecoder().decode(AlertsResponse.self, from: Data(SampleJSON.alerts.utf8))
        }
    }

    // MARK: - Success

    @Test func fetchGridReturnsConfiguredResult() async throws {
        var mock = MockWeatherAPI()
        let expected = try Self.sampleGrid
        mock.gridResult = .success(expected)
        let result = try await mock.fetchGrid(for: Self.sampleCoordinate)
        #expect(result == expected)
    }

    @Test func fetchForecastReturnsConfiguredResult() async throws {
        var mock = MockWeatherAPI()
        let expected = try Self.sampleForecast
        mock.forecastResult = .success(expected)
        let result = try await mock.fetchForecast(for: Self.sampleCoordinate)
        #expect(result == expected)
    }

    @Test func fetchAlertsReturnsConfiguredResult() async throws {
        var mock = MockWeatherAPI()
        let expected = try Self.sampleAlerts
        mock.alertsResult = .success(expected)
        let result = try await mock.fetchAlerts(for: Self.sampleCoordinate)
        #expect(result == expected)
    }

    // MARK: - Errors

    @Test func fetchGridThrowsOnError() async {
        let mock = MockWeatherAPI()
        await #expect(throws: WeatherError.self) {
            try await mock.fetchGrid(for: Self.sampleCoordinate)
        }
    }

    @Test func fetchForecastThrowsOnError() async {
        let mock = MockWeatherAPI()
        await #expect(throws: WeatherError.self) {
            try await mock.fetchForecast(for: Self.sampleCoordinate)
        }
    }

    @Test func fetchAlertsThrowsOnError() async {
        let mock = MockWeatherAPI()
        await #expect(throws: WeatherError.self) {
            try await mock.fetchAlerts(for: Self.sampleCoordinate)
        }
    }
}
