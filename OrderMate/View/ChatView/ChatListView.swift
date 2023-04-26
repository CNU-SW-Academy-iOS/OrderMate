import SwiftUI


struct ChatListView: View {
  
    @State var chatList : [RoomInfoPreview] = []
    @State var currentChat : RoomInfoPreview
    @State var roomList = RoomList()
    
    // 내가 속한 방 & 속했던 방 list
    func chatListRefresh() {
        // ChatListView 새로고침
        DispatchQueue.main.async {
            roomList.getParticipatedBoard { success, data in
                if let list = data as? [RoomInfoPreview] {
                    currentChat = list[0]
                    chatList = Array(list[1...])
                }
            }
        }
    }
    var body: some View {
        NavigationView {
            NavigationLink {
                ChatView(postId: currentChat.postId, chatBoard: currentChat)
            } label: {
                VStack (alignment: .leading) {
                    Text("현재 진행중인 주문")
                    HStack {
                        Text(currentChat.createdAt?.toStringYYMMDD() ?? "")
                        Text("|")
                        Text(currentChat.postStatus ?? "")
                        Spacer()
                    }.padding()
                    Text(currentChat.title ?? "")
                    Text(currentChat.pickupSpace ?? "")
                }.padding()
            }

    
            List {
                ForEach(chatList, id: \.self) { chat in
                    //Text()
                }
            }
        }
    }
    
}

struct ChatListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatListView(currentChat: RoomInfoPreview(postId: 5,
                                                  title: "교촌치킨 같이 시켜먹어요",
                                                  createdAt: Date(),
                                                  postStatus: "배달 완료",
                                                  maxPeopleNum: 5,
                                                  currentPeopleNum: 3,
                                                  isAnonymous: true,
                                                  content: "hi",
                                                  withOrderLink: "hi",
                                                  pickupSpace: "기숙사",
                                                  spaceType: "hi",
                                                  accountNum: "hi",
                                                  estimatedOrderTime: Date(),
                                                  ownerId: 2,
                                                  ownerName: "soom"))
    }
}
