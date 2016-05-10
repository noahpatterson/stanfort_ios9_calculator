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
    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTyping = false
    
    @IBAction func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        // print("touchDigit: \(digit)")
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            // must unwrap display with '!' because it's an optional
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
        
    }
    
    @IBAction func performOperation(sender: UIButton) {
        userIsInTheMiddleOfTyping = false
        if let mathmaticalSymbol = sender.currentTitle {
            if mathmaticalSymbol == "π" {
                display.text = String(M_PI)
            }
        }
    }
    
}

