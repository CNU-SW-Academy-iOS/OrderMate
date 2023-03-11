import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class RoomDataManager: ObservableObject {
    static var shared = RoomDataManager()
    private init() {
        getLists()
        getListTitle()
    }
    
    @Published var roomList: [Room] = []
    @Published var lastListID: String = ""
    @Published var listTitle: String = "Title"
    
    let db = Firestore.firestore()
    
    static let DB_LIST_KEY = "list"
    
    func getLists() {
        db.collection(RoomDataManager.DB_LIST_KEY).addSnapshotListener { querySnapshot, error in
            
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents \(String(describing: error))")
                return
            }
            
            self.roomList = documents.compactMap({ document -> Room? in
                do {
                    return try document.data(as: Room.self)
                } catch {
                    print("Error decoding document into Message:\(error)")
                    return nil
                }
            })
            self.roomList.sort { $0.date > $1.date }
            if let last = self.roomList.last {
                self.lastListID = last.id
            }
        }
    }
    
    func getListTitle() {
        if let key = UserDefaults.standard.string(forKey: RoomDataManager.DB_LIST_KEY) {
            listTitle = key
        }
        else {
            listTitle = "에러가 발생했습니다."
        }
        
    }
    
    func getList() -> [Room] {
        return roomList
    }
    
}
