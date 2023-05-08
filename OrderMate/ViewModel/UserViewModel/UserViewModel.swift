import Foundation

final class UserViewModel: ObservableObject {
    static let shared = UserViewModel()
    @Published var userModel = UserInfoModel()
    @Published var authorityModel = Authority(authority: false)
    
    // 내 정보 가져오기 ( 별명, 본명 )
    func getMyInfo() {
        let url = URL(string: urlString + APIModel.user.rawValue)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let successRange = 200..<300
            guard error == nil, let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  successRange.contains(statusCode) else {
                print()
                print("Error occur: \(String(describing: error))")
                print("error code: \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                return
            }
            guard let data = data else {
                print("invalid data")
                return
            }
            
            do {
                let response = try JSONDecoder().decode(UserInfoModel.self, from: data)
                DispatchQueue.main.async {
                    self.userModel = response
                    print(response)
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
                print("내 정보 get 성공")
                print(response as Any)
                
            } else {
                print("내 정보 get 실패")
                print(response as Any)
            }
        }
        task.resume()
    }
    
    // 내가 방 생성, 참가가 가능한지 확인하기
    func getAuthority() {
        // http://localhost:8080/post/auth
        let url = URL(string: urlString + APIModel.post.rawValue + "/" + "auth")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let successRange = 200..<300
            guard error == nil, let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  successRange.contains(statusCode) else {
                print()
                print("Error occur: \(String(describing: error))")
                print("error code: \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                return
            }
            guard let data = data else {
                print("invalid data")
                return
            }
            
            do {
                let response = try JSONDecoder().decode(Authority.self, from: data)
                DispatchQueue.main.async {
                    self.authorityModel.authority = response.authority
                    print(response)
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
                print("내 생성권한 상태 get 성공")
                print(response as Any)
                
            } else {
                print("내 생성권한 상태 get 실패")
                print(response as Any)
            }
        }
        task.resume()
    }

}
