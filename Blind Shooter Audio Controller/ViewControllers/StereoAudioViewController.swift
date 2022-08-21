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
        let halfWith = mainView.frame.width / 2
        let halfHeight = mainView.frame.height / 2
        
        let pitch = Float(halfHeight - point.y) / 1
        let pan = Float((point.x - halfWith) / halfWith)
        
        // Close to Center
        if centerView.frame.contains(point) {
            guard let url = StereoAudioUrl.center else { return }
            audioPlayer.playSound(url: url)
        } else {
            
            // In CenterView Y axis
            if point.y >= centerView.frame.minY, point.y <= centerView.frame.maxY {
                guard let url = StereoAudioUrl.center else { return }
                audioPlayer.playSound(url: url)
            } else {
                // Move Up
                if point.y < halfHeight {
                    guard let url = StereoAudioUrl.movingUp else { return }
                    audioPlayer.playSound(url: url)
                }
                // Move Down
                else {
                    guard let url = StereoAudioUrl.movingDown else { return }
                    audioPlayer.playSound(url: url)
                }
                
                audioPlayer.setPitch(pitch)
            }
            audioPlayer.setPan(pan)
        }
    }
}

extension StereoAudioViewController: TouchViewDelegate {

    func touchesBegan(_ point: CGPoint) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred() // haptic feedback
    }
    
    func touchesMoved(_ point: CGPoint) {
        handleTouches(point)
    }
    
    func touchesEnded() {
        audioPlayer.stopPlaySound()
    }
}
