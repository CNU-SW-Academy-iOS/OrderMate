import Foundation

struct Message: Codable, Identifiable {
    var id: String
    var text: String
    var timestamp: Date
    var userId: String
    var userNickName: String


}

extension Message {
    func changeDateFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH : mm"
        return dateFormatter.string(from: self.timestamp)
    }
}
