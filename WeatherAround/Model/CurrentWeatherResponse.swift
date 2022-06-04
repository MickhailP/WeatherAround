//MARK: - File description
//Weather Response from Tomorrow IO API
//This results we receive after API call in WeatherService.swift
//

import Foundation

struct Weather {
    let id = UUID()
    
    let startTime: String
    let temperature: Double
    let temperatureApparent: Double
    
    let weatherCode: Int
    
    let humidity: Double
    let precipitationProbability: Int
    let precipitationType: Int
    let pressureSurfaceLevel: Double
    
    let uvIndex: Int?
    let visibility: Double
    let windSpeed: Double
}

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
    let humidity: Double
    let precipitationProbability, precipitationType: Int
    let pressureSurfaceLevel, temperature, temperatureApparent: Double
    let uvIndex: Int?
    let visibility: Double
    let weatherCode: Int
    let windSpeed: Double
}

