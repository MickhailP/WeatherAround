//
//  LocationSearchViewModel.swift
//  WeatherAround
//
//  Created by Миша Перевозчиков on 26.10.2022.
//

import Foundation
import Combine
import MapKit

final class FavoriteLocationViewModel: ObservableObject {
    
    @Published private(set) var isSearching: Bool = false
    @Published var isSearchPresented: Bool = false
    
    @Published var isMainViewPresented: Bool = false
    
    @Published var showSearchList: Bool = false
    
    @Published var searchFieldText: String = ""
    
    @Published private(set) var locationPlaceMarks: [CLPlacemark] = []
    
    @Published private(set) var favoritesLocation: [Location] = []
    
    @Published private(set) var favoriteWeather = [(locationData: Location, weatherData: WeatherObject)]()

    let weatherManager: WeatherManagerProtocol
    
    private let searchService = LocationSearchManager()
    
    private let saveKey = "SavedLocations"
    private var cancellables = Set<AnyCancellable>()
    
    init(weatherManager: WeatherManagerProtocol) {
        
        self.weatherManager = weatherManager
        
        loadFavoriteLocations()

        
        addTextFieldSubscriber()
        addSearchSubscriber()
        setLocationsData()
        fetchAllFavoriteWeather()
    }
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(favoritesLocation) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    
    private func loadFavoriteLocations() {
        if let data = UserDefaults.standard.data(forKey: saveKey) {
            if let decoded = try? JSONDecoder().decode([Location].self, from: data) {
                favoritesLocation = decoded
            }
        }
    }
    
    private func fetchAllFavoriteWeather() {
        Task {
            do {
                let weathers = try await weatherManager.fetchWeatherDataWithTaskGroup(for: favoritesLocation)
                await MainActor.run {
                    favoriteWeather = weathers
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func addToFavorites(placeMark: CLPlacemark) {
        
        if let name = placeMark.name,
           let country = placeMark.country,
           let geoLocation = placeMark.location {
            
            let location = Location(name: name, country: country, geoLocation: geoLocation)
            
            let unique = favoritesLocation.contains(where: { $0 == location})
            
            if !unique {
                favoritesLocation.append(location)
                save()
            } else {
                print("There is the same location in database ")
            }
            
            searchFieldText = ""
            
        }
    }
    
    func delete(_ index: IndexSet) {
        favoritesLocation.remove(atOffsets: index)
        save()
        print("Location removed")
    }
    
    
    private func addTextFieldSubscriber() {
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
    
    private func addSearchSubscriber() {
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
    
    private func searchCity(searchText: String) {
        searchService.request(request: .address, searchText: searchText)
        print("\(#function) has been called")
    }
    
    private func setLocationsData() {
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
