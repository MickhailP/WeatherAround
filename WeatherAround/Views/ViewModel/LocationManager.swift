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

    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        manager.requestLocation()
        print("Location requested")
    }

    // Fetch the user's locations and request Weather from server for the last one.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
        print("Location received FROM MANAGER")
        print(location)

    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Unable to get user's location.", error)
    }
}
