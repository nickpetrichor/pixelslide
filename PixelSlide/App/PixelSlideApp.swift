import SwiftUI

@main
struct PixelSlideApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            PuzzleGameView()
        }
    }
} 