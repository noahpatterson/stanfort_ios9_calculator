//
//  ViewController.swift
//  Calculator
//
//  Created by Noah Patterson on 5/10/16.
//  Copyright © 2016 Noah Patterson. All rights reserved.
//

//importing a module - all public classes are imported. Model might import Foundation
import UIKit

class ViewController: UIViewController {
//    instance variables are called properties in Swift
    
    // placing '!' at declaration allows us to remove the explanation after each usage
    @IBOutlet private weak var display: UILabel!
    
    private var userIsInTheMiddleOfTyping = false
    
    @IBAction private func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            // must unwrap display with '!' because it's an optional
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
        
    }
    
    //computed property
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction private  func performOperation(sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathmaticalSymbol = sender.currentTitle {
            brain.performOperation(mathmaticalSymbol)
        }
        displayValue = brain.result
    }
    
}

