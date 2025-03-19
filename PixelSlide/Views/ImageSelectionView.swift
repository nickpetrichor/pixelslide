import SwiftUI

struct ImageSelectionView: View {
    let onImageSelected: (UIImage) -> Void
    @Environment(\.dismiss) private var dismiss
    
    private let columns = [
        GridItem(.adaptive(minimum: 150, maximum: 200), spacing: 16)
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(PuzzleImage.all) { puzzleImage in
                        if let image = puzzleImage.image {
                            Button {
                                onImageSelected(image)
                                dismiss()
                            } label: {
                                VStack {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(3/4, contentMode: .fill)
                                        .frame(width: 150, height: 200)
                                        .clipped()
                                        .cornerRadius(8)
                                        .shadow(radius: 2)
                                    
                                    Text(puzzleImage.name)
                                        .font(.caption)
                                        .foregroundColor(.primary)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Select Puzzle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
} 