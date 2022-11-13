//
//  WeatherManagerProtocol.swift
//  WeatherAround
//
//  Created by Миша Перевозчиков on 18.10.2022.
//

import Foundation
import CoreLocation

protocol WeatherManagerProtocol {
    
//    func getWeather(for location: CLLocation) async -> WeatherObject?
    func getWeather(for location: Location) async -> WeatherObject?
    
    func decodeWeatherData(_ location: Location?, _ dataResponse: (current: Data?, daily: Data?)) throws -> WeatherObject
    
    func fetchWeatherDataWithTaskGroup(for locations: [Location?]) async throws -> [WeatherObject]
    
    func download(from url: URL, completion: @escaping (_ weatherData: WeatherResponse) async -> Void) async throws
}
