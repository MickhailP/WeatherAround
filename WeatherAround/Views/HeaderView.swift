//
//  HeaderView.swift
//  WeatherAround
//
//  Created by Миша Перевозчиков on 05.06.2022.
//

import SwiftUI

struct HeaderView: View {
    
    let weather: Weather
    let locationName: String
    
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            
            weatherSection
            
            Spacer()
            
            locationSection
            
        }
        .frame(maxWidth: .infinity)
        .foregroundColor(.white)
        .shadow(color: .black.opacity(0.2), radius: 3)
        .padding(15)
    }
    
    private var weatherSection: some View {
        VStack(spacing: 10) {
            weather.image
                .font(.largeTitle)
                .iconColor(weatherCode: weather.weatherCode)
            
            Text(weather.description)
                .font(.title3)
            
            Label {
                Text("\(String(format:"%.2f", weather.windSpeed ?? 0)) mph")
            } icon: {
                Image(systemName: "wind")
            }
            
        }
    }
    
    private var locationSection: some View {
        VStack {
            
            Text("\(Int(weather.temperature))º")
                .font(.system(size: 50))
            Label {
                Text(locationName)
                    .font(.title2)
                    
            } icon: {
                Image(systemName: "location.fill")
            }
        }
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(weather: Weather.example, locationName: "Location")
            .background(.blue)
        
    }
}
