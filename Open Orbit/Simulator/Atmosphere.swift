//
//  Atmosphere.swift
//  Open Orbit
//
//  Created by Mattias Holm on 2023-03-18.
//

import Foundation

protocol Atmosphere {
  func pressure(at pos: SIMD3<Double>) -> Double
  func temperature(at pos: SIMD3<Double>) -> Double
}
