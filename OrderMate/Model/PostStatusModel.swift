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

enum PostStatusEnum: String, Codable {
    case ENDOFROOM = "END_OF_ROOM"
    case RECRUITING = "RECRUITING"
    case RECRUITMENTCOMPLETE = "RECRUITMENT_COMPLETE"
    case ORDERCOMPLETE = "ORDER_COMPLETE"
    case PAYMENTCOMPLETE = "PAYMENT_COMPLETE"
    case DELIVERYCOMPLETE = "DELIVERY_COMPLETE"

}
