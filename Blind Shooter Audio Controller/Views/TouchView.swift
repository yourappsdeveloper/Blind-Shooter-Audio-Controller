//
//  UIWindow+Extension.swift
//  Blind Shooter Audio Controller
//
//  Created by Aleksandr on 19.08.2022.
//

import UIKit

protocol TouchViewDelegate {
    func touchesBeganInCenter()
    func touchesMoved(_ point: CGPoint)
    func touchesEnded()
}

class TouchView: UIView {
    
    var centerMode = false
    var delegate: TouchViewDelegate?
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let center = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 100)))
        center.center = self.center
        centerMode = center.frame.contains(point)
        
        return self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if centerMode { delegate?.touchesBeganInCenter() }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard centerMode, touches.count == 1, let touch = touches.first else { return }
        let point = touch.location(in: self)
        delegate?.touchesMoved(point)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        centerMode = false
        delegate?.touchesEnded()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        centerMode = false
        delegate?.touchesEnded()
    }
}
