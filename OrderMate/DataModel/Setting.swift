//
//  Setting.swift
//  OrderMate
//
//  Created by yook on 2023/03/06.
//

import SwiftUI

var listItem = ListItem()
struct ListItem {
    
    func title(currentRoom: Room) -> String {
        return currentRoom.title
    }
    
    func location(currentRoom: Room) -> String {
        currentRoom.location
    }
     
    func date(currentRoom: Room) -> String {
        return currentRoom.date.description
    }

}
