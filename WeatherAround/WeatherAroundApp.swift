//
//  WeatherAroundApp.swift
//  WeatherAround
//
//  Created by Миша Перевозчиков on 26.05.2022.
//

import SwiftUI

@main
struct WeatherAroundApp: App {
    
    let weatherManager = WeatherManager()
    
    
    
    var body: some Scene {
        WindowGroup {
            TabView {
                
                GeometryReader { proxy in
                    let topEdge = proxy.safeAreaInsets.top
                    MainWeatherView(from: nil, weatherManager: WeatherManager(), topEdge: topEdge)
                        .ignoresSafeArea(.all, edges: .top)
                }
                .tabItem {
                    VStack{
                        Image(systemName: "cloud.sun.rain")
                    }
                }
                
                FavoriteLocationView(weatherManger: weatherManager)
                    .tabItem {
                        VStack{
                            Image(systemName: "heart")
                        }
                    }
            }
            .onAppear {
                let appearance = UITabBarAppearance()
                appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
                
                
                // Use this appearance when scrolling behind the TabView:
                UITabBar.appearance().standardAppearance = appearance
                // Use this appearance when scrolled all the way up:
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
        }
    }
}
