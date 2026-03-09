import Foundation

// MARK: - Points Response

public struct PointsResponse: Codable, Sendable, Equatable {
    public let properties: PointsProperties
}

public struct PointsProperties: Codable, Sendable, Equatable {
    public let gridId: String
    public let gridX: Int
    public let gridY: Int
    public let forecast: String
    public let forecastHourly: String
    public let timeZone: String
    public let relativeLocation: RelativeLocation
}

public struct RelativeLocation: Codable, Sendable, Equatable {
    public let properties: RelativeLocationProperties
}

public struct RelativeLocationProperties: Codable, Sendable, Equatable {
    public let city: String
    public let state: String
}

// MARK: - Forecast Response

public struct ForecastResponse: Codable, Sendable, Equatable {
    public let properties: ForecastProperties
}

public struct ForecastProperties: Codable, Sendable, Equatable {
    public let periods: [ForecastPeriod]
}

public struct ForecastPeriod: Codable, Sendable, Equatable, Identifiable {
    public var id: Int { number }

    public let number: Int
    public let name: String
    public let startTime: String
    public let endTime: String
    public let isDaytime: Bool
    public let temperature: Int
    public let temperatureUnit: String
    public let temperatureTrend: String?
    public let probabilityOfPrecipitation: MeasuredValue?
    public let windSpeed: String
    public let windDirection: String
    public let shortForecast: String
    public let detailedForecast: String
    public let dewpoint: MeasuredValue?
    public let relativeHumidity: MeasuredValue?
}

public struct MeasuredValue: Codable, Sendable, Equatable {
    public let unitCode: String
    public let value: Double?
}

// MARK: - Alerts Response

public struct AlertsResponse: Codable, Sendable, Equatable {
    public let features: [AlertFeature]
}

public struct AlertFeature: Codable, Sendable, Equatable, Identifiable {
    public var id: String { properties.id }
    public let properties: AlertProperties
}

public struct AlertProperties: Codable, Sendable, Equatable {
    public let id: String
    public let areaDesc: String
    public let severity: String
    public let certainty: String
    public let urgency: String
    public let event: String
    public let headline: String?
    public let description: String
    public let instruction: String?
    public let response: String
    public let sent: String
    public let effective: String
    public let onset: String?
    public let expires: String
    public let ends: String?
    public let status: String
    public let senderName: String
}
