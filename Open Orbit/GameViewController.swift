//
//  GameViewController.swift
//  Open Orbit
//
//  Created by Mattias Holm on 17/07/2021.
//

import SceneKit
import QuartzCore

func loadDefaults() {
  // Insert code here to initialize your application
  guard let path = Bundle.main.path(forResource: "UserDefaults", ofType: "plist") else {
    print("Could not find UserDefaults.plist in app bundle")
    return
  }
  guard let plist = FileManager.default.contents(atPath: path) else {
    print("Could not load UserDefaults.plist in app bundle")
    return
  }
  guard let defaults = try? PropertyListSerialization.propertyList(from: plist, format: nil)
          as? [String: Any] else {
    print("Could not deserialize UserDefaults.plist in app bundle")
    return
  }
  UserDefaults.standard.register(defaults: defaults)

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
    loadDefaults()
    
    orbit = OpenOrbit()

    orbit.inputSystem.add(button: "screenshot") {
      let img = self.scnView.snapshot()
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
    }


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

    orbit.inputSystem.configure()
  }

  @objc
  func handlePan(_ gestureRecognizer: NSPanGestureRecognizer) {
    let point = gestureRecognizer.velocity(in: scnView)
    let vec = SIMD2<Double>(point.x / scnView.bounds.width, point.y / scnView.bounds.height)

    orbit.cameraController.rotateBy(x: Float(vec.x), y: Float(vec.y))
  }
  @objc
  func handleZoom(_ gestureRecognizer: NSMagnificationGestureRecognizer) {
    orbit.cameraController.translateInCameraSpaceBy(x: 0, y: 0, z: Float(gestureRecognizer.magnification))
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
    let code = KeyCode(rawValue: event.keyCode)
    if let code {
      orbit.inputSystem.dispatch(key: code)
    }
  }

  func renderer(_ renderer: SCNSceneRenderer,
                updateAtTime time: TimeInterval) {
    orbit.advance(time: time)
  }
}
