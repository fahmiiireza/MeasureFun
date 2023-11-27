////
////  CustomARViewRepresentable.swift
////  MeasureFun
////
////  Created by Fahmi Fahreza on 13/11/23.
////
//
import SwiftUI
import RealityKit
import SwiftUI

struct ARVariables{
    static var arView: CustomARView!
}

struct ARContainerView: UIViewRepresentable {
    func makeUIView(context: Context) -> CustomARView {
//        let arView = CustomARView()

        ARVariables.arView = CustomARView()
        
        // Observe notification for button tap
        NotificationCenter.default.addObserver(ARVariables.arView!, selector: #selector(ARVariables.arView.handleButtonTap), name: Notification.Name("placeItemNotification"), object: nil)

        return ARVariables.arView
    }

    func updateUIView(_ uiView: CustomARView, context: Context) {
        // Update the view if needed
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }

    class Coordinator: NSObject {
        // No need for the handleTap function
    }
}
