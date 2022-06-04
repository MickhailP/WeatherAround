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

//            Text(viewModel.forecast?.timezone ?? "fuck")

        }
        .onAppear{
            viewModel.refresh()
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
