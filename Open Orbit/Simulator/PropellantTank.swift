//
//  PropellantTank.swift
//  Open Orbit
//
//  Created by Mattias Holm on 17/07/2021.
//

import Foundation
import Sim

class PropellantTank : SimObject {
    var pressure: Double = 0.0
    var volume: Double = 0.0
    var temperature: Double = 0.0
    var molecularMass: Double = 0.0
    // openValve
    // enablePump
    
    override init(withName name: String, andSimulator sim: Simulator) {
        super.init(withName: name, andSimulator: sim)
    }

}
