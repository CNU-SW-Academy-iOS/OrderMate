//
//  ChatModel.swift
//  OrderMate
//
//  Created by 이수민 on 2023/04/07.
//

import Foundation

struct Message: Codable, Identifiable {
    var id: String
    var text: String
    var timestamp: Date
    var userId: String
    var userNickName: String


}

extension Message {
    func changeDateFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH : mm"
        return dateFormatter.string(from: self.timestamp)
    }
}
