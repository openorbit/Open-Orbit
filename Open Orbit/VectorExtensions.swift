//
//  VectorExtensions.swift
//  Open Orbit
//
//  Created by Mattias Holm on 15/08/2021.
//

import Foundation
import simd

infix operator ×
extension SIMD3 where Scalar : FloatingPoint {
    static func ×(lhs: SIMD3<Float>, rhs: SIMD3<Float>) -> SIMD3<Float> {
        return cross(lhs, rhs)
    }

    static func ×(lhs: SIMD3<Double>, rhs: SIMD3<Double>) -> SIMD3<Double> {
        return cross(lhs, rhs)
    }

    static func ×(lhs: SIMD3<Scalar>, rhs: SIMD3<Scalar>) -> SIMD3<Scalar> {
        let yzx = SIMD3<Int>(1,2,0)
        let zxy = SIMD3<Int>(2,0,1)
        let result = lhs[yzx] * rhs[zxy] - lhs[zxy] * rhs[yzx]
        return result
    }
}
