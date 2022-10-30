//
//  Location.swift
//  WeatherAround
//
//  Created by Миша Перевозчиков on 26.10.2022.
//

import Foundation
import CoreLocation

struct Location: Identifiable {
    let id = UUID()
    let name: String
    let country: String
    let geoLocation: CLLocation
    
    let weather: Weather? = nil
    let weatherHourly: WeatherHourly? = nil
    let weatherDaily: WeatherDaily? = nil
}
