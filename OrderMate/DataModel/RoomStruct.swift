//
//  RoomStruct.swift
//  OrderMate
//
//  Created by 문영균 on 2023/03/06.
//

import Foundation


struct Room: Hashable, Identifiable, Codable {
    var id: String
    var title: String
    var location: String
    var date: Date
    var maxUser: Int
    var userList: [String] = []
}

struct User: Hashable, Codable {
    var name: String
}
