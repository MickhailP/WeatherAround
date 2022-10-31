//
//  FavoriteLocationView.swift
//  WeatherAround
//
//  Created by Миша Перевозчиков on 27.10.2022.
//

import SwiftUI

struct FavoriteLocationView: View {
    
    
    @State private var isPresented = false
    
    @StateObject private var viewModel = LocationSearchViewModel()
    
    
    
    var body: some View {
        NavigationView {
            
            
            List{
                
                ForEach(viewModel.favoritesLocation) { location in
                    VStack(alignment: .leading) {
                        Text(location.name)
                            .font(.headline)
                        Text(location.country)
                            .font(.subheadline)
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity, maxHeight: 40)
                    .background(.ultraThinMaterial)
                    
                }
                .onDelete(perform: { index in
                    viewModel.delete(index)
                })
                
                
                
                .onAppear{
                    UITableView.appearance().backgroundColor = .red
                    UITableViewCell.appearance().backgroundColor = .yellow
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                
            }
            
            
            .sheet(isPresented: $isPresented) {
                SearchView(viewModel: viewModel)
            }
            .navigationBarTitle("Favorite places")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isPresented = true
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
}


struct BackgroundView:View {
    
    var body: some View {
        ZStack{
            Image("appBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            
            LinearGradient(gradient: Gradient(colors: [.indigo, .white]), startPoint: .topLeading, endPoint: .bottom)
                .ignoresSafeArea()
                .opacity(0.4)
                .blur(radius: 100)
            
            Color.gray.opacity(0.3)
                .ignoresSafeArea()
            
        }
    }
}


struct FavoriteLocationView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteLocationView()
    }
}
