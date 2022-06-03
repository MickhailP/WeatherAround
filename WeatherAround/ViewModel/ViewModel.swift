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
    @Published var forecast: WeatherResponse?

    init(weatherAPI: WeatherService) {
        self.weatherAPI = weatherAPI
    }
    
    func refresh() {
        weatherAPI.getLocation { weather in
            DispatchQueue.main.async {
                self.forecast = weather
                print(self.forecast)
            }
         
        }
    }
    
}




