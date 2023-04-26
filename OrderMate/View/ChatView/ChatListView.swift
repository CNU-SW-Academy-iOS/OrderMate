import SwiftUI

@State var chatList : [BoardStructModel] = []
// 내가 속한 방 & 속했던 방 list
struct ChatListView: View {
    var body: some View {
        NavigationView {
            List {
                
            }
        }
    }
    
}

struct ChatListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatListView()
    }
}
