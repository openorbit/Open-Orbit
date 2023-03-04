//
//  Thruster.swift
//  Open Orbit
//
//  Created by Mattias Holm on 2022-12-11.
//

import Foundation
import SceneKit

class Thruster : Actuator, Steppable {
  var state: EngineState = .SIM_DISARMED
  var throttle: Double = 0.0
  var fMax: SIMD3<Double> = SIMD3<Double>(0.0, 0.0, 0.0)
  var tanks: [PropellantTank] = []
    
  override init(name: String, at pos: SIMD3<Double>, dir: SIMD3<Double>) {
    super.init(name: name, at:pos, dir: dir)

    let scene = SCNScene(named: "art.scnassets/thruster-plume.scn")!
    for node in scene.rootNode.childNodes {
      addObjectToScene(object: node)
    }
    object.name = "plume"
    object.localRotate(by: SCNQuaternion(x: dir.x, y: dir.y, z: dir.z, w: 0.0))
  }

  func step(dt: Double) {
    
  }
}
