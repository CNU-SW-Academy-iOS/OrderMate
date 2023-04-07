//
//  SwiftUIView.swift
//  OrderMate
//
//  Created by 이수민 on 2023/04/07.
//

import SwiftUI

struct ChatView: View {
    let postID = 1
    let nickname = "sumin"
    
    var body: some View {
        VStack {
            HStack {
                Text("방 제목")
                    .font(.title)
                Spacer()
                Text("3/5")
            }
            ScrollViewReader { scrollView in
                ScrollView {
                    VStack {
                        MessageView(username: "12",
                                    currentMessage: Message(username: "12",
                                                            nickname: "soom",
                                                            text: "안녕하세요",
                                                            timestamp: Date()))
                        MessageView(username: "12",
                                    currentMessage: Message(username: "23",
                                                            nickname: "lee",
                                                            text: "반갑습니다",
                                                            timestamp: Date()))
                        MessageView(username: "12",
                                    currentMessage: Message(username: "12",
                                                            nickname: "soom",
                                                            text: "배고파서 얼른 주문하고 싶네요",
                                                            timestamp: Date()))
                        MessageView(username: "12",
                                    currentMessage: Message(username: "12",
                                                            nickname: "soom",
                                                            text: "뭐먹지",
                                                            timestamp: Date()))
                        MessageView(username: "12",
                                    currentMessage: Message(username: "23",
                                                            nickname: "lee",
                                                            text: "그러게요",
                                                            timestamp: Date()))
                        MessageView(username: "12",
                                    currentMessage: Message(username: "33",
                                                            nickname: "kim",
                                                            text: "그냥 지금 주문할까요 ?",
                                                            timestamp: Date()))
                        
                    }
                }
            }
        }.padding(.horizontal)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
