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
    @State var RoomList = RoomListModel()
    var body: some View {
        NavigationStack {
            VStack {
                Button {
                    LoginState = false
                } label: {
                    Text("logout button")
                }.padding()
                Button {
                    RoomList.GetAllRoomList()
//                    let Result = RoomList.GetAllRoomList()
//                    print(Result)
                } label: {
                    Text("새로고침")
                }
                
                
                ScrollViewReader { scrollView in
//                    List {
//                        ForEach(manager.roomList) { list in
//                            NavigationLink {
//                                ContentView(currentRoom: list)
//                            } label: {
//                                ListView(currentRoom: list)
//                            }
//                        }
//                    }
                }
            }
        }

    }
}

struct RoomView_Previews: PreviewProvider {
    @State static var LoginState = false
    static var previews: some View {
        RoomView(LoginState: $LoginState)
    }
}
