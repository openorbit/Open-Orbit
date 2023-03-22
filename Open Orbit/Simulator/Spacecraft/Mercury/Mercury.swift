//
//  Mercury.swift
//  Open Orbit
//
//  Created by Mattias Holm on 17/07/2021.
//

import Foundation
import SceneKit

enum MercuryStages : Int {
  case MERC_REDSTONE
  case MERC_CAPSULE
}

enum Redstone_Actuators : Int {
  case THR_ROCKETDYNE
}

enum Capsule_Actuators : Int {
    case THR_POSI
    case THR_RETRO_0
    case THR_RETRO_1
    case THR_RETRO_2
    case THR_ROLL_0
    case THR_ROLL_1
    case THR_PITCH_0
    case THR_PITCH_1
    case THR_YAW_0
    case THR_YAW_1
}


enum DetachSequence : Int {
  case MERC_REDSTONE
  case MERC_CAPSULE
}

class CommandModule : Stage {
  var retro : [SolidRocketEngine] = []

  override init(name: String, at pos: SIMD3<Double>) {
    super.init(name: name, at: pos)

    let scene = SCNScene(named: "art.scnassets/mercury.scn")!
    for node in scene.rootNode.childNodes {
      addObjectToScene(object: node)
    }
    self.body = SCNPhysicsBody(type: SCNPhysicsBodyType.dynamic,
                          shape: SCNPhysicsShape(geometry: SCNCone(topRadius: 0.0,//0.6/2.0,
                                                                   bottomRadius: 1.8/2.0,
                                                                   height: 3.3)))
    self.body.isAffectedByGravity = true
    object.physicsBody = body
    mass = 1354.0

//    try! add(child: Thruster(name: "Posigrade",
//                             at: SIMD3<Double>(0.0,0.0,0.0),
//                             dir: SIMD3<Double>(0.0,0.0,-1.8e3)))

    // Ripple fire 10 s burntime each
    try! add(child: SolidRocketEngine(name: "Retro 0",
                                      at: SIMD3<Double>(0.0,0.0,0.0),
                                      dir: SIMD3<Double>(0.0,0.0,-1.0)))
    try! add(child: SolidRocketEngine(name: "Retro 1",
                                      at: SIMD3<Double>(0.0,0.0,0.0),
                                      dir: SIMD3<Double>(0.0,0.0,-1.0)))
    try! add(child: SolidRocketEngine(name: "Retro 2",
                                      at: SIMD3<Double>(0.0,0.0,0.0),
                                      dir: SIMD3<Double>(0.0,0.0,-1.0)))

    try! add(child: Thruster(name: "Roll 0",
                             at: SIMD3<Double>(0.82, 0.55, 0.00),
                             dir: SIMD3<Double>(0.0, 0.0, 108.0)))
    try! add(child: Thruster(name: "Roll 1",
                             at: SIMD3<Double>(-0.82, 0.55, 0.00),
                             dir: SIMD3<Double>(0.0, 0.0, 108.0)))
    try! add(child: Thruster(name: "Pitch 0",
                             at: SIMD3<Double>(0.00, 2.20, 0.41),
                             dir: SIMD3<Double>(0.0, 0.0, -108.0)))
    try! add(child: Thruster(name: "Pitch 1",
                             at: SIMD3<Double>(00, 2.20, -0.41),
                             dir: SIMD3<Double>(0.0, 0.0, 108.0)))
    try! add(child: Thruster(name: "Yaw 0",
                             at: SIMD3<Double>(0.41, 2.20, 0.00),
                             dir: SIMD3<Double>(-108.0, 0.0, 0.0)))
    try! add(child: Thruster(name: "Yaw 1",
                             at: SIMD3<Double>(-0.41, 2.20, 0.00),
                             dir: SIMD3<Double>(108.0, 0.0,0.0)))
  }

  override func connect() {
    retro.append(sim.resolver.resolve(relative: "Retro 0", source: self) as! SolidRocketEngine)
    retro.append(sim.resolver.resolve(relative: "Retro 1", source: self) as! SolidRocketEngine)
    retro.append(sim.resolver.resolve(relative: "Retro 2", source: self) as! SolidRocketEngine)

    pitchThrusters.append(sim.resolver.resolve(relative: "Pitch 0", source: self) as! Thruster)
    pitchThrusters.append(sim.resolver.resolve(relative: "Pitch 1", source: self) as! Thruster)

    rollThrusters.append(sim.resolver.resolve(relative: "Roll 0", source: self) as! Thruster)
    rollThrusters.append(sim.resolver.resolve(relative: "Roll 1", source: self) as! Thruster)

    yawThrusters.append(sim.resolver.resolve(relative: "Yaw 0", source: self) as! Thruster)
    yawThrusters.append(sim.resolver.resolve(relative: "Yaw 1", source: self) as! Thruster)

    engines.append(retro[0])
    engines.append(retro[1])
    engines.append(retro[2])

    super.connect()
  }
}
class Redstone : Stage {
  override init(name: String, at pos: SIMD3<Double>) {
    super.init(name: name, at: pos)
    let scene = SCNScene(named: "art.scnassets/redstone.scn")!
    for node in scene.rootNode.childNodes {
      addObjectToScene(object: node)
    }

    self.body = SCNPhysicsBody(type:SCNPhysicsBodyType.dynamic,
        shape: SCNPhysicsShape(geometry: SCNCylinder(radius: 1.78/2, height: 25.41)))
    self.body.isAffectedByGravity = true
    object.physicsBody = body
    // Default calculated from body
    // body.momentOfInertia = SCNVector3(27.14764852, 0.39605, 27.14764852);
    mass = 24000.0 + 2200.0
    emptyMass = 4400.0 // Empty mass

    try! add(child: LiquidRocket(name: "Rocketdyne A-7",
                                 at: SIMD3<Double>(0.0,0.0,0.0),
                                 thrust: SIMD3<Double>(0.0,-370.0e3,0.0)))
    // animate the 3d object
    // object.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 0.1, z: 0, duration: 1)))
  }
  override func connect() {
    let rdyne = sim.resolver.resolve(relative: "Rocketdyne A-7", source: self) as? Actuator
    engines.append(rdyne!)
    super.connect()
  }
}

class Mercury : Spacecraft {
  var detatchSequence: DetachSequence = .MERC_REDSTONE
  var detatchIsComplete: Bool = false
  var detatchIsPossible: Bool = true
  var redstone: Stage! = nil
  var capsule: Stage! = nil
  var connector: SCNPhysicsSliderJoint! = nil
  override init(name: String) {
    super.init(name: name)
    try! add(child: Redstone(name: "Mercury-Redstone", at: SIMD3<Double>(0.0, 0.0, 0.0)))
    try! add(child: CommandModule(name: "Command-Module", at: SIMD3<Double>(0.0, 17.9832, 0.0)))

    //        sc->detatchStage = MercuryDetatch;
    //        sc->toggleMainEngine = MainEngineToggle;
    //        sc->axisUpdate = MercuryAxisUpdate;
    // inertia tensors are entered in the base form, assuming that the total
    // mass = 1.0
    // for the redstone mercury rocket we assume a solid cylinder for the form
    // 1/2 mrr = 0.5 * 1.0 * 0.89 * 0.89 = 0.39605
    // 1/12 m(3rr + hh) = 27.14764852
    //   pl_mass_translate(&redstone->obj->m, 0.0, 8.9916, 0.0);
    //   pl_object_set_drag_coef(redstone->obj, 0.5);
    //   pl_object_set_area(redstone->obj, 2.0*M_PI);

    //   pl_object_set_drag_coef(capsule->obj, 0.5);
    //   pl_object_set_area(capsule->obj, 2.0*M_PI);
    try! add(entrypoint: "detatch") {

    }
  }

  override func connect() {
    capsule = sim.resolver.resolve(relative: "Command-Module", source: self) as? Stage
    redstone = sim.resolver.resolve(relative: "Mercury-Redstone", source: self) as? Stage
    stages.append(capsule!)
    stages.append(redstone!)

    connector = SCNPhysicsSliderJoint(
      bodyA: capsule.body,
      axisA: SCNVector3(x: 0, y: 0, z: 0),
      anchorA: SCNVector3(x: 0, y: 0, z: 0),
      bodyB: redstone.body,
      axisB: SCNVector3(x: 0, y: 0, z: 0),
      anchorB: SCNVector3(x: 0, y: 0, z: 0)
    )
  }
  override func toggleEngine() {
    for engine in redstone.engines {
      engine.object.isHidden = !engine.object.isHidden
    }
  }
 /*
func
axisUpdate()
{
  switch (detatchSequence) {
  case .MERC_REDSTONE:
    redstone.engines[Redstone_Actuators.THR_ROCKETDYNE.rawValue].setThrottle(axises.orbital
  case .MERC_CAPSULE:
    if (!detatchComplete) { break;}
    capsule.engines[Capsule_Actuators.THR_ROLL_0.rawValue].setThrottle(axises.roll)
    capsule.engines[Capsule_Actuators.THR_ROLL_0.rawValue].fire()

    capsule.engines[Capsule_Actuators.THR_ROLL_1.rawValue].setThrottle(-axises.roll)
    capsule.engines[Capsule_Actuators.THR_ROLL_1.rawValue].fire()

    capsule.engines[Capsule_Actuators.THR_PITCH_0.rawValue].setThrottle(axises.pitch)
    capsule.engines[Capsule_Actuators.THR_PITCH_0.rawValue].fire()
    capsule.engines[Capsule_Actuators.THR_PITCH_1.rawValue].setThrottle(-axises.pitch)
    capsule.engines[Capsule_Actuators.THR_PITCH_1.rawValue].fire()

    capsule.engines[Capsule_Actuators.THR_YAW_0.rawValue].setThrottle(axises.yaw)
    capsule.engines[Capsule_Actuators.THR_YAW_0.rawValue].fire()
    capsule.engines[Capsule_Actuators.THR_YAW_1.rawValue].setThrottle(-axises.yaw)
    capsule.engines[Capsule_Actuators.THR_YAW_1.rawValue].fire()
  default:
    assert(false, "invalid case");
  }
}

func
detatchComplete()
{
  //log_info("detatch complete");

    detatchIsPossible = false; // Do not reenable, must be false after last stage detatched
    detatchIsComplete = true;

    capsule.engines[THR_POSI].disable()
    capsule.armEngines()
    capsule.engines[THR_POSI].disarm()
}

func
detatch()
{
    //log_info("detatch commanded");
    detatchIsPossible = false

    if (detatchSequence == .MERC_REDSTONE) {
        //log_info("detatching redstone");
        redstone.disableEngines()
        redstone.lockEngines()

        detachStage(redstone)

        capsule.engines[THR_POSI].arm()
        capsule.engines[THR_POSI].fire()

        detatchIsComplete = false;
        sim.postRelative(seconds: 1.0, object: self, event: {self.detatchComplete()})
    }
}

func
RetroDisable_2()
{
    capsule.engines[THR_RETRO_2].disable()
    capsule.engines[THR_RETRO_2].disarm()
}

func
RetroFire_2()
{
    capsule.engines[THR_RETRO_2].fire()
    sim.postRelative(seconds: 10.0, object: self, event: {
        RetroDisable_2()
    })
}

func
RetroDisable_1(void *data)
{
    capsule.engines[THR_RETRO_1].disable()
    capsule.engines[THR_RETRO_1].disarm()
}

func
RetroFire_1(void *data)
{
    capsule.engines[THR_RETRO_1].fire()
    sim.postRelative(seconds: 10.0, object: self, event: {
        RetroDisable_1()
    })
    sim.postRelative(seconds: 5.0, object: self, event: {
        RetroFire_2()
    })
}

func
RetroDisable_0(void *data)
{
  sim_spacecraft_t *sc = (sim_spacecraft_t*)data;
  sim_stage_t *capsule = sc->stages.elems[MERC_CAPSULE];

  sim_engine_disable(ARRAY_ELEM(capsule->engines, THR_RETRO_0));
  sim_engine_disarm(ARRAY_ELEM(capsule->engines, THR_RETRO_0));
}


func
RetroFire_0(void *data)
{
  sim_spacecraft_t *sc = (sim_spacecraft_t*)data;
  sim_stage_t *capsule = sc->stages.elems[MERC_CAPSULE];

  sim_engine_fire(ARRAY_ELEM(capsule->engines, THR_RETRO_0));

  sim_event_enqueue_relative_s(10.0, RetroDisable_0, sc);
  sim_event_enqueue_relative_s(5.0, RetroFire_1, sc);
}

func MainEngineToggle()
{
  switch (detatchSequence) {
  case .MERC_REDSTONE: {
    sim_stage_t *redstone = sc->stages.elems[MERC_REDSTONE];
    sim_engine_t *eng = ARRAY_ELEM(redstone->engines, THR_ROCKETDYNE);
    if (eng->state == SIM_ARMED) sim_engine_fire(eng);
    else if (eng->state == SIM_BURNING) sim_engine_disable(eng);
    break;
  }
  case .MERC_CAPSULE: {
    sim_stage_t *capsule = sc->stages.elems[MERC_CAPSULE];
    sim_engine_t *eng = ARRAY_ELEM(capsule->engines, THR_RETRO_0);
    if (eng->state == SIM_ARMED) RetroFire_0(sc);
    break;
  }
  default:
    assert(0 && "invalid case");
  }
}
 */
}
