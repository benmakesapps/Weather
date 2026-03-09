import Foundation

// MARK: - Points Response

/// The top-level response from the `/points/{latitude},{longitude}` endpoint.
/// Contains grid metadata used to fetch forecasts for a specific location.
public struct GridResponse: Codable, Sendable, Equatable {
    /// The nested properties object containing all grid and location details.
    public let properties: GridProperties
}

/// Grid metadata returned by the NWS Points API, used to construct forecast endpoint URLs.
public struct GridProperties: Codable, Sendable, Equatable {
    /// The three-letter Weather Forecast Office (WFO) identifier.
    /// Examples: `"TOP"` (Topeka, KS), `"OKX"` (New York, NY), `"LOT"` (Chicago, IL), `"DFW"` (Dallas/Fort Worth, TX)
    public let gridId: String

    /// The X coordinate within the forecast grid. A non-negative integer, typically 0–200.
    /// Example: `32`
    public let gridX: Int

    /// The Y coordinate within the forecast grid. A non-negative integer, typically 0–200.
    /// Example: `81`
    public let gridY: Int

    /// The full URL for the standard (daily) forecast endpoint for this grid point.
    /// Example: `"https://api.weather.gov/gridpoints/TOP/32,81/forecast"`
    public let forecast: String

    /// The full URL for the hourly forecast endpoint for this grid point.
    /// Example: `"https://api.weather.gov/gridpoints/TOP/32,81/forecast/hourly"`
    public let forecastHourly: String

    /// The IANA time zone identifier for the grid point's location.
    /// Examples: `"America/Chicago"`, `"America/New_York"`, `"America/Los_Angeles"`, `"America/Denver"`
    public let timeZone: String

    /// The nearest city/town relative to the queried coordinates.
    public let relativeLocation: RelativeLocation
}

/// Wrapper for the relative location data returned by the NWS Points API.
public struct RelativeLocation: Codable, Sendable, Equatable {
    /// The nested properties containing city and state information.
    public let properties: RelativeLocationProperties
}

/// The city and state of the nearest populated place to the queried coordinates.
public struct RelativeLocationProperties: Codable, Sendable, Equatable {
    /// The name of the nearest city or town.
    /// Examples: `"Linn"`, `"Kansas City"`, `"Springfield"`
    public let city: String

    /// The two-letter US state or territory abbreviation.
    /// Examples: `"KS"`, `"MO"`, `"NY"`, `"CA"`, `"TX"`, `"PR"`
    public let state: String
}

// MARK: - Forecast Response

/// The top-level response from the `/gridpoints/{wfo}/{x},{y}/forecast` and
/// `/gridpoints/{wfo}/{x},{y}/forecast/hourly` endpoints.
public struct ForecastResponse: Codable, Sendable, Equatable {
    /// The nested properties object containing the array of forecast periods.
    public let properties: ForecastProperties
}

/// Contains the array of forecast periods returned by the NWS Forecast API.
public struct ForecastProperties: Codable, Sendable, Equatable {
    /// An ordered list of forecast periods. Daily forecasts typically return 14 periods
    /// (7 days × day/night). Hourly forecasts return up to 156 one-hour periods.
    public let periods: [ForecastPeriod]
}

/// A single forecast period representing either a day/night segment (daily forecast)
/// or a one-hour window (hourly forecast).
public struct ForecastPeriod: Codable, Sendable, Equatable, Identifiable {
    /// Convenience `Identifiable` conformance that uses `number` as the unique ID.
    public var id: Int { number }

    /// The sequential position of this period in the forecast, starting at 1.
    /// Daily forecasts: 1–14. Hourly forecasts: 1–156.
    /// Example: `1`
    public let number: Int

    /// A human-readable label for this period. For daily forecasts, this is the day/time name.
    /// For hourly forecasts, this is typically an empty string.
    /// Examples: `"Tonight"`, `"Sunday"`, `"Sunday Night"`, `"Monday"`, `"Overnight"`, `""`
    public let name: String

    /// The ISO 8601 start time of this period, including the UTC offset.
    /// Example: `"2026-03-08T01:00:00-06:00"`
    public let startTime: String

    /// The ISO 8601 end time of this period, including the UTC offset.
    /// Example: `"2026-03-08T06:00:00-05:00"`
    public let endTime: String

    /// Whether this period falls during daytime hours. `true` for day periods, `false` for night/overnight.
    /// Example: `true`
    public let isDaytime: Bool

    /// The forecast temperature as a whole number in the unit specified by `temperatureUnit`.
    /// Typically ranges from about -30 to 120 (°F) or -35 to 50 (°C).
    /// Example: `55`
    public let temperature: Int

    /// The unit of the `temperature` value. Almost always Fahrenheit for US locations.
    /// Possible values: `"F"` (Fahrenheit), `"C"` (Celsius)
    public let temperatureUnit: String

    /// An optional trend indicator when the temperature is expected to deviate from the typical
    /// high/low during the period. `nil` when no notable trend exists.
    /// Possible values: `"rising"`, `"falling"`, or `nil`
    public let temperatureTrend: String?

    /// The probability of precipitation as a percentage (0–100). `nil` when not reported.
    /// Uses `unitCode` of `"wmoUnit:percent"` and a `value` like `0`, `20`, `80`, etc.
    public let probabilityOfPrecipitation: MeasuredValue?

    /// A human-readable wind speed string, which may be a single value or a range.
    /// Examples: `"10 mph"`, `"15 mph"`, `"5 to 15 mph"`, `"15 to 25 mph"`
    public let windSpeed: String

    /// The cardinal or intercardinal compass direction the wind is blowing from.
    /// Possible values: `"N"`, `"NE"`, `"E"`, `"SE"`, `"S"`, `"SW"`, `"W"`, `"NW"`,
    /// `"NNE"`, `"ENE"`, `"ESE"`, `"SSE"`, `"SSW"`, `"WSW"`, `"WNW"`, `"NNW"`
    public let windDirection: String

    /// A brief summary of the forecast conditions.
    /// Examples: `"Mostly Clear"`, `"Partly Sunny"`, `"Chance Rain"`, `"Snow Likely"`,
    /// `"Thunderstorms"`, `"Sunny"`, `"Mostly Cloudy"`
    public let shortForecast: String

    /// A full-sentence description of the forecast. Present in daily forecasts; typically
    /// an empty string `""` in hourly forecasts.
    /// Example: `"Partly sunny, with a high near 55. South wind around 10 mph."`
    public let detailedForecast: String

    /// The dewpoint temperature, typically in degrees Celsius. Only present in hourly forecasts; `nil` in daily.
    /// Uses `unitCode` of `"wmoUnit:degC"` and a `value` like `-1.11`, `5.0`, `15.56`.
    public let dewpoint: MeasuredValue?

    /// The relative humidity as a percentage (0–100). Only present in hourly forecasts; `nil` in daily.
    /// Uses `unitCode` of `"wmoUnit:percent"` and a `value` like `65`, `45.5`, `92`.
    public let relativeHumidity: MeasuredValue?
}

/// A numeric measurement with its associated WMO unit code, used for precipitation probability,
/// dewpoint, and relative humidity.
public struct MeasuredValue: Codable, Sendable, Equatable {
    /// The WMO (World Meteorological Organization) unit identifier.
    /// Possible values: `"wmoUnit:percent"` (for probability/humidity), `"wmoUnit:degC"` (for dewpoint)
    public let unitCode: String

    /// The numeric value of the measurement. `nil` when the value is not available or not applicable.
    /// Examples: `0` (0% chance), `20` (20% probability), `-1.11` (dewpoint in °C), `65` (65% humidity)
    public let value: Double?
}

// MARK: - Alerts Response

/// The top-level response from the `/alerts/active` endpoint.
/// Contains an array of active weather alert features for the queried area.
public struct AlertsResponse: Codable, Sendable, Equatable {
    /// The list of active alert features. May be empty if no alerts are active for the location.
    public let features: [AlertFeature]
}

/// A GeoJSON feature wrapper for a single weather alert.
public struct AlertFeature: Codable, Sendable, Equatable, Identifiable {
    /// Convenience `Identifiable` conformance using the alert's unique ID string.
    public var id: String { properties.id }

    /// The nested properties containing all alert detail fields.
    public let properties: AlertProperties
}

/// Detailed properties of an active weather alert from the NWS Alerts API.
public struct AlertProperties: Codable, Sendable, Equatable {
    /// A globally unique URN identifier for this alert.
    /// Example: `"urn:oid:2.49.0.1.840.0.1"`
    public let id: String

    /// A human-readable description of the affected geographic area(s). May list multiple areas
    /// separated by semicolons.
    /// Examples: `"Washington County, KS"`, `"Cook County, IL; DuPage County, IL"`
    public let areaDesc: String

    /// The severity level of the alert.
    /// Possible values: `"Extreme"`, `"Severe"`, `"Moderate"`, `"Minor"`, `"Unknown"`
    public let severity: String

    /// How certain the forecaster is that the event will occur.
    /// Possible values: `"Observed"`, `"Likely"`, `"Possible"`, `"Unlikely"`, `"Unknown"`
    public let certainty: String

    /// How urgently action should be taken.
    /// Possible values: `"Immediate"`, `"Expected"`, `"Future"`, `"Past"`, `"Unknown"`
    public let urgency: String

    /// The type of weather event.
    /// Examples: `"Winter Storm Warning"`, `"Tornado Watch"`, `"Severe Thunderstorm Warning"`,
    /// `"Flood Advisory"`, `"Heat Advisory"`, `"Wind Chill Warning"`, `"Dense Fog Advisory"`
    public let event: String

    /// A short headline summarizing the alert. `nil` if not provided by the issuing office.
    /// Example: `"Winter Storm Warning issued for Washington County"`
    public let headline: String?

    /// The raw description text from the NWS API.
    public let description: String

    /// Recommended protective actions for the public. `nil` if no specific instructions are given.
    /// Example: `"Travel is strongly discouraged."`, `"Seek shelter immediately."`
    public let instruction: String?

    /// The recommended broad response category for the alert.
    /// Possible values: `"Shelter"`, `"Evacuate"`, `"Prepare"`, `"Execute"`, `"Avoid"`,
    /// `"Monitor"`, `"Assess"`, `"AllClear"`, `"None"`
    public let response: String

    /// The ISO 8601 timestamp (with UTC offset) when the alert was originally sent.
    /// Example: `"2026-03-08T10:00:00+00:00"`
    public let sent: String

    /// The ISO 8601 timestamp when the alert becomes effective.
    /// Example: `"2026-03-08T10:00:00+00:00"`
    public let effective: String

    /// The ISO 8601 timestamp when the hazard conditions are expected to begin. `nil` if not specified.
    /// Example: `"2026-03-08T12:00:00+00:00"`
    public let onset: String?

    /// The ISO 8601 timestamp when the alert expires and is no longer displayed.
    /// Example: `"2026-03-09T04:00:00+00:00"`
    public let expires: String

    /// The ISO 8601 timestamp when the hazard conditions are expected to end. `nil` if open-ended.
    /// Example: `"2026-03-09T06:00:00+00:00"`
    public let ends: String?

    /// The operational status of the alert.
    /// Possible values: `"Actual"` (real alert), `"Exercise"`, `"System"`, `"Test"`, `"Draft"`
    public let status: String

    /// The name of the NWS office or organization that issued the alert.
    /// Examples: `"NWS Topeka KS"`, `"NWS Chicago IL"`, `"NWS Norman OK"`
    public let senderName: String
}
