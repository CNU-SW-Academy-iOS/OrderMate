import SwiftUI

struct CreateBoardView: View {
    
    @Environment(\.presentationMode) var presentationMode

    @StateObject var manager: BoardViewModel = BoardViewModel.shared
    @State var boardList = RoomList()
    @State var withOrderLink: String = ""
    @State var estimatedOrderTime: Date = Date()
    // 참가 인원 설정하기 위한 변수
    @State private var numberOfPeople: Int = 1
    // picker용 상수들
    let spaces = ["DORMITORY", "STUDIO_APARTMENT", "ALL"]
    let numbers = Array(1...10)
    
    @State var boardInfo = BoardStructModel(ownerName: UUID().uuidString,
                                            title: "",
                                            createdAt: "",
                                            postStatus: .recruiting,
                                            maxPeopleNum: 5,
                                            currentPeopleNum: 1,
                                            isAnonymous: false,
                                            content: "내용 입력",
                                            withOrderLink: "",
                                            pickupSpace: "",
                                            spaceType: "DORMITORY",
                                            accountNum: "")
    // String 옵셔널을 String으로 바꾸기 위한 함수
    func convertBinding(_ optionalBinding: Binding<String?>) -> Binding<String> {
        return Binding<String>(
            get: { optionalBinding.wrappedValue ?? "" },
            set: { optionalBinding.wrappedValue = $0 }
        )
    }
    // 사용자에게 한글로 보이게 하기위한 함수
    // 현재 spaceType은 json에서 enum으로 정의되어있어 "DORMITORY", "STUDIO_APARTMENT", "ALL"을 만족해야만 정상적으로 보내짐
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
        ScrollView {
            VStack(alignment: .leading) {
                TextField("제목을 입력해 주세요", text: $boardInfo.title)
                    .frame(height: 50)
                    .background(Color("green 0"))
                    .cornerRadius(10)
                    .padding()

                HStack {
                    Text("당신의 위치는?")
                        .foregroundColor(Color("green 2"))
                    Spacer()
                    Picker("장소 종류", selection: $boardInfo.spaceType) {
                        ForEach(spaces, id: \.self) { space in
                            Text(convertKeyToName(space)).tag(space)
                        }
                    }
                    .pickerStyle(.menu)
                    .background(Color("green 0"))
                    .cornerRadius(10)
                }
                .padding()
                TextField("픽업 장소를 입력해주세요.", text: $boardInfo.pickupSpace)
                    .frame(height: 50)
                    .background(Color("green 0"))
                    .cornerRadius(10)
                    .padding()

                DatePicker("주문 시각을 선택해주세요.", selection: $estimatedOrderTime)
                    .frame(height: 50)
                    .foregroundColor(Color("green 2"))
                    .cornerRadius(10)
                    .padding()

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
                        boardInfo.createdAt = Date().description
                        boardList.uploadData(post: boardInfo) { success in
                            if success {
                                print("방 생성 완료")
                            } else {
                                print("오류 발생으로 방 생성 실패")
                            }
                        }
                        print(boardInfo)
                        // 버튼 클릭시 현재 뷰를 pop 하여 이전 뷰로 돌아가는 기능
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("방 만들기")
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

struct CreateBoard_Previews: PreviewProvider {
    static var previews: some View {
        CreateBoardView()
    }
}
