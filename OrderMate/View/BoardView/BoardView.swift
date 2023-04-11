//
//  BoardView.swift
//  OrderMate
//
//  Created by 문영균 on 2023/03/15.
//

import SwiftUI

struct BoardView: View {
    var postId: Int
    @EnvironmentObject var userManager: UserViewModel // user Info 받아오기
    @State private var isCompleted: Bool = false // 방이 모집완료인지 체크
    // if boardStructModel.postStatus == PostStatusEnum.RECRUITING.description()로 대체 가능
    
    @State private var isEntered: Bool = false // 방에 참가했는지 체크 // array 조회로 대체
    @State private var isHost: Bool = false // 방장인지 체크 // array 조회로 대체
    
    @State private var isShowLockAlert: Bool = false // 방 잠금 alert용
    
    @StateObject var manager: BoardViewModel = BoardViewModel.shared
    
    var body: some View {
        NavigationStack {
            VStack {
                if let board = manager.board {
                    ScrollView {
                        // 게시글 작성 날짜 추가
                        HStack {
                            Text("안녕하세요, \(userManager.userModel.name)")
                            Spacer()
                            Text(board.createdAt!.formatISO8601DateToCustom())
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }.padding()
                        
                        VStack {
                            if let board = manager.board {
                                Text("\(board.title)")
                                    .font(.system(size: 20))
                                    .bold()
                                    .frame(maxWidth: .infinity, minHeight: 30)
                                    .foregroundColor(.black)
                            } else {
                                Text("N/A")
                            }

                        }
                        .padding()
                        VStack {
                            // 다른 정보들도 넣을 수 있도록 칸 변경 2x2 모양이 가장 깔끔할 것 같음
                            HStack {
                                Text("\(board.pickupSpace)").customBoardInfo()
                                Text("\(board.spaceType)").customBoardInfo()
                            }
                        }
                        .padding(.horizontal)
                        
                        VStack {
                            HStack {
                                Text("\(board.isAnonymous ? "비공개글" : "공개글")").customBoardInfo()
                                Text(board.ownerName!).customBoardInfo()
                            }
                        }.padding(.horizontal)
                        
                        VStack {
                            Text("\(board.content)")
                                .font(.system(size: 15))
                                .font(.title)
                                .frame(maxWidth: .infinity, minHeight: 30)
                                .padding()
                                .foregroundColor(.black)
                                .border(Color("green 2"), width: 3)
                        }
                        
                        // 방장인지 체크, 방장만 방을 잠글 수 있음
                        if isHost {
                            Text("당신의 방 참가자 목록")
                            // 모든 참가자 목록을 불러옴
                            ForEach(board.participationList ?? [], id: \.self) { participant in
                                let name = participant["name"] ?? ""
                                let role = participant["role"] ?? ""
                                Text("\(name) (\(role))")
                            }
                            
                            if board.postStatus == PostStatusEnum.RECRUITING.rawValue {
                                Button {
                                    isShowLockAlert = true
                                } label: {
                                    Text("인원 마감")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                }.alert(isPresented: $isShowLockAlert) {
                                    Alert(title: Text("인원을 마감하시겠습니까?"),
                                          message: Text("마감하면 새로운 사람이 들어올 수 없습니다"),
                                          primaryButton: .destructive(Text("마감"), action: {
                                        // 방 상태 변경 함수
                                        manager.goNextFromRecruiting(postId: postId) { status in
                                            if status {
                                                isCompleted = true
                                                // 방잠금으로 새로 고침
                                                manager.getBoard(postId: postId) { isComplete in
                                                    if isComplete {
                                                        manager.processBoardInfo(userModel: userModel) { _, isHost, isCompleted, isEntered in
                                                            self.isHost = isHost
                                                            self.isCompleted = isCompleted
                                                            self.isEntered = isEntered
                                                        }
                                                    }
                                                }
                                                
                                            } else {
                                                
                                            }
                                        }
                                    }), secondaryButton: .cancel(Text("취소")))
                                }
                            }
                        }

                        Spacer()
                        statePeopleView
                        // 참가 안한 상태고 방이 잠기지 않으면
                        if isEntered == false && isCompleted == false {
                            // 참가전
                            Button {
                                manager.joinAndFetchBoard(postId: postId) { isComplete in
                                    if isComplete {
                                        manager.processBoardInfo(userModel: userModel) { _, isHost, isCompleted, isEntered in
                                            self.isHost = isHost
                                            self.isCompleted = isCompleted
                                            self.isEntered = isEntered
                                        }
                                    }
                                }
                            } label: {
                                Text("방 참여하기")
                                    .font(.system(size: 24))
                                    .frame(maxWidth: .infinity, minHeight: 30)
                                    .padding()
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                                    .background(isCompleted ? Color.orange : Color("green 2"))
                            }
                            .padding()
                        } else if isEntered == false && isCompleted == true {
                            // 참가안한방 잠겨있는경우 접근 불가
                            Button {
                            } label: {
                                Text("<인원 마감 되었습니다>")
                                    .font(.system(size: 24))
                                    .frame(maxWidth: .infinity, minHeight: 30)
                                    .padding()
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                                    .background(Color.orange)
                            }.padding()
                            
                        } else {
                            // 참가후
                            // 방 참가자만 볼수있는 방나기기 버튼
                            Button {
                                manager.leave(postId: postId) { status in
                                    if status {
                                        manager.getBoard(postId: postId) { isComplete in
                                            if isComplete {
                                                manager.processBoardInfo(userModel: userModel) { _, isHost, isCompleted, isEntered in
                                                    self.isHost = isHost
                                                    self.isCompleted = isCompleted
                                                    self.isEntered = isEntered
                                                }
                                            }
                                        }
                                        
                                    }
                                }
                            } label: {
                                Text("방 나가기")
                                    .font(.system(size: 24))
                                    .frame(maxWidth: .infinity, minHeight: 30)
                                    .padding()
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                                    .background(isCompleted ? Color.orange : Color("green 2"))
                            }
                            .padding()
                            
                        }
                        // 목록중에 내가 있다면
                        if let list = board.participationList {
                            ForEach(list, id: \.self) { dict in
                                if dict["username"] == userModel.username {
                                    // 대화뷰 들어가기 버튼
                                    NavigationLink {
                                        ChatView()
                                    } label: {
                                        Text("대화 뷰 들어가기")
                                            .font(.system(size: 24))
                                            .frame(maxWidth: .infinity, minHeight: 30)
                                            .padding()
                                            .foregroundColor(.white)
                                            .fontWeight(.semibold)
                                            .background(Color("green 2"))
                                    } .padding()
                                }
                            }
                        }
                    }.refreshable {
                        manager.getBoard(postId: postId) { isComplete in
                            if isComplete {
                                manager.processBoardInfo(userModel: userModel) { _, isHost, isCompleted, isEntered in
                                    self.isHost = isHost
                                    self.isCompleted = isCompleted
                                    self.isEntered = isEntered
                                }
                            }
                        }
                    }
                }
            }
            .onAppear {
                manager.getBoard(postId: postId) { isComplete in
                    if isComplete {
                        manager.processBoardInfo(userModel: userModel) { _, isHost, isCompleted, isEntered in
                            self.isHost = isHost
                            self.isCompleted = isCompleted
                            self.isEntered = isEntered
                        }
                    }
                }
            }
        }
    }
    
    var statePeopleView: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(manager.getPeopleList(), id: \.self) { imageName in
                    Image(systemName: imageName)
                        .imageScale(.large)
                        .foregroundColor(Color("green 2"))
                        .padding()
                }
            }
        }.padding()
    }
}

// 반복되는 Text 수식 코드를 줄여줌
extension Text {
    func customBoardInfo() -> some View {
        self
            .font(.system(size: 15))
            .font(.title)
            .frame(maxWidth: .infinity, minHeight: 20)
            .padding()
            .foregroundColor(.white)
            .background(Color("green 2"))
    }
}

struct BoardView_Previews: PreviewProvider {
    var postId = 1
    static var previews: some View {
        BoardView(postId: 1)
    }
}
