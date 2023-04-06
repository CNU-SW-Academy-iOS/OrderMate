import Foundation

struct BoardStructModel: Codable {
    var ownerName: String?
    var title: String
    var createdAt: String? // 명세서 따른 변경, String으로 들어옴
    var postStatus: String? // 명세서 따른 변경, String으로 들어옴
    var maxPeopleNum: Int
    var currentPeopleNum: Int 
    var isAnonymous: Bool
    var content: String
    var withOrderLink: String?
    var pickupSpace: String
    var spaceType: String
    var accountNum: String
    var estimatedOrderTime: String?
    var participationList: [[String: String]]?
    var commentList: [String]?
    
}

// Date 받아올때 사용함
extension String {
    func formatISO8601DateToCustom() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "yy-MM-dd HH:mm"
            return dateFormatter.string(from: date)
        }
        return "yy-MM-dd HH:mm"
    }
    
    /*
    사용예시
     let isoDate = "2023-04-06T19:52:56.296139"
     let customFormattedDate = isoDate.formatISO8601DateToCustom()
     print(customFormattedDate) // "23-04-06 19:52"
     */
}
