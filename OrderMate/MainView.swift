//
//  ContentView.swift
//  iosOrdermate
//
//  Created by cnu on 2023/03/02.
//

import SwiftUI

struct MainView: View {
    @State private var loginState = false
    var body: some View {
        if loginState == false {
            StartPageView(loginState: $loginState)
        } else {
            RoomListView(loginState: $loginState)
            //RoomView(LoginState: <#T##Binding<Bool>#>, currentRoom: <#T##Room#>)
        }
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
