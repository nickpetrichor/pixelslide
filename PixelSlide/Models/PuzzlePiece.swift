import Foundation
import SwiftUI

class PuzzlePiece: Identifiable, ObservableObject {
    let id: Int
    let correctPosition: Int
    @Published var currentPosition: Int
    let imageRect: CGRect
    
    var correctRow: Int { correctPosition / 3 }
    var correctColumn: Int { correctPosition % 3 }
    var currentRow: Int { currentPosition / 3 }
    var currentColumn: Int { currentPosition % 3 }
    
    var isInCorrectPosition: Bool {
        correctPosition == currentPosition
    }
    
    init(id: Int, correctPosition: Int, currentPosition: Int, imageRect: CGRect) {
        self.id = id
        self.correctPosition = correctPosition
        self.currentPosition = currentPosition
        self.imageRect = imageRect
    }
} 