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

  var object: SCNNode {
    didSet {
      let t = SIMD3<Float>(Float(pos.x), Float(pos.y), Float(pos.z))
      object.simdPosition = t
    }
  }

  var pos: SIMD3<Double> {
    didSet {
      let t = SIMD3<Float>(Float(pos.x), Float(pos.y), Float(pos.z))
      object.simdPosition = t
    }
  }

  var expendedMass: Double = 0.0
  var state: StageState = .SIM_STAGE_IDLE
  var body: SCNPhysicsBody {
    didSet {
      object.physicsBody = body
    }
  }
  var emptyMass: Double = 0.0
  var mass: Double = 0.0 {
    didSet {
      body.mass = mass
    }
  }

  //pl_object_t *obj; // Mass and inertia tensor of stage, unit is kg
  //  obj_array_t actuators;
    
  var engines: [Actuator] = []
  var pitchThrusters: [Actuator] = []
  var rollThrusters: [Actuator] = []
  var yawThrusters: [Actuator] = []
  var actuatorGroups: [ActuatorGroup] = []
  var payload: [Payload] = []
  var propellantTanks: [PropellantTank] = []
  //sg_object_t *sgobj;
    
  init(name: String, at pos:SIMD3<Double>) {
    self.pos = pos
    self.body = SCNPhysicsBody()
    self.object = SCNNode()
    self.object.name = name
    let posf = SIMD3<Float>(x: Float(pos.x),
                            y: Float(pos.y),
                            z: Float(pos.z))
    self.object.simdPosition = posf
    super.init(name: name)
  }

  override func connect() {
    for actuator in engines {
      addObjectToScene(object: actuator.object)
    }

    for actuator in pitchThrusters {
      addObjectToScene(object: actuator.object)
    }
    for actuator in yawThrusters {
      addObjectToScene(object: actuator.object)
    }
    for actuator in rollThrusters {
      addObjectToScene(object: actuator.object)
    }

    addObjectToScene(object: createAxisNode())
  }

  func addObjectToScene(object: SCNNode) {
    self.object.addChildNode(object)
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
    let nodeType = type(of: object)
    let typeString = String(describing: nodeType)

    if let name = object.name {
      print("root name: \(name) : \(typeString)")
    } else {
      print("root : \(nodeType)")
    }

    for node in object.childNodes {
      printNode(node: node, indent: 2)
    }
  }
}

class Spacecraft : Model {
  var stages: [Stage] = []
  var stageJoints: [SCNPhysicsSliderJoint] = []
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

