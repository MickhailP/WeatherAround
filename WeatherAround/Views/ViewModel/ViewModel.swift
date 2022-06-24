//
//  ViewModel.swift
//  WeatherAround
//
//  Created by Миша Перевозчиков on 26.05.2022.
//

import Foundation
import CoreLocation
import SwiftUI

@MainActor class ViewModel: ObservableObject {
    
    let weatherService = WeatherService.shared
//    let locationManager = LocationManager()
    
    @Published var weather: Weather?
    @Published var weatherHourly: WeatherHourly?
    
    
    
    @Published var locationName = ""
    
    
    enum LoadingState{
        case loading, loaded, failed
    }
    
    @Published var loadingState: LoadingState = .loading
    
    
    init() {
        
        refresh()
      
//        getWeather()
    }
    
    func refresh() {
        weatherService.getLocation { [weak self] weatherResponse in
            DispatchQueue.main.async {
                
                self?.weather = Weather(apiResponse: weatherResponse)
                self?.weatherHourly = WeatherHourly(apiResponse: weatherResponse)
                
                
                if let location = self?.weatherService.location {
                    self?.weatherService.getLocationName(for: location) { name in
                        self?.locationName = name ?? "My location"
                    }
                }
                withAnimation(.easeInOut) {
                    self?.loadingState = .loaded
                }
            }
        }
    }
    
    
//    func getWeather() {
//
//        guard let location = locationManager.location  else {
//            print("There is no location")
//            return
//        }
//        Task {
//            await weatherService.downloadWeather(for: location) { [weak self] weatherResponse in
//                DispatchQueue.main.async {
//
//                    self?.weather = Weather(apiResponse: weatherResponse)
//                    self?.weatherHourly = WeatherHourly(apiResponse: weatherResponse)
//
//
//                    if let location = self?.weatherService.location {
//                        self?.weatherService.getLocationName(for: location) { name in
//                            self?.locationName = name ?? "My location"
//                        }
//                    }
//                    withAnimation(.easeInOut) {
//                        self?.loadingState = .loaded
//                    }
//                }
//
//            }
//        }
//    }
    
    
}





