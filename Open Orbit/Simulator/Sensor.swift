//
//  Sensor.swift
//  Open Orbit
//
//  Created by Mattias Holm on 17/07/2021.
//

import Foundation
import Sim

class Sensor : SimObject {
    var stage: Stage? = nil
    var pos: SIMD3<Double>
    var dir: SIMD3<Double>
    
    init(withName name: String, andSimulator sim: Simulator, at pos: SIMD3<Double>) {
        self.pos = pos
        self.dir = SIMD3<Double>()
        super.init(withName: name, andSimulator: sim)
    }

}
