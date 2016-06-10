//
//  GraphView.swift
//  Calculator
//
//  Created by Noah Patterson on 6/10/16.
//  Copyright © 2016 Noah Patterson. All rights reserved.
//

import UIKit

@IBDesignable
class GraphView: UIView {
    
    @IBInspectable
    var graphScale: CGFloat = 50.0 { didSet { setNeedsDisplay() } }
    private var graphOrigin: CGPoint? = nil { didSet { setNeedsDisplay() } }
    
    func changeScale(recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .Changed, .Ended:
            graphScale *= recognizer.scale
            recognizer.scale = 1.0
        default:
            break
        }
    }
    
    func changeOrigin(recognizer: UIPanGestureRecognizer) {
        let pannedTo: CGPoint = recognizer.translationInView(self.superview)
        graphOrigin = CGPointMake(pannedTo.x + getOrigin().x, pannedTo.y + getOrigin().y)
        recognizer.setTranslation(CGPointZero, inView: self.superview)
    }
    
    func changeTapOrigin(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .Ended {
            graphOrigin = recognizer.locationInView(self)
        }
    }
    
    func getOrigin() -> CGPoint {
        if let originPoint = graphOrigin {
            return originPoint
        } else {
            return CGPoint(x: bounds.midX, y: bounds.midY)
        }
    }
    
    override func drawRect(rect: CGRect) {
        // Drawing code
        let axes = AxesDrawer()
        
        axes.drawAxesInRect(rect, origin: getOrigin(), pointsPerUnit: graphScale)
        
        
    }
}
