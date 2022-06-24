//
//  WeatherService.swift
//  WeatherAround
//
//  Created by Миша Перевозчиков on 28.05.2022.
//

import Foundation
import CoreLocation
import Combine
import SwiftUI


//class LocationManager: NSObject, CLLocationManagerDelegate {
//
//    var location: CLLocation?
//
//    private let manager = CLLocationManager()
//
//    override init() {
//        super.init()
//        manager.delegate = self
//        manager.requestWhenInUseAuthorization()
//        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
//        manager.startUpdatingLocation()
//        print("Location requested")
//    }
//
//    // Fetch the user's locations and request Weather from server for the last one.
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else { return }
//        manager.stopUpdatingLocation()
//        print("Location received FROM MANAGER")
//        print(location)
//
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Unable to get user's location.", error)
//    }
//}

class WeatherService: NSObject, CLLocationManagerDelegate {
    
    static let shared = WeatherService()
    
    enum APIService {
        case currentForecast(location: CLLocation)
        case dailyForecast(lat: Double, long: Double)
    }
    
    
    @Published var location: CLLocation?
    
//    {
//        didSet {
//            guard let location = location else {
//                print("There is no location")
//                return
//            }
//            Task {
//                await fetchWeather(for: location)
//            }
//        }
//    }
    
    
    private let manager = CLLocationManager()
    
    var completionHandler: ((CurrentWeatherResponse) -> Void)?
    
    
 
    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        manager.startUpdatingLocation()
        print("Location requested")
    }
  
    
    
    func getLocation(_ completionHandler: @escaping (_ weather: CurrentWeatherResponse) -> Void) {
        
    
      
        self.completionHandler = completionHandler
    }
    
    //Use this function to fetch weather data from server. Call the WeatherService completion handler with Weather data.
    func downloadWeather(for location: CLLocation) async {
        print("Start fetch Weather")
        
        //Set URL FOR request
        let urlTest = APIService.currentForecast(location: location).url
        
        do {
            let (data, response) = try await URLSession.shared.data(from: urlTest)
            
            guard ( response as? HTTPURLResponse)?.statusCode == 200 else { return }
            
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(CurrentWeatherResponse.self, from: data)
            self.completionHandler?(decodedData)
            
            print("Weather forecast received successfully")
        } catch {
            print(error, error.localizedDescription)
        }
    }
    
    private var locationPublisher: CurrentValueSubject<CLLocation?, Never> = CurrentValueSubject(nil)

    // Fetch the user's locations and request Weather from server for the last one.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first
        manager.stopUpdatingLocation()
        print("Location received")
        print(location)
        
        guard let location = location else {
            print("There is no location")
            return
        }
        Task {
            await downloadWeather(for: location)
        }

    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Unable to get user's location.", error)
    }
}


