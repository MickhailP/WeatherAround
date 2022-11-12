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
    
    @Published private(set) var favoriteLocations: [Location] = []
    
    @Published private(set) var favoriteWeather = [WeatherObject]()

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
        
//        removeAll()
//        save()
        
    }
    
  
    private func loadFavoriteLocations() {
        if let data = UserDefaults.standard.data(forKey: saveKey) {
            do {
                let decoded = try JSONDecoder().decode([Location].self, from: data)
                favoriteLocations = decoded
                print("LOCATIONS LOADED")
                print(favoriteLocations.count)
            } catch {
                print("ERROR calling \(#function)", error.localizedDescription)
            }
        }
    }
    
    private func fetchAllFavoriteWeather() {
        Task {
            do {
                let weathers = try await weatherManager.fetchWeatherDataWithTaskGroup(for: favoriteLocations)
                await MainActor.run {
                    favoriteWeather = weathers
                }
            } catch {
                print("ERROR calling \(#function)", error.localizedDescription)
            }
        }
    }
    
    func addToFavorites(placeMark: CLPlacemark) {
        
        if let name = placeMark.name,
           let country = placeMark.country,
           let geoLocation = placeMark.location {
            
            let location = Location(name: name, country: country, geoLocation: geoLocation)
            
            let contains = favoriteLocations.contains(where: { $0 == location})
            
            if !contains {
                favoriteLocations.append(location)
                save()
                
                Task {
                    let weather = await weatherManager.getWeather(for: location)
            
                    await MainActor.run(body: {
                        if let weather = weather {
                            favoriteWeather.append(weather)
                        }
                    })
                }
                
            } else {
                print("There is the same location in database ")
            }
            
            searchFieldText = ""
            
        }
    }
    
    
    private func save() {
        do {
            let encoded = try JSONEncoder().encode(favoriteLocations)
            UserDefaults.standard.set(encoded, forKey: saveKey)
            print("LOCATION SAVED")
            print(favoriteLocations.count)
            
        } catch  {
            print("ERROR due calling \(#function)", error.localizedDescription)
        }
    }
    
    func delete(_ index: IndexSet) {
        favoriteLocations.remove(atOffsets: index)
        favoriteWeather.remove(atOffsets: index)
        
        save()
        print("Location removed")
    }
    
    private func removeAll() {
        favoriteLocations.removeAll()
        save()
        print("ALL LOCATIONS REMOVED")
        
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
