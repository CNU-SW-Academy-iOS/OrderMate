import SwiftUI

struct LoginView: View {
    @Binding var loginState: Bool
    @State var isSecureMode: Bool = true
    @State var loginModel = LoginViewModel()
    @State var user = UserModel()
    @State var isAlert : Bool = false
    var body: some View {
        VStack {
            Spacer()
            Text("Order Mate").font(.title).bold()
            VStack {
                TextField("ID space", text: $user.username)
                    .padding()
                    .frame(width: 320, height: 60)
                     .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(10)
                ZStack {
                    if isSecureMode {
                        SecureField("password", text: $user.password)
                            .padding()
                            .frame(width: 320, height: 60)
                             .background(Color(uiColor: .secondarySystemBackground))
                        .cornerRadius(10)
                    } else {
                        TextField("password", text: $user.password)
                            .padding()
                            .frame(width: 320, height: 60)
                             .background(Color(uiColor: .secondarySystemBackground))
                             .cornerRadius(10)
                             
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
                    loginModel.loginGetStatus(user: user) { success in
                        if success {
                            loginState = true
                        } else {
                            isAlert = true
                        }
                    }
                   
                } label: {
                    Text("로그인")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        //.frame(minWidth)
                        .padding(.horizontal, 40.0)
                        .frame(width: 320, height: 75)
                        .background(Color("green 0"))
                        .frame(alignment: .center)
                        .cornerRadius(10)
                    
                }.alert(isPresented: $isAlert) {
                    Alert(title: Text("경고"), message: Text("해당 회원 정보가 없습니다."), dismissButton: .default(Text("확인")))
                }
                .padding(.vertical)
                .padding(.top, 20)
            }.padding()
            Spacer()
        }
        .onAppear (perform : UIApplication.shared.hideKeyboard)
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    @State static var loginState = false
    
    static var previews: some View {
        LoginView(loginState: $loginState, isSecureMode: false)
    }
}
