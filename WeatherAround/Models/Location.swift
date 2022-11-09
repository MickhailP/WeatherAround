//
//  Location.swift
//  WeatherAround
//
//  Created by Миша Перевозчиков on 26.10.2022.
//

import Foundation
import CoreLocation

struct Location: Identifiable, Codable {
    
    var id = UUID()
    var name: String
    var country: String
    var geoLocation: CLLocation
}

//
// MARK: Hashable
//
extension Location: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(country)
    }
}

//
// MARK: Equatable
//
extension Location: Equatable {
    static func == (lhs: Location, rhs: Location) -> Bool {
        if lhs.name == rhs.name && lhs.country == rhs.country { return true } else {
            return false
        }
    }
}

//
// MARK: Decodable
//
extension Location {
    enum CodingKeys: CodingKey {
        case id, name, country, geoLocation
    }
    
    init(from decoder: Decoder) throws {
       let container = try decoder.container(keyedBy: CodingKeys.self)
           id = try container.decode(UUID.self, forKey: .id)
           name = try container.decode(String.self, forKey: .name)
           country = try container.decode(String.self, forKey: .country)
           let locationModel = try container.decode(CLLocationData.self, forKey: .geoLocation)
       geoLocation = CLLocation(model: locationModel)
       
   }
}

//
// MARK: Encodable
//
extension CLLocation: Encodable {
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
        case altitude
        case horizontalAccuracy
        case verticalAccuracy
        case speed
        case course
        case timestamp
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
        try container.encode(altitude, forKey: .altitude)
        try container.encode(horizontalAccuracy, forKey: .horizontalAccuracy)
        try container.encode(verticalAccuracy, forKey: .verticalAccuracy)
        try container.encode(speed, forKey: .speed)
        try container.encode(course, forKey: .course)
        try container.encode(timestamp, forKey: .timestamp)
    }
}

//
// MARK: Codable conformance for CLLocation
//
struct CLLocationData: Codable {
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    let altitude: CLLocationDistance
    let horizontalAccuracy: CLLocationAccuracy
    let verticalAccuracy: CLLocationAccuracy
    let speed: CLLocationSpeed
    let course: CLLocationDirection
    let timestamp: Date
}

//
// MARK: Custom init CLLocation
// Allow to init from Decoder anywhere.
// create a CLLocation variable trough the LocationData object
extension CLLocation {
    convenience init(model: CLLocationData) {
      self.init(coordinate: CLLocationCoordinate2DMake(model.latitude, model.longitude), altitude: model.altitude,
                horizontalAccuracy: model.horizontalAccuracy, verticalAccuracy: model.verticalAccuracy,
                course: model.course, speed: model.speed, timestamp: model.timestamp)
     }
}
