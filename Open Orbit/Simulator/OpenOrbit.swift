//
//  Simulator.swift
//  Open Orbit
//
//  Created by Mattias Holm on 17/07/2021.
//

import Foundation
import SceneKit
import Sim

class OpenOrbit {
  var scene: SCNScene

  var time: Double = 2451544.50000 // 2000-01-01 00:00:00
  var sim = SimulatorImpl() as Simulator
  var stepSize: Double = 0.0
  var currentSpacecraft: Spacecraft?

  init() {
    scene = SCNScene()

    try! sim.add(model: Mercury(name: "Mercury"))
    sim.connect()

    currentSpacecraft = sim.getRootModel(name: "Mercury") as? Spacecraft

    for stage in currentSpacecraft!.stages {
      addObjectToScene(object: stage.object)
    }
    // create and add a camera to the scene
    let cameraNode = SCNNode()
    cameraNode.camera = SCNCamera()
    scene.rootNode.addChildNode(cameraNode)

    // place the camera
    cameraNode.position = SCNVector3(x: 0, y: 0, z: 30)

    // create and add a light to the scene
    let lightNode = SCNNode()
    lightNode.light = SCNLight()
    lightNode.light!.type = .omni
    lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
    scene.rootNode.addChildNode(lightNode)

    // create and add an ambient light to the scene
    let ambientLightNode = SCNNode()
    ambientLightNode.light = SCNLight()
    ambientLightNode.light!.type = .ambient
    ambientLightNode.light!.color = NSColor.darkGray
    scene.rootNode.addChildNode(ambientLightNode)


    scene.background.contents = [NSImage(imageLiteralResourceName:"eso0932a_nx"),
                                 NSImage(imageLiteralResourceName:"eso0932a_px"),
                                 NSImage(imageLiteralResourceName:"eso0932a_py"),
                                 NSImage(imageLiteralResourceName:"eso0932a_ny"),
                                 NSImage(imageLiteralResourceName:"eso0932a_nz"),
                                 NSImage(imageLiteralResourceName:"eso0932a_pz")]
    scene.physicsWorld.gravity = SCNVector3(x: 0, y: 0, z: 0)

    printScene()
  }

  func printNode(node: SCNNode, indent: Int) {
    for _ in 0 ..< indent {
      print(" ", terminator: "")
    }

    let nodeType = type(of: node)
    let typeString = String(describing: nodeType)
    let hasPhysics = node.physicsBody != nil
    let mass = node.physicsBody?.mass ?? 0.0
    if let name = node.name {
      print("node name: \(name) : \(typeString) (\(hasPhysics) \(mass) kg)")
    } else {
      print("node: \(typeString) (\(hasPhysics) \(mass) kg)")
    }
    for n in node.childNodes {
      printNode(node: n, indent: indent + 2)
    }
  }
  func printScene() {
    let nodeType = type(of: scene.rootNode)
    let typeString = String(describing: nodeType)

    let hasPhysics = scene.rootNode.physicsBody != nil
    let mass = scene.rootNode.physicsBody?.mass ?? 0.0

    if let name = scene.rootNode.name {
      print("root name: \(name) : \(typeString) (\(hasPhysics) \(mass) kg)")
    } else {
      print("root : \(nodeType) (\(hasPhysics) \(mass) kg)")
    }

    for node in scene.rootNode.childNodes {
      printNode(node: node, indent: 2)
    }
  }
  func addSceneToScene(scene scn: SCNScene, nodeName: String) {
    guard let node = scn.rootNode.childNode(withName: nodeName, recursively: true) else {
      return
    }
    scene.rootNode.addChildNode(node)
  }

  func addObjectToScene(object: SCNNode) {
    print("add \(String(describing: object.name)) \(object.position)")
    scene.rootNode.addChildNode(object)
  }

  func toggleICRFGrid() {
    print("toggle icrf grid")
  }

  func toggleEngine() {
    currentSpacecraft?.toggleEngine()
  }

  var lastRun : TimeInterval = TimeInterval.nan
  func advance(time: TimeInterval) {
    if !lastRun.isNaN {
      let delta = time - lastRun
      let nanos = Int(delta*1e9)
      sim.run(for: nanos)
    }
    lastRun = time
  }
}
