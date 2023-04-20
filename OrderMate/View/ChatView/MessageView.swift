//
//  MyMessage.swift
//  OrderMate
//
//  Created by 이수민 on 2023/04/07.
//

import SwiftUI

struct MessageView: View {
    
    var currentMessage: Message
    let userID = UserDefaults.standard.string(forKey: "username")
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
                    Text(currentMessage.userNickName)
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
        MessageView(currentMessage: Message(id: "11", text: "11", timestamp: Date(), userId: "11", userNickName: "11"))
    }
}
