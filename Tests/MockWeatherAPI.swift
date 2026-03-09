@testable import Weather

struct MockWeatherAPI: WeatherAPIProtocol {
    var gridResult: Result<GridResponse, Error> = .failure(WeatherError.networkError("Not configured"))
    var forecastResult: Result<ForecastResponse, Error> = .failure(WeatherError.networkError("Not configured"))
    var hourlyForecastResult: Result<ForecastResponse, Error> = .failure(WeatherError.networkError("Not configured"))
    var alertsResult: Result<AlertsResponse, Error> = .failure(WeatherError.networkError("Not configured"))

    func fetchGrid(for coordinate: Coordinate) async throws -> GridResponse {
        try gridResult.get()
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
