import Foundation
import SwiftUI

struct BoardView2: View {
    @State var board: BoardStructModel? = nil
    @State var boardTitle: String = "기본 값"
    @State var model = BoardViewModel()
    var body: some View {
        VStack {
            

        }
        .onAppear {
            model.getBoard { isComplete in
                if let title = board?.title {
                    boardTitle = title
                }
            }
        }
    }
   
}

struct BoardView2_Previews: PreviewProvider {
    static var previews: some View {
        BoardView2()
    }
}
