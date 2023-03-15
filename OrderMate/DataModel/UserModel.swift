//
//  UserModel.swift
//  OrderMate
//
//  Created by 이수민 on 2023/03/11.
//

import Foundation


struct UserModel : Codable {
    let username : String
    let password : String
    let name : String?
    let nickName : String?
    let gender : String?
    let school : String?
    let major : String?
}

struct PostUser: Codable {
    let username : String
    let password : String
    let name : String
    let nickName : String
    let gender : String
    let school : String
    let major : String

}

struct LoginUser: Codable {
    let username : String
    let password : String

}
