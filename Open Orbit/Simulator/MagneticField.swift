//
//  MagneticField.swift
//  Open Orbit
//
//  Created by Mattias Holm on 2023-03-18.
//

import Foundation

protocol Mangetosphere {
  func magneticField(at pos: SIMD3<Double>) -> SIMD3<Double>
}
