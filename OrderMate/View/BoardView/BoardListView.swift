import SwiftUI

struct RoomListView: View {
    @EnvironmentObject var userManager: UserViewModel // user Info 받아오기
    
    @Binding var loginState: Bool
    @State var loginModel = LoginViewModel()
    @State var roomList = RoomList()
    @State var title = ""
    @State var listJsonArray: [RoomInfoPreview] = [RoomInfoPreview(postId: 99,
                                                                   title: "개설된 방이 없습니다",
                                                                   createdAt: "yy-MM-dd HH:mm",
                                                                   postStatus: "",
                                                                   maxPeopleNum: 5,
                                                                   currentPeopleNum: 1,
                                                                   isAnonymous: false,
                                                                   content: "",
                                                                   withOrderLink: "",
                                                                   pickupSpace: "",
                                                                   spaceType: "",
                                                                   accountNum: "",
                                                                   estimatedOrderTime: "",
                                                                   ownerId: 1,
                                                                   ownerName: "")]
    @State var recentListArray: [RoomInfoPreview] = [RoomInfoPreview(postId: 99,
                                                                     title: "개설된 방이 없습니다",
                                                                     createdAt: "yy-MM-dd HH:mm",
                                                                     postStatus: "",
                                                                     maxPeopleNum: 5,
                                                                     currentPeopleNum: 1,
                                                                     isAnonymous: false,
                                                                     content: "",
                                                                     withOrderLink: "",
                                                                     pickupSpace: "",
                                                                     spaceType: "",
                                                                     accountNum: "",
                                                                     estimatedOrderTime: "",
                                                                     ownerId: 1,
                                                                     ownerName: "")]
    @State private var showingAlert = false // 로그아웃 alert bool
    @State private var joinErrorFlag = false
    
    func roomListreFreash() {
        // user Info 받아오기
        userManager.getMyInfo()
        userManager.getAuthority()
        // BoardListview 새로고침
        DispatchQueue.main.async {
            roomList.getAllRoomList { success, data in
                listJsonArray = data as! [RoomInfoPreview]
            }
            roomList.getParticipatedBoard { success, data in
                recentListArray = data as! [RoomInfoPreview]
            }
        }
    }
    
    var body: some View {
        ZStack {
            NavigationStack {
                ZStack {
                    VStack {
                        HStack {
                            Text("아이디, \(userModel.username)")
                            Text("이름, \(userManager.userModel.name)")
                            Text("닉네임, \(userManager.userModel.nickname)")
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
                                    loginModel.logOut { status in
                                        if status {
                                            loginState = false
                                        }
                                    }
                                }
                                Button("취소", role: .cancel) {
                                    showingAlert = false
                                }
                            }
                        }.padding()
                        Button {
                            roomListreFreash()
                        } label: {
                            Text("방 목록 새로고침")
                        }
                        ScrollView {
                            if userManager.authorityModel.authority == false {
                                // 나의 방생성/참가 bool이 false면
                                Divider()
                                // 내가 소속된 방정보를 불러와 제일 위에 보여줍니다
                                VStack {
                                    ForEach(recentListArray, id: \.self) { data in
                                        NavigationLink {
                                            BoardView(postId: data.postId!)
                                                .toolbar(.hidden, for: .tabBar)
                                        } label: {
                                            HStack {
                                                VStack(alignment: .leading) {
                                                    Text(data.createdAt!.formatISO8601DateToCustom())
                                                    // "yy-MM-dd HH:mm"
                                                    Text(data.title!)
                                                        .font(.headline)
                                                    Text("픽업 장소: " + data.pickupSpace!)
                                                    Spacer()
                                                }
                                                Spacer()
                                                VStack(alignment: .trailing) {
                                                    Text(data.postStatus!)
                                                    Text(String(data.currentPeopleNum!) + " / " + String(data.maxPeopleNum!))
                                                    Text("postid: " + String(data.postId!))
                                                    Spacer()
                                                }
                                            }
                                        }
                                        .buttonStyle(.bordered)
                                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                                    }
                                }
                                Text("⬆️ 내가 참가중인 방")
                                Divider()
                            }
                            
                            ForEach(listJsonArray, id: \.self) { data in
                                NavigationLink {
                                    if let data = data.postId {
                                        BoardView(postId: data)
                                            .toolbar(.hidden, for: .tabBar)
                                    }
                                } label: {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            if let createdAt = data.createdAt {
                                                Text(createdAt.formatISO8601DateToCustom()) // "yy-MM-dd HH:mm"
                                            }
                                            if let title = data.title {
                                                Text(title)
                                                    .font(.headline)
                                            }
                                            if let pickupSpace = data.pickupSpace {
                                                Text("픽업 장소: " + pickupSpace)
                                            }
                                            Spacer()
                                        }
                                        Spacer()
                                        VStack(alignment: .trailing) {
                                            if let postStatus = data.postStatus,
                                               let currentPeopleNum = data.currentPeopleNum,
                                               let maxPeopleNum = data.maxPeopleNum,
                                               let postId = data.postId {
                                                Text(postStatus)
                                                Text(String(currentPeopleNum) + " / " + String(maxPeopleNum))
                                                Text("postid: " + String(postId))
                                            }
                                            Spacer()
                                        }
                                    }
                                }
                                .buttonStyle(.bordered)
                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                            }
                        }
                    }
                    .onAppear {
                        roomListreFreash()
                    }
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            if userManager.authorityModel.authority == false {
                                Button {
                                    joinErrorFlag = true
                                }  label: {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title.bold())
                                }.alert(isPresented: $joinErrorFlag) {
                                    Alert(title: Text("경고"), message: Text("이미 다른 방에 소속중입니다"), dismissButton: .default(Text("확인")))
                                }
                                .padding()
                            } else {
                                NavigationLink {
                                    CreateBoardView()
                                        .toolbar(.hidden, for: .tabBar)
                                } label: {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title.bold())
                                }
                                .padding()
                            }
                            
                        }.padding()
                    }
                }
                
            }
            
            .refreshable {
                roomListreFreash()
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
