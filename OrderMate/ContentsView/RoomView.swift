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
    @State var roomList = RoomList()
    @State var title = ""
    @State var listJsonArray: [RoomInfoTest] = [RoomInfoTest(postId: 99, title: "개설된 방이 없습니다", content: "")]
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
                    roomList.GetAllRoomList { success, data in
                        listJsonArray = data as! [RoomInfoTest]
                    }
                } label: {
                    Text("새로고침")
                }
                //Text(listJsonArray[0].title!)
                List {
                    ForEach(listJsonArray, id: \.self) { data in
                        Button {
                            
                        } label: {
                            Text(data.title!)
                            Text(data.content!)
                        }
                    }
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
