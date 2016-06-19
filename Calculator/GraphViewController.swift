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
                target: self, action: #selector(GraphViewController.changeScale(_:))
                ))
            
            let panGestureRecongizer = UIPanGestureRecognizer(target: self, action: #selector(GraphViewController.changeOrigin(_:)))
            panGestureRecongizer.maximumNumberOfTouches = 1
            panGestureRecongizer.minimumNumberOfTouches = 1
            graphView.addGestureRecognizer(panGestureRecongizer)
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GraphViewController.changeTapOrigin(_:)))
            tapGestureRecognizer.numberOfTapsRequired = 2
            graphView.addGestureRecognizer(tapGestureRecognizer)
            
            if !resetOrigin {
                graphView.graphOrigin = origin
            }
            graphView.graphScale = scale
        }
    }
    
    private struct Keys {
        static let scale = "GraphViewController.Scale"
        static let origin = "GraphViewController.Origin"
    }
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    private var resetOrigin: Bool {
        get {
            if let originArray = defaults.objectForKey(Keys.origin) as? [CGFloat] {
                return false
            }
            return true
        }
    }
    
    var scale: CGFloat {
        get { return defaults.objectForKey(Keys.scale) as? CGFloat ?? 50.0 }
        set { defaults.setObject(newValue, forKey: Keys.scale) }
    }
    
    var origin: CGPoint {
        get {
            var origin = CGPoint()
            if let originArray = defaults.objectForKey(Keys.origin) as? [CGFloat] {
                origin.x = originArray.first!
                origin.y = originArray.last!
            }
            return origin
        }
        set { defaults.setObject([newValue.x, newValue.y], forKey: Keys.origin) }
    }
    
    func changeScale(recognizer: UIPinchGestureRecognizer) {
        graphView.changeScale(recognizer)
        if recognizer.state == .Ended {
            scale = graphView.graphScale
        }
    }
    
    func changeOrigin(recognizer: UIPanGestureRecognizer) {
        graphView.changeOrigin(recognizer)
        if recognizer.state == .Ended {
            origin = graphView.getOrigin()
        }
    }
    
    func changeTapOrigin(recognizer: UITapGestureRecognizer) {
        graphView.changeTapOrigin(recognizer)
        if recognizer.state == .Ended {
            origin = graphView.getOrigin()
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
