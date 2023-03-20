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
//struct RoomInfo: Codable {
//    let postId : String
//    let title : String
//    let createdAt : String
//    let postStatus : String
//    let maxPeopleNum : String
//    let currentPeopleNum : String
//    let isAnonymous : Bool
//    let content : String
//    let withOrderLink : String
//    let pickupSpace : String
//    let spaceType : String
//    let accountNum : String
//    let estimatedOrderTime : String
//    let ownerId : String
//    let ownerName : String
//}

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

//struct RoomInfo: Codable {
//    let postId : String?
//    let title : String?
//    let createdAt : Date?
//    let postStatus : String?
//    let maxPeopleNum : Int?
//    let currentPeopleNum : Int?
//    let isAnonymous : Bool?
//    let content : String?
//    let withOrderLink : String?
//    let pickupSpace : String?
//    let spaceType : String?
//    let accountNum : String?
//    let estimatedOrderTime : Date?
//    let ownerId : Int?
//    let ownerName : String?
//}

struct RoomInfoTest: Codable, Hashable {
    let postId : Int?
    let title : String?
    let content : String?
}

//    postId,
//    title,
//    LocalDateTime createdAt,
//    PostStatus postStatus,  // 이게머임
//    Integer maxPeopleNum,
//    Integer currentPeopleNum,
//    Boolean isAnonymous,
//    String content,
//    String withOrderLink,
//    String pickupSpace,
//    SpaceType spaceType, // 이게머임
//    String accountNum,
//    LocalDateTime,
//    estimatedOrderTime,
//    Long ownerId,
//    String ownerName
    
    
//"postId": 1,
//"title": "123",
//"createdAt": null,
//"postStatus": null,
//"maxPeopleNum": 12,
//"currentPeopleNum": 1,
//"isAnonymous": false,
//"content": "12",
//"withOrderLink": "12",
//"pickupSpace": "12",
//"spaceType": "DORMITORY",
//"accountNum": "12",
//"estimatedOrderTime": "2018-02-05T12:59:11.332",
//"ownerId": 1,
//"ownerName": "유겸2 이름"


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
                    let output = try JSONDecoder().decode([RoomInfoTest].self, from: data)
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
    
    //func JsonRoomList
}
