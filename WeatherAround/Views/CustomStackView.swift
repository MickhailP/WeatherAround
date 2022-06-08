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
        ZStack {
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(.white.opacity(0.1))
            VStack{
                titleView
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
                    .zIndex(1)
                
                VStack {
                    Divider()
                    
                    contentView
                        
                }
                .offset(y: topOffset >= 120 ? 0 : -(-topOffset + 120))
                .zIndex(0)
                .clipped()
                
            }
            .padding(.horizontal,5)
            .padding(.bottom, 10)
            .frame(maxWidth: .infinity)
            
        }
        
        .offset(y: topOffset >= 120 ? 0 : -topOffset + 120)
        .background(
            
            GeometryReader { proxy  -> Color in
                
                let minY = proxy.frame(in: .global).minY
                
                DispatchQueue.main.async {
                    self.topOffset = minY
                }
                return .clear
                
            }
        )
    }
}

struct CustomStackView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(topEdge: 100)
    }
}
