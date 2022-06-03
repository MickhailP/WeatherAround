//
//  WeatherManager.swift
//  WeatherAround
//
//  Created by Миша Перевозчиков on 28.05.2022.
//

import Foundation
import CoreLocation

//class WeatherManager {
//    
//   private let apiKey = "ffbcacd096f4ac46ea3d08b855bcc948"
//   private let units = "metric"
//
//    
//    enum FetchingErrors: Error {
//        case badURL, fetchingFail
//    }
//   
//
//    func getWeatherData(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> WeatherResponse {
//        
//        guard let url = URL(string: "http://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&exclude=minutely,alerts&appid=\(apiKey)&units=\(units)") else {
//            print("Missing URL")
//            throw FetchingErrors.badURL
//        }
//        
//        let urlRequest = URLRequest(url: url)
//        
//        let (data, response) = try await URLSession.shared.data(for: urlRequest)
//        
//        guard ( response as? HTTPURLResponse)?.statusCode == 200 else { throw FetchingErrors.fetchingFail }
//        
//        let decoder = JSONDecoder()
//        let decodedData = try decoder.decode(WeatherResponse.self, from: data)
//        
//        return decodedData
//        
//    }
//}
