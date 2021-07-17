//
//  TurbopropEngine.swift
//  Open Orbit
//
//  Created by Mattias Holm on 2022-12-11.
//

import Foundation
class TurbopropEngine : Actuator, Steppable {
  var fuelTanks: [PropellantTank] = [PropellantTank]()
  override init(name: String, at pos: SIMD3<Double>, dir: SIMD3<Double>) {
      super.init(name: name, at: pos, dir: dir)
  }

  func step(dt: Double) {

  }
}
