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
    
    
//    var completionHandler: ((OneCallWeatherResponse) -> Void)?
    var completionHandler: ((CurrentWeatherResponse) -> Void)?
    
    private let apiKey = "lT5ix1gfznPpiE860KoSKsRkP1FYuX2Y"
    private let units = "metric"
    private let dateFormatter = ISO8601DateFormatter()
 
    
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func getLocation(_ completionHandler: @escaping ((_ weather: CurrentWeatherResponse) -> Void)) {
        
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
        self.completionHandler = completionHandler 
        print("location requested")
    }
    
    func fetchWeather(for coordinates: CLLocationCoordinate2D) async {
//MARK: ONECALL URL
//        guard let url = URL(string: "http://api.openweathermap.org/data/2.5/onecall?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&exclude=minutely,alerts&appid=\(apiKey)&units=\(units)") else {
//            print("Missing URL")
//            return
//        }
        

        guard let url = URL(string: "https://api.tomorrow.io/v4/timelines?location=\(coordinates.latitude),\(coordinates.longitude)&fields=temperature&fields=temperatureApparent&fields=humidity&fields=windSpeed&fields=pressureSurfaceLevel&fields=precipitationProbability&fields=precipitationType&fields=visibility&fields=uvIndex&fields=weatherCode&units=metric&timesteps=1h&startTime=\(dateFormatter.string(from: Date.now))&apikey=\(apiKey)") else {
            print("Missing URL")
            return
        }
        print(url)
        print(Date.now)
        
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard ( response as? HTTPURLResponse)?.statusCode == 200 else { return }
            
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(CurrentWeatherResponse.self, from: data)
            self.completionHandler?(decodedData)
             
            print("Weather forecast has successfully gotten")
        } catch {
            print(error, error.localizedDescription)
        }
    }
    
    
    
   
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
        if let location = location {
            Task { await fetchWeather(for: location) }
        }
        print(location)
    }
  
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Unable to get user's location.", error)
    }
}
