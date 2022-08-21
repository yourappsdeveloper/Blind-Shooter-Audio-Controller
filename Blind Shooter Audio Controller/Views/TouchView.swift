//
//  UIWindow+Extension.swift
//  Blind Shooter Audio Controller
//
//  Created by Aleksandr on 19.08.2022.
//

import UIKit

protocol TouchViewDelegate {
    func touchesBegan(_ point: CGPoint)
    func touchesMoved(_ point: CGPoint)
    func touchesEnded()
}

class TouchView: UIView {
    
    var delegate: TouchViewDelegate?
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard touches.count == 1, let touch = touches.first else { return }
        let point = touch.location(in: self)
        delegate?.touchesBegan(point)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard touches.count == 1, let touch = touches.first else { return }
        let point = touch.location(in: self)
        delegate?.touchesMoved(point)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        delegate?.touchesEnded()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        delegate?.touchesEnded()
    }
}
