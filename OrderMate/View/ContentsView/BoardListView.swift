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
    @State private var showingAlert = false //로그아웃 alert bool
    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            showingAlert = true
                        } label: {
                            Image(systemName: "door.left.hand.open")
                                .font(.system(size: 20))
                                .padding()
                                .foregroundColor(Color.red)
                        }.alert("로그아웃 하시겠습니까?", isPresented: $showingAlert) {
                            Button("로그아웃", role: .destructive) {
                                loginState = false
                            }
                            Button("취소", role: .cancel) {
                                showingAlert = false
                            }
                        }.padding()
                    }
                    Button {
                        roomList.getAllRoomList { success, data in
                            listJsonArray = data as! [RoomInfoPreview]
                        }
                    } label: {
                        Text("방 목록 새로고침")
                    }
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
                        roomList.uploadData(post: BoardStructModel(title: "버튼테스트3",
                                                                   maxPeopleNum: 12,
                                                                   isAnonymous: false,
                                                                   spaceType: "DORMITORY",
                                                                   content: "버튼테스트",
                                                                   withOrderLink: "버튼테스트",
                                                                   pickupSpace: "버튼테스트",
                                                                   accountNum: "버튼테스트",
                                                                   estimatedOrdTime: "2018-02-05T12:59:11.332")) { success in
                            if success {
                                print("방생성완료")
                            }
                            else{
                                print("방생성실패")
                            }
                        }
                    } label: {
                        Image(systemName: "plus")
                            .font(.title.bold())
                    }.padding()
                }.padding()
            }
            
        }
        .onAppear {
            // BoardListview 진입시 1초뒤 자동 새로고침
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                roomList.getAllRoomList { success, data in
                    listJsonArray = data as! [RoomInfoPreview]
                }
            })
        }
    }
}

struct RoomListView_Previews: PreviewProvider {
    @State static var LoginState = false
    static var previews: some View {
        RoomListView(loginState: $LoginState)
    }
}
