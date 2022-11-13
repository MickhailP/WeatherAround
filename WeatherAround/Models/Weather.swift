//
//  Weather.swift
//  WeatherAround
//
//  Created by Миша Перевозчиков on 04.06.2022.
//

import Foundation
import SwiftUI


struct WeatherObject: Identifiable {
    
    let id = UUID()
    
    var currentWeather: Weather?
    var hourlyWeather: [Weather]?
    var dailyWeather:  [Weather]?
    var location: Location?
    
    init(location: Location? = nil, current apiResponse: WeatherResponse? = nil, daily: WeatherResponse? = nil) {
        
        self.location = location
        
        // Initialise current weather
        //
        if let current = apiResponse,
           let daily = daily {
            
            self.currentWeather = Weather(current: current)
            let hourIntervals = current.data.timelines[0].intervals
            // Initialise hourlyWeather
            //
            self.hourlyWeather = hourIntervals.compactMap { hour -> Weather in
                let weatherCode = WeatherCode(rawValue: "\(hour.values.weatherCode)") ?? WeatherCode.unknown
                return Weather(temperature: Int(hour.values.temperature), weatherCode: weatherCode, startTime: hour.startTime)
            }
            
            
            // Initialise dailyWeather
            //
            let dailyIntervals = daily.data.timelines[0].intervals
            self.dailyWeather = dailyIntervals.compactMap { day -> Weather in
                let weatherCode = WeatherCode(rawValue: "\(day.values.weatherCode)") ?? WeatherCode.unknown
                return Weather(temperature: Int(day.values.temperature), weatherCode: weatherCode, startTime: day.startTime)
            }
        }
        return
    }
}

//
// MARK: Hashable
//
extension WeatherObject: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

//
// MARK: Equatable
//
extension WeatherObject: Equatable {
    static func == (lhs: WeatherObject, rhs: WeatherObject) -> Bool {
        if lhs.id == rhs.id  { return true } else {
            return false
        }
    }
}

//
// MARK: Object example
//
extension WeatherObject {
    
    private init(location: Location? = nil, current: Weather, hourly: [Weather], daily: [Weather]) {
        self.location = location
        
        self.currentWeather = current
        self.hourlyWeather = hourly
        self.dailyWeather = daily
    }
    
    
    static let example = WeatherObject(current: Weather.example, hourly: exampleHourly, daily: exampleDaily)
    
    static let exampleDaily = [
        Weather(temperature: 14, weatherCode: .clear, startTime: "2022-06-05T10:00:00Z", temperatureApparent: 12, humidity: 41, precipitationProbability: 22, precipitationType: 1, pressureSurfaceLevel: 1241, uvIndex: 3, visibility: 16, windSpeed: 2.5),
        Weather(temperature: 14, weatherCode: .clear, startTime: "2022-06-05T11:00:00Z", temperatureApparent: 12, humidity: 41, precipitationProbability: 31, precipitationType: 1, pressureSurfaceLevel: 1241, uvIndex: 3, visibility: 16, windSpeed: 2.5),
        Weather(temperature: 14, weatherCode: .clear, startTime: "2022-06-05T13:00:00Z", temperatureApparent: 12, humidity: 41, precipitationProbability: 25, precipitationType: 1, pressureSurfaceLevel: 1241, uvIndex: 3, visibility: 16, windSpeed: 2.5),
        Weather(temperature: 14, weatherCode: .clear, startTime: "2022-06-05T14:00:00Z", temperatureApparent: 12, humidity: 41, precipitationProbability: 12, precipitationType: 1, pressureSurfaceLevel: 1241, uvIndex: 3, visibility: 16, windSpeed: 2.5)
    ]
    
    static let exampleHourly = [
        Weather(temperature: 14, weatherCode: .clear, startTime: "2022-06-05T11:00:00Z", temperatureApparent: 12, humidity: 41, precipitationProbability: 25, precipitationType: 1, pressureSurfaceLevel: 1241, uvIndex: 3, visibility: 16, windSpeed: 2.5),
        Weather(temperature: 14, weatherCode: .clear, startTime: "2022-06-05T12:00:00Z", temperatureApparent: 12, humidity: 41, precipitationProbability: 25, precipitationType: 1, pressureSurfaceLevel: 1241, uvIndex: 3, visibility: 16, windSpeed: 2.5),
        Weather(temperature: 14, weatherCode: .clear, startTime: "2022-06-05T13:00:00Z", temperatureApparent: 12, humidity: 41, precipitationProbability: 25, precipitationType: 1, pressureSurfaceLevel: 1241, uvIndex: 3, visibility: 16, windSpeed: 2.5),
        Weather(temperature: 14, weatherCode: .clear, startTime: "2022-06-05T14:00:00Z", temperatureApparent: 12, humidity: 41, precipitationProbability: 25, precipitationType: 1, pressureSurfaceLevel: 1241, uvIndex: 3, visibility: 16, windSpeed: 2.5)
        
    ]
   
}


struct Weather: Identifiable {
    var id = UUID()
    
    let startTime: String
    let temperature: Int
    let temperatureApparent: Double?
    
    let weatherCode: WeatherCode
    
    let humidity: Double?
    let precipitationProbability: Int?
    let precipitationType: Int?
    let pressureSurfaceLevel: Double?
    
    let uvIndex: Int?
    let visibility: Double?
    let windSpeed: Double?

    
    /// Default Initializer from API response.
    /// Use it to initialise from api response
    /// - Parameter apiResponse: apiResponse
    init(current apiResponse: WeatherResponse) {
        
        let currentResponse = apiResponse.data.timelines[0].intervals[0]
        
        self.startTime = currentResponse.startTime
        
        let values = currentResponse.values
        
        self.temperature = Int(values.temperature)
        self.temperatureApparent = values.temperatureApparent
        self.weatherCode = WeatherCode(rawValue: "\(values.weatherCode)") ?? WeatherCode.unknown
        self.humidity = values.humidity
        self.precipitationType = values.precipitationType
        self.precipitationProbability = values.precipitationProbability
        self.pressureSurfaceLevel = values.pressureSurfaceLevel
        self.uvIndex = values.uvIndex
        self.visibility = values.visibility
        self.windSpeed = values.windSpeed
        
        print("Weather was successfully initialised")
        
    }
    
    var displayedDay: String {
       
        let dateFormatter = DateFormatter()
        let ISODateFormatter = ISO8601DateFormatter()
        
        let date = ISODateFormatter.date(from: startTime)
        dateFormatter.dateFormat = "EE"
        
        let day = dateFormatter.string(from: date ?? Date.now)
        
        return day
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
    
    var precipitationDescription: String {
        switch precipitationType {
            case 1:
                return "Rain"
            case 2:
                return "Snow"
            case 3:
                return "Freezing Rain"
            case 4:
                return "Ice Pellets"
            default:
                return "Clear"
        }
    }
    
    var uvIndexDescription: String {
        if let uvIndex = uvIndex {
            switch uvIndex {
                case 0...2:
                    return "Low"
                case 3...5:
                    return "Moderate"
                case 6...7:
                    return "High"
                case 8...10:
                    return "Very high"
                case 11...:
                    return "Extreme"
                default:
                    return "Unknown"
            }
        }
        return "Unknown"
    }
    
    var feelsLikeDescription: String {
        if let temperatureApparent = temperatureApparent {
            if temperatureApparent < temperatureApparent - 3.0 {
                return "Colder that actual temperature"
            } else if temperatureApparent > temperatureApparent + 3.0 {
                return "Warmer then actual temperature"
            } else {
                return "Similar to the actual temperature"
            }
        }
        return "Temperature isn't available"
    }
    
}

//
// MARK: Weather initializer
// Use this one to initialise
extension Weather {
    
    
    /// Use this initialiser to set data manually
    init(temperature: Int, weatherCode: WeatherCode, startTime: String,
         temperatureApparent: Double? = nil, humidity: Double? = nil,
         precipitationProbability: Int? = nil, precipitationType: Int? = nil,
         pressureSurfaceLevel: Double? = nil,  uvIndex: Int? = nil,
         visibility: Double? = nil, windSpeed: Double? = nil) {
        
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
    
    static let example = Weather(temperature: 14, weatherCode: .clear,
                                 startTime: "2022-06-05T10:00:00Z",
                                 temperatureApparent: 12, humidity: 41,
                                 precipitationProbability: 25, precipitationType: 1,
                                 pressureSurfaceLevel: 1241, uvIndex: 3,
                                 visibility: 16, windSpeed: 2.5)
    
}

enum PrecipitationCode: Int {
    case unknown = 0
    case rain = 1
    case snow = 2
    case freezingRain = 3
    case icePellets = 4
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

