//
//  HourlyWeatherView.swift
//  WeatherAround
//
//  Created by Миша Перевозчиков on 06.06.2022.
//

import SwiftUI



struct HourlyWeatherView: View {
    let weather: WeatherHourly
    
    var body: some View {
        CustomStackView(titleView: {
            sectionLabel
        }, contentView: {
            scrollHourlySection
        })
    }
}

// Extracted Views in to variables from body
extension HourlyWeatherView {
    
    private var scrollHourlySection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center, spacing: 20) {
                ForEach(weather.weatherHourly) { weather in
                    HourStack(column: HourColumn(columnType: .regular, weather: weather))
                }
            }
            .padding(.trailing)
        }
    }
    
    private var sectionLabel: some View {
        Label("24 Hours forecast", systemImage: "clock")
            .foregroundColor(.secondary)
            .font(.subheadline)
            .padding([.top, .leading], 10)
    }
}


fileprivate struct HourStack: View {
    let column: HourColumn
    
    
    var body: some View {
        VStack(alignment: .center){
            Text(column.time)
                .font(.body)
            Spacer()
            column.icon
                .font(.title2)
                .iconColor(weatherCode: column.weatherCode)
            Spacer()
            Text("\(column.detail)º")
        }
        .foregroundColor(.white)
    }
}

//struct HourlyWeatherView_Previews: PreviewProvider {
//    static var previews: some View {
////        HourlyWeatherView(hourlyWeather: WeatherHourly())
//    }
//}
