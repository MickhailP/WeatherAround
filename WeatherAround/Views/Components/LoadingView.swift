//
//  LoadingView.swift
//  WeatherAround
//
//  Created by Миша Перевозчиков on 29.06.2022.
//

import SwiftUI

struct LoadingCircle: View  {
    
    var strokeColor: Color = .blue.opacity(0.6)
    var strokeWidth: CGFloat  = 3
    
   
    var start: CGFloat
    var end: CGFloat
    var rotation: Angle
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: start , to: end)
                .stroke(strokeColor, style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round))
                .rotationEffect(rotation)
                
            
        }
    }
    
}

struct LoadingView: View {
    
    let rotationTime: Double = 1
    let fullRotation: Angle = .degrees(360)
    static let startPoint: Angle = .degrees(270)
    let animationTime: Double = 1.9
    
    @State private var animationAmount = 2.2
    
//    @State private var rotation: Angle = .degrees(0.2)
    @State private var start: CGFloat = 0.0
    @State private var end: CGFloat = 0.03
    
    @State private var rotationDegrees = startPoint
    
    var body: some View {
        ZStack {
            ZStack {
                Image(systemName: "cloud.fill")
                    .interpolation(.none)
                    .foregroundColor(.gray.opacity(0.1))
                    .font(.title2)
                
                    .shadow(radius: 5)
                    .scaleEffect(animationAmount)
                Image(systemName: "cloud")
                    .interpolation(.none)
                    .foregroundColor(.gray.opacity(0.3))
                    .font(.title2)
                
                    
                    .scaleEffect(animationAmount)
            }
                .shadow(radius: 5)
                .onAppear{
                    withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true )) {
                        
                        self.animationAmount = 2
                        
                    }
                }
            
            Circle()
                .stroke(.gray.opacity(0.3), lineWidth: 4)
                .shadow(color: .gray.opacity(0.5), radius: 5)
                .frame(width: 80, height: 80)
                .offset(y: 2)
                
            
            LoadingCircle(start: start, end: end, rotation: rotationDegrees)
                .frame(width: 80, height: 80)
                .offset(y: 2)
                .onAppear() {
                    Timer.scheduledTimer(withTimeInterval: animationTime, repeats: true) { mainTimer in
                        self.animateSpinner()
                    }
                }
    
        }
    }
    
    func animateSpinner(with timeInterval: Double, completionHandler: @escaping
                        (()-> Void)) {
        Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false)  { _ in
            withAnimation(.easeInOut(duration: rotationTime)) {
                completionHandler()

            }
        }
    }
    
    func animateSpinner() {
        animateSpinner(with: rotationTime) {
            self.end = 1
        }
        
        animateSpinner(with: (rotationTime * 2) ) {
        self.start = self.end - 0.5
            self.end = self.start + 0.3
            

        }
        
        animateSpinner(with: (rotationTime * 2 ) - 0.01) {
            self.rotationDegrees += fullRotation
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
