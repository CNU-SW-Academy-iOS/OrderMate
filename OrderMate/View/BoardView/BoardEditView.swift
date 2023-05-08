//
//  BoardEditView.swift
//  OrderMate
//
//  Created by yook on 2023/04/29.
//

import SwiftUI

struct BoardEditView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userManager: UserViewModel
    var postId: Int
    @State var boardList = RoomList()
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
    @State var boardInfo2 = RoomInfoPreview(postId: 0,
                                            title: "",
                                            createdAt: Date(),
                                            postStatus: PostStatusEnum.endOfRoom.rawValue,
                                            maxPeopleNum: 5,
                                            currentPeopleNum: 5,
                                            isAnonymous: false,
                                            content: "",
                                            withOrderLink: "",
                                            pickupSpace: "",
                                            spaceType: "",
                                            accountNum: "",
                                            estimatedOrderTime: Date(),
                                            ownerId: 0,
                                            ownerName: "")
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
       
        print(boardInfo2.postId)
        
    }
    // String 옵셔널을 String으로 바꾸기 위한 함수
    func convertBinding(_ optionalBinding: Binding<String?>) -> Binding<String> {
        return Binding<String>(
            get: { optionalBinding.wrappedValue ?? "" },
            set: { optionalBinding.wrappedValue = $0 }
        )
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
                    // 제목
                    TextField(board.title, text: $boardInfo.title)
                        .frame(height: 50)
                        .background(Color("green 0"))
                        .cornerRadius(10)
                        .padding()
                    HStack {
                        // 장소 구분
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
                    // 픽업 장소
                    TextField(board.pickupSpace, text: $boardInfo.pickupSpace)
                        .frame(height: 50)
                        .background(Color("green 0"))
                        .cornerRadius(10)
                        .padding()
                    // 주문 예정 시각
                    /*
                    DatePicker("주문 시각을 선택해주세요.", selection: )
                          .frame(height: 50)
                          .foregroundColor(Color.green)
                          .cornerRadius(10)
                          .padding()
                     */
                    HStack {
                        Text("모집 인원을 선택하세요")
                            .foregroundColor(Color("green 2"))
                        Spacer()
                        Picker("모집 인원을 선택하세요", selection: $boardInfo.maxPeopleNum) {
                            ForEach(numbers, id: \.self) { number in
                                Text("\(number)").tag(number)
                            }
                        }
                        .background(Color("green 0"))
                        .cornerRadius(10)
                    }
                    .padding()
                    // 본문
                    TextEditor(text: $boardInfo.content)
                        .scrollContentBackground(.hidden)
                        .frame(height: 200)
                        .font(.body)
                        .background(Color("green 0"))
                        .cornerRadius(10)
                        .onTapGesture { _ in
                            if boardInfo.content == "내용 입력" {
                                boardInfo.content = ""
                            }
                        }
                        .padding()
                    
                    TextField("배달의 민족 함께하기 주소를 입력해주세요.", text: convertBinding($boardInfo.withOrderLink))
                        .frame(height: 50)
                        .background(Color("green 0"))
                        .cornerRadius(10)
                        .padding()
                    
                    TextField("정산받을 계좌번호를 입력해주세요.", text: $boardInfo.accountNum)
                        .frame(height: 50)
                        .background(Color("green 0"))
                        .cornerRadius(10)
                        .padding()
                    HStack {
                        Text("")
                        Spacer()
                        Button {
                            boardList.editData(post: boardInfo, postId: postId) { success in
                                if success {
                                    print("방 편집 완료")
                                    self.boardInfo2 = RoomInfoPreview(postId: postId,
                                                                 title: self.boardInfo.title,
                                                                 createdAt: self.boardInfo.createdAt,
                                                                 postStatus: self.boardInfo.postStatus?.rawValue,
                                                                 maxPeopleNum: self.boardInfo.maxPeopleNum,
                                                                 currentPeopleNum: self.boardInfo.currentPeopleNum,
                                                                 isAnonymous: self.boardInfo.isAnonymous,
                                                                 content: self.boardInfo.content,
                                                                 withOrderLink: self.boardInfo.withOrderLink,
                                                                 pickupSpace: self.boardInfo.pickupSpace,
                                                                 spaceType: self.boardInfo.spaceType,
                                                                 accountNum: self.boardInfo.accountNum,
                                                                 estimatedOrderTime: self.boardInfo.estimatedOrderTime,
                                                                 ownerId: 0,
                                                                 ownerName: self.boardInfo.ownerName)
                                    ChatViewModel.shared.createChat(board: boardInfo2) { success in
                                        if success {
                                            print("파이어베이스 편집 성공")
                                        }
                                    }
                                } else {
                                    print("오류 발생으로 방 편집 실패")
                                }
                            }
                            print(boardInfo)
                            self.presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("편집 하기")
                                .padding()
                                .frame(width: 200)
                                .background(Color("green 0"))
                                .cornerRadius(10)
                                .padding()
                        }
                        Spacer()
                    }
                }
            }
        }
    }
}
