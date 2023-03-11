//
//  ContentView.swift
//  iosOrdermate
//
//  Created by cnu on 2023/03/02.
//

import SwiftUI

struct MainView: View {
    @State private var LoginState = false
    var body: some View {
        if LoginState == false {
            StartPageView(LoginState: $LoginState)
        } else {
            RoomView(LoginState: $LoginState)
        }
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
