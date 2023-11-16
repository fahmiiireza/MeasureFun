//
//  ARManager.swift
//  MeasureFun
//
//  Created by Fahmi Fahreza on 16/11/23.
//

import Combine

class ARManager {
    static let shared = ARManager()
    private init() { }
    
    var actionStream = PassthroughSubject<ARAction, Never>()
}
