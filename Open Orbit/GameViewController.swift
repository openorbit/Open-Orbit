//
//  GameViewController.swift
//  Open Orbit
//
//  Created by Mattias Holm on 17/07/2021.
//

import SceneKit
import QuartzCore

enum KeyCode : UInt16 {
  case q = 12
  case w = 13
  case e = 14
  case r = 15
  case t = 17
  case y = 16
  case u = 32
  case i = 34
  case o = 31
  case p = 35
  case a = 0
  case s = 1
  case d = 2
  case f = 3
  case g = 5
  case h = 4
  case j = 38
  case k = 40
  case l = 37
  case z = 6
  case x = 7
  case c = 8
  case v = 9
  case b = 11
  case n = 45
  case m = 46

  case up = 126
  case down = 125
  case left = 123
  case right = 124

  case semi = 41
  case quote = 39
  case backslash = 42
  case leftbrack = 33
  case rightbrack = 30
  case comma = 43
  case period = 47
  case slash = 44
  case paragraph = 10
  case key_1 = 18
  case key_2 = 19
  case key_3 = 20
  case key_4 = 21
  case key_5 = 23
  case key_6 = 22
  case key_7 = 26
  case key_8 = 28
  case key_9 = 25
  case key_0 = 29
  case key_minus = 27
  case key_equals = 24
}

class GameViewController: NSViewController, SCNSceneRendererDelegate {
  var orbit: OpenOrbit!
  var scnView : SCNView {
    get {
      self.view as! SCNView
    }
  }
  override func viewDidLoad() {
    super.viewDidLoad()

    orbit = OpenOrbit()

    // retrieve the SCNView
    scnView.delegate = self
    // set the scene to the view
    scnView.scene = orbit.scene

    // Camera control settings
    //scnView.allowsCameraControl = true
    //scnView.cameraControlConfiguration.allowsTranslation = false
    //scnView.cameraControlConfiguration.autoSwitchToFreeCamera = true
    //scnView.cameraControlConfiguration.flyModeVelocity = 4.0
    //scnView.defaultCameraController.interactionMode = .orbitTurntable

    // show statistics such as fps and timing information
    scnView.showsStatistics = true
    // configure the view
    scnView.backgroundColor = NSColor.black

    // Add a click gesture recognizer
    var gestureRecognizers = scnView.gestureRecognizers
    let dragGesture = NSPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
    let clickGesture = NSClickGestureRecognizer(target: self, action: #selector(handleClick(_:)))
    let zoomGesture = NSMagnificationGestureRecognizer(target: self, action: #selector(handleZoom(_:)))
    gestureRecognizers.insert(clickGesture, at: 0)
    gestureRecognizers.insert(dragGesture, at: 1)
    gestureRecognizers.insert(zoomGesture, at: 2)
    scnView.gestureRecognizers = gestureRecognizers

  }

  @objc
  func handlePan(_ gestureRecognizer: NSPanGestureRecognizer) {
    let point = gestureRecognizer.velocity(in: scnView)
    let vec = SIMD2<Double>(point.x / scnView.bounds.width, point.y / scnView.bounds.height)
    orbit.camera.pan(relative: vec)
  }
  @objc
  func handleZoom(_ gestureRecognizer: NSMagnificationGestureRecognizer) {
    orbit.camera.zoom(relative: gestureRecognizer.magnification)
  }
  @objc
  func handleClick(_ gestureRecognizer: NSClickGestureRecognizer) {
    // Check what nodes are clicked
    let p = gestureRecognizer.location(in: scnView)
    let hitResults = scnView.hitTest(p, options: [:])
    // check that we clicked on at least one object
    if hitResults.count > 0 {
      // retrieved the first clicked object
      let result = hitResults[0]
      // get its material
      let material = result.node.geometry!.firstMaterial!

      // highlight it
      SCNTransaction.begin()
      SCNTransaction.animationDuration = 0.5

      // on completion - unhighlight
      SCNTransaction.completionBlock = {
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.5

        material.emission.contents = NSColor.black

        SCNTransaction.commit()
      }

      material.emission.contents = NSColor.red

      SCNTransaction.commit()
    }
  }

  override func keyDown(with event: NSEvent) {
    guard !event.isARepeat else {
      return
    }

    switch event.keyCode {
    case KeyCode.i.rawValue:
      orbit.toggleICRFGrid()
    case KeyCode.e.rawValue:
      orbit.toggleEngine()
    case KeyCode.c.rawValue:
      let img = scnView.snapshot()
      let urlPath = URL(filePath: NSSearchPathForDirectoriesInDomains(
        .picturesDirectory,
        .userDomainMask, true).first!)
      .appending(component: "openorbit.png")

      let imageData = img.tiffRepresentation!
      let imageRep = NSBitmapImageRep(data: imageData)
      let pngData = imageRep?.representation(using: .png, properties: [:])
      do {
        try pngData?.write(to: urlPath)
      } catch {
        let alert = NSAlert(error: error)
        alert.alertStyle = .warning
        alert.beginSheetModal(for: self.view.window!)
      }
    default:
      print("pressed \(event.keyCode)")
    }
  }

  func renderer(_ renderer: SCNSceneRenderer,
                updateAtTime time: TimeInterval) {
    orbit.advance(time: time)
  }
}
