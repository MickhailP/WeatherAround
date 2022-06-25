//MARK: - File description
//Weather Response from Tomorrow IO API
//This results we receive after API call in WeatherService.swift
//

import Foundation

// MARK: - WeatherResponse
struct CurrentWeatherResponse: Decodable {
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Decodable {
    let timelines: [Timeline]
}

// MARK: - Timeline
struct Timeline: Decodable {
    let timestep: String
    let endTime, startTime: String
    let intervals: [Interval]
}

// MARK: - Interval
struct Interval: Decodable {
    let startTime: String
    let values: Values
}

// MARK: - Values
struct Values: Decodable {
    
    enum CodingKeys: CodingKey {
        case humidity, precipitationProbability, precipitationType, pressureSurfaceLevel, temperature, temperatureApparent, uvIndex, visibility, weatherCode, windSpeed
    }
    
    let humidity: Double
    let precipitationProbability, precipitationType: Int
    let pressureSurfaceLevel, temperature, temperatureApparent: Double
    let uvIndex: Int?
    let visibility: Double
    let weatherCode: Int
    let windSpeed: Double
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.humidity = try container.decodeIfPresent(Double.self, forKey: .humidity) ?? 00
        self.precipitationProbability = try container.decodeIfPresent(Int.self, forKey: .precipitationProbability) ?? 0
        self.precipitationType = try container.decodeIfPresent(Int.self, forKey: .precipitationType) ?? 00
        self.pressureSurfaceLevel = try container.decodeIfPresent(Double.self, forKey: .pressureSurfaceLevel) ?? 00
        self.temperature = try container.decodeIfPresent(Double.self, forKey: .temperature) ?? 00
        self.temperatureApparent = try container.decodeIfPresent(Double.self, forKey: .temperatureApparent) ?? 00
        self.uvIndex = try container.decodeIfPresent(Int.self, forKey: .uvIndex) ?? 00
        self.visibility = try container.decodeIfPresent(Double.self, forKey: .visibility) ?? 00
        self.weatherCode = try container.decodeIfPresent(Int.self, forKey: .weatherCode) ?? 0
        self.windSpeed = try container.decodeIfPresent(Double.self, forKey: .windSpeed) ?? 00

    }
}

