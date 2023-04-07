//
//  UserViewModel.swift
//  OrderMate
//
//  Created by yook on 2023/04/07.
//

import Foundation

class UserViewModel: ObservableObject {
    static let shared = UserViewModel()
    @Published var userModel = UserInfoModel()
    
//     내 정보 가져오기
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
                //completion(false)
                return
            }
            guard let data = data else {
                print("invalid data")
                //completion(false)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(UserInfoModel.self, from: data)
                DispatchQueue.main.async {
                    self.userModel = response
                    print(response)
                    //completion(true)
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
            
            let getSuccess = 200
            if getSuccess == (response as? HTTPURLResponse)?.statusCode {
                print("내 정보 get 성공")
                print(response as Any)
                //completion(true)
                
            } else {
                print("내 정보 get 실패")
                print(response as Any)
                //completion(false)
            }
        }
        task.resume()
    }
    
    //내가 속한 방 정보 가져오기
    func getParticipatedBoard() {
        //http://localhost:8080/user/post-list
    }

    
}
