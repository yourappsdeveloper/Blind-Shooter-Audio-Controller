//
//  Constants.swift
//  Blind Shooter Audio Controller
//
//  Created by Alexandr on 21.08.2022.
//

import Foundation

enum StereoAudioUrl {
    static let center = Bundle.main.url(forResource: "1_finger_hold_down_Center", withExtension: "mp3")
    static let movingUp = Bundle.main.url(forResource: "1_finger_hold_down_Moving_up", withExtension: "mp3")
    static let movingDown = Bundle.main.url(forResource: "1_finger_hold_down_moving_Down", withExtension: "mp3")
}
