//
//  ViewController.swift
//  Calculator
//
//  Created by Noah Patterson on 5/10/16.
//  Copyright © 2016 Noah Patterson. All rights reserved.
//

//importing a module - all public classes are imported. Model might import Foundation
import UIKit

class CalculatorViewController: UIViewController {
//    instance variables are called properties in Swift
    
    // placing '!' at declaration allows us to remove the explanation after each usage
    @IBOutlet private weak var display: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    private var userIsInTheMiddleOfTyping = false
    private var hasUsedDecimal = false
    private var digit: String?
    
    private func displayText(textToDisplay: String) {
            display.text = textToDisplay
    }
    
    @IBAction private func backspace(sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            let currentDisplay = display.text!
            if (currentDisplay.characters.count == 1) {
                displayValue = 0
                userIsInTheMiddleOfTyping = false
            } else {
                display.text!.removeAtIndex(display.text!.endIndex.predecessor())
            }
        }
    }
    
    @IBAction private func touchDigit(sender: UIButton) {
        digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            if digit! == "." && textCurrentlyInDisplay.rangeOfString(".") != nil {
                return
            }
            displayText(textCurrentlyInDisplay + digit!)
        } else {
            displayText(digit!)
        }
        userIsInTheMiddleOfTyping = true
        
    }
    
    var savedProgram: CalculatorBrain.PropertyList?
    
    @IBAction func save() {
        savedProgram = brain.program
    }
    @IBAction func restore() {
        if savedProgram != nil {
            brain.program = savedProgram!
            displayValue = brain.result
        }
    }
    
    @IBAction func addVariable() {
        brain.setOperand("M")
    }
    @IBAction func setVariable() {
        brain.variableValues["M"] = displayValue
        displayValue = brain.result
        userIsInTheMiddleOfTyping = false
    }
    
    //computed property
    private var displayValue: Double? {
        get {
            let formatter = NSNumberFormatter()
            formatter.maximumFractionDigits = 6
            return Double(formatter.numberFromString(display.text!)!)
        }
        set {
            if let newDisplay = newValue {
            display.text = String(format: "%g", newDisplay)
            descriptionLabel.text = brain.getIsPartialResult ? brain.getDescription + "..." : brain.getDescription + "="
            }
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction private  func performOperation(sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue!)
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathmaticalSymbol = sender.currentTitle {
            brain.performOperation(mathmaticalSymbol)
        }
        displayValue = brain.result
        if sender.currentTitle == "clear" {
            descriptionLabel.text = " "
        }
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        var destinationvc = segue.destinationViewController
        if let navController = destinationvc as? UINavigationController {
            destinationvc = navController.visibleViewController ?? destinationvc
        }
        
        if let graphvc = destinationvc as? GraphViewController {
            if let identifier = segue.identifier {
                switch identifier {
                    case "show graph":
                        graphvc.title = brain.getDescription == "" ? "Graph" : brain.getDescription.componentsSeparatedByString(", ").last
                        graphvc.program = brain.program
                default:
                    break
                }
            }
        }
    }

}

