//
//  HeaderView.swift
//  WeatherAround
//
//  Created by Миша Перевозчиков on 05.06.2022.
//

import SwiftUI

struct HeaderView: View {
    
    let weather: Weather
    
    
    var body: some View {
        VStack(spacing: 5) {
            HStack(alignment: .center, spacing: 30) {
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
                Spacer()
                
                VStack {
                  
                    Text("\(Int(weather.temperature))º")
                        .font(.system(size: 50))
                    Text("My location")
                        .font(.title2)
                }
            }
            .foregroundColor(.white)
            .shadow(color: .black.opacity(0.2), radius: 3)
            .padding(15)
        }
        .frame(maxWidth: .infinity)
    }
    
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(weather: Weather.example)
            .background(.blue)
   
    }
}
