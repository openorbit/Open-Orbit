//
//  LiquidRocket.swift
//  Open Orbit
//
//  Created by Mattias Holm on 2022-12-11.
//

import Foundation
import simd
import Sim
import SceneKit

class LiquidRocket : Actuator, Steppable {
  var state: EngineState = .SIM_DISARMED
  var throttle: Double = 0.0
  var maxThrust: SIMD3<Double>

  var oxidiserTanks: [PropellantTank] = [PropellantTank]()
  var propellantTanks: [PropellantTank] = [PropellantTank]()
  init(name: String, at pos: SIMD3<Double>, thrust: SIMD3<Double>) {
    maxThrust = thrust
    super.init(name: name, at:pos, dir: normalize(thrust))

    let scene = SCNScene(named: "art.scnassets/rocket-plume.scn")!
    for node in scene.rootNode.childNodes {
      addObjectToScene(object: node)
    }
    object.name = "plume"
  }

  func step(dt: Double) {
    
  }
}

