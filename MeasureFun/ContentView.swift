import ARKit
import RealityKit
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            ARContainerView()
            
            Button("Place Item") {
                NotificationCenter.default.post(name: Notification.Name("placeItemNotification"), object: nil)
            }.accessibilityLabel("Place Item")
            .padding()
        }
    }
}
