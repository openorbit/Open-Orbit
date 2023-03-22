//
//  Camera.swift
//  Open Orbit
//
//  Created by Mattias Holm on 2023-03-22.
//

import Foundation
import SceneKit

class Camera : SCNNode {
  var lat: Double = 0
  var lon: Double = 0
  var target: SCNNode?
  var _distance: Double = 0
  var distance: Double {
    set {
      _distance = newValue
      let x = distance * cos(lat) * cos(lon)
      let y = distance * cos(lat) * sin(lon)
      let z = distance * sin(lat)
      position = SCNVector3(x, y, z)
    }
    get {
      return _distance
    }
  }
  init(name: String)
  {
    super.init()
    self.name = name
    self.camera = SCNCamera()
    camera?.zFar = 100000e3
  }
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  func look(at node: SCNNode) {
    target = node
    constraints = [SCNLookAtConstraint(target: node)]

    let x = node.position.x + distance * cos(lat) * cos(lon)
    let y = node.position.y + distance * cos(lat) * sin(lon)
    let z = node.position.z + distance * sin(lat)
    position = SCNVector3(x, y, z)
  }

  func zoom(relative: Double) {
    distance += relative
  }

  func pan(relative: SIMD2<Double>) {
    lon = fmod(lon + relative.x, 2 * .pi)
    lat = fmod(lat + relative.y, .pi / 2)
    if lon < 0 {
      lon += 2 * .pi
    }
    if lat < -.pi/2 {
      lat += .pi
    }

    let x = target!.position.x + distance * cos(lat) * cos(lon)
    let y = target!.position.y + distance * cos(lat) * sin(lon)
    let z = target!.position.z + distance * sin(lat)

    position = SCNVector3(x, y, z)
  }
}
