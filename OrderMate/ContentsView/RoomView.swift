//
//  RoomView.swift
//  OrderMate
//
//  Created by 문영균 on 2023/03/06.
//

import SwiftUI

struct RoomView: View {
    //@StateObject private var manager = RoomDataManager.shared
    @Binding var LoginState: Bool
    @State var RoomList = RoomListModelTest()
    @State var title = ""
    //@State var currentRoom: Room
    var body: some View {
        NavigationStack {
            VStack {
                Button {
                    LoginState = false
                } label: {
                    Text("logout button")
                }.padding()
                Button {
                    RoomList.GetAllRoomList { success, data in
                        print(data)
                    }
                } label: {
                    Text("새로고침")
                }
                Text(title)
                
                
                ScrollViewReader { scrollView in

                }
            }
        }

    }
}

struct RoomView_Previews: PreviewProvider {
    @State static var LoginState = false
    static var previews: some View {
        let room = Room(id: UUID().uuidString, title: "아아아아 배고프아아다아아", location: "충남대학교 어딘가", date: Date(), maxUser: 3)
        
//        ContentView(currentRoom: room)
        
        //RoomView(LoginState: $LoginState, currentRoom: room)
        RoomView(LoginState: $LoginState)
    }
}
