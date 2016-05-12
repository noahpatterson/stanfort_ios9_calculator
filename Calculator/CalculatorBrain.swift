//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Noah Patterson on 5/11/16.
//  Copyright © 2016 Noah Patterson. All rights reserved.
//

import Foundation

func multiply(firstNumber: Double, secondNumber: Double) -> Double {
    return firstNumber * secondNumber
}

class CalculatorBrain {
    
    private var accumulator = 0.0
    
    func setOperand(operand: Double) {
        accumulator = operand
    }
    
    var operations: Dictionary<String, Operation>  = [
        "clear" : Operation.Constant(0.0),
        "π" : Operation.Constant(M_PI), //M_PI,
        "e" : Operation.Constant(M_E), //M_E,
        "√" : Operation.UnaryOperation(sqrt), //sqrt,
        "cos" : Operation.UnaryOperation(cos),//cos
        "✕" : Operation.BinaryOperation(multiply),
        "=" : Operation.Equals
    ]
    
    // enums can have methods, but no vars, no inheritance
    enum Operation {
        case Constant(Double)
        /* unaryOperation defines an associated value that is a function, that takes a double
        , that returns a Double = func(Double) -> Double */
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    private func intermediateEquals(pending: PendingBinaryOperationInfo) -> Double {
        return pending.binaryFunction(pending.firstOperand, accumulator)
    }
    
    
    
    func performOperation(symbol: String) {
//        if let constant = operations[symbol] {
//            accumulator = constant
//        }
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let associatedConstantValue): accumulator = associatedConstantValue
            case .UnaryOperation(let function): accumulator = function(accumulator)
            case .BinaryOperation(let function):
                if pending != nil {
                    accumulator = intermediateEquals(pending!)
                }
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                if pending != nil {
                    accumulator = intermediateEquals(pending!)
                    pending = nil
                }
            }
        }
    }
    
    var pending: PendingBinaryOperationInfo?
    
    // all of the structs vars are part of the 'free' initializer
    struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    
    var result: Double {
        get {
            return accumulator
        }
    }
    
    
}