//
//  LoginModel.swift
//  OrderMate
//
//  Created by 이수민 on 2023/03/10.
//

import Foundation




struct AccountModel {
    let urlString = "http://localhost:8080/join"
    
    func makeAccountPost(_ myUserName: String, _ myPassWord: String, _ myName: String, _ myNickName: String, _ isMale: Bool, _ mySchool: String, _ myMajor: String) -> Bool {
        var postSuccess = true
        
        var urlComponents = URLComponents(string: urlString)
        urlComponents?.path = "/join"
        let body  = [
            URLQueryItem(name: "username", value: myUserName),
            URLQueryItem(name: "password", value: myPassWord),
            URLQueryItem(name: "name", value: myName),
            URLQueryItem(name: "nickname", value: myNickName),
            URLQueryItem(name: "gender", value: isMale ? "MALE" : "FEMALE"),
            URLQueryItem(name: "school", value: mySchool),
            URLQueryItem(name: "major", value: myMajor)
        ]
        
        urlComponents?.percentEncodedQueryItems = body
        
        let url = urlComponents?.url!
        print("url : \(url)")
        
        var request: URLRequest = URLRequest(url: url!)
        
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            guard let e = error else {return}
            postSuccess = true
            
        }
        task.resume()
        print("success = \(postSuccess)")
        return postSuccess
    }
    
    
    
    func postNewUserInfo(username: String, password: String, name: String, nickname: String, gender: String, school: String, major: String, completion: @escaping (Bool) -> Void) {
        let user = PostUser(username: username, password: password, name: name, nickName: nickname, gender: "MALE", school: school, major: major)
        
        guard let uploadData = try? JSONEncoder().encode(user)
        else {
            completion(false)
            return
        }
        
        let url = URL(string: urlString)
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.uploadTask(with: request, from: uploadData) { data, response, error in
            let successRange = 200..<300
            guard error == nil, let statusCode = (response as? HTTPURLResponse)?.statusCode, successRange.contains(statusCode) else {
                print((response as? HTTPURLResponse)?.statusCode)
                print("Error occur: \(String(describing: error))")
                return
            }
            
            let postSuccess = 201
            if postSuccess == (response as? HTTPURLResponse)?.statusCode {
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
    
    
    
    
    func loginGetStatus(_ userName: String, _ userPassWord: String, completion: @escaping (Bool) -> Void) {
        let user = LoginUser(username: userName, password: userPassWord)
        
        guard let uploadData = try? JSONEncoder().encode(user)
        else {
            completion(false)
            return
        }
        
        let url = URL(string: "http://localhost:8080/login")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.uploadTask(with: request, from: uploadData) { data, response, error in
            let successRange = 200..<300
            guard error == nil, let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  successRange.contains(statusCode) else {
                print((response as? HTTPURLResponse)?.statusCode)
                print("Error occur: \(String(describing: error))")
                completion(false)
                return
            }
            
            if statusCode == 200 {
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
    
    
}

