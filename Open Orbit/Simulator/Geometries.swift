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
  xAxis.name = "x-axis"
  xAxis.geometry?.firstMaterial?.diffuse.contents = NSColor.red
  xAxis.localTranslate(by: SCNVector3(x: 2.5, y: 0, z: 0))
  xAxis.eulerAngles = SCNVector3(x: 90 * .pi / 180.0, y: 90 * .pi / 180.0, z: 0)

  let xLabel = SCNNode(geometry: SCNText(string: "X", extrusionDepth: 0.1))
  xLabel.localTranslate(by: SCNVector3(x: -0.25, y: 3, z: 0))
  xLabel.constraints = [SCNBillboardConstraint()]
  xLabel.geometry?.firstMaterial?.diffuse.contents = NSColor.red
  xLabel.scale = SCNVector3(0.025, 0.025, 0.025)

  xAxis.addChildNode(xLabel)
  axises.addChildNode(xAxis)

  let yAxis = SCNNode(geometry: SCNCylinder(radius: 0.1, height: 5.0))
  yAxis.name = "y-axis"
  yAxis.geometry?.firstMaterial?.diffuse.contents = NSColor.green
  yAxis.localTranslate(by: SCNVector3(x: 0, y: 2.5, z: 0))
  yAxis.eulerAngles = SCNVector3(x: 0, y: 0, z: 0)

  let yLabel = SCNNode(geometry: SCNText(string: "Y", extrusionDepth: 0.1))
  yLabel.localTranslate(by: SCNVector3(x: -0.25, y: 3, z: 0))
  yLabel.constraints = [SCNBillboardConstraint()]
  yLabel.geometry?.firstMaterial?.diffuse.contents = NSColor.green
  yLabel.scale = SCNVector3(0.025, 0.025, 0.025)

  yAxis.addChildNode(yLabel)
  axises.addChildNode(yAxis)

  let zAxis = SCNNode(geometry: SCNCylinder(radius: 0.1, height: 5.0))
  zAxis.name = "z-axis"
  zAxis.geometry?.firstMaterial?.diffuse.contents = NSColor.blue
  zAxis.localTranslate(by: SCNVector3(x: 0, y: 0, z: 2.5))
  zAxis.eulerAngles = SCNVector3(x:  90 * .pi / 180.0, y: 0, z: 0)

  let zLabel = SCNNode(geometry: SCNText(string: "Z", extrusionDepth: 0.1))
  zLabel.localTranslate(by: SCNVector3(x: -0.25, y: 3, z: 0))
  zLabel.constraints = [SCNBillboardConstraint()]
  zLabel.geometry?.firstMaterial?.diffuse.contents = NSColor.blue
  zLabel.scale = SCNVector3(0.025, 0.025, 0.025)

  zAxis.addChildNode(zLabel)

  axises.addChildNode(zAxis)

  let origin = SCNNode(geometry: SCNSphere(radius: 0.2))
  origin.name = "origin"
  origin.geometry?.firstMaterial?.diffuse.contents = NSColor.cyan
  axises.addChildNode(origin)
  axises.name = "axises"

  return axises
}
