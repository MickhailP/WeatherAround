//MARK: - File description
//Weather Response from Tomorrow IO API
//This results we receive after API call in WeatherService.swift
//

import Foundation
import SwiftUI

struct Weather {
    let id = UUID()
    
    let startTime: String
    let temperature: Double
    let temperatureApparent: Double
    
    let weatherCode: WeatherCode
    
    let humidity: Double
    let precipitationProbability: Int
    let precipitationType: Int
    let pressureSurfaceLevel: Double
    
    let uvIndex: Int?
    let visibility: Double
    let windSpeed: Double
    
    init(apiResponse: CurrentWeatherResponse) {
        
        let currentResponse = apiResponse.data.timelines[0].intervals[0]
        
            self.startTime = currentResponse.startTime
            
            let currentWeather = currentResponse.values
            
            self.temperature = currentWeather.temperature
            self.temperatureApparent = currentWeather.temperatureApparent
            let weatherCode = WeatherCode(rawValue: "\(currentWeather.weatherCode)")
            self.weatherCode = weatherCode ?? WeatherCode.unknown
            self.humidity = currentWeather.humidity
            self.precipitationType = currentWeather.precipitationType
            self.precipitationProbability = currentWeather.precipitationProbability
            self.pressureSurfaceLevel = currentWeather.pressureSurfaceLevel
            self.uvIndex = currentWeather.uvIndex
            self.visibility = currentWeather.visibility
            self.windSpeed = currentWeather.windSpeed
            
        print("Weather was successfully initialised")
        
    }
    
    enum WeatherCode: String {
        case unknown = "0"
        case clear = "1000"
        case mostlyClear = "1100"
        case partlyCloudy = "1101"
        case mostlyCloudy = "1102"
        case cloudy =  "1001"
        case fog = "2000"
        case lightFog = "2100"
        case drizzle = "4000"
        case rain = "4001"
        case lightRain = "4200"
        case heavyRain = "4201"
        case snow = "5000"
        case flurries = "5001"
        case lightSnow =  "5100"
        case heavySnow = "5101"
        case freezingDrizzle = "6000"
        case freezingRain = "6001"
        case lightFreezingRain =  "6200"
        case heavyFreezingRain =  "6201"
        case icePellets = "7000"
        case heavyIcePellets = "7101"
        case lightIcePellets = "7102"
        case thunderStorm = "8000"
    }
    
    var image: Image {
        switch weatherCode {
            case .clear:
                return Image(systemName: "sun.max.fill")
            case .cloudy:
                return Image(systemName: "cloud.fill")
            case .mostlyClear, .partlyCloudy, .mostlyCloudy:
                return Image(systemName: "cloud.sun.fill")
            case .fog, .lightFog:
                return Image(systemName: "cloud.fog.fill")
            case .drizzle:
                return Image(systemName: "cloud.drizzle.fill")
            case .lightRain, .rain:
                return Image(systemName: "cloud.rain.fill")
            case .heavyRain:
                return Image(systemName: "cloud.heavyrain.fill")
            case .snow, .flurries, .lightSnow, .heavySnow:
                return Image(systemName: "snow")
            case .freezingDrizzle:
                return Image(systemName: "thermometer.snowflake")
            case .freezingRain, .lightFreezingRain, .heavyFreezingRain:
                return Image(systemName: "cloud.rain.fill")
            case .icePellets, .heavyIcePellets, .lightIcePellets:
                return Image(systemName: "cloud.hail.fill")
            case .thunderStorm:
                return Image(systemName: "cloud.bolt.fill")
            case .unknown:
                return Image(systemName: "questionmark")
        }
    }
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

