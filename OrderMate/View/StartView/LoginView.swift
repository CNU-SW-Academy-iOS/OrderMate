import SwiftUI

struct LoginView: View {
    @Binding var loginState: Bool
    @State var isSecureMode: Bool = true
    @State var loginModel = LoginViewModel()
    @State var user = UserModel()
    var body: some View {
        VStack {
            Spacer()
            Text("Table Mate").font(.title).bold()
            VStack {
                TextField("ID space", text: $user.username)
                    .padding()
                     .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(10)
                ZStack {
                    if isSecureMode {
                        SecureField("password", text: $user.password)
                            .padding()
                             .background(Color(uiColor: .secondarySystemBackground))
                        .cornerRadius(10)
                    } else {
                        TextField("password", text: $user.password)
                            .padding()
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
                            print("error")
                        }
                    }
                   
                } label: {
                    Text("로그인")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 155.0)
                        .padding(.vertical, 30.0)
                        .background(Color("green 0"))
                        .cornerRadius(10)
                    
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
