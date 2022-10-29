//
//  CustomStackView.swift
//  WeatherAround
//
//  Created by Миша Перевозчиков on 07.06.2022.
//

import SwiftUI

struct CustomStackView <Title: View, Content: View> : View {
    var titleView: Title
    var contentView: Content
    
    @State private var topOffset: CGFloat = 0
    @State private var bottomOffset: CGFloat = 0
    
    
    init(@ViewBuilder titleView: @escaping () -> Title, @ViewBuilder contentView: @escaping () -> Content) {
        self.contentView = contentView()
        self.titleView = titleView()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            titleView
                .lineLimit(1)
                .frame(height: 30)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 5)
                .padding(.leading, 10)
                .foregroundColor(.secondary)
                .font(.caption)
                .textCase(.uppercase)
                .background(.white.opacity(0.2), in: CustomCorners(corners: bottomOffset < 35 ? .allCorners : [.topLeft, .topRight], radius: 15))
                .zIndex(1)
            
            VStack {
                Divider()
                    .padding(.horizontal, 5)
                
                
                contentView
                    .padding(.horizontal, 15)
                    .padding(.bottom, 10)
                
            }
            .background(.white.opacity(0.2), in: CustomCorners(corners: [.bottomLeft, .bottomRight], radius: 15))
            .offset(y: topOffset >= 120 ? 0 : -(-topOffset + 120))
            .zIndex(0)
            .clipped()
            .opacity(changeOpacity())
            
        }
        
        .frame(maxWidth: .infinity)
        .cornerRadius(15)
        .opacity(changeOpacity())
        .offset(y: topOffset >= 120 ? 0 : -topOffset + 120)
        .background(
            
            GeometryReader { proxy  -> Color in
                
                let minY = proxy.frame(in: .global).minY
                let maxY = proxy.frame(in: .global).maxY
                
                DispatchQueue.main.async {
                    self.topOffset = minY
                    self.bottomOffset = maxY - 120
                }
                return .clear
                
            }
        )
        .modifier(CornerModifier(bottomOffset: $bottomOffset))
    }
    
    func changeOpacity() -> CGFloat {
        if bottomOffset < 28 {
            let progress = bottomOffset / 28
            
            return progress
        }
        return 1
    }
}

struct CornerModifier: ViewModifier {
    @Binding var bottomOffset: CGFloat
    
    func body(content: Content) -> some View {
        if bottomOffset < 35 {
            content
        } else {
            content
                .cornerRadius(15)
        }
    }
}


struct CustomStackView_Previews: PreviewProvider {
    
    static let wm = WeatherManager()
    
    static var previews: some View {
        MainWeatherView(location: nil, weatherManager: wm, topEdge: 100)
    }
}

