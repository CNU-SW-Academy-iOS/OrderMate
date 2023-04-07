//
//  ChatModel.swift
//  OrderMate
//
//  Created by 이수민 on 2023/04/07.
//

import Foundation

struct Message: Hashable, Codable {
    var username: String
    var nickname: String
    var text: String
    var timestamp: Date
}

extension Message {
    func changeDateFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH : mm"
        return dateFormatter.string(from: self.timestamp)
    }
}
