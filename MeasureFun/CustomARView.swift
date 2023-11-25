//
//  CustomARView.swift
//  MeasureFun
//
//  Created by Fahmi Fahreza on 13/11/23.
//
//
import ARKit
import RealityKit
import SwiftUI
import Combine

class CustomARView: ARView {
    // Required initializer for creating an instance programmatically
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
    }
    
    // Required initializer for creating an instance from a storyboard or a nib file
    dynamic required init?(coder decoder: NSCoder) {
        fatalError("Dynamic init coder has not been implemented")
    }
    
    // Convenience initializer for creating an instance with the main screen bounds
    convenience init() {
        self.init(frame: UIScreen.main.bounds)
    }
    
    // Function to handle button tap
    @objc func handleButtonTap() {
        placeItem()
    }
    
    // Function to place a 3D item in the AR scene
    func placeItem() {
        // Load the 3D item (snowman) from the "snowman" asset
        guard let item = try? Entity.load(named: "snowman") else {
            return
        }
        
        // Create an anchor entity for the item and place it on a horizontal plane
        let anchor = AnchorEntity(plane: .horizontal)
        anchor.addChild(item)
        scene.addAnchor(anchor)
        
        // Calculate distance from the first item to the second
        if scene.anchors.count == 2 {
            let distance = simd_precise_distance(scene.anchors[0].position, scene.anchors[1].position)
            
            // Send the calculated distance to the ARManager through the action stream
            ARManager.shared.actionStream.send(.showDistance(distance: String(format: "%.2f", distance * 100.0) + " cm"))
        }
    }
}

