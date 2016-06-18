//
//  GraphViewController.swift
//  Calculator
//
//  Created by Noah Patterson on 6/10/16.
//  Copyright © 2016 Noah Patterson. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController, GraphViewDataSource {
    
    @IBOutlet weak var graphView: GraphView! {
        didSet {
            graphView.dataSource = self
            graphView.addGestureRecognizer(UIPinchGestureRecognizer(
                target: graphView, action: #selector(GraphView.changeScale(_:))
                ))
            
            let panGestureRecongizer = UIPanGestureRecognizer(target: graphView, action: #selector(GraphView.changeOrigin(_:)))
            panGestureRecongizer.maximumNumberOfTouches = 1
            panGestureRecongizer.minimumNumberOfTouches = 1
            graphView.addGestureRecognizer(panGestureRecongizer)
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: graphView, action: #selector(GraphView.changeTapOrigin(_:)))
            tapGestureRecognizer.numberOfTapsRequired = 2
            graphView.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    
    private var brain = CalculatorBrain()
    typealias PropertyList = AnyObject
    var program: PropertyList {
        get {
            return brain.program
        }
        set {
            brain.program = newValue
        }
    }
    
    func y(x: CGFloat) -> CGFloat? {
        
        return CGFloat(cos(Double(x)))
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
