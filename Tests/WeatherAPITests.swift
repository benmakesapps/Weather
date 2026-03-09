import Testing
import Foundation
@testable import Weather

final class MockURLProtocol: URLProtocol, @unchecked Sendable {
    nonisolated(unsafe) static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        guard let handler = Self.requestHandler else { return }
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}

@Suite("WeatherAPI", .serialized)
struct WeatherAPITests {

    private let coordinate = Coordinate(latitude: 39.7456, longitude: -97.0892)

    private func makeSession() -> URLSession {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: config)
    }

    private func makeAPI() -> WeatherAPI {
        WeatherAPI(appId: "TestApp/1.0", session: makeSession())
    }

    private func ok(for request: URLRequest) -> HTTPURLResponse {
        HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    }

    // MARK: - fetchPoints

    @Test func fetchPointsSuccess() async throws {
        MockURLProtocol.requestHandler = { request in
            (ok(for: request), Data(SampleJSON.points.utf8))
        }

        let result = try await makeAPI().fetchPoints(for: coordinate)
        #expect(result.properties.gridId == "TOP")
        #expect(result.properties.gridX == 32)
        #expect(result.properties.gridY == 81)
    }

    @Test func fetchPointsHTTPError() async {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 500, httpVersion: nil, headerFields: nil)!
            return (response, Data())
        }

        await #expect(throws: WeatherError.httpError(statusCode: 500)) {
            try await makeAPI().fetchPoints(for: coordinate)
        }
    }

    @Test func fetchPointsDecodingError() async {
        MockURLProtocol.requestHandler = { request in
            (ok(for: request), Data("not json".utf8))
        }

        await #expect(throws: WeatherError.decodingFailed) {
            try await makeAPI().fetchPoints(for: coordinate)
        }
    }

    // MARK: - fetchForecast

    @Test func fetchForecastSuccess() async throws {
        MockURLProtocol.requestHandler = { request in
            let url = request.url!.absoluteString
            let json = url.contains("/points/") ? SampleJSON.points : SampleJSON.forecast
            return (ok(for: request), Data(json.utf8))
        }

        let result = try await makeAPI().fetchForecast(for: coordinate)
        #expect(result.properties.periods.count == 2)
        #expect(result.properties.periods[0].name == "Overnight")
    }

    // MARK: - fetchHourlyForecast

    @Test func fetchHourlyForecastSuccess() async throws {
        MockURLProtocol.requestHandler = { request in
            let url = request.url!.absoluteString
            let json = url.contains("/points/") ? SampleJSON.points : SampleJSON.hourlyForecast
            return (ok(for: request), Data(json.utf8))
        }

        let result = try await makeAPI().fetchHourlyForecast(for: coordinate)
        #expect(result.properties.periods[0].dewpoint?.value == -1.11)
        #expect(result.properties.periods[0].relativeHumidity?.value == 65)
    }

    // MARK: - fetchAlerts

    @Test func fetchAlertsSuccess() async throws {
        MockURLProtocol.requestHandler = { request in
            (ok(for: request), Data(SampleJSON.alerts.utf8))
        }

        let result = try await makeAPI().fetchAlerts(for: coordinate)
        #expect(result.features.count == 1)
        #expect(result.features[0].properties.event == "Winter Storm Warning")
    }

    @Test func fetchAlertsEmpty() async throws {
        MockURLProtocol.requestHandler = { request in
            (ok(for: request), Data(SampleJSON.alertsEmpty.utf8))
        }

        let result = try await makeAPI().fetchAlerts(for: coordinate)
        #expect(result.features.isEmpty)
    }

    // MARK: - Headers

    @Test func userAgentHeaderIsSent() async throws {
        MockURLProtocol.requestHandler = { request in
            #expect(request.value(forHTTPHeaderField: "User-Agent") == "TestApp/1.0")
            #expect(request.value(forHTTPHeaderField: "Accept") == "application/geo+json")
            return (ok(for: request), Data(SampleJSON.points.utf8))
        }

        _ = try await makeAPI().fetchPoints(for: coordinate)
    }
}
