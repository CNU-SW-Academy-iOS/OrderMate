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
    case endOfRoom = "END_OF_ROOM"
    case recruiting = "RECRUITING"
    case recruitmentComplete = "RECRUITMENT_COMPLETE"
    case orderComplete = "ORDER_COMPLETE"
    case paymentComplete = "PAYMENT_COMPLETE"
    case deliveryComplete = "DELIVERY_COMPLETE"

}
