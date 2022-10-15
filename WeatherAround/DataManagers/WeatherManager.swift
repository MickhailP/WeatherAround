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
    
    
    private var completionHandler: ((_ current: CurrentWeatherResponse,_ daily: CurrentWeatherResponse) -> Void)?

    
    /// Manage received response from downloadWeather() ,etod
    /// - Parameter completionHandler: Current and Daily weather data that has been received and decoded in downloadWeather()
    func setWeatherToModel(_ completionHandler: @escaping (_ current: CurrentWeatherResponse, _ daily: CurrentWeatherResponse) -> Void) {
        self.completionHandler = completionHandler
    }
    
    
    /// Use this method for fetching weather data from server and inset results to the completion handler of 'WeatherManager.swift
    ///
    /// This method creates API Endpoint based on location parameter. It requests data about Current and Daily weather for the specific location from weather API Server.
    /// Then decodes the responses and inserts decoded data to completion handler
    /// - Parameter location: The location's  latitude, longitude for which data should be fetched
    func downloadWeather(for location: CLLocation) async {
        print("Start fetching Weather")
        
        //Set URL for request
        let urlCurrent = APIEndPoint.currentForecast(location: location).url
        let urlDaily = APIEndPoint.dailyForecast(location: location).url
        
        print(urlDaily)
        
        do {
            
            let dataCurrent = try await Networking.shared.requestData(endpoint: urlCurrent)
            
            let dataDaily = try await Networking.shared.requestData(endpoint: urlDaily)
        
            
            let decoder = JSONDecoder()
            
            let decodedDataCurrent = try decoder.decode(CurrentWeatherResponse.self, from: dataCurrent)
            let decodedDataDaily = try decoder.decode(CurrentWeatherResponse.self, from: dataDaily)
            
            self.completionHandler?(decodedDataCurrent, decodedDataDaily)
            
            print("Weather forecast received successfully")
        } catch {
            print(error, error.localizedDescription)
        }
    }
    
    
    func downloadWeatherData(for location: CLLocation) async {
        let endpoints = [
            APIEndPoint.currentForecast(location: location).url,
            APIEndPoint.dailyForecast(location: location).url
        ]
        
       try await withThrowingTaskGroup(of: Data.self) { group in
           var weatherData: [CurrentWeatherResponse] = []
           weatherData.reserveCapacity(endpoints.count)
           
           endpoints.forEach { url in
               group.addTask {
                   try await Networking.shared.requestData(endpoint: url)
               }
           }
        }
    }
    
    func decodeData(_ data: Data) throws -> CurrentWeatherResponse {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CurrentWeatherResponse.self, from: data)
            
            return decodedData
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
}


