import ARKit
import RealityKit
import SwiftUI
import Combine

struct ContentView: View {
    // State variables for managing UI and AR interactions
    @StateObject private var cancellables = CancellableContainer()
    @State private var distance: String = ""
    @State private var buttonTouched = false
    @State private var showingAlert = false

    var body: some View {
        // Use GeometryReader to get the size of the screen
        GeometryReader { geometry in
            // ZStack for layering ARContainerView and UI components
            ZStack {
                // ARContainerView for handling AR-related functionalities
                ARContainerView()
                    .ignoresSafeArea()

                // VStack for placing UI components vertically
                VStack {
                    Spacer() // Push everything to the top

                    // Display the distance if available
                    if distance != "" {
                        Text(distance)
                            .padding()
                            .accessibilityLabel("Distance between the 2 items is " + distance)
                            .background(RoundedRectangle(cornerRadius: 15.0).fill(Color("primaryColor").opacity(0.6)))
                            .clipShape(RoundedRectangle(cornerRadius: 15.0))
                            .font(.caption)
                            .bold()
                            .position(x: geometry.size.width / 2, y: geometry.size.height / 1.75)
                    }

                    Spacer() // Push the button to the bottom

                    // Button for placing AR items
                    Button("Place Item") {
                        if distance == "" {
                            // Notify ARManager to place an item
                            NotificationCenter.default.post(name: Notification.Name("placeItemNotification"), object: nil)
                            // Use VoiceOver to announce item placement
                            UIAccessibility.post(notification: .announcement, argument: "Item Placed")
                            buttonTouched.toggle()
                        } else {
                            // Show an alert if trying to place more than two items
                            showingAlert = true
                        }
                    }
                    .alert("Cannot put more than two items", isPresented: $showingAlert) {
                        Button("OK", role: .cancel) { }
                    }
                    .font(.title)
                    .bold()
                    .accessibilityHint("Place the item in the middle of the screen")
                    .sensoryFeedback(.success, trigger: buttonTouched)
                    .sensoryFeedback(.error, trigger: showingAlert)
                    .buttonStyle(GrowingButton())
                }

                // Indicator circle for guiding user actions
                Circle()
                    .fill(.primary)
                    .scaleEffect(0.02) // Adjust the scale as needed
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    .accessibilityHint("Place 2 items in different areas to calculate the distance between them by clicking the 'Place Item' button")
            }
            .onAppear {
                // Subscribe to the AR action stream
                subscribeToActionStream()
            }
        }
    }

    // Function to subscribe to the AR action stream
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

// ObservableObject for managing cancellables
class CancellableContainer: ObservableObject {
    @Published var set: Set<AnyCancellable> = []
}

// ButtonStyle for creating a growing button effect
struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(RoundedRectangle(cornerRadius: 25.0).fill(Color("primaryColor").opacity(0.6)))
            .clipShape(RoundedRectangle(cornerRadius: 25.0))
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
