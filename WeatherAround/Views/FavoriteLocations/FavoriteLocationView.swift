//
//  FavoriteLocationView.swift
//  WeatherAround
//
//  Created by Миша Перевозчиков on 27.10.2022.
//

import SwiftUI

struct FavoriteLocationView: View {
    
    @StateObject var viewModel: FavoriteLocationViewModel
    
    private let weatherManager: WeatherManagerProtocol
    
    init(weatherManger: WeatherManagerProtocol) {
        _viewModel = StateObject(wrappedValue: FavoriteLocationViewModel(weatherManager: weatherManger))
        self.weatherManager = weatherManger

    }
    
    var body: some View {
        NavigationView {
            Group {
                
                if viewModel.favouriteLocations.isEmpty {
                    emptyLocations
                    
                } else {
                    listView
                }
            }
            .sheet(isPresented: $viewModel.isSearchPresented) {
                SearchView(viewModel: viewModel)
            }
            .sheet(isPresented: $viewModel.showWeatherSheet, content: {
                MainWeatherView(from: viewModel.selectedWeather, weatherManager: weatherManager, topEdge: 59.0)
            })
            .navigationBarTitle("Favorites")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        viewModel.isSearchPresented = true
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.black)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        viewModel.showRemoveAllAlert = true
                    } label: {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
            
            .alert("Remove all", isPresented: $viewModel.showRemoveAllAlert, actions: {
                Button("Nope", role: .cancel, action: {})
                Button("Delete", role: .destructive , action: { viewModel.removeAll()
                })
            }, message: {
                Text("Are you sure delete all your favourite locations? ")
            })
        }
    }
    
    
    var emptyLocations: some View {
        VStack {
            Spacer()
            VStack(spacing: 10){
                Image(systemName: "magnifyingglass.circle")
                    .font(.system(size: 50))
                Text("You haven't favourite places yet!")
                
            }
            Spacer()
        }
    }
    
    var listView: some View {
        List {
            ForEach(viewModel.favoriteWeather, id: \.self) { object in
                
                LocationPreview(weather: object, weatherManager: weatherManager)
                    .onTapGesture {
                        viewModel.selectedWeather = object
                        viewModel.showWeatherSheet = true
                    }
            }
            .onDelete(perform: { index in
                viewModel.delete(index)
            })
            .listStyle(.plain)
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
        }
    } 
}



struct FavoriteLocationView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteLocationView(weatherManger: WeatherManager())
    }
}
