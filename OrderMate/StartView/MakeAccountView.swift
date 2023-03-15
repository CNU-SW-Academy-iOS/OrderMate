//
//  MakeAccountView.swift
//  OrderMate
//
//  Created by cnu on 2023/03/09.
//

import SwiftUI

struct MakeAccountView: View {
    @Binding var LoginState: Bool
    @State var loginModel = AccountModel()
    @State var myUserName: String = ""
    @State var myPassWord: String = ""
    @State var myName: String = ""
    @State var myNickName: String = ""
    @State var isMale: Bool = true
    @State var mySchool: String = ""
    @State var myMajor: String = ""
    @State var isSecureMode: Bool = true
    var body: some View {
        ScrollView {
            
            
            VStack {
                VStack(alignment: .leading){
                    Text("아이디").foregroundColor(Color("green 2"))
                    TextField("아이디를 입력해주세요", text: $myUserName)
                        .textFieldStyle(.roundedBorder)
                }.padding()
                VStack(alignment: .leading){
                    Text("비밀번호").foregroundColor(Color("green 2"))
                    HStack {
                        if isSecureMode {
                            SecureField("비밀번호를 입력해주세요", text: $myPassWord)
                                .textFieldStyle(.roundedBorder)
                        } else {
                            TextField("비밀번호를 입력해주세요", text: $myPassWord)
                                .textFieldStyle(.roundedBorder)
                        }
                        Button {
                            isSecureMode.toggle()
                        } label: {
                            Image(systemName: "eye")
                        }
                    }
                }.padding()
                
                VStack(alignment: .leading){
                    Text("이름").foregroundColor(Color("green 2"))
                    TextField("이름을 입력해주세요", text: $myName)
                        .textFieldStyle(.roundedBorder)
                }.padding()
                
                VStack(alignment: .leading){
                    Text("닉네임").foregroundColor(Color("green 2"))
                    TextField("닉네임을 입력해주세요", text: $myNickName)
                        .textFieldStyle(.roundedBorder)
                }.padding()
                
                VStack(alignment: .leading){
                    Toggle(isOn: $isMale) {
                        Text("성별").foregroundColor(Color("green 2"))
                    }
                }.padding()
                
                VStack(alignment: .leading){
                    Text("학교").foregroundColor(Color("green 2"))
                    TextField("학교를 입력해주세요", text: $mySchool)
                        .textFieldStyle(.roundedBorder)
                }.padding()
                
                VStack(alignment: .leading){
                    Text("학과").foregroundColor(Color("green 2"))
                    TextField("학과를 입력해주세요", text: $myMajor)
                        .textFieldStyle(.roundedBorder)
                }.padding()
                
            }
            Button {
                loginModel.postNewUserInfo(username: myUserName, password: myPassWord, name: myName, nickname: myNickName, gender: "MALE", school: mySchool, major: myMajor) { success in
                    if success {
                        //회원가입이 정상적으로 이루어질 경우 자동 로그인
                        loginModel.loginGetStatus(myUserName, myPassWord) { loginSuccess in
                            if loginSuccess {
                                LoginState = true
                            } else {
                                print("가입 후 자동 로그인 error")
                            }
                        }
                    } else {
                        print("가입 error")
                    }
                }
            } label: {
                Text("회원 가입")
                    .font(.title)
            }
        }
        
        
    }
}

struct MakeAccountView_Previews: PreviewProvider {
    @State static var LoginState = false
    static var previews: some View {
        MakeAccountView(LoginState: $LoginState)
    }
}
