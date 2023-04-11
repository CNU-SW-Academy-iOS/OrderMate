import Foundation

let urlString = "http://localhost:8080/" // 개인 로컬 서버

enum APIModel: String {
    case join
    case login
    case logout
    case user
    case post
    case get
    case put
}
