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
    let coordinates: CLLocationCoordinate2D
    
    let weather: Weather?
    let weatherHourly: WeatherHourly?
    let weatherDaily: WeatherDaily?
}
