import SwiftUI

struct ChatListView: View {
    @EnvironmentObject var userManager: UserViewModel // user Info 받아오기
    @State var chatList: [RoomInfoPreview] = []
    @State var currentChat: RoomInfoPreview?
    @State var roomList = RoomList()
    
    // 내가 속한 방 & 속했던 방 list
    func chatListRefresh() {
        // ChatListView 새로고침
        chatList = []
        currentChat = nil
        userManager.getMyInfo()
        userManager.getAuthority()
        DispatchQueue.main.async {
            roomList.getParticipatedBoard { success, data in
                if success {
                    if var list = data as? [RoomInfoPreview] {
                        list = list.reversed()
                        if list.count > 0 {
                            if list.contains(where: { $0.postStatus != "END_OF_ROOM" }) {
                                if let idx = list.firstIndex(where: { $0.postStatus != "END_OF_ROOM" }) {
                                    currentChat = list[idx]
                                    chatList = list.filter {$0.postStatus == "END_OF_ROOM" }
                                }
                            } else {
                                chatList = list
                            }
                        } else {
                            chatList = []
                            currentChat = nil
                        }
                        
                    }
                }
            }
        }
    }
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    VStack {
                        Section(header: Text("현재 진행중인 주문").bold() ) {
                            NavigationLink {
                                if let id = currentChat?.postId {
                                    ChatView(postId: id)
                                }
                            } label: {
                                if let currentChat = currentChat {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text(currentChat.createdAt?.toStringYYMMDD() ?? "").foregroundColor(.gray)
                                            Text("|").foregroundColor(.gray)
                                            Text(currentChat.postStatus ?? "").foregroundColor(.gray)
                                            Spacer()
                                        }
                                        Text(currentChat.title ?? "").foregroundColor(.black).bold().font(.system(size: 20))
                                        Text(currentChat.pickupSpace ?? "").bold()
                                    }
                                }
                            }.padding().background(Color("green 0")).cornerRadius(15)
                            
                        }
                    }
                    
                    VStack {
                        Section {
                            ForEach(chatList, id: \.self) { list in
                                NavigationLink {
                                    if let id = list.postId {
                                        ChatView(postId: id)
                                    }
                                } label: {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text(list.createdAt?.toStringYYMMDD() ?? "").foregroundColor(.gray)
                                            Text("|").foregroundColor(.gray)
                                            Text(list.postStatus ?? "").foregroundColor(.gray)
                                            Spacer()
                                        }
                                        Text(list.title ?? "").foregroundColor(.black).bold().font(.system(size: 20))
                                        Text(list.pickupSpace ?? "").bold()
                                    }
                                }.padding().background(Color("green 0")).cornerRadius(15)
                            }
                        }
                    }
                }
                .cornerRadius(20)
                .listSectionSeparator(.hidden, edges: .bottom)
                .scrollContentBackground(.hidden)
                
            }
        }.refreshable {
            chatListRefresh()
        } .onAppear {
            chatListRefresh()
        }
        
    }
}

struct ChatListView_Previews: PreviewProvider {
    var chatList: [RoomInfoPreview]
    static var previews: some View {
        ChatListView(chatList: [RoomInfoPreview(postId: 5,
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
                                                ownerName: "soom"),
                                RoomInfoPreview(postId: 5,
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
                                                ownerName: "soom"),
                                RoomInfoPreview(postId: 5,
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
                                                ownerName: "soom")],
                     currentChat: RoomInfoPreview(postId: 5,
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
