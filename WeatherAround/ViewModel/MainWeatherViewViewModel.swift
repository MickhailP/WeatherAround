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
    
    // Managers
    @ObservedObject private var locationManager = LocationManager.shared
    private let weatherManager: WeatherManagerProtocol
    
    
    // Weather instances
    @Published var currentWeather: Weather?
    @Published var hourlyWeather: [Weather]?
    @Published var dailyWeather: [Weather]?
    
    @Published var location: Location?

    
    // UI properties
    @Published var locationName: String = ""
    @Published var loadingState: LoadingState = .loading
    
    private (set) var cancellables = Set<AnyCancellable>()
    
    // MARK: Init from scratch
    /// Use this initialiser to set MainWeatherViewViewModel
    /// - Parameter weatherManager: Weather manager instance, that supports WeatherManager Protocol
    init(from weatherObject: WeatherObject? = nil, weatherManager: WeatherManagerProtocol) {
        
        self.weatherManager = weatherManager
        
        if let weatherObject = weatherObject {
            _currentWeather = Published(wrappedValue: weatherObject.currentWeather)
            _hourlyWeather = Published(wrappedValue: weatherObject.hourlyWeather)
            _dailyWeather = Published(wrappedValue: weatherObject.dailyWeather)
            _location = Published(wrappedValue: weatherObject.location)
            
            if let locationName = weatherObject.location {
                self.locationName = locationName.name
            }
        } else{
            
            print("INITIALISE STARTS. LOADING STATE: \(loadingState)")
            fetchLocationAndWeather()
        }
        
        self.loadingState = .loaded

    }

    
    /// This method listen LocationManager publisher, then user's location has been received it sets location name and requests a Weather data for it.
    func fetchLocationAndWeather() {
        print("CALLING: \(#function)")
        
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
                self?.setLocation(location) { location in
                    print("Location received by \(#file)")
                    self?.getWeatherAndSetModel(for: location)
                    self?.loadingState = .loaded
                }
             print("INIT DONE")
            }
            .store(in: &cancellables)
    }
    
    /// This method sets up Published properties in VM
    /// - Parameter location: CLLocation instance that holds location data for which data should be requested and set to a MainWeatherViewModel
    func getWeatherAndSetModel(for location: Location) {
        print("CALLING \(#function) for \(location.name)")
        
        Task {
            if let weatherObject = await weatherManager.getWeather(for: location) {
                
//                print(weatherObject)
                currentWeather = weatherObject.currentWeather
                hourlyWeather = weatherObject.hourlyWeather
                dailyWeather = weatherObject.dailyWeather
                 
                print(hourlyWeather as AnyObject)
    
                
            } else {
                print("FAIL")
                loadingState = .failed
            }
        }
    }
    
    private func setLocation(_ location: CLLocation?, completion: @escaping (_ location: Location) -> Void) {
        print("CALLING \(#function)")
        
        if let location = location  {
            self.locationManager.returnPlaceMark(for: location) { placemark in
                guard let placemark = placemark else {
                    print("PlaceMark data is not available ")
                    return
                }
                
                if let name = placemark.locality,
                   let country = placemark.country,
                   let geoLocation = placemark.location {
                    
                   let newLocation = Location(name: name, country: country,  geoLocation: geoLocation)
                    
                    self.location = newLocation
                
                 completion(newLocation)
                } else {
                    print("Failed to set Location data")
                }
            }
        }
    }
    
//    // The method sets user's location name that has been received from  Location Manager
//    /// - Parameter location: CLLocation data that hold information about user's location
//    private func setLocationName(_ location: CLLocation?) {
//        if let location = location {
//            self.locationManager.getLocationName(for: location) { name in
//                self.locationName = name ?? "My location"
//            }
//        } else {
//            print("Location name is not available ")
//        }
//    }
    
    
    
    
}

// MARK: Init from WeatherObject
extension MainWeatherViewViewModel{
    
    /// Use this initialiser for creating MainWeatherViewViewModel from existing data
    /// - Parameters:
    ///   - weatherObject: WeatherObject instance that hold weather data
    ///   - location: Location instance that holds location data
    ///   - weatherManager: Weather manager
    ///

}



//    func getCurrentAndDailyWeather(for location: CLLocation)  {
//
//        let urlCurrent = APIEndPoint.currentForecast(location: location).url
//        let urlDaily = APIEndPoint.dailyForecast(location: location).url
//
//        Task {
//            do {
//                async let fetchedCurrent = self.weatherManager.fetchWeatherData(from: urlCurrent)
//                async let fetchedDaily = self.weatherManager.fetchWeatherData(from: urlDaily)
//
//                try await self.weather = Weather(current: fetchedCurrent)
//                try await self.weatherHourly = WeatherHourly(apiResponse: fetchedCurrent)
//                try  await self.weatherDaily = WeatherDaily(apiResponse: fetchedDaily)
//
//                self.loadingState = .loaded
//                print("LOADING STATE: \(loadingState)")
//
//            } catch {
//                self.loadingState = .failed
//                print("There was an error due setting up Weather models. \n ERROR: \(error).\n DESCRIPTION: \(error.localizedDescription)")
//                print("LOADING STATE: \(loadingState)")
//
//            }
//        }
//    }

// MARK: VER. 2
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

// MARK: VER. 1
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


// MARK: VER.1 methods
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






