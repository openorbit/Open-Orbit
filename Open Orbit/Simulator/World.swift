//
//  World.swift
//  Open Orbit
//
//  Created by Mattias Holm on 2023-03-23.
//

import Foundation
import SceneKit
import Sim

func addMass(md: SCNPhysicsBody, ms: SCNPhysicsBody) {
  let recip = 1.0 / (md.mass + ms.mass)

  let a = SCNVector3(md.centerOfMassOffset.x * md.mass,
                     md.centerOfMassOffset.y * md.mass,
                     md.centerOfMassOffset.z * md.mass)
  let b = SCNVector3(ms.centerOfMassOffset.x * ms.mass,
                     ms.centerOfMassOffset.y * ms.mass,
                     ms.centerOfMassOffset.z * ms.mass)
  let c = SCNVector3(a.x + b.x, a.y + b.y, a.z + b.z)
  md.centerOfMassOffset = SCNVector3(c.x * recip, c.y * recip, c.z * recip)
  md.mass += ms.mass
  md.momentOfInertia.x += ms.momentOfInertia.x
  md.momentOfInertia.y += ms.momentOfInertia.y
  md.momentOfInertia.z += ms.momentOfInertia.z
}


class World : Model {
  var physicsWorld: SCNPhysicsWorld

  init(name: String, world: SCNPhysicsWorld) {
    physicsWorld = world
    super.init(name: name)
  }
}
