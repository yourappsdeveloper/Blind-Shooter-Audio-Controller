//
//  StereoAudioViewController.swift
//  Blind Shooter Audio Controller
//
//  Created by Alexandr on 20.08.2022.
//

import UIKit

class StereoAudioViewController: UIViewController {
    
    private let audioPlayer = AudioPlayer()

    @IBOutlet weak var mainView: TouchView!
    @IBOutlet weak var centerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureOnViewLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred() // haptic feedback
    }
}

extension StereoAudioViewController {
    private func configureOnViewLoad() {
        mainView.delegate = self
        addTapGestureRecognizer()
    }
    
    private func addTapGestureRecognizer() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        mainView.addGestureRecognizer(doubleTap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        guard let fingers = sender?.numberOfTouchesRequired else { return }
        audioPlayer.playAudio(gesture: .tap(count: .double, fingers: Int8(fingers)))
    }

    private func handleTouches(_ point: CGPoint) {
        centerView.center = point
        
        let halfWith = mainView.frame.width / 2
        let halfHeight = mainView.frame.height / 2
        
        let pitch = Float(halfHeight - point.y) / 1
        let pan = Float((point.x - halfWith) / halfWith)

        // Move Up
        if point.y < halfHeight {
            guard let url = Bundle.main.url(forResource: "1_finger_hold_down_Moving_up", withExtension: "mp3") else { return }
            audioPlayer.playSound(url: url)
        }
        // Move Down
        else {
            guard let url = Bundle.main.url(forResource: "1_finger_hold_down_moving_Down", withExtension: "mp3") else { return }
            audioPlayer.playSound(url: url)
        }
        
        audioPlayer.setPitch(pitch)
        audioPlayer.setPan(pan)
    }
}

extension StereoAudioViewController: TouchViewDelegate {

    func touchesBeganInCenter() {
        guard let url = Bundle.main.url(forResource: "1_finger_hold_down_Center", withExtension: "mp3") else { return }
        audioPlayer.playSound(url: url)
        UIImpactFeedbackGenerator(style: .light).impactOccurred() // haptic feedback
    }
    
    func touchesMoved(_ point: CGPoint) {
        handleTouches(point)
    }
    
    func touchesEnded() {
        UIView.animate(withDuration: 0.25, delay: 0) { [weak self] in
            guard let self = self else { return }
            self.centerView.center = self.mainView.center
        }
        audioPlayer.stopPlaySound()
    }
}
