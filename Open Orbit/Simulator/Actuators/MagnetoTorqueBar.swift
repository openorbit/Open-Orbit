//
//  MagnetoTorqueBar.swift
//  Open Orbit
//
//  Created by Mattias Holm on 2022-12-11.
//

import Foundation
import Sim

class MagnetoTorqueBar : Actuator, Steppable {
  let n : Double = 0.0
  let A : SIMD3<Double> = SIMD3<Double>(repeating: 0.0)
  override init(name: String, at pos: SIMD3<Double>, dir: SIMD3<Double>) {
    super.init(name: name, at:pos, dir: dir)
  }

  func step(dt: Double) {
    let I = 0.0 // TODO: Take from input
    // m = nIA
    //  where n is turns on wire
    //      I is the current
    //      A is the vector area of the coil
    // tau = m x B
    //   where B is the magnetic field vector (of earth/planet)
    let m = n * I * A
    let B = SIMD3<Double>(repeating: 0.0)
    let tau = m × B
  }
}

