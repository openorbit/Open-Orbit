//
//  JetEngine.swift
//  Open Orbit
//
//  Created by Mattias Holm on 2022-12-11.
//

import Foundation
import Sim
import SceneKit

class JetEngine : Actuator, Steppable {
  var fuelTanks: [PropellantTank] = [PropellantTank]()
  override init(name: String, at pos: SIMD3<Double>, dir: SIMD3<Double>) {
    super.init(name: name, at:pos, dir: dir)

    let scene = SCNScene(named: "art.scnassets/rocket-plume.scn")!
    for node in scene.rootNode.childNodes {
      addObjectToScene(object: node)
    }
    object.name = "plume"
    object.localRotate(by: SCNQuaternion(x: dir.x, y: dir.y, z: dir.z, w: 0.0))
  }

  func step(dt: Double) {
  }
}
