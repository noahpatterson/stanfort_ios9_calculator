//
//  GraphData.swift
//  Calculator
//
//  Created by Noah Patterson on 6/18/16.
//  Copyright © 2016 Noah Patterson. All rights reserved.
//

import Foundation

struct GraphData {
    enum GraphFunction: Int {
        case Sine
        case Cosine
    }
    
    var graphFunction: GraphFunction?
    var variable: Double?
}