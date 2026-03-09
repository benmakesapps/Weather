//
//  ContentView.swift
//  SampleApp
//
//  Created by Benjamin Kelsey on 3/8/26.
//

import SwiftUI
import Weather

struct NamedLocation: Sendable, Equatable, Hashable, Identifiable {
    let name: String
    let coordinate: Coordinate

    init(name: String, coordinate: Coordinate) {
        self.name = name
        self.coordinate = coordinate
    }
    
    var id: String { name }
}

extension NamedLocation {
    static let newYork = NamedLocation(
        name: "New York",
        coordinate: .init(latitude: 40.7128, longitude: -74.0060)
    )

    static let losAngeles = NamedLocation(
        name: "Los Angeles",
        coordinate: .init(latitude: 34.0522, longitude: -118.2437)
    )

    static let chicago = NamedLocation(
        name: "Chicago",
        coordinate: .init(latitude: 41.8781, longitude: -87.6298)
    )

    static let houston = NamedLocation(
        name: "Houston",
        coordinate: .init(latitude: 29.7604, longitude: -95.3698)
    )

    static let seattle = NamedLocation(
        name: "Seattle",
        coordinate: .init(latitude: 47.6062, longitude: -122.3321)
    )
    
    static let phoenix = NamedLocation(
        name: "Phoenix",
        coordinate: .init(latitude: 33.4484, longitude: -112.0740)
    )
    
    static let denver = NamedLocation(
        name: "Denver",
        coordinate: .init(latitude: 39.7392, longitude: -104.9903)
    )
    
    static let miami = NamedLocation(
        name: "Miami",
        coordinate: .init(latitude: 25.7617, longitude: -80.1918)
    )
    
    static let boston = NamedLocation(
        name: "Boston",
        coordinate: .init(latitude: 42.3601, longitude: -71.0589)
    )
    
    static let sanFrancisco = NamedLocation(
        name: "San Francisco",
        coordinate: .init(latitude: 37.7749, longitude: -122.4194)
    )
    
    static let atlanta = NamedLocation(
        name: "Atlanta",
        coordinate: .init(latitude: 33.7490, longitude: -84.3880)
    )
    
    static let tokyo = NamedLocation(
        name: "Tokyo",
        coordinate: .init(latitude: 35.6762, longitude: 139.6503)
    )

    static let all: [NamedLocation] = [
        .newYork,
        .losAngeles,
        .chicago,
        .houston,
        .seattle,
        .phoenix,
        .denver,
        .miami,
        .boston,
        .sanFrancisco,
        .atlanta,
        .tokyo
    ]
}

struct ContentView: View {
    @State var selectedLocation: NamedLocation?
    
    var body: some View {
        NavigationStack {
            List {
                Section("Select a Location") {
                    ForEach(NamedLocation.all) { location in
                        Button {
                            selectedLocation = location
                        } label: {
                            Text(location.name)
                        }
                    }
                }
            }
            .navigationTitle("Weather")
        }
        .sheet(item: $selectedLocation) { location in
            TabView {
                WeatherView(location: location, forecastType: .thisWeek)
                    .tabItem {
                        Label {
                            Text("This Week")
                        } icon: {
                            Image(systemName: "calendar")
                        }
                    }
                
                WeatherView(location: location, forecastType: .now)
                    .tabItem {
                        Label {
                            Text("Now")
                        } icon: {
                            Image(systemName: "clock")
                        }
                    }
                
                AlertView(location: location)
                    .tabItem {
                        Label {
                            Text("Warnings")
                        } icon: {
                            Image(systemName: "exclamationmark.triangle")
                        }
                    }
            }
        }
    }
}

enum ForecastType {
    case now
    case thisWeek
}

struct WeatherView: View {
    let api = WeatherAPI(appId: "com.example.SampleApp")
    let location: NamedLocation
    let forecastType: ForecastType
    @State var forecast: ForecastResponse?
    @State var error: Error?
    
    var body: some View {
        NavigationStack {
            List {
                if let error {
                    Section("Error") {
                        Text(error.localizedDescription)
                    }
                    .foregroundStyle(.red)
                } else {
                    
                    Section() {
                        if let forecast {
                            ForEach(forecast.properties.periods) { period in
                                HStack {
                                    Text(forecastType == .thisWeek ? period.name : period.startTime)
                                        .font(.headline)
                                    Spacer()
                                    Text("\(period.temperature)°\(period.temperatureUnit)")
                                }
                            }
                        } else {
                            ProgressView()
                        }
                    }
                }
            }
            .navigationTitle(location.name)
        }
        .task {
            do {
                switch forecastType {
                case .now:
                    self.forecast = try await api.fetchHourlyForecast(for: location.coordinate)
                case .thisWeek:
                    self.forecast = try await api.fetchForecast(for: location.coordinate)
                }
            } catch {
                self.error = error
            }
        }
    }
}

struct AlertView: View {
    let api = WeatherAPI(appId: "com.example.SampleApp")
    let location: NamedLocation
    
    @State var alerts: AlertsResponse?
    @State var error: Error?
    
    var body: some View {
        NavigationStack {
            List {
                if let error {
                    Section("Error") {
                        Text(error.localizedDescription)
                    }
                    .foregroundStyle(.red)
                } else {
                    
                    Section() {
                        if let alerts {
                            if alerts.features.isEmpty {
                                Text("No active alerts")
                            } else {
                                ForEach(alerts.features) { feature in
                                    Text(feature.properties.event)
                                        .font(.headline)
                                    
                                    VStack {
                                        Text(feature.properties.description)
                                        Text(feature.properties.senderName)
                                            .font(.footnote)
                                    }
                                }
                            }
                        } else {
                            ProgressView()
                        }
                    }
                }
            }
            .navigationTitle(location.name)
        }
        .task {
            do {
                self.alerts = try await api.fetchAlerts(for: location.coordinate)
            } catch {
                self.error = error
            }
        }
    }
}

#Preview {
    ContentView()
}
