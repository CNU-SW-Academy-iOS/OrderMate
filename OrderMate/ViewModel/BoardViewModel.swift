import Foundation

class BoardViewModel: ObservableObject {
    static let shared = BoardViewModel()
    @Published var board: BoardStructModel?
    
    // 날짜 형태 변경
    func changeDateFormat(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: date)
    }
    // 뷰에서 발생하는 함수들은 ViewModel에 작성해주세요
    func getPeopleList() -> Array<String> {
        var totalPeople: [String] = []
        totalPeople = Array(repeating: "person.fill", count: self.board!.currentPeopleNum)
        totalPeople += Array(repeating: "person", count: self.board!.maxPeopleNum - self.board!.currentPeopleNum)
        return totalPeople
    }
    
    func getBoard(postId: Int, completion: @escaping (Bool) -> Void) {
        // 방잠금으로 새로 고침
        let url = URL(string: urlString + APIModel.post.rawValue + "/" + String(postId))
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let successRange = 200..<300
            guard error == nil, let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  successRange.contains(statusCode) else {
                print()
                print("Error occur: \(String(describing: error))")
                print("error code: \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                completion(false)
                return
            }
            guard let data = data else {
                print("invalid data")
                completion(false)
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .formatted(DateFormatter.customISO8601)
            do {
                let response = try decoder.decode(BoardStructModel.self, from: data)
                DispatchQueue.main.async {
                    self.board = response
                    completion(true)
                }
            } catch let DecodingError.dataCorrupted(context) {
                print(context)
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.typeMismatch(type, context) {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch {
                print("error: ", error)
            }
            
            let getSuccess = 200
            if getSuccess == (response as? HTTPURLResponse)?.statusCode {
                print("게시글 정보 get 성공")
                print(response as Any)
                completion(true)
                
            } else {
                print("게시글 정보 get 실패")
                print(response as Any)
                completion(false)
            }
        }
        task.resume()
    }
    
    // 유저의 방 참가
    private func join(postId: Int, completion: @escaping (Bool) -> Void) {
        let url = URL(string: urlString + APIModel.post.rawValue + "/" + String(postId) + "/" + "enter")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        // 서버 체크
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let successRange = 200..<300
            guard error == nil, let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  successRange.contains(statusCode) else {
                print()
                print("Error occur: \(String(describing: error))")
                print("error code: \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                completion(false)
                return
            }
            guard let data = data else {
                print("invalid data")
                completion(false)
                return
            }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .millisecondsSince1970
            
            do {
                let response = try decoder.decode(BoardStructModel.self, from: data)
                DispatchQueue.main.async {
                    self.board = response
                    completion(true)
                }
            } catch let DecodingError.dataCorrupted(context) {
                print(context)
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.typeMismatch(type, context) {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch {
                print("error: ", error)
            }
            
            let getSuccess = 201
            if getSuccess == (response as? HTTPURLResponse)?.statusCode {
                print("유저의 방 참가 성공")
                print(response as Any)
                completion(true)
                
            } else {
                print("유저의 방 참가 실패")
                print(response as Any)
                completion(false)
            }
        }
        task.resume()
    }
    
    // 참가함수 + 새로고침 함수
    func joinAndFetchBoard(postId: Int, completion: @escaping (Bool) -> Void) {
        join(postId: postId) { joinSuccess in
            if joinSuccess {
                self.getBoard(postId: postId) { getBoardSuccess in
                    completion(getBoardSuccess)
                }
            } else {
                completion(false)
            }
        }
    }

    // 방 상태 가져오고 bool값 가져오기
    func processBoardInfo(userModel: UserModel, completion: @escaping (BoardStructModel, Bool, Bool, Bool) -> Void) {
        // Published board값 가져오기
        if let board = self.board {
            var isHost = false // 방장인지 확인
            var isCompleted = true // 모집중인지 확인
            var isEntered = false // 게스트인지 확인
            
            let boardInfo = board // 방 정보 전달
            if self.checkUserIsHost(userName: userModel.username, inArray: boardInfo.participationList!) {
                // 방장인지 확인
                isHost = true
                isEntered = true
            }
            if boardInfo.postStatus == PostStatusEnum.recruiting {
                // 모집중인지 확인
                isCompleted = false
            }
            if self.checkUserIsGuest(userName: userModel.username, inArray: boardInfo.participationList!) {
                // 게스트인지 확인
                isEntered = true
            }
            completion(boardInfo, isHost, isCompleted, isEntered)
            
        }
    }
    
    // 유저의 방 탈퇴
    func leave(postId: Int, completion: @escaping (Bool) -> Void) {
        let url = URL(string: urlString + APIModel.post.rawValue + "/" + String(postId) + "/" + "leave")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        // 서버 체크
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let successRange = 200..<300
            guard error == nil, let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  successRange.contains(statusCode) else {
                print()
                print("Error occur: \(String(describing: error))")
                print("error code: \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                completion(false)
                return
            }
            guard let data = data else {
                print("invalid data")
                completion(false)
                return
            }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .millisecondsSince1970
            
            do {
                let response = try decoder.decode(BoardStructModel.self, from: data)
                DispatchQueue.main.async {
                    self.board = response
                    completion(true)
                }
            } catch let DecodingError.dataCorrupted(context) {
                print(context)
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.typeMismatch(type, context) {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch {
                print("error: ", error)
            }
            
            let getSuccess = 201
            if getSuccess == (response as? HTTPURLResponse)?.statusCode {
                print("유저의 방 탈퇴 성공")
                print(response as Any)
                completion(true)
                
            } else {
                print("유저의 방 탈퇴 실패")
                print(response as Any)
                completion(false)
            }
        }
        task.resume()
    }
    
    /**
     방 상태를 모집완료로 변경
     */
    func changeToRecruitingComplete(postId: Int, completion: @escaping (Bool) -> Void) {
        var postStatusModel = PostStatusModel(directionType: "NEXT",
                                              currentStatus: PostStatusEnum.recruiting.rawValue)

        let url = URL(string: urlString + APIModel.post.rawValue + "/" + String(postId) + "/" + "status")
        guard let uploadData = try? JSONEncoder().encode(postStatusModel)
        else {
            completion(false)
            return
        }
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        let task = session.uploadTask(with: request, from: uploadData) { data, response, error in
            let successRange = 200..<300
            let status = (response as? HTTPURLResponse)?.statusCode ?? 0
            guard error == nil else {
                print("Error occur: \(String(describing: error))")
                return
            }
            if !successRange.contains(status) {
                print("status code: ", status)
            }

            if status == 201 {
                print("방 상태 모집중으로 변경 성공")
                print(response as Any)
                completion(true)
            } else {
                print("방 상태 모집중으로 변경 실패")
                print(response as Any)
                completion(false)
            }
        }
        task.resume()
    }
    
    /**
     방 상태를 모집중으로 변경
     */
    func changeToRecruiting(postId: Int, completion: @escaping (Bool) -> Void) {
        var postStatusModel = PostStatusModel(directionType: "PREV",
                                              currentStatus: PostStatusEnum.recruitmentComplete.rawValue)

        let url = URL(string: urlString + APIModel.post.rawValue + "/" + String(postId) + "/" + "status")
        guard let uploadData = try? JSONEncoder().encode(postStatusModel)
        else {
            completion(false)
            return
        }
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        let task = session.uploadTask(with: request, from: uploadData) { data, response, error in
            let successRange = 200..<300
            let status = (response as? HTTPURLResponse)?.statusCode ?? 0
            guard error == nil else {
                print("Error occur: \(String(describing: error))")
                return
            }
            if !successRange.contains(status) {
                print("status code: ", status)
            }

            if status == 201 {
                print("방 상태 모집중으로 변경 성공")
                print(response as Any)
                completion(true)
            } else {
                print("방 상태 모집중으로 변경 실패")
                print(response as Any)
                completion(false)
            }
        }
        task.resume()
    }
    /**
     방 상태를 방 완료로 변경
     */
    func changeBoardComplete(postId: Int, completion: @escaping (Bool) -> Void) {
        var postStatusModel = PostStatusModel(directionType: "NEXT",
                                              currentStatus: PostStatusEnum.deliveryComplete.rawValue)

        let url = URL(string: urlString + APIModel.post.rawValue + "/" + String(postId) + "/" + "status")
        guard let uploadData = try? JSONEncoder().encode(postStatusModel)
        else {
            completion(false)
            return
        }
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        let task = session.uploadTask(with: request, from: uploadData) { data, response, error in
            let successRange = 200..<300
            let status = (response as? HTTPURLResponse)?.statusCode ?? 0
            guard error == nil else {
                print("Error occur: \(String(describing: error))")
                return
            }
            if !successRange.contains(status) {
                print("status code: ", status)
            }

            if status == 201 {
                print("방 상태 완료로 변경 성공")
                print(response as Any)
                completion(true)
            } else {
                print("방 상태 완료로 변경 실패")
                print(response as Any)
                completion(false)
            }
        }
        task.resume()
    }
    
    // CreateBoardView 를 통해 얻은 struct 정보를 바탕으로 게시글을 생성하는 함수.
    // 현재는 Encoding error 확인용으로 만들어놨다.
    func createBoard(_ boardInfo: BoardStructModel, completion: @escaping (Bool) -> Void) {
        guard let uploadData = try? JSONEncoder().encode(boardInfo)
        else {
            completion(false)
            return
        }

        let url = URL(string: "http://localhost:8080/post/upload")

        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        let task = session.uploadTask(with: request, from: uploadData) { data, response, error in

            let successRange = 200..<300
            guard error == nil, let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  successRange.contains(statusCode) else {
                print((response as? HTTPURLResponse)?.statusCode)
                print("Post 실패 | Error occur: \(String(describing: error))")

                return
            }

            let postSuccess = 201
            if postSuccess == (response as? HTTPURLResponse)?.statusCode {
                print("새 글 post 성공")
                print(response as Any)
                completion(true)
            } else {
                print("새 글 post 실패")
                print(response as Any)
                completion(false)
            }
        }
        task.resume()

    }
    
    func checkUserIsHost(userName: String, inArray array: [[String: String]]) -> Bool {
        for dict in array {
            if let name = dict["username"], name == userName, dict["role"] == "HOST" {
                return true
            }
        }
        return false
    }
    
    func checkUserIsGuest(userName: String, inArray array: [[String: String]]) -> Bool {
        for dict in array {
            if let name = dict["username"], name == userName {
                return true
            }
        }
        return false
    }
    
}
