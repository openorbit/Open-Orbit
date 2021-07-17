//
//  Battery.swift
//  Open Orbit
//
//  Created by Mattias Holm on 17/07/2021.
//

import Foundation
import Sim
class Battery : Model {
  var energyContent: Double = 0.0   // Joule
  var maxDischargeRate: Double = 0.0 // Watt
  var maxChargeRate: Double = 0.0     // Watt
  var currentLoad: Double = 0.0       // Watt
    
  override init(name: String) {
    super.init(name: name)
  }
};
class EnergySource : Model {
  var currentPower: Double = 0.0      // Watt
    
  override init(name: String) {
    super.init(name: name)
  }
}
class PowerBus : Model {
  var currentLoad: Double = 0.0
  var currentPower: Double = 0.0
  var batteries: [Battery] = [Battery]()
  var energySources: [EnergySource] = [EnergySource]()
    
  // overloadAction
  // requestPower
  // providePower

  override init(name: String) {
    super.init(name: name)
  }
}
