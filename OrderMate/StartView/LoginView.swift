//
//  LoginView.swift
//  iosOrdermate
//
//  Created by cnu on 2023/03/02.
//

import SwiftUI

struct LoginView: View {
    @Binding var LoginState: Bool
    @State var myIdString: String = ""
    @State var myPasswordString: String = ""
    @State var isSecureMode: Bool = true
    @State var loginModel = AccountModel()
    var body: some View {
        VStack {
            Spacer()
            Text("Table Mate").font(.title).bold()
            VStack{
                TextField("ID space", text: $myIdString)
                    .textFieldStyle(.roundedBorder).padding()
                ZStack{
                    if isSecureMode {
                        SecureField("password", text: $myPasswordString)
                            .textFieldStyle(.roundedBorder).padding()
                    }
                    else{
                        TextField("password", text: $myPasswordString)
                            .textFieldStyle(.roundedBorder).padding()
                    }
                    HStack {
                        Spacer()
                        Button {
                            isSecureMode.toggle()
                        } label: {
                            Image(systemName: "eye")
                        }
                        Text("      ")
                    }
                }
            
                Button {
                    loginModel.loginGetStatus(myIdString, myPasswordString) { success in
                        if success {
                            LoginState = true
                        } else {
                            print("error")
                        }
                    }
                } label: {
                    Text("login status")
                        .font(.title2)
                        .frame(width: 330, height: 80)
                        .foregroundColor(.black)
                        .background(Color("green 0"))
                        .cornerRadius(30)
                }
            }
            Spacer()
        }
        .padding()
    }
}



struct LoginView_Previews: PreviewProvider {
    @State static var LoginState = false
    
    static var previews: some View {
        LoginView(LoginState: $LoginState, myIdString: "", myPasswordString: "", isSecureMode: false)
    }
}
