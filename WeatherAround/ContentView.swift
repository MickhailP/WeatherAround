//
//  ContentView.swift
//  WeatherAround
//
//  Created by Миша Перевозчиков on 26.05.2022.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = ViewModel(weatherAPI: WeatherService())
    
    var body: some View {
        ScrollView{

            Text(viewModel.forecast?.timezone ?? "fuck")
//            Text("\(viewModel.forecast?.current.clouds)")
        }
        .onAppear{
            viewModel.refresh()
            
        }
//        .onAppear {
//            Task{
//                locationManager.getLocation()
//            }
//            Task{
//                if let location = locationManager.location {
//                    do {
//                     try await viewModel.forecast =  weatherManager.getWeatherData(latitude: location.latitude, longitude: location.longitude)
//                        print("Weather forecast has successfully gotten")
//                    } catch{
//                      print("Fetching failed")
//                    }
//                }
//                print("Failed")
//            }
//        }
//        .task {
////            locationManager.getLocation()
//            print(locationManager.location)
//            if let location = locationManager.location {
//                do {
//                 try await viewModel.forecast =  weatherManager.getWeatherData(latitude: location.latitude, longitude: location.longitude)
//                    print("Weather forecast has successfully gotten")
//                } catch{
//                  print("Fetching failed")
//                }
//            }
//            print("Failed")
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
