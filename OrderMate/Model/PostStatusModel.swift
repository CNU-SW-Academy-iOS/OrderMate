//
//  PostStatusModel.swift
//  OrderMate
//
//  Created by yook on 2023/04/05.
//

import Foundation

struct PostStatusModel: Codable {
    var directionType: String
    var currentStatus: String
}

enum PostStatusEnum: Codable {
    case ENDOFROOM
    case RECRUITING
    case RECRUITMENTCOMPLETE
    case ORDERCOMPLETE
    case PAYMENTCOMPLETE
    case DELIVERYCOMPLETE
    
    func description() -> String {
        switch self {
        case .ENDOFROOM:
            return "END_OF_ROOM"
        case .RECRUITING:
            return "RECRUITING"
        case .RECRUITMENTCOMPLETE:
            return "RECRUITMENT_COMPLETE"
        case .ORDERCOMPLETE:
            return "ORDER_COMPLETE"
        case .PAYMENTCOMPLETE:
            return "PAYMENT_COMPLETE"
        case .DELIVERYCOMPLETE:
            return "DELIVERY_COMPLETE"
        }
    }
}
