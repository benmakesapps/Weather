import Foundation

enum SampleJSON {
    static let points = """
    {
      "properties": {
        "gridId": "TOP",
        "gridX": 32,
        "gridY": 81,
        "forecast": "https://api.weather.gov/gridpoints/TOP/32,81/forecast",
        "forecastHourly": "https://api.weather.gov/gridpoints/TOP/32,81/forecast/hourly",
        "timeZone": "America/Chicago",
        "relativeLocation": {
          "properties": {
            "city": "Linn",
            "state": "KS"
          }
        }
      }
    }
    """

    static let forecast = """
    {
      "properties": {
        "periods": [
          {
            "number": 1,
            "name": "Overnight",
            "startTime": "2026-03-08T01:00:00-06:00",
            "endTime": "2026-03-08T06:00:00-05:00",
            "isDaytime": false,
            "temperature": 36,
            "temperatureUnit": "F",
            "temperatureTrend": null,
            "probabilityOfPrecipitation": {
              "unitCode": "wmoUnit:percent",
              "value": 0
            },
            "windSpeed": "15 mph",
            "windDirection": "SW",
            "shortForecast": "Mostly Clear",
            "detailedForecast": "Mostly clear, with a low around 36."
          },
          {
            "number": 2,
            "name": "Sunday",
            "startTime": "2026-03-08T06:00:00-05:00",
            "endTime": "2026-03-08T18:00:00-05:00",
            "isDaytime": true,
            "temperature": 55,
            "temperatureUnit": "F",
            "temperatureTrend": "rising",
            "probabilityOfPrecipitation": {
              "unitCode": "wmoUnit:percent",
              "value": 20
            },
            "windSpeed": "10 mph",
            "windDirection": "S",
            "shortForecast": "Partly Sunny",
            "detailedForecast": "Partly sunny, with a high near 55."
          }
        ]
      }
    }
    """

    static let hourlyForecast = """
    {
      "properties": {
        "periods": [
          {
            "number": 1,
            "name": "",
            "startTime": "2026-03-08T01:00:00-06:00",
            "endTime": "2026-03-08T02:00:00-06:00",
            "isDaytime": false,
            "temperature": 38,
            "temperatureUnit": "F",
            "temperatureTrend": null,
            "probabilityOfPrecipitation": {
              "unitCode": "wmoUnit:percent",
              "value": 0
            },
            "dewpoint": {
              "unitCode": "wmoUnit:degC",
              "value": -1.11
            },
            "relativeHumidity": {
              "unitCode": "wmoUnit:percent",
              "value": 65
            },
            "windSpeed": "15 mph",
            "windDirection": "SW",
            "shortForecast": "Mostly Clear",
            "detailedForecast": ""
          }
        ]
      }
    }
    """

    static let alerts = """
    {
      "features": [
        {
          "properties": {
            "id": "urn:oid:2.49.0.1.840.0.1",
            "areaDesc": "Washington County, KS",
            "severity": "Moderate",
            "certainty": "Likely",
            "urgency": "Expected",
            "event": "Winter Storm Warning",
            "headline": "Winter Storm Warning issued for Washington County",
            "description": "Heavy snow expected. Total accumulations of 6 to 10 inches.",
            "instruction": "Travel is strongly discouraged.",
            "response": "Shelter",
            "sent": "2026-03-08T10:00:00+00:00",
            "effective": "2026-03-08T10:00:00+00:00",
            "onset": "2026-03-08T12:00:00+00:00",
            "expires": "2026-03-09T04:00:00+00:00",
            "ends": "2026-03-09T06:00:00+00:00",
            "status": "Actual",
            "senderName": "NWS Topeka KS"
          }
        }
      ]
    }
    """

    static let alertsEmpty = """
    {
      "features": []
    }
    """
}
