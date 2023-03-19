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

struct PostInfo: Codable {
    let postId : String
    let title : String
    let createdAt : Date
    let postStatus : String
    let maxPeopleNum : Int
    let currentPeopleNum : Int
    let isAnonymous : Bool
    let content : String
    let withOrderLink : String
    let pickupSpace : String
    let spaceType : String
    let accountNum : String
    let estimatedOrderTime : Date
    let ownerId : Int
    let ownerName : String
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

struct RoomListModel {
    func GetAllRoomList() {
        //var List = PostInfo(
        print("모든 리스트 정보 가져오기")
        let url = URL(string: "http://localhost:8080/post")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let successRange = 200..<300
            guard error == nil, let statusCode = ( response as? HTTPURLResponse)?.statusCode, successRange.contains(statusCode) else {
                print((response as? HTTPURLResponse)?.statusCode)
                print("Error occur: \(String(describing: error))")
                return
            }
            let postSuccess = 200
            if postSuccess == (response as? HTTPURLResponse)?.statusCode {
                print("모든 리스트 정보 가져오기 성공")
                print(response as Any)
                //completion(true)
            } else {
                print("모든 리스트 정보 가져오기 실패")
                print(response as Any)
                //completion(false)
            }
        }
        task.resume()
        return
    }
}

