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
    
    override func drawRect(rect: CGRect) {
        // Drawing code
        let axes = AxesDrawer()
        axes.drawAxesInRect(rect, origin: CGPoint(x: bounds.midX, y: bounds.midY), pointsPerUnit: graphScale)
        
        
    }
}
