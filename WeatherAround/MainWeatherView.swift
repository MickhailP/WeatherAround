//
//  MainWeatherView.swift
//  WeatherAround
//
//  Created by Миша Перевозчиков on 26.05.2022.
//

import SwiftUI

struct MainWeatherView: View {
    
    @StateObject var viewModel: MainWeatherViewViewModel
    
    @State private var offset: CGFloat = 0
    
    private let topEdge: CGFloat
    
    init(from weatherObject: WeatherObject?, weatherManager: WeatherManagerProtocol, topEdge: CGFloat) {
        if let weatherObject = weatherObject {
            _viewModel = StateObject(wrappedValue: MainWeatherViewViewModel(from: weatherObject, weatherManager: weatherManager))
            
        } else {
            _viewModel = StateObject(wrappedValue: MainWeatherViewViewModel(weatherManager: weatherManager))
        }
        
        self.offset = 0
        self.topEdge = topEdge
        
    }
    
    
    var body: some View {
        ZStack{
            BackgroundView()
            
            if viewModel.loadingState == .loading {
                
                loadingPlaceholder
                
            } else if viewModel.loadingState == .loaded {
                
                if
                    let weather = viewModel.currentWeather,
                    let weatherHourly = viewModel.hourlyWeather,
                    let weatherDaily = viewModel.dailyWeather,
                    let location = viewModel.location
                {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 15) {
                            headerSection(weather, location)
                            HourlyWeatherView(weather: weatherHourly)
                            DailyForecastView(weatherDaily: weatherDaily)
                            WeatherDetailView(weather: weather)
                        }
                        .padding(.top, 25)
                        .padding(.top, topEdge)
                        .padding([.horizontal, .bottom])
                        .overlay(
                            // read the frames to adjust scrolling animations
                            GeometryReader{ proxy -> Color in
                                let minY = proxy.frame(in: .global).minY
                                
                                DispatchQueue.main.async {
                                    self.offset = minY
                                }
                                return .clear
                            }
                        )
                    }
                } else if viewModel.loadingState == .failed {
                    Text("FAIL")
                }
            }
        }
        .onAppear {
        
        }
//        .navigationBarHidden(true)
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


extension MainWeatherView {

    
// MARK: headerSection component
    private func headerSection(_ weather: Weather, _ location: Location) -> some View {
       return ZStack {
            HStack(alignment: .top) {
                Text(location.name)
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.top, 20)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .opacity( 1 - getTitleOpacity())
            
            
            HeaderView(weather: weather, locationName: location.name)
                .opacity(getTitleOpacity())
                .padding(.vertical, 30)
        }
        // DRAGGING MODIFIERS
        // for dragging from bottom
        .offset(y: -offset)
        // for dragging from top
        .offset(y: offset > 0 ? (offset / UIScreen.main.bounds.width) * 100 : 0)
        .offset(y: getTitleOffset())
    
    }
    
// MARK: loadingPlaceholder component
    private var loadingPlaceholder: some View {
        VStack(spacing: 10) {
            LoadingView()
            Text("Loading weather data...")
                .foregroundColor(.white.opacity(0.8))
                .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static let viewMode = WeatherManager()
    
    static var previews: some View {
        
        MainWeatherView(from: WeatherObject.example, weatherManager: WeatherManager(), topEdge: 100)
    }
}
