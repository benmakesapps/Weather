import Testing
@testable import Weather

@Suite("WeatherError")
struct WeatherErrorTests {

    @Test func invalidURLDescription() {
        #expect(WeatherError.invalidURL.errorDescription ==
            "The weather service URL could not be constructed.")
    }

    @Test func httpErrorDescription() {
        #expect(WeatherError.httpError(statusCode: 404).errorDescription ==
            "The weather service returned HTTP 404.")
    }

    @Test func decodingFailedDescription() {
        #expect(WeatherError.decodingFailed.errorDescription ==
            "The weather service response could not be decoded.")
    }

    @Test func networkErrorDescription() {
        #expect(WeatherError.networkError("timeout").errorDescription == "timeout")
    }

    @Test func equatableSameCases() {
        #expect(WeatherError.invalidURL == WeatherError.invalidURL)
        #expect(WeatherError.httpError(statusCode: 500) == WeatherError.httpError(statusCode: 500))
        #expect(WeatherError.decodingFailed == WeatherError.decodingFailed)
        #expect(WeatherError.networkError("a") == WeatherError.networkError("a"))
    }

    @Test func equatableDifferentCases() {
        #expect(WeatherError.invalidURL != WeatherError.decodingFailed)
        #expect(WeatherError.httpError(statusCode: 404) != WeatherError.httpError(statusCode: 500))
        #expect(WeatherError.networkError("a") != WeatherError.networkError("b"))
    }
}
