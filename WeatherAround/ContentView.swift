//
//  ContentView.swift
//  WeatherAround
//
//  Created by Миша Перевозчиков on 26.05.2022.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = ViewModel()
    
    @State private var offset: CGFloat = 0
    
    let topEdge: CGFloat
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.7), .white]), startPoint: .topLeading, endPoint: .bottom)
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                if let weather = viewModel.weather {
                    VStack {
                        HeaderView(weather: weather)
                        //for dragging from bottom
                        .offset(y: -offset)
                        
                        //for dragging from top
                        .offset(y: offset > 0 ? (offset / UIScreen.main.bounds.width) * 100 : 0)
                        
                        .offset(y: getTitleOffset())
                        
                        .opacity(getTitleOpacity())
                        
                        if let weatherHourly = viewModel.weatherHourly {
                            HourlyWeatherView(weather: weatherHourly)
//                                .padding()
                        }
                       
                    }
                    .padding(.top, 25)
                    .padding(.top, topEdge)
                    .padding([.horizontal, .bottom])
                    .overlay(
                        GeometryReader{ proxy -> Color in
                            let minY = proxy.frame(in: .global).minY
                            
                            DispatchQueue.main.async {
                                self.offset = minY
                            }
                            return .clear
                        }
                    )
                }
            }
            
        }
        .onAppear{
            viewModel.refresh()
        }
    }
    
    func getTitleOpacity() -> CGFloat {
        let titleOffset = -getTitleOffset()
        let progress = titleOffset / 20
        let opacity  = 1 - progress
        return opacity
    }
    
    func getTitleOffset() -> CGFloat {
        if offset < 0 {
            let progress = -offset / 120
            
            let newOffset = (progress <= 1.0 ? progress : 1) * 20
            return -newOffset
        }
        return 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView( topEdge: 100 )
    }
}
