//
//  GraphView.swift
//  Calculator
//
//  Created by Noah Patterson on 6/10/16.
//  Copyright © 2016 Noah Patterson. All rights reserved.
//

import UIKit

protocol GraphViewDataSource: class {
    func y(x: CGFloat) -> CGFloat?
}

@IBDesignable
class GraphView: UIView {
    
    weak var dataSource: GraphViewDataSource?
    
    @IBInspectable
    var graphScale: CGFloat = 50.0 { didSet { setNeedsDisplay() } }
    var graphOrigin: CGPoint? = nil { didSet { setNeedsDisplay() } }
    
    var lineWidth: CGFloat = 1.0
    var color: UIColor = UIColor.blackColor() { didSet { setNeedsDisplay() } }
    
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
        
        color.set()
        let path = UIBezierPath()
        path.lineWidth = lineWidth
        var firstValue = true
        var point = CGPoint()
        var i = 0
        while i <= Int(bounds.size.width * contentScaleFactor) {
            point.x = CGFloat(i) / contentScaleFactor
            if let y = dataSource?.y((point.x - getOrigin().x) / graphScale) {
                point.y = getOrigin().y - y * graphScale
                if firstValue {
                    path.moveToPoint(point)
                    firstValue = false
                } else {
                    path.addLineToPoint(point)
                }
            }
            i += 1
        }
        path.stroke()
        
    }
}
