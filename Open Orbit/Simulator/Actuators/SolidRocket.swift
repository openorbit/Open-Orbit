//
//  SolidRocket.swift
//  Open Orbit
//
//  Created by Mattias Holm on 2022-12-11.
//

import Foundation
import SceneKit

class SolidRocketEngine : Actuator, Steppable {
  var grain: GrainKind = .SIM_CIRCULAR
  var areaFunction: [Double] = [Double]()
  var state: EngineState = .SIM_DISARMED
  var throttle: Double = 0.0

  override init(name: String, at pos: SIMD3<Double>, dir: SIMD3<Double>) {
    super.init(name: name, at:pos, dir: dir)

    let scene = SCNScene(named: "art.scnassets/rocket-plume.scn")!
    for node in scene.rootNode.childNodes {
      addObjectToScene(object: node)
    }
    object.name = name
    object.localRotate(by: SCNQuaternion(x: dir.x, y: dir.y, z: dir.z, w: 0.0))
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
