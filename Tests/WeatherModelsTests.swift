import Testing
import Foundation
@testable import Weather

@Suite("WeatherModels")
struct WeatherModelsTests {

    // MARK: - Points

    @Test func decodesPointsResponse() throws {
        let data = Data(SampleJSON.points.utf8)
        let response = try JSONDecoder().decode(PointsResponse.self, from: data)
        #expect(response.properties.gridId == "TOP")
        #expect(response.properties.gridX == 32)
        #expect(response.properties.gridY == 81)
        #expect(response.properties.timeZone == "America/Chicago")
        #expect(response.properties.relativeLocation.properties.city == "Linn")
        #expect(response.properties.relativeLocation.properties.state == "KS")
    }

    // MARK: - Forecast

    @Test func decodesForecastResponse() throws {
        let data = Data(SampleJSON.forecast.utf8)
        let response = try JSONDecoder().decode(ForecastResponse.self, from: data)
        #expect(response.properties.periods.count == 2)

        let first = response.properties.periods[0]
        #expect(first.number == 1)
        #expect(first.name == "Overnight")
        #expect(first.isDaytime == false)
        #expect(first.temperature == 36)
        #expect(first.temperatureUnit == "F")
        #expect(first.temperatureTrend == nil)
        #expect(first.shortForecast == "Mostly Clear")
        #expect(first.windSpeed == "15 mph")
        #expect(first.windDirection == "SW")
    }

    @Test func forecastPeriodTemperatureTrend() throws {
        let data = Data(SampleJSON.forecast.utf8)
        let response = try JSONDecoder().decode(ForecastResponse.self, from: data)
        let second = response.properties.periods[1]
        #expect(second.temperatureTrend == "rising")
    }

    @Test func forecastPeriodIsIdentifiable() throws {
        let data = Data(SampleJSON.forecast.utf8)
        let response = try JSONDecoder().decode(ForecastResponse.self, from: data)
        let first = response.properties.periods[0]
        #expect(first.id == 1)
    }

    // MARK: - Hourly Forecast

    @Test func decodesHourlyForecastWithDewpointAndHumidity() throws {
        let data = Data(SampleJSON.hourlyForecast.utf8)
        let response = try JSONDecoder().decode(ForecastResponse.self, from: data)
        let period = response.properties.periods[0]
        #expect(period.dewpoint?.unitCode == "wmoUnit:degC")
        #expect(period.dewpoint?.value == -1.11)
        #expect(period.relativeHumidity?.unitCode == "wmoUnit:percent")
        #expect(period.relativeHumidity?.value == 65)
    }

    @Test func standardForecastOmitsDewpointAndHumidity() throws {
        let data = Data(SampleJSON.forecast.utf8)
        let response = try JSONDecoder().decode(ForecastResponse.self, from: data)
        let period = response.properties.periods[0]
        #expect(period.dewpoint == nil)
        #expect(period.relativeHumidity == nil)
    }

    // MARK: - Alerts

    @Test func decodesAlertsResponse() throws {
        let data = Data(SampleJSON.alerts.utf8)
        let response = try JSONDecoder().decode(AlertsResponse.self, from: data)
        #expect(response.features.count == 1)

        let alert = response.features[0].properties
        #expect(alert.event == "Winter Storm Warning")
        #expect(alert.severity == "Moderate")
        #expect(alert.certainty == "Likely")
        #expect(alert.urgency == "Expected")
        #expect(alert.senderName == "NWS Topeka KS")
        #expect(alert.headline == "Winter Storm Warning issued for Washington County")
        #expect(alert.instruction == "Travel is strongly discouraged.")
    }

    @Test func decodesEmptyAlerts() throws {
        let data = Data(SampleJSON.alertsEmpty.utf8)
        let response = try JSONDecoder().decode(AlertsResponse.self, from: data)
        #expect(response.features.isEmpty)
    }

    @Test func alertFeatureIsIdentifiable() throws {
        let data = Data(SampleJSON.alerts.utf8)
        let response = try JSONDecoder().decode(AlertsResponse.self, from: data)
        #expect(response.features[0].id == "urn:oid:2.49.0.1.840.0.1")
    }
}
