import ARKit
import RealityKit
import SwiftUI
import Combine
struct ContentView: View {
    @StateObject private var cancellables = CancellableContainer()
    @State private var distance: String = ""
    @State private var buttonTouched = false
    @State private var showingAlert = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ARContainerView()
                    .ignoresSafeArea()
                
                VStack {
                    Spacer() // Push everything to the top
                    if distance != "" {
                        Text(distance)
                            .padding()
                            .accessibilityLabel("Distance between the 2 item is " + distance)
                            .background(RoundedRectangle(cornerRadius: 15.0).fill(Color("primaryColor").opacity(0.6)))
                            .clipShape(RoundedRectangle(cornerRadius: 15.0))
                            .font(.caption)
                            .bold()
                            .position(x: geometry.size.width / 2, y: geometry.size.height / 1.75)

                    }
                    Spacer() // Push the button to the bottom
                    
                    
                    Button("Place Item") {
                        if distance == "" {
                            NotificationCenter.default.post(name: Notification.Name("placeItemNotification"), object: nil)
                            UIAccessibility.post(notification: .announcement, argument: "Item Placed")
                            buttonTouched.toggle()
                        } else {
                            showingAlert = true
                        }
                    }
                    .alert("Cannot put more than two item", isPresented: $showingAlert) {
                               Button("OK", role: .cancel) { }
                           }
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .bold()
                    .accessibilityHint("Place the item in the middle of the screen")
                    .sensoryFeedback(.success, trigger: buttonTouched)
                    .sensoryFeedback(.error, trigger: showingAlert)
                    .buttonStyle(GrowingButton())
                }
                
                Circle()
                    .fill(.primary)
                    .scaleEffect(0.02) // Adjust the scale as needed
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    .accessibilityHint("Place 2 item in different area to calculate the distance in between by clicking button place item")
                
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
            .background(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/).fill(Color("primaryColor").opacity(0.6)))
            .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/))
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
