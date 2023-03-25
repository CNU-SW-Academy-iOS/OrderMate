import SwiftUI

var listItem = ListItem()
struct ListItem {
    
    #warning("안쓰는 함수, Setting.swift")
    func title(currentRoom: Room) -> String {
        return currentRoom.title
    }
    //MARK: -aaaa
    func location(currentRoom: Room) -> String {
        currentRoom.location
    }
     
    func date(currentRoom: Room) -> String {
        return currentRoom.date.description
    }

}
