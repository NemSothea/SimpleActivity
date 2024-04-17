//
//  File.swift
//  SimpleActivity
//
//  Created by MobileR&D-Sothea007 on 5/4/24.
//

import Foundation
// MARK: - Order Status
enum Status : String , CaseIterable , Codable   {
    case request    = "request"
    case process    = "process"
    case completed  = "completed"
    case rejected   = "rejected"
}
