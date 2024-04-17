//
//  BarProgressStyle.swift
//  SimpleActivity
//
//  Created by MobileR&D-Sothea007 on 3/4/24.
//

import SwiftUI

struct BarProgressStyle : ProgressViewStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                configuration.label?.font(.body)
                
                RoundedRectangle(cornerRadius: 10.0)
                    .fill(Color(uiColor: .systemGray5))
                    .frame(width: geometry.size.width, height: 10.0)
                    .overlay(alignment : .leading) {
                        ProgressView(configuration).tint(.yellow)
                    }
                
            }
        }
    }
}
