//
//  LocationSearchViewModel.swift
//  WeatherAround
//
//  Created by Миша Перевозчиков on 26.10.2022.
//

import Foundation
import Combine
import MapKit

final class LocationSearchViewModel: ObservableObject {
    
    @Published private(set) var isSearching: Bool = false
    
    @Published var showSearchList: Bool = false
    
    @Published var searchFieldText: String = ""
    
    @Published private(set) var locationPlaceMarks: [CLPlacemark] = []
    
    @Published private(set) var favoritesLocation: [Location] = []
    
    private let searchService = LocationSearchManager()
    
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addTextFieldSubscriber()
        addSearchSubscriber()
        setLocationsData()
    }
    
    func addToFavorites(placeMark: CLPlacemark) {
        
        if let name = placeMark.name,
           let country = placeMark.country,
           let geoLocation = placeMark.location {
            
            let location = Location(name: name, country: country, geoLocation: geoLocation)
            
            favoritesLocation.append(location)
        }
    }
    
    
    func addTextFieldSubscriber() {
        $searchFieldText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .combineLatest($isSearching)
            .sink { [weak self] (text, shouldSearch) in
                print("Search Text: \(text)")
                self?.locationPlaceMarks = []
                
                
                if shouldSearch {
                    self?.searchCity(searchText: text)
                    print("Start searching")
                } else {
                    print("We are not searching")
                }
                
            }
            .store(in: &cancellables)
    }
    
    func addSearchSubscriber() {
        $searchFieldText
            .sink(receiveValue: { [weak self] text in
                if text.count < 2 {
                    self?.isSearching = false
                    print(text.count)
                } else {
                    self?.isSearching = true
                }
                     
            })
            .store(in: &cancellables)
    }
    
    func searchCity(searchText: String) {
        searchService.request(request: .address, searchText: searchText)
        print("\(#function) has been called")
    }
    
    func setLocationsData() {
        searchService.locationSearchPublisher
            .receive(on: DispatchQueue.main)
            .replaceError(with: [])
            .sink { [weak self] mapItems in
                
                self?.locationPlaceMarks = mapItems.compactMap { item -> CLPlacemark in
                    print(item)
                    return item.placemark
                }
                
            }
            .store(in: &cancellables)
    }
    
}
