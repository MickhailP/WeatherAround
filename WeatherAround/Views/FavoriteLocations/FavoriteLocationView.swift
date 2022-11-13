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
                
                if viewModel.favoriteLocations.isEmpty {
                    VStack {
                        Spacer()
                        VStack{
                            Image(systemName: "magnifyingglass.circle")
                                .font(.system(size: 50))
                            Text("You haven't favourite places yet")
                            
                        }
                        
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(viewModel.favoriteWeather, id: \.self) { object in
                            
                            LocationPreview(weather: object, weatherManager: weatherManager)
                            
                        }
                        .onDelete(perform: { index in
                            viewModel.delete(index)
                        })
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                }
                
            }
            .sheet(isPresented: $viewModel.isSearchPresented) {
                SearchView(viewModel: viewModel)
            }
            .navigationBarTitle("Favorite places")
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
}



struct FavoriteLocationView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteLocationView(weatherManger: WeatherManager())
    }
}
