import Foundation
import SwiftUI

struct BoardModel: View {
    @State var board: Board? = nil
    var api = APIStruct()
    @State var boardTitle: String = "기본 값"
    var body: some View {
        VStack {
            

        }
        .onAppear {
            getBoard { isComplete in
                if let title = board?.title {
                    boardTitle = title
                }
            }
        }
    }
    func getBoard(completion: @escaping (Bool) -> Void) {
        let url = URL(string: "http://localhost:8080" + api.post + "/1")
        
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
                let response = try decoder.decode(Board.self, from: data)
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

struct BoardModel_Previews: PreviewProvider {
    static var previews: some View {
        BoardModel()
    }
}
