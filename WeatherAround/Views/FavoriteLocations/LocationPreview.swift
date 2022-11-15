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
    
    var weatherAvailable: Bool {
        if weather.currentWeather != nil {
            return true
        } else {
            return false
        }
    }
    
    
    var body: some View {
        HStack {
            
            locationSection
            
            Spacer()
            
            HStack {
                if weatherAvailable {
                    WeatherSection(weather: weather)
                    
                } else {
                    WeatherSection(weather: weather)
                        .redacted(reason: .placeholder)
                }
            }
            .padding()
        }
    
        .frame(maxWidth: .infinity, maxHeight: 70)
        .background(
            BackgroundView()
        )
        .cornerRadius(20)
        
    }
    
    var locationSection: some View {
        Group{
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
        }
    }
}

private struct WeatherSection: View {
    
    let weather: WeatherObject
    
    var body: some View {
        if let weather = weather.currentWeather {
            Group {
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
            }
        } else {
            Group {
                Image(systemName: "cloud")
                    .font(.title)
                
                
                VStack(alignment: .leading, spacing: 10){
                    Text("000˚")
                        .font(.headline)
                    Text("Not av")
                        .font(.subheadline)
                }
                .foregroundColor(.white)
            }
        }
    }
}


struct LocationPreview_Previews: PreviewProvider {
    static var previews: some View {
        LocationPreview(weather: WeatherObject.example, weatherManager: WeatherManager())
    }
}
