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


// The functionality to update user's location name
extension LocationManager {
    
    /// Use this function to decode current location to locality name.
    /// - Parameters:
    ///   - location: Coordinates that should be named
    ///   - completionHandler: Closure that manages received location name
    func getLocationName(for location: CLLocation, completionHandler: @escaping (String?) -> Void ) {
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
            // To see all available options of placemark
            print(place)
            
            if let name = place.locality {
                // Decoding was successful, call completion handler with locality name
                completionHandler(name)
            }
        }
    }
    
    
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
            // To see all available options of placemark
            completionHandler(place)
        }
    }
}

