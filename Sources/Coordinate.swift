import Foundation

/// A geographic coordinate representing a location on Earth, used to query the NWS API.
public struct Coordinate: Sendable, Equatable, Hashable {
    /// The north-south position in decimal degrees. Ranges from -90.0 (South Pole) to 90.0 (North Pole).
    /// Example: `39.7456` (near Lawrence, KS)
    public let latitude: Double

    /// The east-west position in decimal degrees. Ranges from -180.0 to 180.0, where negative values are west of the Prime Meridian.
    /// Example: `-97.0892` (near Lawrence, KS)
    public let longitude: Double

    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
