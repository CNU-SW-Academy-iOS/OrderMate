//
//  StartPageView.swift
//  iosOrdermate
//
//  Created by cnu on 2023/03/02.
//

import SwiftUI

struct StartPageView: View {
    @Binding var LoginState: Bool
    var body: some View {
        NavigationStack{
            VStack {
                Spacer()
                Text("Order Mate")
                    .font(.system(size: 50))
                    .fontWeight(.bold)
                Text("Table Mate와 함께 식사해요!")
                    .foregroundColor(Color("green 2"))
                    .bold()
                Spacer()
                NavigationLink {
                    LoginView(LoginState: $LoginState)
                } label: {
                    Text("로그인")
                        .fontWeight(.bold)
                        .foregroundColor(Color.black)
                        .font(.system(size: 20))
                        .frame(width: 320, height: 75)
                        .background(Color("green 0"))
                        .cornerRadius(20)
                }
                NavigationLink {
                    MakeAccountView(LoginState: $LoginState)
                } label: {
                    Text("회원가입")
                        .fontWeight(.bold)
                        .foregroundColor(Color.black)
                        .font(.system(size: 20))
                        .frame(width: 320, height: 75)
                        .background(Color("green 0"))
                        .cornerRadius(20)
                }
                
                Spacer()
                    .frame(height: 10)
            }
            
        }
        
    }
}

struct StartPageView_Previews: PreviewProvider {
    @State static var LoginState = false
    static var previews: some View {
        StartPageView(LoginState: $LoginState)
    }
}
