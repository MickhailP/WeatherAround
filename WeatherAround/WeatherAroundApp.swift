//
//  WeatherAroundApp.swift
//  WeatherAround
//
//  Created by Миша Перевозчиков on 26.05.2022.
//

import SwiftUI

@main
struct WeatherAroundApp: App {
    var body: some Scene {
        WindowGroup {
            GeometryReader { proxy in
                let topEdge = proxy.safeAreaInsets.top
                ContentView(topEdge: topEdge)
                    .ignoresSafeArea(.all, edges: .top)
            }
        }
    }
}
