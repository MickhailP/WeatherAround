//
//  LocationManager.swift
//  WeatherAround
//
//  Created by Миша Перевозчиков on 27.06.2022.
//

import Foundation
import CoreLocation
import Combine


final class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    static let shared = LocationManager()
    
    @Published var location: CLLocation?
    
    private let manager = CLLocationManager()
    
    override private init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        manager.requestLocation()
        print("Location requested")
    }
    
    // Fetch the user's locations and request Weather from server for the last one.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.location = location
        print("Location received FROM MANAGER")
        print(location)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Unable to get user's location.", error)
        manager.requestLocation()
    }
}


extension LocationManager: LocationManagerProtocol {
    
    /// Use this function to get a placemark for specific location.
    /// This method uses a  CLGeocoder() instance to find an information about CLLocation, such as names of the city and coutry
    /// - Parameters:
    ///   - location: CLLocation that should be geocoded
    ///   - completionHandler: Closure that manages received values
    func returnPlaceMark(for location: CLLocation, completionHandler: @escaping (CLPlacemark?) -> Void ) {
        
        // create a CLGeocoder instance
        let geocoder = CLGeocoder()
        
        // Look up a location and pass it in to closure
        geocoder.reverseGeocodeLocation(location, preferredLocale: .current) { placemark, error in
            
            // Check if location available
            guard let place = placemark?.first, error == nil else {
                // An error occurred during decoding
                completionHandler(nil)
                print("Failed to get placemark from location")
                return
            }
            // Call the closure with the first placemark
            completionHandler(place)
        }
    }
}

