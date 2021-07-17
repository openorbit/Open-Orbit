//
//  Planet.swift
//  Open Orbit
//
//  Created by Mattias Holm on 2022-12-11.
//

import Foundation

protocol Planet {
  var referencFrame: Frame { get set }
  func getPosition(jd: Double) -> SIMD3<Double>
  func getVelocity(jd: Double) -> SIMD3<Double>
  func getRotation(jd: Double) -> SIMD4<Double>
  func getPressure(jd: Double, pos: SIMD3<Double>) -> Double;
  func getMagneticField(jd: Double, pos: SIMD3<Double>) -> SIMD3<Double>;
}
