//
//  LocationPreview.swift
//  WeatherAround
//
//  Created by Миша Перевозчиков on 06.11.2022.
//

import SwiftUI

struct LocationPreview: View {

    
    let weather: WeatherObject
    let location: Location
    
    let weatherManager: WeatherManagerProtocol

    
    var body: some View {
        NavigationLink {
            MainWeatherView(from: weather, location: location, weatherManager: weatherManager, topEdge: 59.0)
        } label: {
            HStack {
                
                VStack(alignment: .leading, spacing: 10){
                    Text(location.name)
                        .font(.headline)
                    Text(location.country)
                        .font(.subheadline)
                }
                .padding()
                .foregroundColor(.white)
                
                Spacer()
                
                HStack {
                    weather.currentWeather.image
                        .iconColor(weatherCode: weather.currentWeather.weatherCode)
                        .font(.title)
                    
                    
                    
                    VStack(alignment: .leading, spacing: 10){
                        Text("\(weather.currentWeather.temperature)˚")
                            .font(.headline)
                        Text(weather.currentWeather.description)
                            .font(.subheadline)
                    }
                    .foregroundColor(.white)
                    
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
//
//struct LocationPreview_Previews: PreviewProvider {
//    static var previews: some View {
//        LocationPreview(weather: WeatherObject.example, location: Location(name: "Lon", country: "Russia"))
//    }
//}
