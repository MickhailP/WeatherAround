//
//  ViewModel.swift
//  WeatherAround
//
//  Created by Миша Перевозчиков on 26.05.2022.
//

import Foundation
import SwiftUI
import Combine
import CoreLocation

final class MainWeatherViewViewModel: ObservableObject {
    
    //Managers
    @ObservedObject private var locationManager = LocationManager.shared
    private let weatherManager: WeatherManagerProtocol
    
    
    
    //Weather instances
    @Published var weather: Weather?
    @Published var weatherHourly: WeatherHourly?
    @Published var weatherDaily: WeatherDaily?
    
    //UI properties
    @Published var locationName: String = ""
    @Published var loadingState: LoadingState = .loading
    
    private (set) var cancellables = Set<AnyCancellable>()
    
    //MARK: Ver.3
    init(weatherManager: WeatherManagerProtocol) {
        self.weatherManager = weatherManager
        
        print("INITIALISE STARTS. LOADING STATE: \(loadingState)")
        fetchLocationAndWeather()
        
    }
    
    init(location: Location? = nil, weatherManager: WeatherManagerProtocol) {
        self.weatherManager = weatherManager
        
        if let location = location {
            if location.weather == nil &&
                location.weatherDaily == nil &&
                location.weatherHourly == nil {
                getCurrentAndDailyWeather(for: location.geoLocation)
                
            } else {
                _weather = Published(wrappedValue: location.weather)
                _weatherHourly = Published(wrappedValue: location.weatherHourly)
                _weatherDaily = Published(wrappedValue:location.weatherDaily)
            }
            
            self.locationName = location.name
        } else {
            fetchLocationAndWeather()
        }
    }
    
   
    func setLocationName(_ location: CLLocation?) {
        if let location = location {
            self.locationManager.getLocationName(for: location) { name in
                self.locationName = name ?? "My location"
            }
        } else {
            print("Location name is not available ")
        }
    }
    
    func fetchLocationAndWeather() {
        locationManager.$location
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { completion in
                switch completion {
                    case .finished:
                        print("Location has been set up.")
                        break
                    case .failure(let error):
                        withAnimation(.easeIn) {
                            self.loadingState = .failed
                        }
                        print("There was an error: \(error). Fetching location hasn't done.")
                }
            } receiveValue: { [ weak self ] location in
                self?.setLocationName(location)
                self?.getCurrentAndDailyWeather(for: location)
            }
            .store(in: &cancellables)
    }
    
    func getCurrentAndDailyWeather(for location: CLLocation)  {
        
        let urlCurrent = APIEndPoint.currentForecast(location: location).url
        let urlDaily = APIEndPoint.dailyForecast(location: location).url
        
        Task {
            do {
                async let fetchedCurrent = self.weatherManager.fetchWeatherData(from: urlCurrent)
                async let fetchedDaily = self.weatherManager.fetchWeatherData(from: urlDaily)
                
                try await self.weather = Weather(apiResponse: fetchedCurrent)
                try await self.weatherHourly = WeatherHourly(apiResponse: fetchedCurrent)
                try  await self.weatherDaily = WeatherDaily(apiResponse: fetchedDaily)
                
                self.loadingState = .loaded
                print("LOADING STATE: \(loadingState)")
               
            } catch {
                self.loadingState = .failed
                print("There was an error due setting up Weather models. \n ERROR: \(error).\n DESCRIPTION: \(error.localizedDescription)")
                print("LOADING STATE: \(loadingState)")
                
            }
        }
    }
    
    //MARK: VER. 2
    /*
    //    init() {
    //        fetchWeather2()
    //
    //        if let location = self.locationManager.location {
    //            self.locationManager.getLocationName(for: location) { name in
    //                self.locationName = name ?? "My location"
    //            }
    //        } else {
    //            print("Location name is not available ")
    //        }
    //        print(loadingState)
    //    }
     */
    
    //MARK: VER. 1
    /*
    //    init() {
    //        fetchWeather()
    //
    //        if let location = self.locationManager.location {
    //            self.locationManager.getLocationName(for: location) { name in
    //                self.locationName = name ?? "My location"
    //            }
    //        } else {
    //            self.loadingState = .failed
    //            print("Location is not available ")
    //        }
    //
    //        weatherManager.setWeatherToModel { [weak self] current, daily in
    //            DispatchQueue.main.async {
    //
    //                //Set up location name
    //
    //
    //                //Initialise Weather instances based on decoded Weather data
    //                self?.weather = Weather(apiResponse: current)
    //                self?.weatherHourly = WeatherHourly(apiResponse: current)
    //                self?.weatherDaily = WeatherDaily(apiResponse: daily)
    //
    //                //Dismiss LoadingView
    //                withAnimation(.easeIn) {
    //                    self?.loadingState = .loaded
    //                }
    //            }
    //
    //        }
    //
    //    }
   
    
    /// Use this method to get the location from LocationManager and request downloading a Weather data.
    ///
    ///  It requests data downloading through WeatherManager when LocationManager has published location data.
//    func fetchWeather() {
//        locationManager.$location
//            .receive(on: DispatchQueue.main)
//            .compactMap { $0 }
//            .sink { [weak self] location in
//                Task  {
//                    await self?.weatherManager.downloadWeather(for: location)
//                }
//            }
//            .store(in: &cancellables)
//    }
     */
    
    
    //MARK: VER.1 methods
    /*
//    func fetchWeather2() {
//
//        locationManager.$location
//            .receive(on: DispatchQueue.main)
//            .compactMap { $0 }
//            .sink { completion in
//                switch completion {
//                    case .finished:
//                        withAnimation(.easeIn) {
//                            self.loadingState = .loaded
//                        }
//                        print("Fetching task has been done.")
//                        break
//                    case .failure(let error):
//                        withAnimation(.easeIn) {
//                            self.loadingState = .failed
//                        }
//                        print("There was an error: \(error). Fetching task hasn't done.")
//                }
//            } receiveValue: { [ weak self ] location in
//                let urlCurrent = APIEndPoint.currentForecast(location: location).url
//                let urlDaily = APIEndPoint.dailyForecast(location: location).url
//
//                self?.setLocationName(location)
//
//                Task {
//                    await self?.weatherManager.download(from: urlCurrent) { weatherDataCurrent in
//                        DispatchQueue.main.async{
//                            self?.weather = Weather(apiResponse: weatherDataCurrent)
//                            self?.weatherHourly = WeatherHourly(apiResponse: weatherDataCurrent)
//                        }
//                    }
//                }
//                Task {
//                    await self?.weatherManager.download(from: urlDaily) { weatherDataDaily in
//                        DispatchQueue.main.async {
//                            self?.weatherDaily = WeatherDaily(apiResponse: weatherDataDaily)
//                        }
//                    }
//                }
////                self?.loadingState = .loaded
//            }
//            .store(in: &cancellables)
//    }
     */
        
    }
    
    
    
    
