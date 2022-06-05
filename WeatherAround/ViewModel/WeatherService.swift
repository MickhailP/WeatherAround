//
//  WeatherService.swift
//  WeatherAround
//
//  Created by Миша Перевозчиков on 28.05.2022.
//

import Foundation
import CoreLocation

class WeatherService: NSObject, CLLocationManagerDelegate {
    
    private let manager = CLLocationManager()
    
    @Published var location: CLLocationCoordinate2D?
    
    
    var completionHandler: ((CurrentWeatherResponse) -> Void)?
    
    private let apiKey = "lT5ix1gfznPpiE860KoSKsRkP1FYuX2Y"
    private let units = "metric"
    private let dateFormatter = ISO8601DateFormatter()
    private let startTime = Date.now
    private let endTime = Calendar.current.date(byAdding: DateComponents(day: 1), to: Date())
    
    
    
    override init() {
        super.init()
        manager.delegate = self
    }
  
    
    func getLocation(_ completionHandler: @escaping ((_ weather: CurrentWeatherResponse) -> Void)) {
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
        self.completionHandler = completionHandler
        print("Location requested")
    }
    
    func fetchWeather(for coordinates: CLLocationCoordinate2D) async {
        
        guard let endTime = endTime else { return }
        
        guard let url = URL(string: "https://api.tomorrow.io/v4/timelines?location=\(coordinates.latitude),\(coordinates.longitude)&fields=temperature&fields=temperatureApparent&fields=humidity&fields=windSpeed&fields=pressureSurfaceLevel&fields=precipitationProbability&fields=precipitationType&fields=visibility&fields=uvIndex&fields=weatherCode&units=metric&timesteps=1h&startTime=\(dateFormatter.string(from: startTime))&endTime=\(dateFormatter.string(from: endTime))&apikey=\(apiKey)")
        else {
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
            
            print("Weather forecast received successfully")
        } catch {
            print(error, error.localizedDescription)
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
