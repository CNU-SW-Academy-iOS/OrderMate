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
    func getPeopleList(_ board: BoardStructModel) -> Array<String> {
        var totalPeople: [String] = []
        totalPeople = Array(repeating: "person.fill", count: board.currentPeopleNum)
        totalPeople += Array(repeating: "person", count: board.maxPeopleNum - board.currentPeopleNum)
        return totalPeople
    }
    
    func getBoard(postId: Int, completion: @escaping (Bool) -> Void) {
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
            decoder.dateDecodingStrategy = .millisecondsSince1970
            
            do {
                let response = try decoder.decode(BoardStructModel.self, from: data)
                DispatchQueue.main.async {
                    self.board = response
                    completion(true)
                }
//            } catch let error {
//                print(String(data: data, encoding: .utf8))
//                print("error occured.")
//                print(error.localizedDescription )
            } catch let DecodingError.dataCorrupted(context) {
                print(context)
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.typeMismatch(type, context)  {
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
    func join(postId: Int, completion: @escaping (Bool) -> Void) {
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
            } catch let DecodingError.typeMismatch(type, context)  {
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
    
    // 방 상태 변경
    func goNextFromRecruiting(postId: Int, completion: @escaping (Bool) -> Void) {
        var postStatusModel = PostStatusModel(directionType: "NEXT",
                                              currentStatus: PostStatusEnum.RECRUITING.description())

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
                print("방 상태 모집 완료로 변경 성공")
                print(response as Any)
                completion(true)
            } else {
                print("방 상태 모집 완료로 변경 실패")
                print(response as Any)
                completion(false)
            }
        }
        task.resume()
    }
    
}
