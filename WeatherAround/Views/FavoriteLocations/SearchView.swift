//
//  SearchView.swift
//  WeatherAround
//
//  Created by Миша Перевозчиков on 30.10.2022.
//

import SwiftUI

struct SearchView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.dismissSearch) var dismissSearch
    @Environment(\.isSearching) private var isSearching
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var viewModel: FavoriteLocationViewModel
    
    
    var body: some View {
        NavigationView{
            List {
                ForEach(viewModel.locationPlaceMarks, id: \.self) { location in
                    
                    Button {
                        viewModel.addToFavorites(placeMark: location)
                        dismissSearch()
                        dismiss()
                        
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(location.name ?? "Unkn")
                                    .font(.headline)
                                Text(location.country ?? "Unkn")
                                    .font(.caption)
                            }
                            Spacer()
                        }
                        .padding()
                        .foregroundColor(colorScheme == .light ? .black : .white)
                    }
                    .buttonStyle(.borderless)
                    
                }
            }
            .listStyle(.plain)
        }
        .searchable(text: $viewModel.searchFieldText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "Search City"
        )
        
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(viewModel: FavoriteLocationViewModel(weatherManager: WeatherManager()))
    }
}
