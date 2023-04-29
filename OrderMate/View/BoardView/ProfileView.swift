//
//  ProfileView.swift
//  OrderMate
//
//  Created by yook on 2023/04/15.
//

import SwiftUI

struct ProfileView: View {
    
    
    @EnvironmentObject var userManager: UserViewModel // user Info 받아오기
    
    var body: some View {
        VStack {
            Text("내 정보").bold().font(.title).padding()
            ZStack {
                Color("green 0")
                VStack(alignment: .leading) {
                    HStack {
                        Text("이름").font(.title3).foregroundColor(.gray)
                        Text(userManager.userModel.name).font(.title3)
                    }.padding()
                    HStack {
                        Text("닉네임").font(.title3).foregroundColor(.gray)
                        Text(userManager.userModel.nickname).font(.title3)
                    }.padding()
                    HStack {
                        Text("성별").font(.title3).foregroundColor(.gray)
                        Text(userManager.userModel.gender).font(.title3)
                    }.padding()
                    HStack {
                        Text("학교").font(.title3).foregroundColor(.gray)
                        Text(userManager.userModel.school).font(.title3)
                    }.padding()
                    HStack {
                        Text("학과").font(.title3).foregroundColor(.gray)
                        Text(userManager.userModel.major).font(.title3)
                    }.padding()
                }
            }.cornerRadius(10).padding(50)
            
        }.padding()
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
