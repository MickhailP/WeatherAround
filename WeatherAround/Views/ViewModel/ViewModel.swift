//
//  ViewModel.swift
//  WeatherAround
//
//  Created by Миша Перевозчиков on 26.05.2022.
//

import Foundation
import SwiftUI
import Combine

@MainActor class ViewModel: ObservableObject {
    
    @ObservedObject var locationManager = LocationManager.shared
    let weatherManager = WeatherManager.shared
    
    @Published var weather: Weather?
    @Published var weatherHourly: WeatherHourly?
    @Published var weatherDaily: WeatherDaily?
    
    @Published var locationName = ""
    
    
    enum LoadingState{
        case loading, loaded, failed
    }
    
    @Published var loadingState: LoadingState = .loading
    
    private (set) var cancellables = Set<AnyCancellable>()
    
    
    init() {
        fetchWeather()
        weatherManager.setWeatherToModel { [weak self] current, daily in
            DispatchQueue.main.async {
                
                if let location = self?.locationManager.location {
                    self?.weatherManager.getLocationName(for: location) { name in
                        self?.locationName = name ?? "My location"
                    }
                } else {
                    self?.loadingState = .failed
                    print("Location not found")
                }
                
                self?.weather = Weather(apiResponse: current)
                self?.weatherHourly = WeatherHourly(apiResponse: current)
                self?.weatherDaily = WeatherDaily(apiResponse: daily)
                
                
                withAnimation(.easeInOut) {
                    self?.loadingState = .loaded
                }
            }
        }
    }
    
    func fetchWeather() {
        locationManager.$location
            .sink { [weak self] location in
                guard let location = location else {
                    self?.loadingState = .failed
                    print("Location not found")
                    return
                }
                
                Task  {
                    await self?.weatherManager.downloadWeather(for: location)
                }
            }
            .store(in: &cancellables)
    }
}





