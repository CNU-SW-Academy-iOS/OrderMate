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
