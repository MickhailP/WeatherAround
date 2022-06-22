//
//  IconColor.swift
//  WeatherAround
//
//  Created by Миша Перевозчиков on 05.06.2022.
//

import Foundation
import SwiftUI

extension View {
    func iconColor(weatherCode: WeatherCode) -> some View {
        modifier(IconColor(weatherCode: weatherCode))
            .symbolVariant(.fill)
            .symbolRenderingMode(.palette)
    }
}

struct IconColor: ViewModifier {
    
    let weatherCode: WeatherCode
    
    func body(content: Content) -> some View {
        
        switch weatherCode {
            case .clear:
                content.foregroundStyle(.yellow)
            case .cloudy:
                content.foregroundStyle(.white)
            case .mostlyClear, .partlyCloudy, .mostlyCloudy:
                content.foregroundStyle(.white, .yellow)
            case .fog, .lightFog:
                content.foregroundStyle(.white, .gray)
            case .drizzle:
                content.foregroundStyle(.white, .blue)
            case .lightRain, .rain:
                content.foregroundStyle(.white, .blue)
            case .heavyRain:
                content.foregroundStyle(.white, .blue)
            case .snow, .flurries, .lightSnow, .heavySnow:
                content.foregroundStyle(.gray, .white)
            case .freezingDrizzle:
                content.foregroundStyle(.gray, .white)
            case .freezingRain, .lightFreezingRain, .heavyFreezingRain:
                content.foregroundStyle(.gray, .blue)
            case .icePellets, .heavyIcePellets, .lightIcePellets:
                content.foregroundStyle(.white, .blue)
            case .thunderStorm:
                content.foregroundStyle(.gray, .yellow)
            case .unknown:
                content.foregroundStyle(.white)
                
        }
    }
}
