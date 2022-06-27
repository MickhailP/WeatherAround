//
//  WeatherService.swift
//  WeatherAround
//
//  Created by Миша Перевозчиков on 28.05.2022.
//

import Foundation
import CoreLocation
import Combine


final class WeatherManager {
    
    static let shared = WeatherManager()
    
    enum APIEndPoint {
        case currentForecast(location: CLLocation)
        case dailyForecast(location: CLLocation)
    }

    var completionHandler: ((_ current: CurrentWeatherResponse,_ daily: CurrentWeatherResponse) -> Void)?


    func setWeatherToModel(_ completionHandler: @escaping (_ current: CurrentWeatherResponse, _ daily: CurrentWeatherResponse) -> Void) {
        self.completionHandler = completionHandler
    }
    
    //Use this function to fetch weather data from server. Call the WeatherService completion handler with Weather data.
    func downloadWeather(for location: CLLocation) async {
        print("Start fetch Weather")
        
        //Set URL FOR request
        let urlCurrent = APIEndPoint.currentForecast(location: location).url
        let urlDaily = APIEndPoint.dailyForecast(location: location).url
        
        print(urlDaily)
        
        do {
            let (dataCurrent, responseCurrent) = try await URLSession.shared.data(from: urlCurrent)
            let (dataDaily, responseDaily) = try await URLSession.shared.data(from: urlDaily)
            
            
            guard (responseCurrent as? HTTPURLResponse)?.statusCode == 200 &&
                    (responseDaily as? HTTPURLResponse)?.statusCode == 200 else {
                print("There should be a code 2xx, but it is \(responseCurrent) or  \(responseDaily)")
            
                return
            }

            let decoder = JSONDecoder()
            
            let decodedDataCurrent = try decoder.decode(CurrentWeatherResponse.self, from: dataCurrent)
            let decodedDataDaily = try decoder.decode(CurrentWeatherResponse.self, from: dataDaily)
            
            self.completionHandler?(decodedDataCurrent, decodedDataDaily)
            
            print("Weather forecast received successfully")
            print(decodedDataDaily)
        } catch {
            print(error, error.localizedDescription)
        }
    }
}


