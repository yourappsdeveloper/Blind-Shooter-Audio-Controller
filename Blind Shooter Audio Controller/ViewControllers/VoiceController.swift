//
//  VoiceController.swift
//  Blind Shooter Audio Controller
//
//  Created by Aleksandr on 19.08.2022.
//

import UIKit

class VoiceController: UIViewController {
    
    private let audioPlayer = AudioPlayer()

    @IBOutlet weak var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureOnViewLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIImpactFeedbackGenerator(style: .rigid).impactOccurred() // haptic feedback 
    }
}

extension VoiceController {
    private func configureOnViewLoad() {
        addTapGestureRecognizer()
        addSwipeGestureRecognizer()
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
    
    private func addSwipeGestureRecognizer() {
        for fingers in 1...3 {
            mainView.addGestureRecognizer(getSwipeGestureRecognizer(direction: .up, fingers: fingers))
            mainView.addGestureRecognizer(getSwipeGestureRecognizer(direction: .down, fingers: fingers))
            mainView.addGestureRecognizer(getSwipeGestureRecognizer(direction: .left, fingers: fingers))
            mainView.addGestureRecognizer(getSwipeGestureRecognizer(direction: .right, fingers: fingers))
        }
    }
    
    @objc func handleSwipe(_ sender: UISwipeGestureRecognizer? = nil) {
        guard let direction = sender?.direction, let fingers = sender?.numberOfTouchesRequired else { return }
        audioPlayer.playAudio(gesture: .swipe(direction: direction , fingers: Int8(fingers)))
    }
    
    private func getSwipeGestureRecognizer(direction: UISwipeGestureRecognizer.Direction, fingers: Int) -> UISwipeGestureRecognizer {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe(_:)))
        swipeGesture.numberOfTouchesRequired = fingers
        swipeGesture.direction = direction
        
        return swipeGesture
    }
}
