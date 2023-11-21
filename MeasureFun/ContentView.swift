import ARKit
import RealityKit
import SwiftUI
import Combine
struct ContentView: View {
    @StateObject private var cancellables = CancellableContainer()
    @State private var distance: String = ""
    @State private var buttonTouched = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ARContainerView()
                    .ignoresSafeArea()
                
                VStack {
                    Spacer() // Push everything to the top
                    Text(distance)
                        .padding()
                        .background(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)).fill(distance != "" ? Color.white : .clear))
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
                        .font(.caption)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 1.75)
                    Spacer() // Push the button to the bottom
                    
                    
                    Button("Place Item") {
                        NotificationCenter.default.post(name: Notification.Name("placeItemNotification"), object: nil)
                    }
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .bold()
                    .accessibilityLabel("Place Item")
                    .sensoryFeedback(.success, trigger: buttonTouched)
                    .buttonStyle(GrowingButton())
                }
                
                Circle()
                    .fill(.primary)
                    .scaleEffect(0.02) // Adjust the scale as needed
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
                distance = newDistance
                
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


struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)).fill(Color.red))
            .clipShape(RoundedRectangle(cornerSize: /*@START_MENU_TOKEN@*/CGSize(width: 20, height: 10)/*@END_MENU_TOKEN@*/))
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
