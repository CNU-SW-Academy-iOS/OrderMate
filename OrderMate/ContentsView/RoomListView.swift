//
//  RoomView.swift
//  OrderMate
//
//  Created by 문영균 on 2023/03/06.
//

import SwiftUI

struct RoomListView: View {
    @Binding var loginState: Bool
    @State var roomList = RoomList()
    @State var title = ""
    @State var listJsonArray: [RoomInfoPreview] = [RoomInfoPreview(postId: 99,
                                                                   title: "개설된 방이 없습니다",
                                                                   content: "")]
    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            loginState = false
                        } label: {
                            Text("logout button")
                                .bold()
                        }.padding()
                    }
                    Button {
                        roomList.getAllRoomList { success, data in
                            listJsonArray = data as! [RoomInfoPreview]
                        }
                    } label: {
                        Text("방 목록 새로고침")
                    }
                    //Text(listJsonArray[0].title!)
                    List {
                        ForEach(listJsonArray, id: \.self) { data in
                            NavigationLink {
                                BoardView(postId: data.postId!)
                            } label: {
                                Text(String(data.postId!))
                                Text(data.title!)
                                Text(data.content!)
                            }
                        }
                    }
                }
                
            }.refreshable {
                roomList.getAllRoomList { success, data in
                    listJsonArray = data as! [RoomInfoPreview]
                }
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    NavigationLink {
                        CreateBoardView()
                    } label: {
                        Image(systemName: "plus")
                            .font(.title.bold())
                    }.padding()
                    
                    Button {
                        roomList.uploadData(title: "버튼테스트3", maxPeopleNum: "12", isAnonymous: 0,
                                            spaceType: "DORMITORY", content: "버튼테스트", withOrderLink: "버튼테스트",
                                            pickupSpace: "버튼테스트", accountNum: "버튼테스트",
                                            estimatedOrdTime: "2023-03-20T12:59:11.332") { success in
                            if success {
                                print("방생성완료")
                            }
                        }
                    } label: {
                        Image(systemName: "plus")
                            .font(.title.bold())
                    }.padding()
                }.padding()
            }
            
        }
    }
}

struct RoomListView_Previews: PreviewProvider {
    @State static var LoginState = false
    static var previews: some View {
        RoomListView(loginState: $LoginState)
    }
}
