import Foundation

// boardListView용 데이터...struct RoomInfo와 달라야하는지 리뷰 필요
struct RoomInfoPreview: Codable, Hashable {
    let postId: Int?
    let title: String?
    let createdAt: String?
    let postStatus: String?
    let maxPeopleNum: Int?
    let currentPeopleNum: Int?
    let isAnonymous: Bool?
    let content: String?
    let withOrderLink: String?
    let pickupSpace: String?
    let spaceType: String?
    let accountNum: String?
    let estimatedOrderTime: String?
    let ownerId: Int? // 아이디별 고유 넘버링
    let ownerName: String? // 익명 여부에 따라 이름 혹은 별명
}

struct RoomList {
    func getAllRoomList(completionHandler: @escaping (Bool, Any) -> Void) {
        print("모든 리스트 정보 가져오기")
        if let url = URL(string: "http://localhost:8080/post") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"

            let session = URLSession.shared
            let task = session.dataTask(with: request) { (data, response, error) in
                guard error == nil else {
                    print("Error: error calling GET")
                    print(error!)
                    return
                }
                guard let data = data else {
                    print("Error: Did not receive data")
                    return
                }
                guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                    print("Error: HTTP request failed")
                    return
                }
                
                do {
                    let output = try JSONDecoder().decode([RoomInfoPreview].self, from: data)
                    print(output)
                    print("JSON Data Parsing")
                    
                    completionHandler(true, output)
                } catch {
                    print(error)
                }
            }
            task.resume()
        }
    }
    
    func uploadData(post: BoardStructModel, completion: @escaping (Bool) -> Void) {
        guard let uploadData = try? JSONEncoder().encode(post)
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
                print("Error occur: \(String(describing: error))")
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
    
    func getParticipatedBoard(completionHandler: @escaping (Bool, Any) -> Void) {
        // 내가 속한 방 정보 가져오기
        // http://localhost:8080/user/post-list
        
        if let url = URL(string: urlString + APIModel.user.rawValue + "/" + "post-list") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"

            let session = URLSession.shared
            let task = session.dataTask(with: request) { (data, response, error) in
                guard error == nil else {
                    print("Error: error calling GET")
                    print(error!)
                    return
                }
                guard let data = data else {
                    print("Error: Did not receive data")
                    return
                }
                guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                    print("Error: HTTP request failed")
                    return
                }
                
                do {
                    let output = try JSONDecoder().decode([RoomInfoPreview].self, from: data)
                    print(output)
                    print("JSON Data Parsing")
                    
                    completionHandler(true, output)
                } catch {
                    print(error)
                }
            }
            task.resume()
        }
    }
}
