//
//  BackgroundView.swift
//  WeatherAround
//
//  Created by Миша Перевозчиков on 06.11.2022.
//

import SwiftUI

struct BackgroundView:View {
    
    var body: some View {
        ZStack{
            Image("appBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .frame(maxWidth: .infinity)
            
            
            LinearGradient(gradient: Gradient(colors: [.indigo, .white]), startPoint: .topLeading, endPoint: .bottom)
                .ignoresSafeArea()
                .opacity(0.4)
                .blur(radius: 100)
            
            Color.gray.opacity(0.3)
                .ignoresSafeArea()
            
        }
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}
