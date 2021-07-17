//
//  ReferenceFrame.swift
//  Open Orbit
//
//  Created by Mattias Holm on 20/08/2021.
//

import Foundation

class Frame {
  public let depth: Int
  public var parent: Frame? = nil
  public var root: Frame? = nil
  var children: [Frame] = []
    
    init() {
      self.depth = 0
    }

    init(parent: Frame) {
      self.depth = parent.depth + 1
      self.parent = parent
      parent.children += [self]
    }

  public func isChildOf(parent: Frame) -> Bool {
    return self.parent != nil && parent === self.parent!
  }

  public func isDecendantOf(ancestor: Frame) -> Bool {
    var cursor = self
    while cursor.parent != nil {
      cursor = cursor.parent!
      if ancestor === cursor {
        return true
      }
    }
    return false
  }
}

class IERSFrame : Frame {
    
}

class FrameTransform {
    var upFrames: [Frame]
    var downFrames: [Frame]
    let isIdentity: Bool
    
    init(from: Frame, to: Frame) {
        upFrames = []
        downFrames = []
        
        isIdentity = from === to
        
        // Compute two stacks containing the from and to frames as starting points
        // We then iterate these stacks in reverse order (staring at the root), and
        // pop of the common part in the treee.
        var fromStack: [Frame] = []
        var toStack: [Frame] = []
        
        var tmp: Frame? = from
        while tmp != nil {
            fromStack += [tmp!]
            tmp = tmp!.parent
        }
        
        tmp = to
        while tmp != nil {
            toStack += [tmp!]
            tmp = tmp!.parent
        }
        
        // Remove common suffixes of frames
        var commonPrefixDepth = 0
        for (f, t) in zip(fromStack.reversed(), toStack.reversed()) {
            if f === t {
                commonPrefixDepth += 1
            } else {
                break
            }
        }
        fromStack = fromStack.dropLast(commonPrefixDepth)
        toStack = toStack.dropLast(commonPrefixDepth)
        upFrames += fromStack
        downFrames += toStack.reversed()
    }
}
