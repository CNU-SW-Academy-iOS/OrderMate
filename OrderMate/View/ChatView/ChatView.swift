import SwiftUI

struct ChatView: View {
    var postId: Int
    var chatBoard: BoardStructModel
    @State private var sendMessage: String = ""
    @StateObject private var manager = ChatViewModel.shared
    let userID = userIDModel.username
    
    var body: some View {
        
        VStack {
            VStack {
                ZStack {
                    Text(chatBoard.title)
                    HStack {
                        Spacer()
                        Text("\(chatBoard.currentPeopleNum)/\(chatBoard.maxPeopleNum)")
                    }
                    
                }
                Text("함께 주문하기 링크: \(chatBoard.withOrderLink ?? "")")
            }
            ScrollViewReader { scrollView in
                ScrollView {
                    VStack {
                        ForEach(manager.msgList) {
                            MessageView(currentMessage: $0).id($0.id)
                        }
                    }
                    .onChange(of: manager.lastMsgID, perform: { newValue in
                        withAnimation {
                            scrollView.scrollTo(newValue, anchor: .bottom)
                        }
                    })
                }
            }
            HStack {
                TextField("Message 입력", text: $sendMessage, axis: .vertical)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("send") {
                    send()
                }
            }

        }.padding(.horizontal)
            .onAppear(perform: {
                ChatViewModel.shared.getChatInfo(postId: postId)
                ChatViewModel.shared.listenRoomChat(postId: postId)
            })
    }
    func send() {
        let msg = Message(id: UUID().uuidString, text: sendMessage, timestamp: Date(), userId: userID ?? "", userNickName: UserViewModel.shared.userModel.nickname)
        ChatViewModel.shared.sendMessageInServer(postId: postId, msg: msg)
        sendMessage = ""
    }
   
}
