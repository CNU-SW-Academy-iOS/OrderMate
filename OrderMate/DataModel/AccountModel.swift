//
//  LoginModel.swift
//  OrderMate
//
//  Created by 이수민 on 2023/03/10.
//

import Foundation




struct AccountModel {
    let urlString = "http://localhost:8080"
    
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
    func loginGet(_ userName: String, _ userPassWord: String) -> Bool {
        var success = false
        
        
        return success
        
    }
    
}

