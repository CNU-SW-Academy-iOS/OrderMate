import Foundation

struct UserModel: Codable {
    var username: String = ""
    var password: String = ""
    var name: String = ""
    var nickname: String = ""
    var gender: String = ""
    var school: String = ""
    var major: String = ""

    // struct는 self 지정안해도 작동함
}

// 로그인 후 내 정보 조회용으로 사용 전역변수
var userModel = UserModel()

// 가입시 쓰는 UserModel 쓰면 Json 항목이달라 Json 연결시 에러가 발생합니다
struct UserInfoModel: Codable {
    var name: String = ""
    var nickname: String = ""
    var gender: String = ""
    var school: String = ""
    var major: String = ""
}
