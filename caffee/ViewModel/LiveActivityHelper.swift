//
//  LiveActivityHelper.swift
//  Bizcard4.0
//
//  Created by MobileR&D-Sothea007 on 25/3/24.
//  Copyright © 2024 KOSIGN. All rights reserved.
//

import Foundation
import ActivityKit
import SwiftUI

@available(iOS 16.2, *)

final class LiveActivityHelper {
    
//    @State var currentID : String = ""
//    @State var currentStatus : Status = .request
    
    static var shared = LiveActivityHelper()
    private var orderActivity: Activity<OrderAttributes>?
    
    private init() {}
    
    func startLiveActivity(userInfo : [String:Any]) {
        
        if orderActivity != nil {
            return
        }
        
        let orderid     = userInfo["orderid"] as? Int ?? 1
        let orderNumber = userInfo["orderNumber"] as? Int ?? 0
        let orderItem   = userInfo["orderItem"] as? String ?? ""
        
        let orderAttributes = OrderAttributes(orderid: orderid, orderNumber: orderNumber, orderItem: orderItem)
       
        let intialContentState = OrderAttributes.ContentState(spendingTime: Date()...Date().addingTimeInterval(0))
        
        let content = ActivityContent(state: intialContentState, staleDate: nil, relevanceScore: 1.0)
        
        do {
            
            orderActivity = try Activity<OrderAttributes>.request(
                attributes: orderAttributes,
                content: content,
                pushType: nil)
            
            print("Activity added Successfully : \(orderActivity?.id ?? "")")
        }catch {
            print(error.localizedDescription)
        }
        
    }
    
    func updateLiveActivity(status : Status,userInfo : [String:Any]) async {
        
        // Update the existing live activity
        let orderNumber = userInfo["orderNumber"] as? Int ?? 0
        /*
         - 1 cup : Need three minutes for cook so I need to count down.
         */
        let state = OrderAttributes.ContentState(status: status, spendingTime: Date()...Date().addingTimeInterval(TimeInterval(orderNumber * 120)))
        
        var alert: AlertConfiguration?
        
        switch status {
        case .completed,.rejected:
            alert = AlertConfiguration(title: "\(state.description)", body: "", sound: .default)
            
            await orderActivity?.update(
                ActivityContent<OrderAttributes.ContentState>(
                    state: state,
                    staleDate: nil
                ),
                alertConfiguration: alert
            )
            
            self.endLiveActivity(status: status)
            
        default :
            
//            if let activity = Activity.activities.first(where: { ( activity:Activity<OrderAttributes>) in
//                activity.id == currentID
//            }) {
//                print("Actity Found")
//                
//                var updateState = activity.content.state
//                updateState.status = currentStatus
//            }
            
            await orderActivity?.update(
                ActivityContent<OrderAttributes.ContentState>(
                    state: state,
                    staleDate: nil
                ),
                alertConfiguration: alert
            )
        }
    }
    private func endLiveActivity(status : Status) {
        // 10 second End the existing live activity

        DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: {
            Task {
                
                let spendingTime = Date()...Date().addingTimeInterval(0)
                
                await self.orderActivity?.end(
                    ActivityContent(state: OrderAttributes.ContentState.init(status: status, spendingTime: spendingTime),
                                    staleDate: nil),
                    dismissalPolicy: .immediate
                )
                self.orderActivity = nil
            }
            
        })
    }
    
}
