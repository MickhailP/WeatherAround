//
//  ViewModel.swift
//  WeatherAround
//
//  Created by Миша Перевозчиков on 26.05.2022.
//

import Foundation
import CoreLocation

@MainActor class ViewModel: ObservableObject {
    
    let weatherAPI: WeatherService

    
    @Published var weather: Weather?
    @Published var weatherHourly: WeatherHourly?
    

    init(weatherAPI: WeatherService) {
        self.weatherAPI = weatherAPI
        
    }
    
    func refresh() {
        weatherAPI.getLocation { [weak self] weatherResponse in
            DispatchQueue.main.async {
//                self.oneCallWeather = weather
                self?.weather = Weather(apiResponse: weatherResponse)
                self?.weatherHourly = WeatherHourly(apiResponse: weatherResponse)
                print(self?.weather)
                print(self?.weatherHourly?.weatherHourly)
                print(self?.weatherHourly?.weatherHourly.count)
            }
        }
    }
    
}




