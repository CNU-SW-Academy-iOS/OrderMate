//
//  BoardStruct.swift
//  OrderMate
//
//  Created by 문영균 on 2023/03/15.
//

import Foundation

struct Board: Codable {
    var ownerName: String? = nil
    var title: String
    var createdAt: Date? = nil
    var postStatus: Bool? = nil
    var maxPeopleNum: Int
    var currentPeopleNum: Int
    var isAnonymous: Bool
    var content: String
    var withOrderLink: String?
    var pickupSpace: String
    var spaceType: String
    var accountNum: String
//    var estimatedOrderTime: Date? = nil
//    var participationList: [String: String]? = nil
    var commentList: [String]? = nil
    
}
