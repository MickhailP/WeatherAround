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
//    @Published var oneCallWeather: OneCallWeatherResponse?
    
    @Published var currentWeather: CurrentWeatherResponse?
    
    @Published var temperature = "--º"
    @Published var maxTemp = ""
    @Published var lowTemp = ""
    

    init(weatherAPI: WeatherService) {
        self.weatherAPI = weatherAPI
    }
    
    func refresh() {
        weatherAPI.getLocation { weatherResponse in
            DispatchQueue.main.async {
//                self.oneCallWeather = weather
                self.currentWeather = weatherResponse

                
                print(self.currentWeather)
            }
         
        }
    }
    
}




