//
//  BoardView.swift
//  OrderMate
//
//  Created by 문영균 on 2023/03/15.
//

import SwiftUI

struct BoardView: View {
    var postId: Int
    @State private var isComplete: Bool = false
    @StateObject var manager: BoardViewModel = BoardViewModel.shared
    @State var ownerName: String = "주인장 이름"
    @State var title: String = "타이틀"
    @State var createdAt: Date = Date()
    @State var postStatus: Bool? = nil
    @State var maxPeopleNum: Int = 5
    @State var currentPeopleNum: Int = 2
    @State var isAnonymous: Bool = false
    @State var content: String = "제목"
    @State var pickupSpace: String = "픽업 장소"
    @State var withOrderLink: String = "배민 함꼐하기 주소"
    @State var spaceType: String = "기숙사 / 충대 내부"
    @State var accountNum: String = "계좌 번호"
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    Text("\(title)")
                        .font(.system(size: 27))
                        .frame(maxWidth: .infinity, minHeight: 30)
                        .padding()
                        .foregroundColor(.black)
                        .background(Color("green 0"))
                        .cornerRadius(10)
                }
                .padding()
                
                VStack {
                    Text("\(pickupSpace)")
                        .font(.system(size: 20))
                        .font(.title)
                        .frame(maxWidth: .infinity, minHeight: 30)
                        .padding()
                        .foregroundColor(.black)
                        .background(Color("green 0"))
                        .cornerRadius(10)
                }
                .padding()
                
                VStack {
                    Text("\(content)")
                        .font(.system(size: 24))
                        .font(.title)
                        .frame(maxWidth: .infinity, minHeight: 30)
                        .padding()
                        .foregroundColor(.black)
                        .background(Color("green 0"))
                        .cornerRadius(10)
                }
                .padding()
                
                Toggle(isOn: $isComplete) {
                    Text("인원 마감")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                .padding()
                
                Spacer()
                statePeople
//                HStack {
//                    ForEach(0..<5){ _ in
//                        Image(systemName: "person.fill")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit
//                            )
//                            .frame(width: 25)
//                            .padding()
//                    }
//                }
                NavigationLink {
                    Text("참여하기 뷰")
                } label: {
                    Text("참여하기")
                        .font(.system(size: 24))
                        .frame(maxWidth: .infinity, minHeight: 30)
                        .padding()
                        .foregroundColor(.black)
                        .fontWeight(.semibold)
                        .background(Color("green 0"))
                        .cornerRadius(10)
                }
                .padding()
            }
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
                                self.currentPeopleNum = board.currentPeopleNum!
                                self.isAnonymous = board.isAnonymous
                                self.content = board.content
                                self.pickupSpace = board.pickupSpace
                                self.spaceType = board.spaceType
                                self.accountNum = board.accountNum
                            }
                        }
                    }
                }
            }
        }
    }
    func getPeopleList() -> Array<String> {
        var totalPeople: [String]
        totalPeople = Array(repeating: "person.fill", count: currentPeopleNum)
        totalPeople += Array(repeating: "person", count: maxPeopleNum - currentPeopleNum)
        return totalPeople
    }
    
    var statePeople: some View {
        HStack(spacing: -3) {
            ForEach(getPeopleList(), id: \.self) { imageName in
                Image(systemName: imageName)
                    .imageScale(.large)
                    .foregroundColor(Color("green 0"))
                    Spacer(minLength: 2)
            }
        }
    }
}

struct BoardView_Previews: PreviewProvider {
    var postId = 1
    static var previews: some View {
        BoardView(postId: 1)
    }
}
