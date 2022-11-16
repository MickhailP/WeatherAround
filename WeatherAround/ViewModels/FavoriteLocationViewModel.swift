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
    
    // Search sheet
    @Published private(set) var shouldSearch: Bool = false
    @Published var isSearchPresented: Bool = false
    @Published var showSearchList: Bool = false
    @Published var searchFieldText: String = ""
    @Published private(set) var locationPlaceMarks: [CLPlacemark] = []
    
    // Favourite Locations
    @Published private(set) var favouriteLocations: [Location] = []
    @Published private(set) var favoriteWeather = [WeatherObject]()
    
    // MainWeather sheet
    @Published var selectedWeather: WeatherObject?
    @Published var showWeatherSheet: Bool = false
    
    // Alerts
    @Published var showSameLocationAlert: Bool = false
    @Published var showRemoveAllAlert: Bool = false
    
    // FetchingError alert
    @Published var showFetchingAlert: Bool = false
    @Published var errorCode: Error?
    
    
    
    // Managers
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
    
    
    /// Load favourite Locations form UserDefaults and decode to favouriteLocations array
    private func loadFavoriteLocations() {
        if let data = UserDefaults.standard.data(forKey: saveKey) {
            do {
                let decoded = try JSONDecoder().decode([Location].self, from: data)
                favouriteLocations = decoded
                print("LOCATIONS LOADED")
                print(favouriteLocations.count)
            } catch {
                print("ERROR calling \(#function)", error.localizedDescription)
            }
        }
    }
    
   
    
    /// Creates a Location instance based on chosen place mark from SearchView and request a weather data for it.
    /// Updates the favoriteLocations list
    /// - Parameter placeMark: CLPlacemak for which weather data should be fetched
    func addToFavorites(placeMark: CLPlacemark) {
        
        if let name = placeMark.name,
           let country = placeMark.country,
           let geoLocation = placeMark.location {
            
            let location = Location(name: name, country: country, geoLocation: geoLocation)
            
            let contains = favouriteLocations.contains(where: { $0 == location})
            
            if !contains {
                favouriteLocations.append(location)
                save()
    
                requestWeather(for: location)
                
            } else {
                showSameLocationAlert = true
                print("There is the same location in database ")
            }
            
            searchFieldText = ""
            showSearchList = false
            
        }
    }
    
    /// Fetches weather data for Location
    /// - Parameter location: Location instance for which data should be fetched
    private func requestWeather(for location: Location) {
        Task {
            do {
                let weather = try await weatherManager.getWeather(for: location)
                
                await MainActor.run(body: {
                    if let weather = weather {
                        favoriteWeather.append(weather)
                    }
                })
            } catch {
                print("ERROR calling \(#function) for \(location.name)", error.localizedDescription)
                await MainActor.run(body: {
                    
                    // Save place only with Location data
                    let weatherObject = WeatherObject(location: location)
                    favoriteWeather.append(weatherObject)
                   
                    // Handle error
                    self.errorCode = error
                    self.showFetchingAlert = true
                })
            }
        }
    }
    
    /// Fetch weather data for favouriteLocations
    private func fetchAllFavoriteWeather() {
        Task {
            do {
                let weathers = try await weatherManager.fetchWeatherDataWithTaskGroup(for: favouriteLocations)
                await MainActor.run {
                    favoriteWeather = weathers
                }
            } catch {
                print("ERROR calling \(#function) for \(favouriteLocations)", error.localizedDescription)
                await MainActor.run {
                    self.errorCode = error
                    self.showFetchingAlert = true
                }
            }
        }
    }
    
    
    /// Save favoriteLocations in the UserDefaults
    private func save() {
        do {
            let encoded = try JSONEncoder().encode(favouriteLocations)
            UserDefaults.standard.set(encoded, forKey: saveKey)
            print("LOCATION SAVED")
            print(favouriteLocations.count)
            
        } catch  {
            print("ERROR due calling \(#function)", error.localizedDescription)
        }
    }
    
    ///  Delete chosen  location from list of favoriteLocations
    /// - Parameter index: Index set from List
    func delete(_ index: IndexSet) {
        favouriteLocations.remove(atOffsets: index)
        favoriteWeather.remove(atOffsets: index)
        
        save()
        print("Location removed")
    }
    
    /// Remove all favourite locations
    func removeAll() {
        favouriteLocations.removeAll()
        favoriteWeather.removeAll()
        save()
        print("ALL LOCATIONS REMOVED")
        
    }
    
    /// Subscribes on $searchFieldText changes and call searchCity method to find a place if shouldSearch = true
    private func addTextFieldSubscriber() {
        $searchFieldText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .combineLatest($shouldSearch)
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
    
    /// Subscribes on $searchFieldText  and  set shouldSearching to true if searching text is longer than 2 characters and false if it is less than 2
    private func addSearchSubscriber() {
        $searchFieldText
            .sink(receiveValue: { [weak self] text in
                if text.count < 2 {
                    self?.shouldSearch = false
                    print(text.count)
                } else {
                    self?.shouldSearch = true
                }
                
            })
            .store(in: &cancellables)
    }
    
    /// Creates a request to Search service to find place
    /// - Parameter searchText: Place  that should be searched
    private func searchCity(searchText: String) {
        searchService.request(request: .address, searchText: searchText)
        print("\(#function) has been called")
    }
    
    /// Adds a Placemark  that was founded by searchCity to locationPlaceMarks
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
