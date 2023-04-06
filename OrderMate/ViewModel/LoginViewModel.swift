import Foundation

class LoginViewModel: ObservableObject {

    func postNewUserInfo(user: UserModel, completion: @escaping (Bool) -> Void) {
        guard let uploadData = try? JSONEncoder().encode(user)
        else {
            completion(false)
            return
        }

        let url = URL(string: urlString + APIModel.join.rawValue)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
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
                print("User 정보 post 성공")
                print(response as Any)
                completion(true)
            } else {
                print("User 정보 post 실패")
                print(response as Any)
                completion(false)
            }
        }
        task.resume()
    }

    func loginGetStatus(user: UserModel, completion: @escaping (Bool) -> Void) {
        guard let uploadData = try? JSONEncoder().encode(user)
        else {
            completion(false)
            return
        }

        let url = URL(string: urlString + APIModel.login.rawValue)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
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

            if status == 200 {
                userModel.username = user.username // 현재 로그인 정보
                print("User login 성공")
                print(response as Any)
                completion(true)
            } else {
                print("User login 실패")
                print(response as Any)
                completion(false)
            }
        }
        task.resume()
    }
    
    // 로그 아웃, request param 없음, responseParam 없음
    func logOut(completion: @escaping (Bool) -> Void) {
        let url = URL(string: urlString + APIModel.logout.rawValue)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
             
            let successRange = 200..<300
            let status = (response as? HTTPURLResponse)?.statusCode ?? 0
            guard error == nil else{
                print("Error occur: \(String(describing: error))")
                return
            }
            if !successRange.contains(status) {
                print("status code: ",status )
            }

            if status == 200 {
                userModel.username = "" // 현재 로그인 유저 정보 삭제
                print("User logout 성공")
                print(response as Any)
                completion(true)
            } else {
                print("User logout 실패")
                print(response as Any)
                completion(false)
            }
        }
        task.resume()
        
    }
}
