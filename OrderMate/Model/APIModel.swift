import Foundation

let urlString = "http://175.106.93.14:8080/" // 개인 로컬 서버

enum APIModel: String {
    case join
    case login
    case logout
    case user
    case post
    case get
    case put
    case upload
}
