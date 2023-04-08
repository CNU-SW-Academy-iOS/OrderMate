import Foundation

let urlString = "http://localhost:8080/" // 개인 로컬 서버
let serverUrlString = "http://175.106.93.14:8080/" // 실제 서버

enum APIModel: String {
    case join
    case login
    case logout
    case user
    case post
    case get
    case put
}
