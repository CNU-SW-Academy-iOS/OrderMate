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
            }
            
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
