//
//  WeatherService.swift
//  WeatherAround
//
//  Created by Миша Перевозчиков on 28.05.2022.
//

import Foundation
import CoreLocation
import Combine
import UIKit

final class WeatherManager: WeatherManagerProtocol {
    
    //
    // Prototype
    //
    func getWeather(for location: CLLocation) async -> WeatherObject? {
        let urlCurrent = APIEndPoint.currentForecast(location: location).url
        let urlDaily = APIEndPoint.dailyForecast(location: location).url
        
        
        do {
            async let fetchedCurrent = fetchWeatherData(from: urlCurrent)
            async let fetchedDaily = fetchWeatherData(from: urlDaily)
            
            let weather = try await WeatherObject(current: fetchedCurrent, daily: fetchedDaily)

            return weather
            
        } catch {
            
            print("There was an error due setting up Weather models. \n ERROR: \(error).\n DESCRIPTION: \(error.localizedDescription)")
            return nil
            
        }
    }
    
    // MARK: VER.#3
    
    /// Use this method for fetching weather data from server
    ///
    /// This method request weather data that has been specified in url based on APIEndpoint enum.
    /// Than receives the response from Networking manager and decodes in to CurrentWeatherResponse
    /// - Parameter url: URL with data  request according to Weather API
    /// - Returns: Decoded server response
    func fetchWeatherData(from url: URL) async throws -> WeatherResponse {
        do {
            print("WEATHER DATA REQUESTED")
            let data = try await Networking.shared.requestData(endpoint: url)
            
            let decoder = JSONDecoder()
            
            let decodedData = try decoder.decode(WeatherResponse.self, from: data)
            
            
            print("Weather forecast received successfully")
            return decodedData
            
        } catch {
            
            print(error, error.localizedDescription)
            throw error
        }
    }
    
    
    /// Use this method for fetching weather data from server for multiple endpoints, for example for different locations at the same time
    /// - Parameter locations: Coordinates for those data should be fetched
    /// - Returns: Array of decoded Weather responses for different locations
    func fetchWeatherDataWithTaskGroup(for locations: [CLLocation?]) async throws -> [WeatherResponse] {
        
        var endpoints = [URL]()
        var responses = [WeatherResponse]()
        
        for location in locations {
            if let location = location {
                let newURL = APIEndPoint.currentForecast(location: location).url
                endpoints.append(newURL)
            }
        }
        
        return try await withThrowingTaskGroup(of: Data.self) { group in
            var weatherData: [WeatherResponse] = []
            weatherData.reserveCapacity(endpoints.count)
            
            endpoints.forEach { url in
                group.addTask {
                    try await Networking.shared.requestData(endpoint: url)
                }
            }
            
            for try await dataResponse in group {
                
                let decoder = JSONDecoder()
                
                let decodedData = try decoder.decode(WeatherResponse.self, from: dataResponse)
                responses.append(decodedData)
                
            }
            return responses
        }
    }
    
    
    // MARK: VER.#2
    //Download from some URL and return decoded CurrentWeatherResponse to MainWeatherViewViewModel.swift trough the closure
    //More universal variant
    func download(from url: URL, completion: @escaping (_ weatherData: WeatherResponse) async -> Void) async throws {
        do {
            print("WEATHER DATA REQUESTED")
            let data = try await Networking.shared.requestData(endpoint: url)
            
            let decoder = JSONDecoder()
            
            let decodedData = try decoder.decode(WeatherResponse.self, from: data)
            
            await completion(decodedData)
            
            print("Weather forecast received successfully")
        } catch {
            print(error, error.localizedDescription)
            throw error
        }
    }
    
    // MARK: VER.#1. Fetching trough the closures
    //Async loading two responses for specific location and sending response in tuple to the MainWeatherViewViewModel.swift trough the closure
    /*
     private var completionHandler: ((_ current: CurrentWeatherResponse,_ daily: CurrentWeatherResponse) -> Void)?
     
     
     /// Manage received response from downloadWeather() ,metod
     /// - Parameter completionHandler: Current and Daily weather data that has been received and decoded in downloadWeather()
     func setWeatherToModel(_ completionHandler: @escaping (_ current: CurrentWeatherResponse, _ daily: CurrentWeatherResponse) -> Void) {
     self.completionHandler = completionHandler
     }
     
     /// Use this method for fetching weather data from server and insert results to the completion handler of 'WeatherManager.swift
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
     */
    
    
    
    // MARK: DECODE METHOD
    //MAY BE USEFUL SOMEWHERE ELSE
    /*
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
     */
}


