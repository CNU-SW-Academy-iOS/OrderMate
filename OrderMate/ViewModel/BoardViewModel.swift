import Foundation

class BoardViewModel: ObservableObject {
    static var shared = BoardViewModel()
    @Published var board: BoardStructModel?
    
    init() {
        // 리뷰 필요
        getBoard(postId: 1) { isComplete in
        }
    }
    
    func getBoard(postId: Int, completion: @escaping (Bool) -> Void) {
        let url = URL(string: urlString + APIModel.post.rawValue + "/" + String(postId))
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let successRange = 200..<300
            guard error == nil, let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  successRange.contains(statusCode) else {
                print()
                print("Error occur: \(String(describing: error)) error code: \((response as? HTTPURLResponse)?.statusCode)")
                completion(false)
                return
            }
            guard let data = data else {
                print("invalid data")
                completion(false)
                return
            }
            let decoder = JSONDecoder()
            
            do {
                let response = try decoder.decode(BoardStructModel.self, from: data)
                DispatchQueue.main.async {
                    self.board = response
                    completion(true)
                }
            } catch {
                print("error occured.")
            }
            
            let getSuccess = 200
            if getSuccess == (response as? HTTPURLResponse)?.statusCode {
                print("게시글 정보 get 성공")
                print(response as Any)
                completion(true)
                
            } else {
                print("게시글 정보 get 실패")
                print(response as Any)
                completion(false)
            }
        }
        task.resume()
    }
    
    func getBoard(completion: @escaping (Bool) -> Void) {
        let url = URL(string: urlString + APIModel.post.rawValue + "/1")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let successRange = 200..<300
            guard error == nil, let statusCode = (response as? HTTPURLResponse)?.statusCode, successRange.contains(statusCode) else {
                print()
                print("Error occur: \(String(describing: error)) error code: \((response as? HTTPURLResponse)?.statusCode)")
                completion(false)
                return
            }
            guard let data = data else {
                print("invalid data")
                completion(false)
                return
            }
            let decoder = JSONDecoder()
            
            do {
                let response = try decoder.decode(BoardStructModel.self, from: data)
                DispatchQueue.main.async {
                    self.board = response
                    completion(true)
                }
            } catch {
                print("error occured.")
            }
            
            let getSuccess = 200
            if getSuccess == (response as? HTTPURLResponse)?.statusCode {
                print("게시글 정보 get 성공")
                print(response as Any)
                completion(true)
                
            } else {
                print("게시글 정보 get 실패")
                print(response as Any)
                completion(false)
            }
        }
        task.resume()
    }
}
