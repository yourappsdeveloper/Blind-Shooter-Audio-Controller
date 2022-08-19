//
//  ViewController.swift
//  Blind Shooter Audio Controller
//
//  Created by Aleksandr on 19.08.2022.
//

import UIKit

class ViewController: UIViewController {
    
    private let audioPlayer = AudioPlayer()

    @IBOutlet weak var mainView: TouchView!
    @IBOutlet weak var centerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureOnViewLoad()
    }
}

extension ViewController {
    private func configureOnViewLoad() {
        mainView.delegate = self
        addTapGestureRecognizer()
        addSwipeGestureRecognizer()
    }
    
    private func addTapGestureRecognizer() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        mainView.addGestureRecognizer(doubleTap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        guard !mainView.centerMode, let fingers = sender?.numberOfTouchesRequired else { return }
        audioPlayer.playAudio(gesture: .tap(count: .double, fingers: Int8(fingers)))
    }
    
    private func addSwipeGestureRecognizer() {
        for fingers in 1...3 {
            mainView.addGestureRecognizer(getSwipeGestureRecognizer(direction: .up, fingers: fingers))
            mainView.addGestureRecognizer(getSwipeGestureRecognizer(direction: .down, fingers: fingers))
            mainView.addGestureRecognizer(getSwipeGestureRecognizer(direction: .left, fingers: fingers))
            mainView.addGestureRecognizer(getSwipeGestureRecognizer(direction: .right, fingers: fingers))
        }
    }
    
    @objc func handleSwipe(_ sender: UISwipeGestureRecognizer? = nil) {
        guard !mainView.centerMode, let direction = sender?.direction, let fingers = sender?.numberOfTouchesRequired else { return }
        audioPlayer.playAudio(gesture: .swipe(direction: direction , fingers: Int8(fingers)))
    }
    
    private func getSwipeGestureRecognizer(direction: UISwipeGestureRecognizer.Direction, fingers: Int) -> UISwipeGestureRecognizer {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe(_:)))
        swipeGesture.numberOfTouchesRequired = fingers
        swipeGesture.direction = direction
        
        return swipeGesture
    }
    
    private func handleTouches(_ point: CGPoint) {
        let halfWith = mainView.frame.width / 2
        let halfHeight = mainView.frame.height / 2
        
        let pitch = Float(halfHeight - point.y) / 1
        let pan = Float((point.x - halfWith) / halfWith)

        audioPlayer.setPitch(pitch)
        audioPlayer.setPan(pan)
    }
}

extension ViewController: TouchViewDelegate {

    func touchesBeganInCenter() {
        audioPlayer.playSound()
    }
    
    func touchesMoved(_ point: CGPoint) {
        handleTouches(point)
    }
    
    func touchesEnded() {
        audioPlayer.stopPlaySound()
    }    
}
