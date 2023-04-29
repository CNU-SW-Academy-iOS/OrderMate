import Foundation

struct RoomList {
    
    // 외부 (ChatListViewModel)에서 RoomList의 사용할 수 있도록 싱글톤 객체 생성
    static let shared = RoomList()
    
   
    
    func getAllRoomList(completionHandler: @escaping (Bool, Any) -> Void) {
        print("모든 리스트 정보 가져오기")
        if let url = URL(string: "http://175.106.93.14:8080/post") {
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
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(DateFormatter.customISO8601)
                    let output = try decoder.decode([RoomInfoPreview].self, from: data)
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
    

    // 게시글 업로드 시 게시글 정보 반환 (Any형 data)
    func uploadData(post: BoardStructModel, completion: @escaping (Bool, RoomInfoPreview?) -> Void) {
        let dateFormatter = DateFormatter()
          dateFormatter.locale = Locale(identifier: "en_US_POSIX")
          dateFormatter.timeZone = TimeZone.current
             dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
          
          let encoder = JSONEncoder()
              encoder.dateEncodingStrategy = .formatted(dateFormatter)
          
          guard let uploadData = try? encoder.encode(post)
          else {
              completion(false, nil)
              return
          }
          
          let url = URL(string: "http://175.106.93.14:8080/post/upload")
          
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
                  if let data = data {
                      let decoder = JSONDecoder()
                      decoder.keyDecodingStrategy = .convertFromSnakeCase
                      decoder.dateDecodingStrategy = .formatted(DateFormatter.customISO8601)
                      guard let boardData = try? decoder.decode(RoomInfoPreview.self, from: data)
                      else {
                          completion(false, nil)
                          return
                      }
                      completion(true, boardData)
                  }
              } else {
                  print("새 글 post 실패")
                  print(response as Any)
                  completion(false, nil)
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
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(DateFormatter.customISO8601)
                    let output = try decoder.decode([RoomInfoPreview].self, from: data)
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
