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
    
    func setOperand(operand: Double) {
        accumulator = operand
    }
    
    private var operations: Dictionary<String, Operation>  = [
        "clear" : Operation.Clear,
        "π" : Operation.Constant(M_PI), //M_PI,
        "e" : Operation.Constant(M_E), //M_E,
        "√" : Operation.UnaryOperation(sqrt), //sqrt,
        "cos" : Operation.UnaryOperation(cos),//cos
        "✕" : Operation.BinaryOperation({ $0 * $1 }),
        "-" : Operation.BinaryOperation({ $0 - $1 }),
        "+" : Operation.BinaryOperation({ $0 + $1 }),
        "÷" : Operation.BinaryOperation({ $0 / $1 }),
        "=" : Operation.Equals
    ]
    
    // enums can have methods, but no vars, no inheritance
    private enum Operation {
        case Constant(Double)
        /* unaryOperation defines an associated value that is a function, that takes a double
        , that returns a Double = func(Double) -> Double */
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
        case Clear
    }
    
    private func intermediateEquals() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let associatedConstantValue): accumulator = associatedConstantValue
            case .UnaryOperation(let function): accumulator = function(accumulator)
            case .BinaryOperation(let function):
                intermediateEquals()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                intermediateEquals()
            case .Clear:
                pending = nil
                accumulator = 0.0
            }
        }
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    // all of the structs vars are part of the 'free' initializer
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    
    var result: Double {
        get {
            return accumulator
        }
    }
    
    
}