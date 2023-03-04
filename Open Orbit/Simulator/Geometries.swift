//
//  Geometries.swift
//  Open Orbit
//
//  Created by Mattias Holm on 2023-03-04.
//

import SceneKit

func createAxisNode() -> SCNNode {
  let axises = SCNNode()
  let xAxis = SCNNode(geometry: SCNCylinder(radius: 0.1, height: 5.0))
  let yAxis = SCNNode(geometry: SCNCylinder(radius: 0.1, height: 5.0))
  let zAxis = SCNNode(geometry: SCNCylinder(radius: 0.1, height: 5.0))
  xAxis.geometry?.firstMaterial?.diffuse.contents = NSColor.red
  yAxis.geometry?.firstMaterial?.diffuse.contents = NSColor.green
  zAxis.geometry?.firstMaterial?.diffuse.contents = NSColor.blue

  xAxis.localTranslate(by: SCNVector3(x: 2.5, y: 0, z: 0))
  yAxis.localTranslate(by: SCNVector3(x: 0, y: 2.5, z: 0))
  zAxis.localTranslate(by: SCNVector3(x: 0, y: 0, z: 2.5))
  xAxis.eulerAngles = SCNVector3(x: 90 * .pi / 180.0, y: 90 * .pi / 180.0, z: 0)
  yAxis.eulerAngles = SCNVector3(x: 0, y: 0, z: 0)
  zAxis.eulerAngles = SCNVector3(x:  90 * .pi / 180.0, y: 0, z: 0)

  let centerSphere = SCNNode(geometry: SCNSphere(radius: 0.2))
  centerSphere.geometry?.firstMaterial?.diffuse.contents = NSColor.cyan
  axises.addChildNode(xAxis)
  axises.addChildNode(yAxis)
  axises.addChildNode(zAxis)
  axises.addChildNode(centerSphere)
  return axises
}
