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
        let chair = try? Entity.load(named: "chair_swan")
        let anchor = AnchorEntity(plane: .horizontal)
        anchor.addChild(chair!)
        scene.addAnchor(anchor)
    }
}
