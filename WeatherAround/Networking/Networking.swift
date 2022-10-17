//
//  Networking.swift
//  WeatherAround
//
//  Created by Миша Перевозчиков on 13.10.2022.
//

import Foundation

public class Networking {
    
    static let shared = Networking()
    
    private init() {}
    
     func requestData(endpoint: URL) async throws -> Data {
        
        do {
            let (data, response) = try await URLSession.shared.data(from: endpoint)
            try handleResponse(response)
            
//            if let json = try? JSONSerialization.jsonObject(with: data) {
//                print(json)
//            }
            
            return data
            
            
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
    
     private func handleResponse(_ response: URLResponse?) throws {
        guard
            let response = response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300
        else {
            throw NetworkingError.badURLResponse
        }
         
         guard response.statusCode >= 200 && response.statusCode < 300
         else {
             throw NetworkingError.error(response.statusCode)
         }
    }
}
