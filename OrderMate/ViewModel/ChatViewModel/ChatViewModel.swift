import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

// firebase를 이용한 채팅 뷰, 채팅 리스트 구현 View Model
class ChatViewModel: ObservableObject {
    static let shared = ChatViewModel()
    @Published var msgList: [Message] = []
    @Published var chatList: [BoardStructModel] = []
    @Published var lastMsgID: String = ""
    @Published var board: BoardStructModel = BoardStructModel(title: "", maxPeopleNum: 0, currentPeopleNum: 0, isAnonymous: false, content: "", pickupSpace: "", spaceType: "", accountNum: "")
    let userManager: UserViewModel = UserViewModel.shared
    let roomManager = RoomList.shared
    
    let db = Firestore.firestore()
    
    init() {
    }
    
    var listIDArray: [Int] = [] // 내가 속한 boardID들

    // postid 입력시 firebase의 board 정보 반환
    func getChatInfo(postId: Int) {
        print(postId)
        let chatRef = db.collection("chatlist").document("\(postId)")
        chatRef.getDocument{ (document, error) in
            guard let data = document?.data() else {
                print("document가 비었습니다.")
                return
            }
            guard JSONSerialization.isValidJSONObject(data) else {
                print("Is Not Vaild JSONObject")
                return
            }
            guard let parsingData = try? JSONSerialization.data(withJSONObject: data) else { return }
            guard let returnData = try? JSONDecoder().decode(BoardStructModel.self, from: parsingData) else { return }
            print("firebase에서 읽기 성공")
            self.board = returnData
            return
        }
    }
    
    // 방 생성 시 채팅방 생성
    func createChat(board: RoomInfoPreview, completion: @escaping (Bool) -> Void) {
        
        var boardData = board
        // 옵셔널 모두 해제
        if let postId = board.postId,
           let title = board.title,
           let postStatus = board.postStatus,
           let maxPeopleNum = board.maxPeopleNum,
           let currentPeopleNum = board.currentPeopleNum,
           let isAnonymous = board.isAnonymous,
           let content = board.content,
           let withOrderLink = board.withOrderLink,
           let pickupSpace = board.pickupSpace,
           let spaceType = board.spaceType,
           let accountNum = board.accountNum,
           let estimatedOrderTime = board.estimatedOrderTime,
           let ownerName = board.ownerName {
            boardData.postId = postId
            boardData.title = title
            boardData.postStatus = postStatus
            boardData.maxPeopleNum = maxPeopleNum
            boardData.currentPeopleNum = currentPeopleNum
            boardData.isAnonymous = isAnonymous
            boardData.content = content
            boardData.withOrderLink = withOrderLink
            boardData.pickupSpace = pickupSpace
            boardData.spaceType = spaceType
            boardData.accountNum = accountNum
            boardData.estimatedOrderTime = estimatedOrderTime
            boardData.ownerName = ownerName
        }
        // createAt은 아직 nil 값이 들어옵니다 추후 수정해주신다고 합니다.
        boardData.createdAt = Date()
        
        // board firebase에 쓰기 위해 encode()
        guard let dictionary = board.asDictionary else {
            print("encode error")
            return
        }
        db.collection("chatlist").document("\(boardData.postId!)").setData(dictionary) { error in
            if let err = error {
                print("파이어베이스 쓰기 실패: \(err)")
            } else {
                print("파이어베이스 쓰기 성공")
            }
        }
    }
    
    // 메세지 전송
    func sendMessageInServer(postId: Int, msg: Message) {
        // 메세지 encoding
        msgList.append(msg)
        lastMsgID = msg.id
        guard let dictionary = msg.asDictionary else {
            print("message encode error")
            return
        }
        // 메세지가 있을 경우 메세지 추가
        let msgRef = db.collection("\(postId)").document("Messages")
        msgRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.db.collection("Messages").document("\(msg.id)")
                    .setData(dictionary) { error in
                        if let err = error {
                            print("메세지 추가 실패: \(err)")
                        } else {
                            print("메세지 추가 성공")
                        }
                    }
            }
            // 첫 메세지면 messages 생성
            else {
                let msgRef = self.db.collection("chatlist").document("\(postId)")
                    .collection("messages").document(msg.id)
                    .setData(dictionary) { error in
                        if let err = error {
                            print("메세지 추가 실패: \(err)")
                        } else {
                            print("메세지 추가 성공")
                        }
                    }
            }
        }
    }
    
    // 채팅방 실시간 감시
    func listenRoomChat(postId: Int) {
        self.db.collection("chatlist").document("\(postId)")
            .collection("messages")
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("메세지 실시간 읽기 에러 \(String(describing: error))")
                    return
                }
                self.msgList = documents.compactMap({ document -> Message? in
                    guard JSONSerialization.isValidJSONObject(document.data()) else {
                        print("Is Not Vaild JSONObject")
                        return nil
                    }
                    guard let data = try? JSONSerialization.data(withJSONObject: document.data()) else { return nil }
                    guard let decodedResults = try? JSONDecoder().decode(Message.self, from: data) else { return nil }
                    return decodedResults})
                self.msgList.sort { $0.timestamp < $1.timestamp }
                if let last = self.msgList.last {
                    self.lastMsgID = last.id
                }
                print(self.msgList)
            }
    }
}
