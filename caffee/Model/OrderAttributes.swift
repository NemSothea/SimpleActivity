//
//  File.swift
//  Bizcard4.0
//
//  Created by MobileR&D-Sothea007 on 21/3/24.
//  Copyright © 2024 KOSIGN. All rights reserved.
//

import WidgetKit
import ActivityKit

struct OrderAttributes: ActivityAttributes {
    
    //when you don't want to update the state if the new update has come so you need to add value here
    var orderid     : Int
    var orderNumber : Int
    var orderItem   : String
    
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here
        // when you want to update the state if the new update has come so you need to add value here
        let status      : Status
        var spendingTime: ClosedRange<Date>
        
        init(status:Status = .request, spendingTime : ClosedRange<Date>) {
            self.status = status
            self.spendingTime = spendingTime
        }
        var description: String {
            switch status {
            case .request:
                return "We're checking your request"
            case .process:
                return "We're preparing your order"
            case .completed:
                return "Your order is ready to pick up!"
            case .rejected:
                return "Your order is out of stock!"
            }
        }
    }
}

