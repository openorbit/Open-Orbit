//
//  SolidRocket.swift
//  Open Orbit
//
//  Created by Mattias Holm on 2022-12-11.
//

import Foundation

class SolidRocketEngine : Actuator, Steppable {
  var grain: GrainKind = .SIM_CIRCULAR
  var areaFunction: [Double] = [Double]()
  var state: EngineState = .SIM_DISARMED
  var throttle: Double = 0.0

  override init(name: String, at pos: SIMD3<Double>, dir: SIMD3<Double>) {
    super.init(name: name, at:pos, dir: dir)
  }
    
  func step(dt: Double) {
        
  }
}
