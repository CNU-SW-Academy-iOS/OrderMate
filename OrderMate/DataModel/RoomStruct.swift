//
//  RoomStruct.swift
//  OrderMate
//
//  Created by 문영균 on 2023/03/06.
//

import Foundation


struct Room: Hashable, Identifiable, Codable {
    var id: String
    var title: String
    var location: String
    var date: Date
    var maxUser: Int
    var userList: [String] = []
}

struct CreatRoom: Codable {
    var title: String
    var maxPeopleNum: String
    var isAnonymous: Int?
    var spaceType: String?
    var content: String
    var withOrderLink: String?
    var pickupSpace: String?
    var accountNum: String?
    var estimatedOrdTime: String?
   
}

struct RoomInfo: Decodable {
    let postId : Int?
    let title : String?
    let createdAt : Date?
    let postStatus : String?
    let maxPeopleNum : Int?
    let currentPeopleNum : Int?
    let isAnonymous : Bool?
    let content : String?
    let withOrderLink : String?
    let pickupSpace : String?
    let spaceType : String?
    let accountNum : String?
    let estimatedOrderTime : Date?
    let ownerId : Int?
    let ownerName : String?
}

struct RoomInfoPreview: Codable, Hashable {
    let postId : Int?
    let title : String?
    let content : String?
}


struct RoomList {
    func GetAllRoomList(completionHandler: @escaping (Bool, Any) -> Void) {
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
    
    func UploadData(title:String, maxPeopleNum:String, isAnonymous:Int,
                    spaceType:String, content:String, withOrderLink:String,
                    pickupSpace:String, accountNum:String, estimatedOrdTime:String
                    ,completion: @escaping (Bool) -> Void) {
        let post = CreatRoom(title: title, maxPeopleNum: maxPeopleNum, isAnonymous: isAnonymous,
                             spaceType: spaceType, content: content, withOrderLink: withOrderLink,
                             pickupSpace: pickupSpace, accountNum: accountNum, estimatedOrdTime: estimatedOrdTime)
    
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
            guard error == nil, let statusCode = (response as? HTTPURLResponse)?.statusCode, successRange.contains(statusCode) else {
                print((response as? HTTPURLResponse)?.statusCode)
                print("Error occur: \(String(describing: error))")
                return
            }
            
            
            let postSuccess = 201
            if postSuccess == (response as? HTTPURLResponse)?.statusCode {
                print("새 글 post 성공")
                print(response as Any)
                completion(true)
            }
        }
        task.resume()
    }
}
