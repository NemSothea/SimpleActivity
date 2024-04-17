//
//  caffee.swift
//  caffee
//
//  Created by MobileR&D-Sothea007 on 2/4/24.
//

import WidgetKit
import SwiftUI

struct caffee: Widget {
    let kind: String = "caffee"
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: OrderAttributes.self) { context in
            // Lock screen/banner UI goes here
            // MAX : 220 pixcel
            LiveActivityView(context: context.state,statusType: context.attributes)
            
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("\(context.state.status.rawValue)".uppercased())
                        .fontWeight(.medium)
                        .foregroundColor(.yellow)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    HStack {
                        Text("\(context.attributes.orderNumber)")
                        Image(systemName: "cup.and.saucer.fill")
                    }
                    .foregroundColor(.yellow)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    ExpandedRegionView(context: context.state)
                }
            } compactLeading: {
                Text("\(context.attributes.orderItem)")
                    .foregroundColor(.yellow)
            } compactTrailing: {
                HStack {
                    Text("\(context.attributes.orderNumber)")
                    Image(systemName: "cup.and.saucer.fill")
                }
                .foregroundColor(.yellow)
               
            } minimal: {
                Image(systemName: "cup.and.saucer.fill")
                .foregroundColor(.yellow)
            }
            .widgetURL(URL(string: "https://kosignstore.wecambodia.com/"))
            .keylineTint(Color.red)
        }
    }
}

/*
 .request
 .process
 .completed
 .rejected
 */
struct Widget_Previews : PreviewProvider {
   
    static let arrttributes = OrderAttributes(orderid: 101, orderNumber: 2, orderItem: "Caffee")
    static let numberItem = arrttributes.orderNumber
    
    static var previews: some View {
      
        Group {
            arrttributes.previewContext(OrderAttributes.ContentState(status: .request, spendingTime: Date()...Date().addingTimeInterval(TimeInterval(numberItem * 0))), viewKind: .content)
            
            arrttributes.previewContext(OrderAttributes.ContentState(status: .process, spendingTime: Date()...Date().addingTimeInterval(TimeInterval(numberItem * 120))), viewKind: .content)
            
            arrttributes.previewContext(OrderAttributes.ContentState(status: .completed, spendingTime: Date()...Date().addingTimeInterval(TimeInterval(numberItem * 0))), viewKind: .content)
            
            arrttributes.previewContext(OrderAttributes.ContentState(status: .rejected, spendingTime: Date()...Date().addingTimeInterval(TimeInterval(numberItem * 0))), viewKind: .content)
            
        }
       
    }
}
