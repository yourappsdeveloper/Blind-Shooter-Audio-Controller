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
    
    private func getPoint(from touches: Set<UITouch>) -> CGPoint? {
        guard touches.count == 1, let touch = touches.first else { return nil}
        return touch.location(in: self)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let point = getPoint(from: touches) else { return }
        
        delegate?.touchesBegan(point)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let point = getPoint(from: touches) else { return }
        
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
