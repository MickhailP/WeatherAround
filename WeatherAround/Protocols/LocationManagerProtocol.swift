//
//  LocationManagerProtocol.swift
//  WeatherAround
//
//  Created by Миша Перевозчиков on 29.11.2022.
//

import Foundation
import CoreLocation

protocol LocationManagerProtocol {
    func returnPlaceMark(for location: CLLocation, completionHandler: @escaping (CLPlacemark?) -> Void)
}
