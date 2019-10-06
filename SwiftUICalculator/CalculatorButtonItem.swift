//
//  CalculatorButtonItem.swift
//  SwiftUICalculator
//
//  Created by Issac Penn on 2019/10/6.
//  Copyright © 2019 Issac Penn. All rights reserved.
//

import CoreGraphics
enum CalculatorButtonItem {
    
    enum Op: String {
        case plus = "+"
        case minus = "-"
        case multiply = "×"
        case divide = "÷"
        case equal = "="
    }
    
    enum Command: String {
        case clear = "AC"
        case flip = "+/-"
        case percent = "%"
    }
    
    case digit(Int)
    case dot
    case op(Op)
    case command(Command)
}

extension CalculatorButtonItem: Hashable {
    var title: String {
        switch self {
        case .digit(let number):
            return String(number)
        case .dot:
            return "."
        case .op(let op):
            return op.rawValue
        case .command(let command):
            return command.rawValue
        }
    }
    
    var size: CGSize {
        if case .digit(let number) = self, number == 0 {
            return CGSize(width: 80 * 2 + 8, height: 80)
        } else {
            return CGSize(width: 80, height: 80)
        }
        
    }
    
    var backgroundColorName: String {
        switch self {
        case .digit, .dot:
            return "digitBackground"
        case .op:
            return "operatorBackground"
        case .command:
            return "commandBackground"
        }
    }
}
