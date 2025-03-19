import SwiftUI

class PuzzleViewModel: ObservableObject {
    @Published private(set) var pieces: [PuzzlePiece] = []
    @Published private(set) var isComplete = false
    @Published var processedImage: UIImage?
    
    let rows = 4
    let columns = 3
    
    private var draggedPiece: PuzzlePiece?
    
    func setImage(_ image: UIImage) {
        self.processedImage = processImage(image)
        createPuzzlePieces()
        shufflePieces()
    }
    
    private func processImage(_ image: UIImage) -> UIImage {
        let targetAspectRatio: CGFloat = 3.0 / 4.0
        let currentAspectRatio = image.size.width / image.size.height
        
        var targetSize: CGSize
        if currentAspectRatio > targetAspectRatio {
            let targetWidth = image.size.height * targetAspectRatio
            targetSize = CGSize(width: targetWidth, height: image.size.height)
        } else {
            let targetHeight = image.size.width / targetAspectRatio
            targetSize = CGSize(width: image.size.width, height: targetHeight)
        }
        
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1.0
        
        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
        return renderer.image { context in
            let drawRect = CGRect(origin: .zero, size: targetSize)
            image.draw(in: drawRect)
        }
    }
    
    private func createPuzzlePieces() {
        guard let image = processedImage else { return }
        pieces.removeAll()
        
        let pieceWidth = 1.0 / CGFloat(columns)
        let pieceHeight = 1.0 / CGFloat(rows)
        
        for row in 0..<rows {
            for col in 0..<columns {
                let position = row * columns + col
                let piece = PuzzlePiece(
                    id: position,
                    correctPosition: position,
                    currentPosition: position,
                    imageRect: CGRect(
                        x: CGFloat(col) * pieceWidth,
                        y: CGFloat(row) * pieceHeight,
                        width: pieceWidth,
                        height: pieceHeight
                    )
                )
                pieces.append(piece)
            }
        }
    }
    
    func shufflePieces() {
        var positions = Array(0..<pieces.count)
        positions.shuffle()
        
        for (index, piece) in pieces.enumerated() {
            piece.currentPosition = positions[index]
        }
        
        checkCompletion()
        if isComplete {
            shufflePieces()
        }
    }
    
    func pieceMoved(_ piece: PuzzlePiece, to location: CGPoint) {
        guard let draggedPiece = pieces.first(where: { $0.id == piece.id }) else { return }
        
        let gridWidth = UIScreen.main.bounds.width - 32
        let gridHeight = gridWidth * 4/3
        let pieceWidth = gridWidth / CGFloat(columns)
        let pieceHeight = gridHeight / CGFloat(rows)
        
        let col = Int((location.x / pieceWidth).rounded())
        let row = Int((location.y / pieceHeight).rounded())
        
        let newPosition = max(0, min(row * columns + col, pieces.count - 1))
        draggedPiece.currentPosition = newPosition
    }
    
    func pieceDropped(_ piece: PuzzlePiece) {
        guard let draggedPiece = pieces.first(where: { $0.id == piece.id }) else { return }
        
        if let targetPiece = pieces.first(where: { $0.currentPosition == draggedPiece.currentPosition && $0.id != draggedPiece.id }) {
            let tempPosition = targetPiece.currentPosition
            targetPiece.currentPosition = piece.currentPosition
            draggedPiece.currentPosition = tempPosition
        }
        
        checkCompletion()
    }
    
    private func checkCompletion() {
        isComplete = pieces.allSatisfy { $0.isInCorrectPosition }
    }
} 