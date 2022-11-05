//
//  DailyForecastView.swift
//  WeatherAround
//
//  Created by Миша Перевозчиков on 24.06.2022.
//

import SwiftUI

struct DailyForecastView: View {
    
    let weatherDaily: [Weather]
    
    var body: some View {
        CustomStackView {
            Label("10 - days forecast", systemImage: "calendar")
                .padding([.top, .leading], 10)

        } contentView: {
            ForEach(weatherDaily) { day in
                VStack {
                    HStack {
                        Text("\(day.displayedDay)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer()
                        
                        day.image
                            .iconColor(weatherCode: day.weatherCode)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        Spacer()
                        HStack {
                            Image(systemName: "thermometer")
                            Text("\(Int(day.temperature))º")
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        
                    }
                    .padding(.horizontal, 10)
//                    .padding(.vertical, 5)
                    .font(.title3 .weight(.regular))
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
