@testable import Weather

struct MockWeatherAPI: WeatherAPIProtocol {
    var pointsResult: Result<PointsResponse, Error> = .failure(WeatherError.networkError("Not configured"))
    var forecastResult: Result<ForecastResponse, Error> = .failure(WeatherError.networkError("Not configured"))
    var hourlyForecastResult: Result<ForecastResponse, Error> = .failure(WeatherError.networkError("Not configured"))
    var alertsResult: Result<AlertsResponse, Error> = .failure(WeatherError.networkError("Not configured"))

    func fetchPoints(for coordinate: Coordinate) async throws -> PointsResponse {
        try pointsResult.get()
    }

    func fetchForecast(for coordinate: Coordinate) async throws -> ForecastResponse {
        try forecastResult.get()
    }

    func fetchHourlyForecast(for coordinate: Coordinate) async throws -> ForecastResponse {
        try hourlyForecastResult.get()
    }

    func fetchAlerts(for coordinate: Coordinate) async throws -> AlertsResponse {
        try alertsResult.get()
    }
}
