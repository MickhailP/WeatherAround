//
//  FavoriteLocationView.swift
//  WeatherAround
//
//  Created by Миша Перевозчиков on 27.10.2022.
//

import SwiftUI

struct FavoriteLocationView: View {
    
    @StateObject private var viewModel = LocationSearchViewModel()
    
    var body: some View {
        NavigationView() {
            VStack {
                Text ("Hello")
                List{
                    ForEach(viewModel.locationPlaceMarks, id: \.self) { location in
                        VStack (alignment: .leading){
                                Text(location.name ?? "Unkn")
                                Text(location.country ?? "Unkn")
                                .font(.caption)
                                
                            }
                        }
                    
                }
                .listStyle(.plain)
                .searchable(text: $viewModel.searchFieldText )
            }
        }
    }
}

struct FavoriteLocationView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteLocationView()
    }
}
