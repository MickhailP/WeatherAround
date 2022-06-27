//
//  WeatherServiceExtensions.swift
//  WeatherAround
//
//  Created by Миша Перевозчиков on 24.06.2022.
//

import CoreLocation
import Foundation

extension WeatherManager.APIEndPoint {
    
    //This properties configure URL parameters
    private static let currentWeatherAPIKey = APIKeys.currentWeatherAPIKey
    
    //Date parameters
    private static let dateFormatter = ISO8601DateFormatter()
    private static let startTimeFormatted = dateFormatter.string(from: Date.now)

    
    //ATTENTION!! FORCE UNWRAPPED OPTIONAL
    private static let endTimeFormatted = dateFormatter.string(from: Calendar.current.date(byAdding: DateComponents(day: 1), to: Date.now)!)
    private static let endTimeForDailyFormatted = dateFormatter.string(from: Calendar.current.date(byAdding: DateComponents(day: 10), to: Date.now)!)
    
    var url: URL {
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.path = path
        urlComponents?.queryItems = queryItems
        
        guard let urlComponents = urlComponents?.url else {
            fatalError("Invalid URL")
        }
        return urlComponents
    }
    
    var baseURL: String {
        switch self {
            case .currentForecast:
                return "https://api.tomorrow.io"
            case .dailyForecast:
                return "https://api.tomorrow.io"
        }
    }
    
    var path: String {
        switch self {
            case .currentForecast:
                return "/v4/timelines"
            case .dailyForecast:
                return "/v4/timelines"
        }
    }
    
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



//The functionality to update user's location name
extension WeatherManager {
    
    //Use this function to decode current location to locality name
    func getLocationName(for location: CLLocation, completionHandler: @escaping (String?) -> Void ) {
        //create a CLGeocoder instance
        let geocoder = CLGeocoder()
        
        //Look up a location and pass it in to closure
        geocoder.reverseGeocodeLocation(location, preferredLocale: .current) { placemark, error in
            
            //Check if location available
            guard let place = placemark?.first, error == nil else {
                //An error occurred during decoding
                completionHandler(nil)
                print("Failed to get placemark from location")
                return
            }
            // To see all available options of placemark
            print(place)
            
            var name = "My location"
        
            if let locality = place.locality {
                name = locality
            }
            
            //Decoding was successful, call completion handler with locality name
            completionHandler(name)
        }
    }
}
