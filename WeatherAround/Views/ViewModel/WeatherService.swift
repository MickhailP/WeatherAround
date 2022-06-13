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
    
//    @Published var location: CLLocationCoordinate2D?
    @Published var location: CLLocation?
    
    
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
    
    //Use this function to fetch weather data from server. Call the WeatherService completion handler with Weather data.
    func fetchWeather(for location: CLLocation) async {
                
        //Unwrap end time for URL request
        guard let endTime = endTime else { return }
        
        //Unwrap URL and pass URL parameters
        guard let url = URL(string: "https://api.tomorrow.io/v4/timelines?location=\(location.coordinate.latitude),\(location.coordinate.longitude)&fields=temperature&fields=temperatureApparent&fields=humidity&fields=windSpeed&fields=pressureSurfaceLevel&fields=precipitationProbability&fields=precipitationType&fields=visibility&fields=uvIndex&fields=weatherCode&units=metric&timesteps=1h&startTime=\(dateFormatter.string(from: startTime))&endTime=\(dateFormatter.string(from: endTime))&apikey=\(apiKey)")
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
    
    // Fetch the user's locations and request Weather from server for the first one.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first
        if let location = location {
            //Pass location in to async weather request.
            Task { await fetchWeather(for: location) }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Unable to get user's location.", error)
    }
}

//The functionality to update user's location name
extension WeatherService {
    
    //Use this function to decode current location to locality name
    func getLocationName(for location: CLLocation, completionHandler: @escaping (String?) -> Void ) {
        //create a CLGeocoder instance
        let geocoder =  CLGeocoder()
        
        //Look up a location and pass it in to closure
        geocoder.reverseGeocodeLocation(location, preferredLocale: .current) { placemark, error in
            
            //Check if location available
            guard let place = placemark?.first, error == nil else {
                //An error occurred during decoding
                completionHandler(nil)
                print("Failed to get placemark from location")
                return
            }
            // To see all available options of placemark
            print(place)
            
            var name = "My location"
           
            if let locality = place.locality {
                name = locality
            }
            
            //Decoding was successful, call completion handler with locality name
            completionHandler(name)
        }
    }
}
