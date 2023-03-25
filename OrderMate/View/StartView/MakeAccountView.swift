//
//  MakeAccountView.swift
//  OrderMate
//
//  Created by cnu on 2023/03/09.
//

import SwiftUI

struct MakeAccountView: View {
    let genders = ["MALE", "FEMALE"]
    @Binding var loginState: Bool
    @State var loginModel = LoginViewModel()
    @State var user = UserModel(username: "", password: "")
    @State var isPresented = false
    @State var isSecureMode: Bool = true
    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading){
                    Text("아이디").foregroundColor(Color("green 2"))
                    TextField("아이디를 입력해주세요", text: $user.username)
                        .textFieldStyle(.roundedBorder)
                }.padding()
                VStack(alignment: .leading){
                    Text("비밀번호").foregroundColor(Color("green 2"))
                    HStack {
                        if isSecureMode {
                            SecureField("비밀번호를 입력해주세요", text: $user.password)
                                .textFieldStyle(.roundedBorder)
                        } else {
                            TextField("비밀번호를 입력해주세요", text: $user.password)
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
                    TextField("이름을 입력해주세요", text: $user.name)
                        .textFieldStyle(.roundedBorder)
                }.padding()
                
                VStack(alignment: .leading){
                    Text("닉네임").foregroundColor(Color("green 2"))
                    TextField("닉네임을 입력해주세요", text: $user.nickName)
                        .textFieldStyle(.roundedBorder)
                }.padding()
                
                VStack(alignment: .leading){
                    HStack{
                        Text("성별").foregroundColor(Color("green 2"))
                        Spacer()
                        Picker("성별 선택", selection: $user.gender) {
                            ForEach(genders, id: \.self) {
                                Text($0)
                            }
                        }
                        .frame(width: 150)
                        .background(Color("green 0"))
                        .pickerStyle(.segmented)
                        .cornerRadius(15)
                        
                    }
                    
                }.padding()
                
                VStack(alignment: .leading){
                    Text("학교").foregroundColor(Color("green 2"))
                    TextField("학교를 입력해주세요", text: $user.school)
                        .textFieldStyle(.roundedBorder)
                }.padding()
                
                VStack(alignment: .leading){
                    Text("학과").foregroundColor(Color("green 2"))
                    TextField("학과를 입력해주세요", text: $user.major)
                        .textFieldStyle(.roundedBorder)
                }.padding()
                
            }
            Button {
                print(user)
                loginModel.postNewUserInfo(user: user) { success in
                    if success {
                        loginModel.loginGetStatus(user: user) {loginSucceess in
                            if loginSucceess {
                                loginState = true
                            }else {
                                print("가입 후 자동 로그인 error")
                            }
                        }
                    }
                    else{
                        isPresented = true
                    }
                }
            } label: {
                Text("회원 가입")
                    .fontWeight(.bold)
                    .frame(width: 300.0, height: 30)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color("AccentColor"))
                    .cornerRadius(14)
                   
                
                    .font(.title)
            }.alert(isPresented: $isPresented) {
                Alert(title: Text("Title"), message: Text("이미 존재하는 아이디입니다."), dismissButton: .default(Text("Dismiss")))
            }
        }.padding()
        
        
    }
}

struct MakeAccountView_Previews: PreviewProvider {
    @State static var loginState = false
    static var previews: some View {
        MakeAccountView(loginState: $loginState)
    }
}
