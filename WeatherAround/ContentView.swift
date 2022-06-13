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
            
            if viewModel.loadingState == .loaded {
                
                if let weather = viewModel.weather  {
                    ScrollView(showsIndicators: false) {
                        
                        VStack(spacing: 15) {
                            ZStack {
                                HStack(alignment: .top) {
                                    Text(viewModel.locationName)
                                        .font(.title)
                                        .foregroundColor(.white)
                                        .padding(.top, 20)
                                    
                                }
                                .frame(maxHeight: .infinity, alignment: .top)
                                .opacity( 1 - getTitleOpacity())
                                
                                
                                HeaderView(weather: weather, locationName: viewModel.locationName)
                                    .opacity(getTitleOpacity())
                                    .padding(.vertical, 30)
                                
                                
                            }
                            //                        .background(.red)
                            
                            //for dragging from bottom
                            .offset(y: -offset)
                            
                            //for dragging from top
                            .offset(y: offset > 0 ? (offset / UIScreen.main.bounds.width) * 100 : 0)
                            
                            .offset(y: getTitleOffset())
                            
                            if let weatherHourly = viewModel.weatherHourly {
                                ForEach(0..<7, id:\.self) { _ in
                                    HourlyWeatherView(weather: weatherHourly)
                                    
                                }
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
            } else if viewModel.loadingState == .loading {
                ProgressView()
                    .scaleEffect(2)
            }
        }
        .onAppear{
            withAnimation {
                viewModel.refresh()
            }
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
            
            let newOffset = (progress <= 1.0 ? progress : 1) * 30
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
