//
//  ExpandedRegionView.swift
//  SimpleActivity
//
//  Created by MobileR&D-Sothea007 on 2/4/24.
//

import SwiftUI
import WidgetKit

// ExpandedRegionView
struct ExpandedRegionView : View {
    
    // Variable
    let context     : OrderAttributes.ContentState
    
    var body: some View {
        
        VStack {
            if context.status == .request {
                ProgressView(value: 1.0, total: 1) {
                   
                        Text(.now, style: .timer).font(.system(size: 8)).multilineTextAlignment(.center)
                }
                .progressViewStyle(.circular)
                .tint(.yellow)
                Text("\(context.description)")
                    .font(.body)
                    .foregroundColor(.yellow)
            }else if context.status == .process ||  context.status == .completed {
                ProgressView(value: 1.0, total: 1) {
                   
                        Text(.now, style: .timer).font(.system(size: 8)).multilineTextAlignment(.center)
                }
                .progressViewStyle(.circular)
                .tint(.green)
                Text("\(context.description)")
                    .font(.body)
                    .foregroundColor(.green)
                
            }else {
                ProgressView(value: 1.0, total: 1) {
                   
                        Text(.now, style: .timer).font(.system(size: 8)).multilineTextAlignment(.center)
                }
                .progressViewStyle(.circular)
                .tint(.red)
                Text("\(context.description)")
                    .font(.body)
                    .foregroundColor(.red)
            }
        }
        
    }
}

