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
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
    }
    
    dynamic required init?(coder decoder: NSCoder) {
        fatalError("Dynamic init coder has not been implemented")
    }
    
    convenience init() {
        self.init(frame: UIScreen.main.bounds)
    }
    
    @objc func handleButtonTap() {
        placeItem()
    }
    
    func placeItem() {
        let item = try? Entity.load(named: "snowman")
        
        let anchor = AnchorEntity(plane: .horizontal)
        anchor.addChild(item!)
        scene.addAnchor(anchor)
        
//        calculate distance from the first item to the second
        if scene.anchors.count == 2 {
            let distance = simd_precise_distance(scene.anchors[0].position, scene.anchors[1].position)
            ARManager.shared.actionStream.send(.showDistance(distance: String(format: "%.2f", distance * 100.0) + " cm"))
//            distanceLabel = Text("Distance: \(String(format: "%.2f", distance)) meters")

        }
    }
}
