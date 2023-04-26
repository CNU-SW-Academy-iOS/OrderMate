import Foundation

// 게시글 상세 조회용
struct BoardStructModel: Codable {
    var loginUsername: String? // 아이디
    var ownerName: String? // 익명 여부에 따라 이름 혹은 별명
    var title: String
    var createdAt: Date? // 명세서 따른 변경, String으로 들어옴
    var postStatus: PostStatusEnum? // 명세서 따른 변경, String으로 들어옴
    var maxPeopleNum: Int
    var currentPeopleNum: Int
    var isAnonymous: Bool
    var content: String
    var withOrderLink: String?
    var pickupSpace: String
    var spaceType: String
    var accountNum: String
    var estimatedOrderTime: Date?
    var participationList: [[String: String]]?
    var commentList: [String]?
}
// boardListView용 데이터...struct RoomInfo와 달라야하는지 리뷰 필요
struct RoomInfoPreview: Codable, Hashable {
    var postId: Int?
    var title: String?
    var createdAt: Date?
    var postStatus: String?
    var maxPeopleNum: Int?
    var currentPeopleNum: Int?
    var isAnonymous: Bool?
    var content: String?
    var withOrderLink: String?
    var pickupSpace: String?
    var spaceType: String?
    var accountNum: String?
    var estimatedOrderTime: Date?
    var ownerId: Int? // 아이디별 고유 넘버링
    var ownerName: String? // 익명 여부에 따라 이름 혹은 별명
}
//// Date 받아올때 사용함
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
extension Date {
    func toStringYYMMDDHHMM() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy-MM-dd HH:mm"
        return dateFormatter.string(from: self)
    }
    
    func toStringYYMMDD() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy-MM-dd"
        return dateFormatter.string(from: self)
    }
}

extension DateFormatter {
    static let customISO8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        return formatter
    }()
}



// 파이어베이스에서 데이터 쓸 때 [String:Any] 형태로 바꿔서 쓰기
extension Encodable {
    var asDictionary: [String : Any]? {
        guard let object = try? JSONEncoder().encode(self),
              let dictinoary = try? JSONSerialization.jsonObject(with: object, options: []) as? [String: Any] else { return nil }
        return dictinoary
    }
}
