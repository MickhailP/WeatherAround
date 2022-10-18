//
//  WeatherManagerProtocol.swift
//  WeatherAround
//
//  Created by Миша Перевозчиков on 18.10.2022.
//

import Foundation
import CoreLocation

protocol WeatherManagerProtocol {
    
    func fetchWeatherData(from url: URL) async throws -> CurrentWeatherResponse
    
    func fetchWeatherDataWithTaskGroup(for locations: [CLLocation?]) async throws -> [CurrentWeatherResponse]
    
    func download(from url: URL, completion: @escaping (_ weatherData: CurrentWeatherResponse) async -> Void) async throws
}
