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
                    .textFieldStyle(.roundedBorder).padding()
                ZStack {
                    if isSecureMode {
                        SecureField("password", text: $user.password)
                            .textFieldStyle(.roundedBorder).padding()
                    } else {
                        TextField("password", text: $user.password)
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
                    loginModel.loginGetStatus(user: user) { success in
                        if success {
                            loginState = true
                        } else {
                            print("error")
                        }
                    }
                } label: {
                    Text("login")
                        .font(.title2)
                        .frame(width: 330, height: 60)
                        .foregroundColor(.white)
                        .background(Color("green 2"))
                }
            }
            Spacer()
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    @State static var loginState = false
    
    static var previews: some View {
        LoginView(loginState: $loginState, isSecureMode: false)
    }
}
