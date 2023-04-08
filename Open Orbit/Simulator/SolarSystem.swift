//
//  Planet.swift
//  Open Orbit
//
//  Created by Mattias Holm on 2022-12-11.
//

import Foundation
import Sim
import CelMek

protocol PlanetProt {
  var referencFrame: Frame { get set }
  func getPosition(jd: Double) -> SIMD3<Double>
  func getVelocity(jd: Double) -> SIMD3<Double>
  func getRotation(jd: Double) -> SIMD4<Double>
  func getPressure(jd: Double, pos: SIMD3<Double>) -> Double;
  func getMagneticField(jd: Double, pos: SIMD3<Double>) -> SIMD3<Double>;
}

class CelestialBody : Model {
  @Output var position: SIMD3<Double> = SIMD3<Double>(0, 0, 0)
  @Output var velocity: SIMD3<Double> = SIMD3<Double>(0, 0, 0)
  @Output var rotation: SIMD4<Double> = SIMD4<Double>(0, 0, 1, 0)

  func pressure(at pos: SIMD3<Double>) -> Double
  {
    return 0.0
  }
  func magneticField(at pos: SIMD3<Double>) -> SIMD3<Double>
  {
    return SIMD3<Double>(0, 0, 0)
  }

  override init(name: String) {
    super.init(name: name)
  }
}

class VSOPCelestialBody : Model, Steppable {
  @Output var position: SIMD3<Double> = SIMD3<Double>(0, 0, 0)
  @Output var velocity: SIMD3<Double> = SIMD3<Double>(0, 0, 0)
  @Output var rotation: SIMD4<Double> = SIMD4<Double>(0, 0, 1, 0)

  let body: vsop87_body
  func pressure(at pos: SIMD3<Double>) -> Double
  {
    return 0.0
  }
  func magneticField(at pos: SIMD3<Double>) -> SIMD3<Double>
  {
    return SIMD3<Double>(0, 0, 0)
  }

  init(name: String, body: vsop87_body) {
    self.body = body
    super.init(name: name)
  }

  func step(dt: Double) {
    let simTime = sim.timeKeeper.simTime
    let jd = sim.timeKeeper.convertToJD(simTime: simTime)
    let (pos, vel, _, _) = body.position(jd: jd)

    position = pos
    velocity = vel
  }
}


class SolarSystem : Model, ClockedModel {
  override init(name: String) {
    super.init(name: name)
  }


  var frequency: Double = 1.0

  var period: Double {
    get {
      return 1.0/frequency
    }
    set {
      frequency = 1.0/newValue
    }
  }

  var planets : [VSOPCelestialBody] = []

  func tick(dt: Double) {
    let epochTime = sim.timeKeeper.epochTime
    let epochJD = sim.timeKeeper.convertToJD(epochTime: epochTime)
    //let clock = ContinuousClock()

    Task {
      let positions
      = await withTaskGroup(of: (SIMD3<Double>, SIMD3<Double>, Double, vsop87_body_id).self,
                            returning: [(SIMD3<Double>, SIMD3<Double>, Double, vsop87_body_id)].self) { group in

        for planet in planets {
          group.addTask() {
            return planet.body.position(jd: epochJD)
          }
        }

        var result: [(SIMD3<Double>, SIMD3<Double>, Double, vsop87_body_id)] = []
        for await pos in group {
          result.append(pos)
        }
        return result
      }

      for (p, v, _, bodyId) in positions {
        planets[bodyId.rawValue].position = p
        planets[bodyId.rawValue].velocity = v
      }
    }
  }
  override func connect() {
    planets.append(sim.resolver.resolve(relative: "Sun", source: self) as! VSOPCelestialBody)
    planets.append(sim.resolver.resolve(relative: "Mercury", source: self) as! VSOPCelestialBody)
    planets.append(sim.resolver.resolve(relative: "Venus", source: self) as! VSOPCelestialBody)
    planets.append(sim.resolver.resolve(relative: "Earth", source: self) as! VSOPCelestialBody)
    planets.append(sim.resolver.resolve(relative: "Mars", source: self) as! VSOPCelestialBody)
    planets.append(sim.resolver.resolve(relative: "Jupiter", source: self) as! VSOPCelestialBody)
    planets.append(sim.resolver.resolve(relative: "Saturn", source: self) as! VSOPCelestialBody)
    planets.append(sim.resolver.resolve(relative: "Uranus", source: self) as! VSOPCelestialBody)
    planets.append(sim.resolver.resolve(relative: "Neptune", source: self) as! VSOPCelestialBody)
  }
}

func createSolarSystem(sim: Simulator) -> SolarSystem {
  let solarSystem = SolarSystem(name: "SolarSystem")

  let sun = VSOPCelestialBody(name: "Sun", body: sun)
  let mercury = VSOPCelestialBody(name: "Mercury", body: mercury)
  let venus = VSOPCelestialBody(name: "Venus", body: venus)

  let earth = VSOPCelestialBody(name: "Earth", body: earth)
  try! earth.add(child: CelestialBody(name: "Moon"))

  let mars = VSOPCelestialBody(name: "Mars", body: mars)

  let jupiter = VSOPCelestialBody(name: "Jupiter", body: jupiter)
  try! jupiter.add(child: CelestialBody(name: "Ganymede"))
  try! jupiter.add(child: CelestialBody(name: "Europa"))
  try! jupiter.add(child: CelestialBody(name: "Io"))
  try! jupiter.add(child: CelestialBody(name: "Callisto"))

  let saturn = VSOPCelestialBody(name: "Saturn", body: saturn)
  try! saturn.add(child: CelestialBody(name: "S2009 S 1"))
  try! saturn.add(child: CelestialBody(name: "Pan"))
  try! saturn.add(child: CelestialBody(name: "Daphnis"))
  try! saturn.add(child: CelestialBody(name: "Atlas"))
  try! saturn.add(child: CelestialBody(name: "Prometheus"))
  try! saturn.add(child: CelestialBody(name: "Pandora"))
  try! saturn.add(child: CelestialBody(name: "Epimetheus"))
  try! saturn.add(child: CelestialBody(name: "Janus"))
  try! saturn.add(child: CelestialBody(name: "Aegaeon"))
  try! saturn.add(child: CelestialBody(name: "Mimas"))
  try! saturn.add(child: CelestialBody(name: "Methone"))
  try! saturn.add(child: CelestialBody(name: "Anthe"))
  try! saturn.add(child: CelestialBody(name: "Pallene"))
  try! saturn.add(child: CelestialBody(name: "Enceladus"))
  try! saturn.add(child: CelestialBody(name: "Tethys"))
  try! saturn.add(child: CelestialBody(name: "Telesto"))
  try! saturn.add(child: CelestialBody(name: "Calypso"))
  try! saturn.add(child: CelestialBody(name: "Dione"))
  try! saturn.add(child: CelestialBody(name: "Helene"))
  try! saturn.add(child: CelestialBody(name: "Polydeuces"))
  try! saturn.add(child: CelestialBody(name: "Rhea"))
  try! saturn.add(child: CelestialBody(name: "Titan"))
  try! saturn.add(child: CelestialBody(name: "Hyperion"))
  try! saturn.add(child: CelestialBody(name: "Iapetus"))
  try! saturn.add(child: CelestialBody(name: "S2019 S 1"))
  try! saturn.add(child: CelestialBody(name: "Kiviuq"))
  try! saturn.add(child: CelestialBody(name: "Ijiraq"))
  try! saturn.add(child: CelestialBody(name: "Phoebe"))
  try! saturn.add(child: CelestialBody(name: "Paaliaq"))
  try! saturn.add(child: CelestialBody(name: "Skathi"))
  try! saturn.add(child: CelestialBody(name: "S2007 S 2"))
  try! saturn.add(child: CelestialBody(name: "S2004 S 37"))
  try! saturn.add(child: CelestialBody(name: "Albiorix"))
  try! saturn.add(child: CelestialBody(name: "Bebhionn"))
  try! saturn.add(child: CelestialBody(name: "S2004 S 29"))
  try! saturn.add(child: CelestialBody(name: "S2004 S 31"))
  try! saturn.add(child: CelestialBody(name: "Erriapus"))
  try! saturn.add(child: CelestialBody(name: "Skoll"))
  try! saturn.add(child: CelestialBody(name: "Tarqeq"))
  try! saturn.add(child: CelestialBody(name: "Siarnaq"))
  try! saturn.add(child: CelestialBody(name: "Tarvos"))
  try! saturn.add(child: CelestialBody(name: "Hyrrokkin"))
  try! saturn.add(child: CelestialBody(name: "Greip"))
  try! saturn.add(child: CelestialBody(name: "S2004 S 13"))
  try! saturn.add(child: CelestialBody(name: "Mundilfari"))
  try! saturn.add(child: CelestialBody(name: "S2006 S 1"))
  try! saturn.add(child: CelestialBody(name: "Gridr"))
  try! saturn.add(child: CelestialBody(name: "Bergelmir"))
  try! saturn.add(child: CelestialBody(name: "Jarnsaxa"))
  try! saturn.add(child: CelestialBody(name: "Narvi"))
  try! saturn.add(child: CelestialBody(name: "Suttungr"))
  try! saturn.add(child: CelestialBody(name: "S2004 S 17"))
  try! saturn.add(child: CelestialBody(name: "S2007 S 3"))
  try! saturn.add(child: CelestialBody(name: "Hati"))
  try! saturn.add(child: CelestialBody(name: "S2004 S 12"))
  try! saturn.add(child: CelestialBody(name: "Eggther"))
  try! saturn.add(child: CelestialBody(name: "Farbauti"))
  try! saturn.add(child: CelestialBody(name: "Thrymr"))
  try! saturn.add(child: CelestialBody(name: "Bestla"))
  try! saturn.add(child: CelestialBody(name: "S2004 S 7"))
  try! saturn.add(child: CelestialBody(name: "Angrboda"))
  try! saturn.add(child: CelestialBody(name: "Aegir"))
  try! saturn.add(child: CelestialBody(name: "Beli"))
  try! saturn.add(child: CelestialBody(name: "Gerd"))
  try! saturn.add(child: CelestialBody(name: "Gunnlod"))
  try! saturn.add(child: CelestialBody(name: "S2006 S 3"))
  try! saturn.add(child: CelestialBody(name: "Skrymir"))
  try! saturn.add(child: CelestialBody(name: "S2004 S 28"))
  try! saturn.add(child: CelestialBody(name: "Alvaldi"))
  try! saturn.add(child: CelestialBody(name: "Kari"))
  try! saturn.add(child: CelestialBody(name: "Geirrod"))
  try! saturn.add(child: CelestialBody(name: "Fenrir"))
  try! saturn.add(child: CelestialBody(name: "Surtur"))
  try! saturn.add(child: CelestialBody(name: "Loge"))
  try! saturn.add(child: CelestialBody(name: "Ymir"))
  try! saturn.add(child: CelestialBody(name: "S2004 S 21"))
  try! saturn.add(child: CelestialBody(name: "S2004 S 39"))
  try! saturn.add(child: CelestialBody(name: "S2004 S 24"))
  try! saturn.add(child: CelestialBody(name: "S2004 S 36"))
  try! saturn.add(child: CelestialBody(name: "Thiazzi"))
  try! saturn.add(child: CelestialBody(name: "S2004 S 34"))
  try! saturn.add(child: CelestialBody(name: "Fornjot"))
  try! saturn.add(child: CelestialBody(name: "S2004 S 26"))

  let uranus = VSOPCelestialBody(name: "Uranus", body: uranus)
  try! uranus.add(child: CelestialBody(name: "Cordelia"))
  try! uranus.add(child: CelestialBody(name: "Ophelia"))
  try! uranus.add(child: CelestialBody(name: "Bianca"))
  try! uranus.add(child: CelestialBody(name: "Cressida"))
  try! uranus.add(child: CelestialBody(name: "Desdemona"))
  try! uranus.add(child: CelestialBody(name: "Juliet"))
  try! uranus.add(child: CelestialBody(name: "Portia"))
  try! uranus.add(child: CelestialBody(name: "Rosalind"))
  try! uranus.add(child: CelestialBody(name: "Cupid"))
  try! uranus.add(child: CelestialBody(name: "Belinda"))
  try! uranus.add(child: CelestialBody(name: "Perdita"))
  try! uranus.add(child: CelestialBody(name: "Puck"))
  try! uranus.add(child: CelestialBody(name: "Mab"))
  try! uranus.add(child: CelestialBody(name: "Miranda"))
  try! uranus.add(child: CelestialBody(name: "Ariel"))
  try! uranus.add(child: CelestialBody(name: "Umbriel"))
  try! uranus.add(child: CelestialBody(name: "Titania"))
  try! uranus.add(child: CelestialBody(name: "Oberon"))
  try! uranus.add(child: CelestialBody(name: "Francisco"))
  try! uranus.add(child: CelestialBody(name: "Caliban"))
  try! uranus.add(child: CelestialBody(name: "Stephano"))
  try! uranus.add(child: CelestialBody(name: "Trinculo"))
  try! uranus.add(child: CelestialBody(name: "Sycorax"))
  try! uranus.add(child: CelestialBody(name: "Margaret"))
  try! uranus.add(child: CelestialBody(name: "Prospero"))
  try! uranus.add(child: CelestialBody(name: "Setebos"))
  try! uranus.add(child: CelestialBody(name: "Ferdinand"))

  let neptune = VSOPCelestialBody(name: "Neptune", body: neptune)
  try! neptune.add(child: CelestialBody(name: "Naiad"))
  try! neptune.add(child: CelestialBody(name: "Thalassa"))
  try! neptune.add(child: CelestialBody(name: "Despina"))
  try! neptune.add(child: CelestialBody(name: "Galatea"))
  try! neptune.add(child: CelestialBody(name: "Larissa"))
  try! neptune.add(child: CelestialBody(name: "Hippocamp"))
  try! neptune.add(child: CelestialBody(name: "Proteus"))
  try! neptune.add(child: CelestialBody(name: "Triton"))
  try! neptune.add(child: CelestialBody(name: "Nereid"))
  try! neptune.add(child: CelestialBody(name: "Halimede"))
  try! neptune.add(child: CelestialBody(name: "Sao"))
  try! neptune.add(child: CelestialBody(name: "Laomedeia"))
  try! neptune.add(child: CelestialBody(name: "Psamathe"))
  try! neptune.add(child: CelestialBody(name: "Nesoo"))

  try! solarSystem.add(child: sun)
  try! solarSystem.add(child: mercury)
  try! solarSystem.add(child: venus)
  try! solarSystem.add(child: earth)
  try! solarSystem.add(child: mars)
  try! solarSystem.add(child: jupiter)
  try! solarSystem.add(child: saturn)
  try! solarSystem.add(child: uranus)
  try! solarSystem.add(child: neptune)

  return solarSystem
}
