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
//    func roomInfoPreviewToBoardStructModel(room: RoomInfoPreview) -> BoardStructModel {
//        return BoardStructModel(loginUsername: nil,
//                                ownerName: room.ownerName,
//                                title: room.title ?? "",
//                                createdAt: room.createdAt,
//                                postStatus: PostStatusEnum(rawValue: room.postStatus ?? "END_OF_ROOM"),
//                                maxPeopleNum: room.maxPeopleNum ?? 0,
//                                currentPeopleNum: room.currentPeopleNum ?? 0,
//                                isAnonymous: room.isAnonymous ?? false,
//                                content: room.content ?? "",
//                                withOrderLink: room.withOrderLink ?? "",
//                                pickupSpace: room.pickupSpace ?? "",
//                                spaceType: room.spaceType ?? "",
//                                accountNum: room.accountNum ?? "",
//                                estimatedOrderTime: room.estimatedOrderTime ?? Date(),
//                                participationList: nil,
//                                commentList: nil)
//
//    }
    var body: some View {
        NavigationView {
            ZStack {
                Color("grren 2")
                List {
                    VStack {
                        Section(header: Text("현재 진행중인 주문").bold() ) {
                            NavigationLink {
                                if let id = currentChat.postId {
                                    ChatView(postId: id)
                                }
                            } label: {
                                VStack (alignment: .leading) {
                                    HStack {
                                        Text(currentChat.createdAt?.toStringYYMMDD() ?? "").foregroundColor(.gray)
                                        Text("|").foregroundColor(.gray)
                                        Text(currentChat.postStatus ?? "").foregroundColor(.gray)
                                        Spacer()
                                    }
                                    Text(currentChat.title ?? "").font(.title).foregroundColor(.black).bold()
                                    Text(currentChat.pickupSpace ?? "").bold()
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
                                    VStack (alignment: .leading) {
                                        HStack {
                                            Text(currentChat.createdAt?.toStringYYMMDD() ?? "").foregroundColor(.gray)
                                            Text("|").foregroundColor(.gray)
                                            Text(currentChat.postStatus ?? "").foregroundColor(.gray)
                                            Spacer()
                                        }
                                        Text(currentChat.title ?? "").font(.title).foregroundColor(.black).bold()
                                        Text(currentChat.pickupSpace ?? "").bold()
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
    var chatList : [RoomInfoPreview]
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
