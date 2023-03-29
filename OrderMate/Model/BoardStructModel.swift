import Foundation

struct BoardStructModel: Codable {
    var ownerName: String?
    var title: String
    var createdAt: Date?
    var postStatus: Bool?
    var maxPeopleNum: Int
    var currentPeopleNum: Int 
    var isAnonymous: Bool
    var content: String
    var withOrderLink: String?
    var pickupSpace: String
    var spaceType: String
    var accountNum: String
    var estimatedOrderTime: String?
    var participationList: [[String:String]]?
    var commentList: [String]?

//    init(title: String,
//         maxPeopleNum: Int,
//         isAnonymous: Bool,
//         spaceType: String,
//         content: String,
//         withOrderLink: String,
//         pickupSpace: String,
//         accountNum: String,
//         createdAt: Date,
//         currentPeopleNum: Int)
//    {
//    self.title = title
//    self.maxPeopleNum = maxPeopleNum
//    self.isAnonymous = isAnonymous
//    self.spaceType = spaceType
//    self.content = content
//    self.withOrderLink = withOrderLink
//    self.pickupSpace = pickupSpace
//    self.accountNum = accountNum
//    self.createdAt = createdAt
//    self.currentPeopleNum = currentPeopleNum
//}
    
}
