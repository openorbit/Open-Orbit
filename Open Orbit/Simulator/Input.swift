//
//  Input.swift
//  Open Orbit
//
//  Created by Mattias Holm on 2023-03-27.
//

import Foundation

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
  case space = 49
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


class Input {
  let name: String
  var valueChanged: Optional<() -> ()> =  nil

  init(name: String) {
    self.name = name
  }
}

class AxisInput : Input {
  let min: Double
  let max: Double
  var nullZone: Double
  var currentValue: Double

  init(name: String, min: Double, max: Double, changed: Optional<() -> ()> = nil) {
    self.min = min
    self.max = max
    self.nullZone = 0
    self.currentValue = min + (max - min) / 2
    super.init(name: name)
    self.valueChanged = changed
  }
}

class ToggleInput : Input {
  var state: Int = 0
  var states: [String] = []

  init(name: String, states: [String], changed: Optional<() -> ()> = nil) {
    self.states = states
    super.init(name: name)
    self.valueChanged = changed
  }
}

class ButtonInput : Input {
  var state: Double = 0.0
  init(name: String, changed: Optional<() -> ()> = nil) {
    super.init(name: name)
    self.valueChanged = changed
  }
}

class InputSystem {
  let keys: [String: KeyCode] = [
    "q" : .q,
    "w" : .w,
    "e" : .e,
    "r" : .r,
    "t" : .t,
    "y" : .y,
    "u" : .u,
    "i" : .i,
    "o" : .o,
    "p" : .p,
    "a" : .a,
    "s" : .s,
    "d" : .d,
    "f" : .f,
    "g" : .g,
    "h" : .h,
    "j" : .j,
    "k" : .k,
    "l" : .l,
    "z" : .z,
    "x" : .x,
    "c" : .c,
    "v" : .v,
    "b" : .b,
    "n" : .k,
    "m" : .m,
    "up" : .up,
    "down": .down,
    "left": .left,
    "right": .right,

    ";": .semi,
    "'": .quote,
    "\\": .backslash,
    "[": .leftbrack,
    "]": .rightbrack,
    ",": .comma,
    ".": .period,
    "/": .slash,
    "§": .paragraph,
    "space": .space,
    "1": .key_1,
    "2": .key_2,
    "3": .key_3,
    "4": .key_4,
    "5": .key_5,
    "6": .key_6,
    "7": .key_7,
    "8": .key_8,
    "9": .key_9,
    "0": .key_0,

    "-": .key_minus,
    "=": .key_equals,
  ]
  var buttons: [String : ButtonInput] = [:]
  var axises: [String : AxisInput] = [:]
  var toggles: [String : ToggleInput] = [:]

  var keyActions: [KeyCode : Input] = [:]

  init() {

  }

  func configure() {
    let defaults = UserDefaults.standard
    let controls = defaults.dictionary(forKey: "controls") as? [String : AnyObject]

    guard let controls else {
      return
    }
    let keyboard = controls["keyboard"] as? [String : String]
    guard let keyboard else {
      return
    }

    for (k, v) in keyboard {
      if let code = keys[k] {
        if let toggle = toggles[v] {
          keyActions[code] = toggle
        }
        if let button = buttons[v] {
          keyActions[code] = button
        }
        if let axis = axises[v] {
          keyActions[code] = axis
        }
      }
    }
  }

  func add(button: String, callback: Optional<() -> ()>) {
    buttons[button] = ButtonInput(name: button, changed: callback)
  }
  func add(axis: String, min: Double, max: Double, callback: Optional<() -> ()>) {
    axises[axis] = AxisInput(name: axis, min: min, max: max, changed: callback)
  }
  func add(toggle: String, states: [String], callback: Optional<() -> ()>) {
    toggles[toggle] = ToggleInput(name: toggle, states: states, changed: callback)
  }

  func dispatch(key: KeyCode) {
    let action = keyActions[key]
    if let changed = action?.valueChanged {
      print("dispatching \(action!.name)")
      changed()
    }
  }
}
