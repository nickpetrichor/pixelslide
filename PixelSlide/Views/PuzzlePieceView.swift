import SwiftUI

struct PuzzlePieceView: View {
    @ObservedObject var piece: PuzzlePiece
    let pieceSize: CGSize
    let image: UIImage
    
    var body: some View {
        let scaledWidth = image.size.width / 3
        let scaledHeight = image.size.height / 4
        
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: scaledWidth * 3, height: scaledHeight * 4)
            .offset(
                x: -piece.imageRect.minX * image.size.width,
                y: -piece.imageRect.minY * image.size.height
            )
            .clipped()
            .frame(width: pieceSize.width, height: pieceSize.height)
            .background(Color.white)
            .border(Color.black, width: 0.5)
            .shadow(radius: 1)
    }
} 