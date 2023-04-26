import SwiftUI

struct MakeAccountView: View {
    let genders = ["MALE", "FEMALE"]
    @Binding var loginState: Bool
    @State var loginModel = LoginViewModel()
    @State var user = UserModel()
    @State var isPresented = false
    @State var isSecureMode: Bool = true
    @State var isShowAlert: Bool = false
    
    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading) {
                    Text("아이디").foregroundColor(Color("green 2"))
                    TextField("아이디를 입력해주세요", text: $user.username)
                        .textFieldStyle(.roundedBorder)
                }.padding()
                VStack(alignment: .leading) {
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
                
                VStack(alignment: .leading) {
                    Text("이름").foregroundColor(Color("green 2"))
                    TextField("이름을 입력해주세요", text: $user.name)
                        .textFieldStyle(.roundedBorder)
                }.padding()
                
                VStack(alignment: .leading) {
                    Text("닉네임").foregroundColor(Color("green 2"))
                    TextField("닉네임을 입력해주세요", text: $user.nickname)
                        .textFieldStyle(.roundedBorder)
                }.padding()
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("성별").foregroundColor(Color("green 2"))
                        Spacer()
                        Picker("성별 선택", selection: $user.gender) {
                            ForEach(genders, id: \.self) {
                                Text($0)
                            }
                        }
                        .frame(width: 150, height: 36)
                        .pickerStyle(.segmented)
                        .accentColor(Color("green 0"))
                        .cornerRadius(10)
                        .onAppear {
                            UISegmentedControl.appearance().backgroundColor = UIColor(named: "green 0")
                        }
                    }
                    
                }.padding()
                
                VStack(alignment: .leading) {
                    Text("학교").foregroundColor(Color("green 2"))
                    TextField("학교를 입력해주세요", text: $user.school)
                        .textFieldStyle(.roundedBorder)
                }.padding()
                
                VStack(alignment: .leading) {
                    Text("학과").foregroundColor(Color("green 2"))
                    TextField("학과를 입력해주세요", text: $user.major)
                        .textFieldStyle(.roundedBorder)
                }.padding()
                
            }
            
            if [user.username,
                user.password,
                user.name,
                user.nickname,
                user.gender,
                user.school,
                user.major].allSatisfy({ !$0.isEmpty }) {
                // 모든 항목이 빈 문자열이 아닌 경우에만 가입이 진행됩니다
                Button {
                    loginModel.postNewUserInfo(user: user) { success in
                        if success {
                            loginModel.loginGetStatus(user: user) { loginSucceess in
                                if loginSucceess {
                                    loginState = true
                                } else {
                                    print("가입 후 자동 로그인 error")
                                }
                            }
                        } else {
                            isPresented = true
                        }
                    }
                } label: {
                    Text("회원 가입")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color("AccentColor"))
                }.alert(isPresented: $isPresented) {
                    Alert(title: Text("경고"), message: Text("이미 존재하는 아이디입니다."), dismissButton: .default(Text("확인")))
                }
            } else {
                // 모든 멤버가 빈 문자열이 있는 경우 경고창을 표시
                Button {
                    isShowAlert = true
                } label: {
                    Text("회원 가입")
                        .fontWeight(.semibold)
                        .frame(width: 300.0, height: 30)
                        .padding()
                        .foregroundColor(.black)
                        .background(Color("green 0"))
                        .font(.title2)
                        .cornerRadius(10)
                }.alert(isPresented: $isShowAlert) {
                    Alert(title: Text("경고"), message: Text("모든 정보를 입력해주세요."), dismissButton: .default(Text("확인")))
                }
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
