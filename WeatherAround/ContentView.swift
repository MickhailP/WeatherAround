//
//  ContentView.swift
//  WeatherAround
//
//  Created by Миша Перевозчиков on 26.05.2022.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.7), .white]), startPoint: .topLeading, endPoint: .bottom)
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                if let weather = viewModel.weather {
                    VStack {
                        HeaderView(weather: weather)
                        .padding(.vertical, 40)
                        .padding(.horizontal, 40)
                        
                        if let weatherHourly = viewModel.weatherHourly {
                            HourlyWeatherView(weather: weatherHourly)
                                .padding()
                        }
                       
                    }
                    ProgressView()
                }
            }
            
        }
        .onAppear{
            viewModel.refresh()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
