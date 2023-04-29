import SwiftUI

struct ChatView: View {
    var postId: Int
    @State private var sendMessage: String = ""
    @StateObject private var manager = ChatViewModel.shared
    let userID = userIDModel.username
    
    var body: some View {
        
        VStack {
            VStack {
                ZStack {
                    Text("[ \(manager.board.title) ]").bold()
                    HStack {
                        Spacer()
                        Text("\(manager.board.currentPeopleNum)/\(manager.board.maxPeopleNum)")
                    }
                }
                if let link = manager.board.withOrderLink {
                    if link.contains("골라보세요. ") {
                        if let url = URL(string: String(link.split(separator: "골라보세요. ")[1])) {
                            Link(destination: url) {
                                Text("배민 함께 주문하기 링크")
                            }
                        }
                    }
                }
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
                Button {
                    send()
                } label: {
                    Text("send").padding(5).foregroundColor(.white).background(Color("green 2")).cornerRadius(10)
                }
            }.padding(5)
            
        }.padding(.horizontal)
            .onAppear(perform: {
                ChatViewModel.shared.getChatInfo(postId: postId)
                ChatViewModel.shared.listenRoomChat(postId: postId)
            })
            .onAppear (perform : UIApplication.shared.hideKeyboard)
        
    }
    func send() {
        let msg = Message(id: UUID().uuidString, text: sendMessage, timestamp: Date(), userId: userID ?? "", userNickName: UserViewModel.shared.userModel.nickname)
        ChatViewModel.shared.sendMessageInServer(postId: postId, msg: msg)
        sendMessage = ""
    }
    
}
