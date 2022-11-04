//
//  IconView.swift
//  WeatherAround
//
//  Created by Миша Перевозчиков on 04.11.2022.
//

import SwiftUI

struct IconView: View {
    
    let color1: Color = Color(hex: "#B993D6") ?? .black
    let color2: Color =  Color(hex: "#8CA6DB") ?? .black
    
    // Jaipur
//    let color2: Color = Color(hex: "#DBE6F6") ?? .black
//    let color1: Color =  Color(hex: "#C5796D") ?? .black
    
    // Venice
//    let color2: Color = Color(hex: "#6190E8") ?? .black
//    let color1: Color =  Color(hex: "#A7BFE8") ?? .black
    
    // UltraViolet
//    let color1: Color = Color(hex: "#eaafc8") ?? .black
//    let color2: Color =  Color(hex: "#654ea3") ?? .black
    
    // Day/Night
//    let color1: Color = Color(hex: "#2c3e50") ?? .black
//    let color2: Color =  Color(hex: "#3498db") ?? .black
//

    var body: some View {
        ZStack {
            
            
//            LinearGradient(gradient:
//                            Gradient(colors: [
//                                color1, color2
//                            ]),
//                           startPoint: .bottom, endPoint: .top)
            LinearGradient(gradient:
                            Gradient(colors: [
                                color1, color2
                            ]),
                           startPoint: .topLeading, endPoint: .bottomTrailing)
            
            
            if #available(iOS 16.0, *) {
                Image(systemName: "cloud.fill")
                    .interpolation(.none)
                    .font(.system(size: 330))
                    .foregroundStyle(
                        .white.gradient
                            .shadow(
                            .inner(color: .black.opacity(0.25), radius: 20)
                        )
                    )
                    
            } else {
                // Fallback on earlier versions
            }
            
            

        }
        .frame(maxWidth: 450, maxHeight: 450)
//        .clipShape(RoundedRectangle(cornerRadius: 40, style: .continuous))
       
    }
}

struct IconView_Previews: PreviewProvider {
    static var previews: some View {
        IconView()
    }
}


