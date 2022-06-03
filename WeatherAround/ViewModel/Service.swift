//
//  WeatherService.swift
//  WeatherAround
//
//  Created by Миша Перевозчиков on 28.05.2022.
//

import Foundation
import CoreLocation

class WeatherService: NSObject, ObservableObject, CLLocationManagerDelegate {

    let manager = CLLocationManager()
    @Published var location: CLLocationCoordinate2D?
    @Published var forecast: WeatherResponse?
    
    var completionHandler: ((WeatherResponse) -> Void)?
    
    private let apiKey = "ffbcacd096f4ac46ea3d08b855bcc948"
    private let units = "metric"
    
    
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func getLocation(_ completionHandler: @escaping ((_ weather: WeatherResponse) -> Void)) {
        
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
        self.completionHandler = completionHandler 
        print("location requested")
    }
    
    func fetchWeather(for coordinates: CLLocationCoordinate2D) async {

        guard let url = URL(string: "http://api.openweathermap.org/data/2.5/onecall?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&exclude=minutely,alerts&appid=\(apiKey)&units=\(units)") else {
            print("Missing URL")
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard ( response as? HTTPURLResponse)?.statusCode == 200 else { return }
            
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(WeatherResponse.self, from: data)
            self.completionHandler?(decodedData)
             
            print("Weather forecast has successfully gotten")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    
   
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
        if let location = location {
            Task { await fetchWeather(for: location) }
        }
    }
  
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Unable to get user's location.", error)
    }
}
