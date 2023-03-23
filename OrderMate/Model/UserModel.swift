//
//  UserModel.swift
//  OrderMate
//
//  Created by 이수민 on 2023/03/11.
//

import Foundation

struct UserModel: Codable {
    var username: String
    var password: String
    var name: String = ""
    var nickName: String = ""
    var gender: String = ""
    var school: String = ""
    var major: String = ""

    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}
