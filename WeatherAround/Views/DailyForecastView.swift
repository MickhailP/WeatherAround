//
//  DailyForecastView.swift
//  WeatherAround
//
//  Created by Миша Перевозчиков on 24.06.2022.
//

import SwiftUI

struct DailyForecastView: View {
    
    let weatherDaily: WeatherDaily
    
    var body: some View {
        CustomStackView {
            Label("10 - days forecast", systemImage: "calendar")
                .padding([.top, .leading], 10)

        } contentView: {
            ForEach(weatherDaily.weatherDaily) { day in
                VStack(spacing: 5) {
                    HStack {
                        Text("\(day.displayedDay)")
                        
                        Spacer()
                        
                        day.image
                            .iconColor(weatherCode: day.weatherCode)
                            .font(.title3)
                        
                        Spacer()
                        
                        Image(systemName: "thermometer")
                        Text("\(Int(day.temperature))º")
                        
                    }
                    .padding(.horizontal, 10)
                    .font(.title2 .weight(.semibold))
                    .foregroundColor(.white)
                    
                    Divider()
                }
            }
        }
    }
}

//struct DailyForecastView_Previews: PreviewProvider {
//    static var previews: some View {
//        let tempEx = WeatherDaily
//        DailyForecastView(weatherDaily: WeatherDaily.example)
//    }
//}
