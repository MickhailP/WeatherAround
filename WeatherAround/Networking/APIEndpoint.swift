//
//  APIEndpoits.swift
//  WeatherAround
//
//  Created by Миша Перевозчиков on 24.06.2022.
//

import CoreLocation
import Foundation


/// Use this enum to set up URL components to make a request to TOMORROW.IO  API
enum APIEndPoint {
    case currentForecast(location: CLLocation)
    case dailyForecast(location: CLLocation)
}

extension APIEndPoint {
    
    //MARK: APIKeys
    //This properties configure URL parameters
    private static let currentWeatherAPIKey = APIKeys.currentWeatherAPIKey
    
    //MARK:  Date parameters
    private static let dateFormatter = ISO8601DateFormatter()
    private static let startTimeFormatted = dateFormatter.string(from: Date.now)
    
    
    //MARK: Time settings
    //ATTENTION!! FORCE UNWRAPPED OPTIONAL
    private static let endTimeFormatted = dateFormatter.string(from: Calendar.current.date(byAdding: DateComponents(day: 1), to: Date.now)!)
    private static let endTimeForDailyFormatted = dateFormatter.string(from: Calendar.current.date(byAdding: DateComponents(day: 10), to: Date.now)!)
    
    //MARK: URL compose
    var url: URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.tomorrow.io"
        urlComponents.path = self.path
        urlComponents.queryItems = self.queryItems
        
        guard let urlComponents = urlComponents.url else {
            fatalError("Failed to construct URL")
        }
        return urlComponents
    }
    

    //MARK: Path
    var path: String {
        switch self {
            case .currentForecast:
                return "/v4/timelines"
            case .dailyForecast:
                return "/v4/timelines"
        }
    }
    
    //MARK: QueryItems
    //Setup your queryItems for data that should be received from server
    var queryItems: [URLQueryItem]? {
        switch self {
            case .currentForecast(let location):
                return [
                    URLQueryItem(name: "location", value: "\(location.coordinate.latitude),\(location.coordinate.longitude)"),
                    URLQueryItem(name: "fields", value: "temperature"),
                    URLQueryItem(name: "fields", value: "temperatureApparent"),
                    URLQueryItem(name: "fields", value: "humidity"),
                    URLQueryItem(name: "fields", value: "windSpeed"),
                    URLQueryItem(name: "fields", value: "pressureSurfaceLevel"),
                    URLQueryItem(name: "fields", value: "precipitationProbability"),
                    URLQueryItem(name: "fields", value: "precipitationType"),
                    URLQueryItem(name: "fields", value: "visibility"),
                    URLQueryItem(name: "fields", value: "uvIndex"),
                    URLQueryItem(name: "fields", value: "weatherCode"),
                    URLQueryItem(name: "units", value: "metric"),
                    URLQueryItem(name: "timesteps", value: "1h"),
                    URLQueryItem(name: "startTime", value: "\(Self.startTimeFormatted)"),
                    URLQueryItem(name: "endTime", value: "\(Self.endTimeFormatted)"),
                    URLQueryItem(name: "apikey", value: "\(Self.currentWeatherAPIKey)")
                ]
            case .dailyForecast(let location):
                return [
                    URLQueryItem(name: "location", value: "\(location.coordinate.latitude),\(location.coordinate.longitude)"),
                    URLQueryItem(name: "fields", value: "temperature"),
                    URLQueryItem(name: "fields", value: "weatherCode"),
                    URLQueryItem(name: "timesteps", value: "1d"),
                    URLQueryItem(name: "startTime", value: "\(Self.startTimeFormatted)"),
                    URLQueryItem(name: "endTime", value: "\(Self.endTimeForDailyFormatted)"),
                    URLQueryItem(name: "apikey", value: "\(Self.currentWeatherAPIKey)")
                ]
        }
    }
}


