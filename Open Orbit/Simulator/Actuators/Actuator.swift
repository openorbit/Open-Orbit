//
//  ActuatorGroup.swift
//  Open Orbit
//
//  Created by Mattias Holm on 17/07/2021.
//

import Foundation
import Sim
import SceneKit

enum DefaultActuatorGroups : Int {
    case SIM_ACT_ORBITAL = 0
    case SIM_ACT_VERTICAL = 1
    case SIM_ACT_HORISONTAL = 2
    case SIM_ACT_FORWARD = 3
    case SIM_ACT_PITCH = 4
    case SIM_ACT_ROLL = 5
    case SIM_ACT_YAW = 6
};
enum EngineKind {
    case SIM_THRUSTER
    case SIM_PROP
    case SIM_TURBO_PROP
    case SIM_JET
    case SIM_LIQUID_ROCKET
    case SIM_SOLID_ROCKET
}

enum EngineState : Int {
    case SIM_DISARMED = 0x00
    case SIM_ARMED = 0x01
    case SIM_BURNING = 0x82
    case SIM_LOCKED_BURNING = 0x83
    case SIM_LOCKED_CLOSED = 0x04
    case SIM_FAULT_CLOSED = 0x05
    case SIM_FAULT_BURNING = 0x86
}

let SIM_ENGINE_BURNING_BIT :Int = 0x80

enum GrainKind {
    case SIM_CIRCULAR
    case SIM_END_BURNER
    case SIM_C_SLOT
    case SIM_MOON_BURNER
    case SIM_FINOCYL
}


// Actuators all have position and direction states
class Actuator : Model {
  var stage: Stage! = nil
  var pos: SIMD3<Double>
  var dir: SIMD3<Double>

  var scene: SCNScene
  var object: SCNNode {
    didSet {
      let t = SIMD3<Float>(Float(pos.x), Float(pos.y), Float(pos.z))
      object.simdLocalTranslate(by: t)
    }
  }

  init(name: String, at pos: SIMD3<Double>, dir: SIMD3<Double>) {
    self.pos = pos
    self.dir = dir
    scene = SCNScene()
    object = scene.rootNode
    super.init(name: name)
  }

  func addObjectToScene(object: SCNNode) {
    scene.rootNode.addChildNode(object)
  }
}

class ActuatorGroup : Model {
  var actuators: [Actuator] = [Actuator]()
  init(withName name: String) {
    super.init(name: name)
  }
}
