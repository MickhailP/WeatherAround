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
    
func getWeather(for location: Location) async -> WeatherObject? {
        print("CALLING \(#file) for \(location.name)")
    
        let urlCurrent = APIEndPoint.currentForecast(location: location.geoLocation).url
        let urlDaily = APIEndPoint.dailyForecast(location: location.geoLocation).url
        
        do {
            async let fetchedCurrent = fetchWeatherData(from: urlCurrent)
            async let fetchedDaily = fetchWeatherData(from: urlDaily)
            
            let weather = try await decodeWeatherData(location, (current: fetchedCurrent, daily: fetchedDaily))
            
  
            return weather
            
        } catch {
            
            print("There was an error due setting up Weather models. \n ERROR: \(error).\n DESCRIPTION: \(error.localizedDescription)")
            return nil
        }
    }
    
    
    
    /// Use this method to set up Network request for specific location and request data for Current, Hourly and Daily forecast using async call
    /// - Parameter location: Location for which data should be requested
    /// - Returns: WeatherObject instance
//    func getWeather(for location: CLLocation) async -> WeatherObject? {
//        let urlCurrent = APIEndPoint.currentForecast(location: location).url
//        let urlDaily = APIEndPoint.dailyForecast(location: location).url
//
//
//        do {
//            async let fetchedCurrent = fetchWeatherData(from: urlCurrent)
//            async let fetchedDaily = fetchWeatherData(from: urlDaily)
//
//            let weather = try await decodeWeatherData( nil,  (current: fetchedCurrent, daily: fetchedDaily))
//
//            return weather
//
//        } catch {
//
//            print("There was an error due setting up Weather models. \n ERROR: \(error).\n DESCRIPTION: \(error.localizedDescription)")
//            return nil
//        }
//    }
    
    // MARK: VER.#3
    
    /// Use this method for fetching weather data from server
    ///
    /// This method request weather data that has been specified in url based on APIEndpoint enum.
    /// Than receives the response from Networking manager and decodes in to CurrentWeatherResponse
    /// - Parameter url: URL with data  request according to Weather API
    /// - Returns: Decoded server response
    internal func fetchWeatherData(from url: URL) async throws -> Data {
        do {
            print("WEATHER DATA REQUESTED")
            let data = try await Networking.shared.requestData(endpoint: url)
            
            print("Weather data received successfully")
            return data
            
        } catch {
            
            print(error, error.localizedDescription)
            throw error
        }
    }
    
    /// Use this method for fetching weather data from server for multiple endpoints, for example for different locations at the same time
    /// - Parameter locations: Coordinates for those data should be fetched
    /// - Returns: Array of decoded Weather responses for different locations
    ///
    func fetchWeatherDataWithTaskGroup(for locations: [Location?]) async throws -> [WeatherObject] {
        print("Called", #function)
        
        
        var endpoints = [(location: Location, currentURL: URL, dailyURL: URL)]()
        
        var weatherData: [WeatherObject] = []
        //        weatherData.reserveCapacity(endpoints.count)
        
        print("WE WILL SEARCH FOR THOOSE LOCATIONS: ",locations.count)
        
        for location in locations {
            print("FOR  \(location?.name.uppercased())")
            if let location = location {
                
                let currentEndpoint = APIEndPoint.currentForecast(location: location.geoLocation).url
                let dailyEndpoint = APIEndPoint.dailyForecast(location: location.geoLocation).url
                endpoints.append((location, currentEndpoint, dailyEndpoint))
                
                print("HERE IS ENDPOINTS TUPLES COUNT", endpoints.count)
            }
        }
        return try await withThrowingTaskGroup(of: (current: Data?, daily: Data?).self) { group -> ([WeatherObject]) in
            
            
            for endpoint in endpoints {
                group.addTask {
                    do {
                        
                        let currentWeatherData = try await Networking.shared.requestData(endpoint: endpoint.currentURL)
                        let dailyWeatherData = try await Networking.shared.requestData(endpoint: endpoint.dailyURL)
                        
                        return (currentWeatherData, dailyWeatherData)
                        
                    } catch {
                        print("Data task has been failed")
                        print("ERROR calling \(#function)", error.localizedDescription)
                        return (nil, nil)
                    }
                    
                }
                print("Added a TASKS for \(endpoint.location)" )
                
                
                for try await dataResponse in group {
                    
                    let weather = try decodeWeatherData(endpoint.location, dataResponse)
                    
                    weatherData.append(weather)
                    print("ADDED WEATHER OBJECT for \(endpoint.location)")
                }
            }
            return weatherData
        }
    }
    
        
       
    
    
     func decodeWeatherData(_ location: Location?, _ dataResponse: (current: Data?, daily: Data?)) throws -> WeatherObject {
         
         print("CALLING \(#function) \(location?.name)")
         
        if let current = dataResponse.current,
           let daily = dataResponse.daily {
            
            let decodedCurrentData = try JSONDecoder().decode(WeatherResponse.self, from: current)
            let decodedDailyData = try JSONDecoder().decode(WeatherResponse.self, from: daily)
            
            let weatherObject = WeatherObject(location: location, current: decodedCurrentData, daily: decodedDailyData)
            
//            print("\(#function) MADE WEATHER OBJECT: \(weatherObject)" )
            return weatherObject
        } else {
            print("WEATHER DATA NOT DECODED")
            let weatherObject = WeatherObject(location: location)
            
            return weatherObject
        }
    }
    
    
    
    // MARK: VER.#2
    //Download from some URL and return decoded WeatherResponse to MainWeatherViewViewModel.swift trough the closure
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

}


