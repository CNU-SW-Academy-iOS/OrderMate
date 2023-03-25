import SwiftUI
// 사용하지 않는 구조체 같음
struct ListView: View {
    var currentRoom: Board
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            Text(currentRoom.title)
                .font(.headline)
                .foregroundColor(Color.accentColor)
            Text(currentRoom.location)
                .font(.subheadline)
                .foregroundColor(Color.accentColor)
            Text("\(currentRoom.date.description)")
                .foregroundColor(Color.accentColor)
        }
        .padding()
        .foregroundColor(Color.white)
        .cornerRadius(10)
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        let room = Board(id: UUID().uuidString, title: "아아아아 배고프아아다아아", location: "충남대학교 어딘가", date: Date(), maxUser: 3)
        ListView(currentRoom: room)
    }
}
