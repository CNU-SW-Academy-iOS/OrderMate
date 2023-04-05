//
//  BoardView.swift
//  OrderMate
//
//  Created by 문영균 on 2023/03/15.
//

import SwiftUI

struct BoardView: View {
    var postId: Int
    @State private var isCompleted: Bool = false
    @State private var isEntered: Bool = false
    @State private var isHost: Bool = false // 방장인지 체크
    @State private var isShowLockAlert: Bool = false // 방 잠금 alert용
    
    @StateObject var manager: BoardViewModel = BoardViewModel.shared
    @State var ownerName: String = "주인장 이름"
    @State var title: String = "교촌 치킨 같이 배달 시키실 분 구합니다"
    
    //@State var createdAt: Date = Date()
    @State var createdAt: String? = "date" // 명세서 따른 변경, String으로 들어옴
    //@State var postStatus: Bool?
    @State var postStatus: String? // 명세서 따른 변경, String으로 들어옴
    
    @State var maxPeopleNum: Int = 5
    @State var currentPeopleNum: Int = 2
    @State var isAnonymous: Bool = false
    @State var content: String = "함께 교촌 치킨 시켜 먹어요\n기숙사 7동에서 시킵니다\n배달비가 너무 비싸서 배달비 n빵해요\n😄\n남녀노소 상관 없어요"
    @State var pickupSpace: String = "픽업 장소"
    @State var withOrderLink: String = "배민 함꼐하기 주소"
    @State var spaceType: String = "기숙사 / 충대 내부"
    @State var accountNum: String = "계좌 번호"
    
    var body: some View {
        NavigationStack {
            VStack {
                // 게시글 작성 날짜 추가
                HStack {
                    Spacer()
                    Text(createdAt!)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }.padding()
                
                VStack {
                    Text("\(title)")
                        .font(.system(size: 20))
                        .bold()
                        .frame(maxWidth: .infinity, minHeight: 30)
                        .foregroundColor(.black)
                }
                .padding()
                VStack {
                    //다른 정보들도 넣을 수 있도록 칸 변경 2x2 모양이 가장 깔끔할 것 같음
                    HStack {
                        Text("\(pickupSpace)").customBoardInfo()
                        Text("\(spaceType)").customBoardInfo()
                    }
                }
                .padding(.horizontal)
                
                VStack {
                    HStack {
                        Text("\(isAnonymous ? "비공개글" : "공개글")").customBoardInfo()
                        Text("\(ownerName)").customBoardInfo()
                    }
                }.padding(.horizontal)
                VStack {
                    Text("\(content)")
                        .font(.system(size: 15))
                        .font(.title)
                        .frame(maxWidth: .infinity, minHeight: 30)
                        .padding()
                        .foregroundColor(.black)
                        .border(Color("green 2"), width: 3)
                }
                .padding()
                
                //if isHost {
                    // 방장인지 체크, 방장만 방을 잠글 수 있음
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
                                                } else {
                                                    
                                                }
                                            }
                                        }), secondaryButton: .cancel(Text("취소")))
                                    }

                    Toggle(isOn: $isCompleted) {
                        Text("인원 마감 UI 테스트 버튼")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                    .padding()
                //}
                
                Spacer()
                statePeopleView
                
                if isEntered == false && isCompleted == false {
                    // 참가전
                    Button {
                        manager.join(postId: postId) { status in
                            if status {
                                isEntered = true
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
                } else if  isEntered == false && isCompleted == true {
                    // 참가안한방 잠겨있는경우 접근 불가
                    Button {
                    } label: {
                        Text("<인원 마감>")
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
                                isEntered = false
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
                    
                    // 대화뷰 들어가기 버튼
                    NavigationLink {
                        CompletedBoardView()
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
            // 리뷰 필요
            .onAppear {
                manager.getBoard(postId: postId) { isComplete in
                    if isComplete {
                        if let board = manager.board {
                            DispatchQueue.main.async {
                                if let ownerName = board.ownerName {
                                    self.ownerName = ownerName
                                }
                                self.title = board.title
                                if let createdAt = board.createdAt {
                                    self.createdAt = createdAt
                                }
                                if let postStatus = board.postStatus {
                                    self.postStatus = postStatus
                                }
                                
                                if let withOrderLink = board.withOrderLink {
                                    self.withOrderLink = withOrderLink
                                }
                                self.maxPeopleNum = board.maxPeopleNum
                                self.currentPeopleNum = board.currentPeopleNum
                                self.isAnonymous = board.isAnonymous
                                self.content = board.content
                                self.pickupSpace = board.pickupSpace
                                self.spaceType = board.spaceType
                                self.accountNum = board.accountNum
                                
                                if self.ownerName == userModel.username {
                                    // 방장이 맞는지 확인
                                    isHost = true
                                } else {
                                    isHost = false
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    var statePeopleView: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(manager.getPeopleList(BoardStructModel(title: title,
                                                               maxPeopleNum: maxPeopleNum, currentPeopleNum: currentPeopleNum,
                                                               isAnonymous: isAnonymous,
                                                               content: content,
                                                               pickupSpace: pickupSpace,
                                                              
                                                               spaceType: spaceType,
                                                               accountNum: accountNum)), id: \.self) { imageName in
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
