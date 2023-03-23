//
//  CreateBoard.swift
//  OrderMate
//
//  Created by yook on 2023/03/21.
//

import SwiftUI

struct CreateBoardView: View {
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
        Text("방 만들기 텍스트필드 화면")
    }
}

struct CreateBoard_Previews: PreviewProvider {
    static var previews: some View {
        CreateBoardView()
    }
}
