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
    
    func changeScale(recongizer: UIPinchGestureRecognizer) {
        switch recongizer.state {
        case .Changed, .Ended:
            graphScale *= recongizer.scale
            recongizer.scale = 1.0
        default:
            break
        }
    }
    
    func changeOrigin(recongizer: UIPanGestureRecognizer) {
        graphOrigin = recongizer.translationInView(self)

    }
    
    func getOrigin() -> CGPoint {
        if let origin = graphOrigin {
            return origin
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
