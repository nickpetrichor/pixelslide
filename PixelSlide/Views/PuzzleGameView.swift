import SwiftUI

struct PuzzleGameView: View {
    @StateObject private var viewModel = PuzzleViewModel()
    @State private var showingImagePicker = false
    @State private var showingCompletionAlert = false
    @State private var draggedPiece: PuzzlePiece?
    
    private let gridSize: (width: CGFloat, height: CGFloat) = {
        let width: CGFloat = min(UIScreen.main.bounds.width - 32, 400) // Max width of 400
        let height = width * (4/3)
        return (width: width, height: height)
    }()
    
    private var pieceSize: CGSize {
        CGSize(
            width: gridSize.width / CGFloat(viewModel.columns),
            height: gridSize.height / CGFloat(viewModel.rows)
        )
    }
    
    private func position(for piece: PuzzlePiece) -> CGPoint {
        let row = piece.currentPosition / viewModel.columns
        let col = piece.currentPosition % viewModel.columns
        return CGPoint(
            x: CGFloat(col) * pieceSize.width + pieceSize.width/2,
            y: CGFloat(row) * pieceSize.height + pieceSize.height/2
        )
    }
    
    var body: some View {
        VStack(spacing: 20) {
            if viewModel.processedImage == nil {
                // Initial state - show image picker button
                Button {
                    showingImagePicker = true
                } label: {
                    VStack {
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.largeTitle)
                        Text("Select Image")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            } else if let image = viewModel.processedImage {
                // Game state - show puzzle grid
                ZStack {
                    // Background grid
                    VStack(spacing: 0) {
                        ForEach(0..<viewModel.rows, id: \.self) { row in
                            HStack(spacing: 0) {
                                ForEach(0..<viewModel.columns, id: \.self) { column in
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.05))
                                        .frame(width: pieceSize.width, height: pieceSize.height)
                                        .border(Color.gray.opacity(0.2), width: 0.5)
                                }
                            }
                        }
                    }
                    
                    // Puzzle pieces
                    ForEach(viewModel.pieces) { piece in
                        PuzzlePieceView(piece: piece, pieceSize: pieceSize, image: image)
                            .position(position(for: piece))
                            .animation(.spring(dampingFraction: 0.7), value: piece.currentPosition)
                            .zIndex(draggedPiece?.id == piece.id ? 1 : 0)
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        draggedPiece = piece
                                        viewModel.pieceMoved(piece, to: gesture.location)
                                    }
                                    .onEnded { _ in
                                        viewModel.pieceDropped(piece)
                                        draggedPiece = nil
                                    }
                            )
                    }
                }
                .frame(width: gridSize.width, height: gridSize.height)
                .border(Color.gray, width: 1)
                .padding(.vertical, 20)
                
                // Controls
                HStack(spacing: 20) {
                    Button {
                        showingImagePicker = true
                    } label: {
                        Label("New Image", systemImage: "photo.on.rectangle.angled")
                    }
                    .buttonStyle(.bordered)
                    
                    Spacer()
                    
                    Button {
                        withAnimation {
                            viewModel.shufflePieces()
                        }
                    } label: {
                        Label("Shuffle", systemImage: "shuffle")
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.horizontal)
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImageSelectionView { selectedImage in
                viewModel.setImage(selectedImage)
            }
        }
        .alert("Puzzle Completed!", isPresented: $showingCompletionAlert) {
            Button("Play Again") {
                withAnimation {
                    viewModel.shufflePieces()
                }
            }
            Button("New Image") {
                showingImagePicker = true
            }
        } message: {
            Text("Congratulations! Would you like to play again or try a different image?")
        }
        .onChange(of: viewModel.isComplete) { oldValue, newValue in
            if newValue {
                showingCompletionAlert = true
            }
        }
    }
}