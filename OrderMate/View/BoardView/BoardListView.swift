import SwiftUI

struct RoomListView: View {
    @EnvironmentObject var userManager: UserViewModel // user Info 받아오기
    
    @Binding var loginState: Bool
    @State var loginModel = LoginViewModel()
    @State var roomList = RoomList()
    @State var title = ""
    @State var listJsonArray: [RoomInfoPreview] = [RoomInfoPreview(postId: 99,
                                                                   title: "개설된 방이 없습니다",
                                                                   createdAt: Date(),
                                                                   postStatus: "",
                                                                   maxPeopleNum: 5,
                                                                   currentPeopleNum: 1,
                                                                   isAnonymous: false,
                                                                   content: "",
                                                                   withOrderLink: "",
                                                                   pickupSpace: "",
                                                                   spaceType: "",
                                                                   accountNum: "",
                                                                   estimatedOrderTime: Date(),
                                                                   ownerId: 1,
                                                                   ownerName: "")]
    @State var recentListArray: [RoomInfoPreview] = [RoomInfoPreview(postId: 99,
                                                                     title: "개설된 방이 없습니다",
                                                                     createdAt: Date(),
                                                                     postStatus: "",
                                                                     maxPeopleNum: 5,
                                                                     currentPeopleNum: 1,
                                                                     isAnonymous: false,
                                                                     content: "",
                                                                     withOrderLink: "",
                                                                     pickupSpace: "",
                                                                     spaceType: "",
                                                                     accountNum: "",
                                                                     estimatedOrderTime: Date(),
                                                                     ownerId: 1,
                                                                     ownerName: "")]
    @State private var showingAlert = false // 로그아웃 alert bool
    @State private var joinErrorFlag = false
    @State private var search: String = ""
    func roomListreFreash() {
        // user Info 받아오기
        userManager.getMyInfo()
        userManager.getAuthority()
        // BoardListview 새로고침
        DispatchQueue.main.async {
            roomList.getAllRoomList { success, data in
                if success {
                    if let list = data as? [RoomInfoPreview] {
                        listJsonArray = list.reversed()
                    }
                }
                
            }
            roomList.getParticipatedBoard { success, data in
                if success {
                    if let list = data as? [RoomInfoPreview] {
                        recentListArray = list.reversed()
                    }
                }
                
            }
        }
    }
    
    var body: some View {
        ZStack {
            NavigationStack {
                ZStack {
                    VStack {
                        HStack {
                            Text("\(userManager.userModel.nickname) 님 오늘도 맛있는 식사하세요 😃")
                            Spacer()
                            Button {
                                showingAlert = true
                            } label: {
                                Image(systemName: "door.left.hand.open")
                                    .font(.system(size: 25))
                                    .padding(5)
                                    .foregroundColor(Color("green 2"))
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
                        }
                        HStack {
                            TextField("검색어 입력하세요", text: $search).padding(5)
                            Spacer()
                            Button {
                            } label: {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 20))
                                    .padding()
                                    .foregroundColor(Color("green 2"))
                            }
                        }.cornerRadius(10)
                        ScrollView {
                            ForEach(listJsonArray, id: \.self) { data in
                                NavigationLink {
                                    if let data = data.postId {
                                        BoardView(postId: data)
                                            .toolbar(.hidden, for: .tabBar)
                                    }
                                } label: {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            HStack {
                                                if let createdAt = data.createdAt {
                                                    Text(createdAt.toStringYYMMDDHHMM()).foregroundColor(.gray) // "yy-MM-dd HH:mm"
                                                }
                                                Spacer()
                                            }
                                            if let title = data.title {
                                                Text(title)
                                                    .font(.system(size: 20))
                                                    .foregroundColor(.black)
                                                    .bold()
                                            }
                                            if let pickupSpace = data.pickupSpace {
                                                Text("픽업 장소: " + pickupSpace).foregroundColor(.black)
                                            }
                                        }
                                        Spacer()
                                        VStack(alignment: .trailing) {
                                            if let postStatus = data.postStatus,
                                               let currentPeopleNum = data.currentPeopleNum,
                                               let maxPeopleNum = data.maxPeopleNum,
                                               let postId = data.postId {
                                                Text(postStatus).foregroundColor(.gray)
                                                Text(String(currentPeopleNum) + " / " + String(maxPeopleNum)).foregroundColor(.black)
                                                Text("postid: " + String(postId)).foregroundColor(.black)
                                            }
                                        }
                                    }
                                }.padding(10).background(Color("green 0")).cornerRadius(10)
                            }.scrollContentBackground(.hidden).padding()
                                .onAppear {
                                    roomListreFreash()
                                }
                        }
                    }.padding()
                    
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            if userManager.authorityModel.authority == false {
                                Button {
                                    joinErrorFlag = true
                                }  label: {
                                    Image(systemName: "plus.circle.fill").font(.system(size: 50))
                                }.alert(isPresented: $joinErrorFlag) {
                                    Alert(title: Text("경고"), message: Text("이미 다른 방에 소속중입니다"), dismissButton: .default(Text("확인")))
                                }
                            } else {
                                NavigationLink {
                                    CreateBoardView()
                                        .toolbar(.hidden, for: .tabBar)
                                } label: {
                                    Image(systemName: "plus.circle.fill").font(.system(size: 50))
                                }
                            }
                        }.padding()
                    }}
            }
            
        }
        
        .refreshable {
            roomListreFreash()
        }
        .onAppear {
            roomListreFreash()
        }
        .onAppear (perform : UIApplication.shared.hideKeyboard)
    }
}

struct RoomListView_Previews: PreviewProvider {
    @State static var LoginState = false
    static var previews: some View {
        RoomListView(loginState: $LoginState)
    }
}
