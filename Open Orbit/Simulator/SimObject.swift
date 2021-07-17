//
//  SimObject.swift
//  Open Orbit
//
//  Created by Mattias Holm on 17/07/2021.
//

import Foundation
import Sim

class SimObject: Model {
    var fieldNames: Set<String> = Set<String>()

    init(withName name: String, andSimulator sim: Simulator) {
      super.init(name: name)
      publish(["name"])
    }

    func publish(_ fields: Set<String>) {
        fieldNames.formUnion(fields)
    }
    
    func getProperty(_ prop: String) -> Any? {
        if (fieldNames.contains(prop)) {
            let mirror = Mirror(reflecting: self)
            for child in mirror.children {
                if child.label == prop {
                    return child.value
                }
            }
        }
        return nil
    }
    func info() {
        let mirror = Mirror(reflecting: self)

        for child in mirror.children {
            print("Property name: \(String(describing: child.label))")
            print("Property value: \(child.value)")
        }
    }
}
