//
//  Earth.swift
//  Open Orbit
//
//  Created by Mattias Holm on 2023-03-08.
//

import Foundation

struct EarthAtmosphere: Atmosphere {
  // Very simplified model from:
  // https://www.grc.nasa.gov/www/k-12/airplane/atmosmet.html

  func temperature(h : Double) -> Double {
    if h < 11000 { // Troposphere
      let T = 15.04 - 0.00649 * h
      return T
    } else if h < 25000 { // Lower stratosphere
      let T = -56.46
      return T
    } else { // Upper stratosphere
      let T = -131.21 * 0.00299 * h
      return T
    }
  }
  func density(at pos: SIMD3<Double>) -> Double {
    let posSquared = (pos * pos)
    let distSquared = posSquared.x + posSquared.y + posSquared.z
    let hc = distSquared.squareRoot()
    let h = hc - 6371.0e3 // Distance from surface

    let T = temperature(h: h)

    if h < 11000 { // Troposphere
      let p = 101.29 * pow(((T + 273.1) / 288.08), 5.256)
      return p
    } else if h < 25000 { // Lower stratosphere
      let p = 22.65 * exp(1.73 - 0.000157 * h)
      return p
    } else { // Upper stratosphere
      let p = 2.488 * pow((T + 273.1)/216.6, -11.388)
      return p
    }
  }

  func pressure(at pos: SIMD3<Double>) -> Double {
    let p = density(at: pos)
    let T = temperature(at: pos)
    let pressure = p / (0.2869 * (T + 273.1))
    return pressure
  }
  func temperature(at pos: SIMD3<Double>) -> Double {
    let posSquared = (pos * pos)
    let distSquared = posSquared.x + posSquared.y + posSquared.z
    let hc = distSquared.squareRoot()
    let h = hc - 6371.0e3 // Distance from surface
    return temperature(h: h)
  }
}
