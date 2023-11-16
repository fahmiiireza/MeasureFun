import ARKit
import RealityKit
import SwiftUI
import Combine
struct ContentView: View {
    @StateObject private var cancellables = CancellableContainer()
    @State private var distance: String = ""

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ARContainerView()
//                    .ignoresSafeArea()

                VStack {
                    Spacer() // Push everything to the top
                    Text(distance)
                        .font(.largeTitle)
                        .padding()
                    Spacer() // Push the button to the bottom

                    
                    Button("Place Item") {
                        NotificationCenter.default.post(name: Notification.Name("placeItemNotification"), object: nil)
                    }
                    .accessibilityLabel("Place Item")
                    .padding()
                }
                
                Circle()
                    .fill(.primary)
                    .scaleEffect(0.03) // Adjust the scale as needed
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)

            }
            .onAppear {
                subscribeToActionStream()
            }
        }
    }

    func subscribeToActionStream() {
        ARManager.shared.actionStream.sink { action in
            switch action {
            case .showDistance(let newDistance):
                print("get the action stream")
                distance = newDistance
                print(newDistance)

            case .removeAllAnchors:
                distance = ""
            }
        }
        .store(in: &cancellables.set)
    }
}

class CancellableContainer: ObservableObject {
    @Published var set: Set<AnyCancellable> = []
}
