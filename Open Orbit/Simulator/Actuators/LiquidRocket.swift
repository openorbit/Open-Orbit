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

    //let scene = SCNScene(named: "art.scnassets/rocket-plume.scn")!
    //for node in scene.rootNode.childNodes {
    //  addObjectToScene(object: node)
    //}
    //object.name = name
    //object.orientation = SCNQuaternion(x: dir.x, y: dir.y, z: dir.z, w: 0.0)
  }

  func step(dt: Double) {
    
  }

  override func connect() {
    let parent = sim.resolver.resolve(relative: "../", source: self) as! Stage
    object = parent.object.childNode(withName: name, recursively: false)!
    super.connect()
  }

  override func toggle() {
    object.isHidden = !object.isHidden
  }
}

