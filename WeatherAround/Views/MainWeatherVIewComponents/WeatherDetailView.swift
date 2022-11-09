//
//  WeatherDetailView.swift
//  WeatherAround
//
//  Created by Миша Перевозчиков on 13.06.2022.
//

import SwiftUI

struct WeatherDetailView: View {
    
    let weather: Weather
    
    let customStackContentViewSpacing: CGFloat = 10
   
    var body: some View {
        VStack {
            HStack {
                
                CustomStackView {
                    Label("Precipitation", systemImage: "aqi.medium")
                } contentView: {
                    VStack(alignment: .leading, spacing: customStackContentViewSpacing) {
                        Text(weather.precipitationDescription)
                            .font(.title)
                        Text("Chance \(weather.precipitationProbability ?? 0) %")
                            .font(.subheadline)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                }
               

                CustomStackView {
                    Label("UV index", systemImage: "sun.max.fill")
                } contentView: {
                    VStack(alignment: .leading, spacing: customStackContentViewSpacing) {
                        Text("\(weather.uvIndex ?? 0)")
                            .font(.title)
                        Text("\(weather.uvIndexDescription)")
                            .font(.headline)
                    }
                    
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                }
            }
            .frame(maxHeight: .infinity)
            
            HStack {
                CustomStackView {
                    Label("Feels like", systemImage: "thermometer")
                } contentView: {
                    VStack(alignment: .leading, spacing: customStackContentViewSpacing) {
                        
                        Text("\(Int(weather.temperatureApparent ?? 0))º")
                            .font(.title)
                        Spacer()
                        
                        Text(weather.feelsLikeDescription)
                            .font(.subheadline)
                    }
                    
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .font(.title3)
                }
               

                CustomStackView {
                    Label("Humidity", systemImage: "humidity")
                } contentView: {
                    VStack(alignment: .leading, spacing: customStackContentViewSpacing) {
                        Text("\(Int(weather.humidity ?? 0))%")
                            .font(.title)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                }
            }
            .frame(maxHeight: .infinity)
            
            
            HStack {
                CustomStackView {
                    Label("Wind speed", systemImage: "wind")
                } contentView: {
                    VStack(alignment: .leading, spacing: customStackContentViewSpacing) {
                        Text("\(String(format:"%.2f", weather.windSpeed ?? 0)) m/s")
                            .font(.title)
                        Spacer()
                    }
                    
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .font(.title3)
                }
                
                
                CustomStackView {
                    Label("Visibility", systemImage: "eye")
                } contentView: {
                    VStack(alignment: .leading, spacing: customStackContentViewSpacing) {
                        Text("\(Int(weather.visibility ?? 0)) km")
                            .font(.title)
                        Spacer()
                        
                        Text("Light haze is affecting visibility")
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                }
            }
            .frame(maxHeight: .infinity)
        }
        .foregroundColor(.white)
    }
}

struct WeatherDetailView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherDetailView(weather: Weather.example)
            .background(.blue)
    }
}
