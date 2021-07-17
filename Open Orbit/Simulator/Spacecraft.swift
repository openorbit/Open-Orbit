//
//  Spacecraft.swift
//  Open Orbit
//
//  Created by Mattias Holm on 17/07/2021.
//

import Foundation
import SceneKit
import Sim

struct Axises {
    var yaw: Double
    var pitch: Double
    var roll: Double
    var lateral: Double
    var vertical: Double
    var fwd: Double
    var orbital: Double
    var throttle: Double
}

enum StageState {
    case SIM_STAGE_IDLE
    case SIM_STAGE_DETATCHED
    case SIM_STAGE_ENABLED
}

class Stage : Model {
  //var sc: Spacecraft;
  var scene: SCNScene

  var object: SCNNode {
    didSet {
      let t = SIMD3<Float>(Float(pos.x), Float(pos.y), Float(pos.z))
      object.simdLocalTranslate(by: t)
    }
  }

  var pos: SIMD3<Double>
  var expendedMass: Double = 0.0
  var state: StageState = .SIM_STAGE_IDLE
  var body: SCNPhysicsBody
  var emptyMass: Double = 0.0
  var mass: Double = 0.0

  //pl_object_t *obj; // Mass and inertia tensor of stage, unit is kg
  //  obj_array_t actuators;
    
  var engines: [Actuator] = [Actuator]()
  var actuatorGroups: [ActuatorGroup] = [ActuatorGroup]()
  var payload: [Payload] = [Payload]()
  var propellantTanks: [PropellantTank] = [PropellantTank]()
  //sg_object_t *sgobj;
    
  init(name: String, at pos:SIMD3<Double>) {
    self.pos = pos
    self.body = SCNPhysicsBody()
    self.scene = SCNScene()
    self.object = self.scene.rootNode
    super.init(name: name)
  }

  override func connect() {
    for actuator in engines {
      addObjectToScene(object: actuator.object)
    }
  }

  func addObjectToScene(object: SCNNode) {
    scene.rootNode.addChildNode(object)
  }

  func printNode(node: SCNNode, indent: Int) {
    for _ in 0 ..< indent {
      print(" ", terminator: "")
    }

    let nodeType = type(of: node)
    let typeString = String(describing: nodeType)
    if let name = node.name {
      print("node name: \(name) : \(typeString)")
    } else {
      print("node: \(typeString)")
    }
    for n in node.childNodes {
      printNode(node: n, indent: indent + 2)
    }
  }
  func printScene() {
    let nodeType = type(of: scene.rootNode)
    let typeString = String(describing: nodeType)

    if let name = scene.rootNode.name {
      print("root name: \(name) : \(nodeType)")
    } else {
      print("root : \(nodeType)")
    }

    for node in scene.rootNode.childNodes {
      printNode(node: node, indent: 2)
    }
  }

}

class Spacecraft : Model {
  var stages: [Stage] = []

  override init(name: String) {
    super.init(name: name)
  }

  func detatch() {

  }

  func fire() {

  }

  func toggleEngine() {
  }
}

