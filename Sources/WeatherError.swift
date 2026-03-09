import Foundation

public enum WeatherError: LocalizedError, Equatable {
    case invalidURL
    case httpError(statusCode: Int)
    case decodingFailed
    case networkError(String)

    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            "The weather service URL could not be constructed."
        case .httpError(let statusCode):
            "The weather service returned HTTP \(statusCode)."
        case .decodingFailed:
            "The weather service response could not be decoded."
        case .networkError(let message):
            message
        }
    }

    public static func == (lhs: WeatherError, rhs: WeatherError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL): true
        case (.httpError(let l), .httpError(let r)): l == r
        case (.decodingFailed, .decodingFailed): true
        case (.networkError(let l), .networkError(let r)): l == r
        default: false
        }
    }
}
