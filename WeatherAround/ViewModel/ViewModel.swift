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
    
    @ObservedObject private var locationManager = LocationManager.shared
    private let weatherManager = WeatherManager.shared
    
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
                
                //Set up location name
                if let location = self?.locationManager.location {
                    self?.locationManager.getLocationName(for: location) { name in
                        self?.locationName = name ?? "My location"
                    }
                } else {
                    self?.loadingState = .failed
                    print("Location is not available ")
                }
                
                //Initialise Weather instances based on decoded Weather data
                self?.weather = Weather(apiResponse: current)
                self?.weatherHourly = WeatherHourly(apiResponse: current)
                self?.weatherDaily = WeatherDaily(apiResponse: daily)
                
                //Dismiss LoadingView
                withAnimation(.easeIn) {
                    self?.loadingState = .loaded
                }
            }
        }
    }
    
    /// Use this method to get the location from LocationManager and request downloading a Weather data.
    ///
    ///  It requests data downloading through WeatherManager when LocationManager has published location data.
    func fetchWeather() {
        locationManager.$location
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] location in
                Task  {
                    await self?.weatherManager.downloadWeather(for: location)
                }
            }
            .store(in: &cancellables)
    }
}





