//
//  GestureType.swift
//  Blind Shooter Audio Controller
//
//  Created by Aleksandr on 19.08.2022.
//

import Foundation
import UIKit

enum TapCount: String {
    case single = "One"
    case double = "Double"
}

enum GestureType {
    case tap(count: TapCount, fingers: Int8)
    case swipe(direction: UISwipeGestureRecognizer.Direction, fingers: Int8)
    
    var audioUrl: URL? {
        let bundle = Bundle.main
        switch self {
            
        // Tap Gesture
        case .tap(count: let count, fingers: let fingers):
            return bundle.url(forResource: "\(fingers)_Finger_\(count.rawValue)_Tap", withExtension: "mp3")
            
        // Swipe Gesture
        case .swipe(direction: let direction, fingers: let fingers):
            return bundle.url(forResource: "\(fingers)_Finger_Swipe_\(directionName(direction))", withExtension: "mp3")
        }
    }
    
    func directionName(_ direction: UISwipeGestureRecognizer.Direction) -> String {
        switch direction {
        case .right:
            return "Right"
        case .left:
            return "Left"
        case .up:
            return "Up"
        case .down:
            return "Down"
        default:
            return ""
        }
    }
}
