//
//  WeatherManagerProtocol.swift
//  WeatherAround
//
//  Created by Миша Перевозчиков on 18.10.2022.
//

import Foundation
import CoreLocation

protocol WeatherManagerProtocol {
    
    func getWeather(for location: CLLocation) async -> WeatherObject?
    
    func fetchWeatherData(from url: URL) async throws -> WeatherResponse
    
    func fetchWeatherDataWithTaskGroup(for locations: [Location?]) async throws -> [(locationData: Location, weatherData: WeatherObject)]
    
    func download(from url: URL, completion: @escaping (_ weatherData: WeatherResponse) async -> Void) async throws
}
