import Foundation

struct UserModel: Codable {
    var username: String
    var password: String
    var name: String = ""
    var nickName: String = ""
    var gender: String = ""
    var school: String = ""
    var major: String = ""

    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}
