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
    
    // FetchingError alert
    @Published var showFetchingAlert: Bool = false
    @Published var errorCode: Error?
    
    private (set) var cancellables = Set<AnyCancellable>()
    
    
    /// Use this initialiser to set MainWeatherViewViewModel
    ///
    ///The view model initialise by this init()  in two ways.
    ///By default WeatherObject is set to nil and in this case it will cal fetchLocationAndWeather() to initialise ViewModel from scratch
    ///If you pass a WeatherObject to it than ViewModel will create from data that this object holds
    /// - Parameter weatherManager: Weather manager instance, that supports WeatherManager Protocol
    /// - Parameter weatherObject: Weather Object from which MainView will be create
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
            
            self.loadingState = .loaded
            
        } else {
            fetchLocationAndWeather()
        }

    }

    
    /// This method listen LocationManager publisher, then user's location has been received it sets location model  and requests a Weather data for it.
    private func fetchLocationAndWeather() {
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
                    print("DATA HAS BEEN SET")
                }
            }
            .store(in: &cancellables)
    }
    
    /// This method sets up Published properties in VM
    /// - Parameter location: Location instance that holds location data for which data should be requested and set to a MainWeatherViewModel properties
    private func getWeatherAndSetModel(for location: Location) {
        print("CALLING \(#function) for \(location.name)")
        
        Task {
            do {
                if let weatherObject = try await weatherManager.getWeather(for: location) {
                    
                    await MainActor.run(body: {
                        currentWeather = weatherObject.currentWeather
                        hourlyWeather = weatherObject.hourlyWeather
                        dailyWeather = weatherObject.dailyWeather
                    })
                    
                } else {
                        print("FAIL. Decoding Error")
                        loadingState = .failed
                    }
                
            } catch {
                print("ERROR calling \(#function) for \(location.name)", error.localizedDescription)
                self.errorCode = error
                self.showFetchingAlert = true
            }
        }
    }
    
    /// Transform CLLocation to Location object
    /// - Parameters:
    ///   - location: CLLocation data
    ///   - completion: transfer Location instance forward
    private func setLocation(_ location: CLLocation?, completion: @escaping (_ location: Location) -> Void) {
        print("CALLING \(#function)")
        
        if let location = location  {
            self.locationManager.returnPlaceMark(for: location) { placemark in
                guard let placemark = placemark else {
                    print("PlaceMark data is not available ")
                    return
                }
                
                if let name = placemark.locality,
                   let country = placemark.country {
                    
                    let newLocation = Location(name: name, country: country,  geoLocation: location)
                    self.location = newLocation
                    completion(newLocation)
                    
                } else {
                    print("Failed to set Location data")
                }
            }
        }
    }
}

// OLD VERSIONS
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






