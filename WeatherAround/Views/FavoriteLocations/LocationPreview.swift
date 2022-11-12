//
//  LocationPreview.swift
//  WeatherAround
//
//  Created by Миша Перевозчиков on 06.11.2022.
//

import SwiftUI

struct LocationPreview: View {
    
    
    let weather: WeatherObject
    
    let weatherManager: WeatherManagerProtocol
    
    
    var body: some View {
        ZStack {
            NavigationLink(destination:  MainWeatherView(from: weather, weatherManager: weatherManager, topEdge: 59.0)) {
                EmptyView()
            }
            
            .opacity(0.0)
            .buttonStyle(.plain)
            
            HStack {
                if let location = weather.location {
                    VStack(alignment: .leading, spacing: 10){
                        Text(location.name)
                            .font(.headline)
                        Text(location.country)
                            .font(.subheadline)
                    }
                    .padding()
                    .foregroundColor(.white)
                }
                
            // TODO: When weather is unavailable create a blank view
                
                Spacer()
                
                HStack {
                    if let weather = weather.currentWeather {
                    
                        weather.image
                            .iconColor(weatherCode: weather.weatherCode)
                            .font(.title)
                        
                        
                        
                        VStack(alignment: .leading, spacing: 10){
                            Text("\(weather.temperature)˚")
                                .font(.headline)
                            Text(weather.description)
                                .font(.subheadline)
                        }
                        .foregroundColor(.white)
                    } else {
                        ProgressView()
                    }
                    
                }
                .padding()
                
            }
            
        }
        .background(
            BackgroundView()
        )
        .cornerRadius(20)
        .frame(maxWidth: .infinity, maxHeight: 50)
        .padding()
        
    }
}

struct LocationPreview_Previews: PreviewProvider {
    static var previews: some View {
        LocationPreview(weather: WeatherObject.example, weatherManager: WeatherManager())
    }
}
