//
//  MyMessage.swift
//  OrderMate
//
//  Created by 이수민 on 2023/04/07.
//

import SwiftUI

struct MessageView: View {
    
    var username: String // 현재 채팅방 들어온 사람의 id
    var currentMessage: Message
    var body: some View {
        VStack {
            let isCurrentUser = username == currentMessage.username
            
            if isCurrentUser {
                HStack {
                    Spacer()
                    Text(currentMessage.nickname)
                }
                HStack {
                    Spacer()
                    Text(currentMessage.text)
                        .frame(minWidth: 80, maxWidth: 200)
                        .padding()
                        .background(isCurrentUser ?
                                    Color("green 2")
                                    : Color(uiColor: UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)))
                        .foregroundColor(isCurrentUser ? .white : .black)
                        .cornerRadius(10)
                        .bold()
                }
                HStack {
                    Spacer()
                    Text(currentMessage.changeDateFormat())
                        .foregroundColor(.gray)
                        .font(.system(size: 10))
                }
            } else {
                HStack {
                    Text(currentMessage.nickname)
                    Spacer()
                }
                HStack {
                    Text(currentMessage.text)
                        .frame(minWidth: 80, maxWidth: 200)
                        .padding()
                        .background(isCurrentUser ?
                                    Color("green 2")
                                    : Color(uiColor: UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)))
                        .foregroundColor(isCurrentUser ? .white : .black)
                        .cornerRadius(10)
                        .bold()
                    Spacer()
                }
                HStack {
                    Text(currentMessage.changeDateFormat())
                        .foregroundColor(.gray)
                        .font(.system(size: 10))
                    Spacer()
                }
            }
        }.padding()
        
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView(username: "12",
                    currentMessage: Message(username: "12", nickname: "sumin", text: "hi", timestamp: Date()))
    }
}
