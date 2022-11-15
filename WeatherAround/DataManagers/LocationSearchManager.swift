//
//  LocationSearchManager.swift
//  WeatherAround
//
//  Created by Миша Перевозчиков on 26.10.2022.
//

import Foundation
import MapKit
import Combine

final class LocationSearchManager {
    
    var locationSearchPublisher = PassthroughSubject<[MKMapItem], Never>()
    
    public func request(request: MKLocalSearch.ResultType, searchText: String) {
        
        print("Location Search requested")
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchText.lowercased()
        
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { [weak self] response, error in
            
            guard let response = response else {
                print("Bad Location search response")
                print("Error: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            
            self?.locationSearchPublisher.send(response.mapItems)
            
            print("Location Search has been done")
            print(response.mapItems)
                
        }
    }
}
