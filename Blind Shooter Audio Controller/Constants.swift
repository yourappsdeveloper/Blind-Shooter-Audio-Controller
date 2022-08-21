//
//  Constants.swift
//  Blind Shooter Audio Controller
//
//  Created by Alexandr on 21.08.2022.
//

import Foundation

enum StereoAudioUrl {
    static let center = Bundle.main.url(forResource: "12_second_constant_beep_for_inside_of_circle", withExtension: "mp3")
    static let movingUp = Bundle.main.url(forResource: "1_finger_hold_Down_above_Top_Of_Circle", withExtension: "mp3")
    static let movingDown = Bundle.main.url(forResource: "1_finger_hold_down_Below_Bottom_Of_Circle", withExtension: "mp3")
}
