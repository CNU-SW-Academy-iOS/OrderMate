//
//  MyMessage.swift
//  OrderMate
//
//  Created by 이수민 on 2023/04/07.
//

import SwiftUI

struct MessageView: View {
    
    var currentMessage: Message
    let userID = userIDModel.username
    var body: some View {
        VStack {
            let isCurrentUser = userID == currentMessage.userId
            
            if isCurrentUser {
                HStack {
                    Spacer()
                    Text(currentMessage.userNickName)
                }
                HStack {
                    Spacer()
                    Text(currentMessage.text)
                        .padding(10)
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
                    Text(currentMessage.userNickName)
                    Spacer()
                }
                HStack {
                    Text(currentMessage.text)
                        .padding(10)
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
        }.padding(.horizontal)
        
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView(currentMessage: Message(id: "11", text: "1dsfdsfdsfdssfds1", timestamp: Date(), userId: "11", userNickName: "11"))
    }
}
