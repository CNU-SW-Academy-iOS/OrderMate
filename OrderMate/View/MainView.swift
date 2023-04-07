import SwiftUI

struct MainView: View {
    @State private var loginState = false
    var body: some View {
        if loginState == false {
            StartPageView(loginState: $loginState)
        } else {
            RoomListView(loginState: $loginState)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
