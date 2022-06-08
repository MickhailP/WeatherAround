//
//  Weather.swift
//  WeatherAround
//
//  Created by Миша Перевозчиков on 04.06.2022.
//

import Foundation
import SwiftUI

struct WeatherHourly {
    let weatherHourly: [Weather]
    
    init(apiResponse: CurrentWeatherResponse){
        let hourIntervals = apiResponse.data.timelines[0].intervals
        
        var tempHourlyWeather = [Weather]()
        
        for hour in hourIntervals {
            let weatherCode = WeatherCode(rawValue: "\(hour.values.weatherCode)") ?? WeatherCode.unknown
            let weather = Weather(temperature: hour.values.temperature, weatherCode: weatherCode, startTime: hour.startTime)
            tempHourlyWeather.append(weather)
        }
        
        self.weatherHourly = tempHourlyWeather
    }
    init(array: [Weather]) {
        self.weatherHourly = array
    }
    
    static let example = WeatherHourly(array: [
        Weather(temperature: 14, weatherCode: .clear, startTime: "2022-06-05T11:00:00Z", temperatureApparent: 12, humidity: 41, precipitationProbability: 25, precipitationType: 1, pressureSurfaceLevel: 1241, uvIndex: 3, visibility: 16, windSpeed: 2.5),
        Weather(temperature: 14, weatherCode: .clear, startTime: "2022-06-05T12:00:00Z", temperatureApparent: 12, humidity: 41, precipitationProbability: 25, precipitationType: 1, pressureSurfaceLevel: 1241, uvIndex: 3, visibility: 16, windSpeed: 2.5),
        Weather(temperature: 14, weatherCode: .clear, startTime: "2022-06-05T13:00:00Z", temperatureApparent: 12, humidity: 41, precipitationProbability: 25, precipitationType: 1, pressureSurfaceLevel: 1241, uvIndex: 3, visibility: 16, windSpeed: 2.5),
        Weather(temperature: 14, weatherCode: .clear, startTime: "2022-06-05T14:00:00Z", temperatureApparent: 12, humidity: 41, precipitationProbability: 25, precipitationType: 1, pressureSurfaceLevel: 1241, uvIndex: 3, visibility: 16, windSpeed: 2.5)
        
    ])
}


struct Weather: Identifiable {
    let id = UUID()
    
    let startTime: String?
    let temperature: Double
    let temperatureApparent: Double?
    
    let weatherCode: WeatherCode
    
    let humidity: Double?
    let precipitationProbability: Int?
    let precipitationType: Int?
    let pressureSurfaceLevel: Double?
    
    let uvIndex: Int?
    let visibility: Double?
    let windSpeed: Double?
    
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
    
    var description: String {
        switch weatherCode {
            case .unknown:
                return "Unknown"
            case .clear:
                return "Clear"
            case .mostlyClear:
                return "Mostly clear"
            case .partlyCloudy:
                return "Partly cloudy"
            case .mostlyCloudy:
                return "Mostly cloudy"
            case .cloudy:
                return "Cloudy"
            case .fog:
                return "Fog"
            case .lightFog:
                return "Light fog"
            case .drizzle:
                return "Drizzle"
            case .rain:
                return "Rain"
            case .lightRain:
                return "Light rain"
            case .heavyRain:
                return "Heavy rain"
            case .snow:
                return "Snow"
            case .flurries:
                return "Flurries"
            case .lightSnow:
                return "Light snow"
            case .heavySnow:
                return "Heavy snow"
            case .freezingDrizzle:
                return "Freezing drizzle"
            case .freezingRain:
                return "Freezing rain"
            case .lightFreezingRain:
                return "Light freezing rain"
            case .heavyFreezingRain:
                return "Heavy freezing rain"
            case .icePellets:
                return "Ice pellets"
            case .heavyIcePellets:
                return "Heavy ice pellets"
            case .lightIcePellets:
                return "Light ice pellets"
            case .thunderStorm:
                return "Thunder strom"
        }
    }
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

extension Weather {
    
    init(temperature: Double, weatherCode: WeatherCode, startTime: String , temperatureApparent: Double? = nil, humidity: Double? = nil, precipitationProbability: Int? = nil, precipitationType: Int? = nil, pressureSurfaceLevel: Double? = nil,  uvIndex: Int? = nil, visibility: Double? = nil, windSpeed: Double? = nil) {
        self.temperature = temperature
        self.weatherCode = weatherCode
        self.startTime = startTime
        
        
        self.temperatureApparent = temperatureApparent
        self.humidity = humidity
        self.precipitationType = precipitationType
        self.precipitationProbability = precipitationProbability
        self.pressureSurfaceLevel = pressureSurfaceLevel
        self.uvIndex = uvIndex
        self.visibility = visibility
        self.windSpeed = windSpeed
    }
    
    static let example = Weather(temperature: 14, weatherCode: .clear, startTime: "2022-06-05T10:00:00Z", temperatureApparent: 12, humidity: 41, precipitationProbability: 25, precipitationType: 1, pressureSurfaceLevel: 1241, uvIndex: 3, visibility: 16, windSpeed: 2.5)
    
}
