//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Noah Patterson on 5/11/16.
//  Copyright © 2016 Noah Patterson. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private var accumulator = 0.0
    private var description = ""
    private var internalProgram = [AnyObject]()
    private var variableAdded = false
    
    func setOperand(operand: Double) {
        accumulator = operand
        description = String(format: "%g", operand)
        internalProgram.append(operand)
    }

    func setOperand(variable: String) {
        description = variable
        internalProgram.append(variable)
        variableAdded = true
    }
    
    var variableValues = [String : Double]()
    
    private var operations: Dictionary<String, Operation>  = [
        "rnd" : Operation.Rand,
        "clear" : Operation.Clear,
        "π" : Operation.Constant(M_PI), //M_PI,
        "e" : Operation.Constant(M_E), //M_E,
        // unary operations should supply a second function that does the string formatting for description
        "√" : Operation.UnaryOperation(sqrt, { "√(\($0))" }), //sqrt,
        "cos" : Operation.UnaryOperation(cos, { "cos(\($0))" }),//cos
        "✕" : Operation.BinaryOperation({ $0 * $1 }, { "\($0)✕\($1)" }),
        "-" : Operation.BinaryOperation({ $0 - $1 }, { "\($0)-\($1)" }),
        "+" : Operation.BinaryOperation({ $0 + $1 }, { "\($0)+\($1)" }),
        "÷" : Operation.BinaryOperation({ $0 / $1 }, { "\($0)÷\($1)" }),
        "=" : Operation.Equals,
        "M" : Operation.Variable
        
    ]
    
    // enums can have methods, but no vars, no inheritance
    private enum Operation {
        case Constant(Double)
        /* unaryOperation defines an associated value that is a function, that takes a double
        , that returns a Double = func(Double) -> Double */
        case UnaryOperation((Double) -> Double, (String) -> String)
        case BinaryOperation((Double, Double) -> Double, (String, String) -> String)
        case Equals
        case Clear
        case Rand
        case Variable
    }
    
    private func intermediateEquals() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            description = pending!.descriptionFunction(pending!.descriptionOperand, description)
            pending = nil
        }
    }
    
    private func addToDescription(toAdd: String) {
        description += toAdd
    }
    
    func performOperation(symbol: String) {
        internalProgram.append(symbol)
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let associatedConstantValue):
                accumulator = associatedConstantValue
                description = symbol
                
            case .UnaryOperation(let function, let descriptionFunction):
                accumulator = function(accumulator)
                description = descriptionFunction(description)
                
            case .BinaryOperation(let function, let descriptionFunction):
                intermediateEquals()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator, descriptionFunction: descriptionFunction, descriptionOperand: description)
                
            case .Equals:
                intermediateEquals()

            case .Clear:
                pending = nil
                accumulator = 0.0
                description = ""
                variableValues.removeAll()
                
            case .Rand:
                accumulator = drand48()
                description = "(rand)"
                
            case .Variable:
                if let variable = variableValues["M"] {
                    accumulator = variable
                } else {
                    accumulator = 0.0
                }
            }
        }
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    // all of the structs vars are part of the 'free' initializer
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
        var descriptionFunction: (String, String) -> String
        var descriptionOperand: String
    }
    
    
    var result: Double {
        get {
            if variableAdded {
                program = internalProgram
            }
            return accumulator
        }
    }
    
    var getDescription: String {
        get {
            if pending == nil {
                return description
            } else {
                let pendingUnwrapped = pending!
                return pendingUnwrapped.descriptionFunction(pendingUnwrapped.descriptionOperand, pendingUnwrapped.descriptionOperand != description ? description : "")
            }
        }
    }
    
    var getIsPartialResult: Bool {
        get {
            return pending != nil
        }
    }
    
    //storing programing to be used later
    typealias PropertyList = AnyObject
    var program: PropertyList {
        get {
            return internalProgram
        }
        set {
            clear()
            if let arrayOfOperations = newValue as? [AnyObject] {
                for operation in arrayOfOperations { 
                    if let operand = operation as? Double {
                        setOperand(operand)
                    } else if let op = operation as? String {
                        performOperation(op)
                    }
                }
            }

        }
    }
    
    func clear() {
        accumulator = 0.0
        pending = nil
        description = ""
        internalProgram.removeAll()
        variableAdded = false
    }
    
    
}