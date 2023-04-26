import SwiftUI

struct MainView: View {
    @State private var loginState = false
    var body: some View {
        if loginState == false {
            StartPageView(loginState: $loginState)
        } else {
            TabView {
                RoomListView(loginState: $loginState)
                    .tabItem {
                        Image(systemName: "house")
                        Text("Rooms")
                    }
                ProfileView()
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                ChatListView(currentChat: RoomInfoPreview(postId: 5,
                                                          title: "교촌치킨 같이 시켜먹어요",
                                                          createdAt: Date(),
                                                          postStatus: "배달 완료",
                                                          maxPeopleNum: 5,
                                                          currentPeopleNum: 3,
                                                          isAnonymous: true,
                                                          content: "hi",
                                                          withOrderLink: "hi",
                                                          pickupSpace: "기숙사",
                                                          spaceType: "hi",
                                                          accountNum: "hi",
                                                          estimatedOrderTime: Date(),
                                                          ownerId: 2,
                                                          ownerName: "soom"))
                    .tabItem {
                        Image(systemName: "list")
                        Text("ChatList")
                    }
            }
            
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
