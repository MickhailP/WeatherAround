//
//  HourColumn.swift
//  WeatherAround
//
//  Created by Миша Перевозчиков on 06.06.2022.
//


import SwiftUI

struct HourColumn: Identifiable {
    enum ColumnType {
        case sunrise, sunset
        case regular
    }
    
    let id = UUID()
    let time: String
    let icon: Image
    let date: Date
    let detail: String
    let weatherCode: WeatherCode
    
    init(columnType: ColumnType, weather: Weather) {
        
        let dateFormatter = DateFormatter()
        let ISODateFormatter = ISO8601DateFormatter()
        
        
        let startTime = weather.startTime
        let convertedDate = ISODateFormatter.date(from: startTime) ?? Date()
        
        self.date = convertedDate
        self.weatherCode = weather.weatherCode
        
        switch columnType {
            case .sunrise:
                dateFormatter.dateFormat = "h:mma"
                time = dateFormatter.string(from: date)
                icon = Image(systemName: "sunrise")
                detail = "Sunrise"
            case .sunset:
                dateFormatter.dateFormat = "h:mma"
                time = dateFormatter.string(from: date)
                icon = Image(systemName: "sunrise")
                detail = "Sunset"
                
            case .regular:
                dateFormatter.dateFormat = "h"
                time = dateFormatter.string(from: date)
                icon = weather.image
                detail = ("\( weather.temperature)")
        }
    }
}
