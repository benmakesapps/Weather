import Testing
@testable import Weather

@Suite("Coordinate")
struct CoordinateTests {

    @Test func initSetsValues() {
        let c = Coordinate(latitude: 39.7456, longitude: -97.0892)
        #expect(c.latitude == 39.7456)
        #expect(c.longitude == -97.0892)
    }

    @Test func equatable() {
        let a = Coordinate(latitude: 39.7456, longitude: -97.0892)
        let b = Coordinate(latitude: 39.7456, longitude: -97.0892)
        #expect(a == b)
    }

    @Test func notEqualWhenDifferent() {
        let a = Coordinate(latitude: 39.7456, longitude: -97.0892)
        let b = Coordinate(latitude: 40.0, longitude: -97.0892)
        #expect(a != b)
    }

    @Test func hashable() {
        let a = Coordinate(latitude: 39.7456, longitude: -97.0892)
        let b = Coordinate(latitude: 39.7456, longitude: -97.0892)
        #expect(a.hashValue == b.hashValue)
    }
}
