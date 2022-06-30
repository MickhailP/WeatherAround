//
//  LoadingView.swift
//  WeatherAround
//
//  Created by Миша Перевозчиков on 29.06.2022.
//

import SwiftUI

struct LoadingCircle: View  {
    
    var strokeColor: Color = .red
    var strokeWidth: CGFloat  = 3
    
    var rotation: Angle
    var start: CGFloat
    var end: CGFloat

    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: start , to: end)
                .stroke(strokeColor, style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round))
                
            
        }
        .rotationEffect(rotation)
    }
    
}

struct LoadingView: View {
    
    let rotationTime: Double = 0.75
    let fullRotation: Angle = .degrees(360)
    static let startPoint: Angle = .degrees(270)
    let animationTime: Double = 1.9
    
    @State private var animationAmount = 1.5
    
//    @State private var rotation: Angle = .degrees(0.2)
    @State private var start: CGFloat = 0.0
    @State private var end: CGFloat = 0.03
    
    @State private var rotationDegrees = startPoint
    
    var body: some View {
        ZStack {
            Image(systemName: "cloud.fill")
                .interpolation(.none)
                .foregroundColor(.gray)
                .font(.title)
                .shadow(radius: 5)
                .scaleEffect(animationAmount)
                .overlay(
                    Circle()
                        .stroke(.gray, lineWidth: 3)
                        .shadow(radius: 10)
                        .frame(width: 100, height: 100)
                        .offset(y: 2)
                        
                        
                )
                .onAppear{
                    withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true )) {
                        
                        self.animationAmount = 2
                        
                    }
                }
            
            LoadingCircle(rotation: rotationDegrees, start: start, end: end)
                .frame(width: 100, height: 100)
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
        animateSpinner(with: (rotationTime * 2) - 0.025) {
            self.rotationDegrees += fullRotation
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
