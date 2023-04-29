//
//  BoardEditView.swift
//  OrderMate
//
//  Created by yook on 2023/04/29.
//

import SwiftUI

struct BoardEditView: View {
    var postId: Int
    var formattedDateBinding: Binding<Date>?
    @StateObject var manager: BoardViewModel = BoardViewModel.shared
    @State var boardInfo = BoardStructModel(ownerName: UUID().uuidString,
                                            title: "",
                                            createdAt: Date(),
                                            postStatus: .recruiting,
                                            maxPeopleNum: 5,
                                            currentPeopleNum: 1,
                                            isAnonymous: false,
                                            content: "내용 입력",
                                            withOrderLink: "",
                                            pickupSpace: "",
                                            spaceType: "DORMITORY",
                                            accountNum: "",
                                            estimatedOrderTime: Date())
    let spaces = ["DORMITORY", "STUDIO_APARTMENT", "ALL"]
    let numbers = Array(1...10)
    
    init(postId: Int) {
              self.postId = postId
              let board = manager.board
              // 기존 board의 값을 사용하여 boardInfo를 초기화합니다.
              _boardInfo = State(initialValue: board ?? BoardStructModel(ownerName: UUID().uuidString,
                                                                         title: "",
                                                                         createdAt: Date(),
                                                                         postStatus: .recruiting,
                                                                         maxPeopleNum: 5,
                                                                         currentPeopleNum: 1,
                                                                         isAnonymous: false,
                                                                         content: "내용 입력",
                                                                         withOrderLink: "",
                                                                         pickupSpace: "",
                                                                         spaceType: "DORMITORY",
                                                                         accountNum: "",
                                                                         estimatedOrderTime: Date()))
          }
    func convertKeyToName(_ spaces: String) -> String {
        if spaces == "DORMITORY" {
            return "기숙사"
        } else if spaces == "STUDIO_APARTMENT" {
            return "자취방"
        } else {
            return "모두"
            
        }
    }
    var body: some View {
        VStack {
            Text("글 수정 페이지")
        }
        if let board = manager.board {
            ScrollView {
                VStack(alignment: .leading) {
                    TextField(board.title, text: $boardInfo.title)
                        .frame(height: 50)
                        .background(Color("green 0"))
                        .cornerRadius(10)
                        .padding()
                    
                    HStack {
                        Text("당신의 위치는?")
                            .foregroundColor(Color("green 2"))
                        Spacer()
                        Picker(board.spaceType, selection: $boardInfo.spaceType) {
                            ForEach(spaces, id: \.self) { space in
                                Text(convertKeyToName(space)).tag(space)
                            }
                        }
                        .pickerStyle(.menu)
                        .background(Color("green 0"))
                        .cornerRadius(10)
                    }
                    .padding()
                    TextField(board.pickupSpace, text: $boardInfo.pickupSpace)
                        .frame(height: 50)
                        .background(Color("green 0"))
                        .cornerRadius(10)
                        .padding()
                }
            }
        }
    }
}
