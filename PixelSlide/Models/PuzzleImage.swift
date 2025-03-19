import SwiftUI

struct PuzzleImage: Identifiable {
    let id: String
    let name: String
    let imageName: String
    
    var image: UIImage? {
        UIImage(named: imageName)
    }
}

// Extension to manage all available puzzle images
extension PuzzleImage {
    static let all: [PuzzleImage] = [
        PuzzleImage(id: "nature1", name: "Mountain Lake", imageName: "puzzle_nature1"),
        PuzzleImage(id: "nature2", name: "Forest Path", imageName: "puzzle_nature2"),
        PuzzleImage(id: "city1", name: "City Skyline", imageName: "puzzle_city1"),
        PuzzleImage(id: "abstract1", name: "Color Splash", imageName: "puzzle_abstract1")
    ]
} 