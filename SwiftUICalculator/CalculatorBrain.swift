//
//  CalculatorBrain.swift
//  SwiftUICalculator
//
//  Created by Issac Penn on 2019/10/9.
//  Copyright © 2019 Issac Penn. All rights reserved.
//

import Foundation

enum CalculatorBrain {
    case left(String)
    case leftOp(left: String, op: CalculatorButtonItem.Op)
    case leftOpRight(left: String, op: CalculatorButtonItem.Op, right: String)
    case error
}

extension CalculatorBrain {
    
    var formatter: NumberFormatter {
        let f = NumberFormatter()
        f.minimumFractionDigits = 0
        f.maximumFractionDigits = 8
        f.numberStyle = .decimal
        return f
    }
    
    var output: String {
        let result: String
        switch self {
        case .left(let left):
            result = left
        case .leftOp(left: let left, op: _):
            result = left
        case .leftOpRight(left: _, op: _, right: let right):
            result = right
        case .error:
            result = "Error"
        }
        
        guard let value = Double(result) else {
            return "Error"
        }
        
        return formatter.string(from: NSNumber(value: value))!
    }
    
    func apply(item: CalculatorButtonItem) -> CalculatorBrain {
        switch item {
        case .digit(let num):
            return apply(num: num)
        case .dot:
            return applyDot()
        case .op(let op):
            return apply(op: op)
        case .command(let command):
            return apply(command: command)
        }
    }
    
    func apply(num: Int) -> CalculatorBrain {
        switch self {
        case .error:
            return .error
        case .left(let left):
            if left == "0" {
                return .left(String(num))
            } else {
                return .left(left + String(num))
            }
        case .leftOp(left: let left, op: let op):
            if op == .equal {
                return .left(String(num))
            } else {
                return .leftOpRight(left: left, op: op, right: String(num))
            }
        case .leftOpRight(left: let left, op: let op, right: let right):
            return .leftOpRight(left: left, op: op, right: right + String(num))
        }
    }
    
    func applyDot() -> CalculatorBrain {
        switch self {
        case .error:
            return .error
        case .left(let left):
            if left.contains(".") {
                return self
            } else {
                return .left(left + ".")
            }
        case .leftOp(left: let left, op: let op):
            return .leftOpRight(left: left, op: op, right: "0.")
        case .leftOpRight(left: let left, op: let op, right: let right):
            if right.contains(".") {
                return self
            } else {
                return .leftOpRight(left: left, op: op, right: right + ".")
            }
        }
    }
    
    func apply(op: CalculatorButtonItem.Op) -> CalculatorBrain {
        switch self {
        case .error:
            return .error
        case .left(let left):
            return .leftOp(left: left, op: op)
        case .leftOp(let left, let oldOp):
            if op == .equal {
                switch oldOp {
                case .plus:
                    return .leftOp(left: String(Double(left)! + Double(left)!), op: .equal)
                case .minus:
                    return .leftOp(left: String(Double(left)! - Double(left)!), op: .equal)
                case .multiply:
                    return .leftOp(left: String(Double(left)! * Double(left)!), op: .equal)
                case .divide:
                    if Double(left)! == 0 {
                        return .error
                    } else {
                        return .leftOp(left: String(Double(left)! / Double(left)!), op: .equal)
                    }
                case .equal:
                     return .leftOp(left: left, op: op)
                }
            } else {
                return .leftOp(left: left, op: op)
            }
        case .leftOpRight(let left, let oldOp, let right):
            switch oldOp {
            case .plus:
                return .leftOp(left: String(Double(left)! + Double(right)!), op: op)
            case .minus:
                return .leftOp(left: String(Double(left)! - Double(right)!), op: op)
            case .multiply:
                return .leftOp(left: String(Double(left)! * Double(right)!), op: op)
            case .divide:
                if Double(right)! == 0 {
                    return .error
                } else {
                    return .leftOp(left: String(Double(left)! / Double(right)!), op: op)
                }
            case .equal:
                 return .leftOp(left: left, op: op)
            }
        }
    }
    
    func apply(command: CalculatorButtonItem.Command) -> CalculatorBrain {
        switch command {
        case .clear:
            return .left("0")
        case .percent:
            switch self {
            case .error:
                return .error
            case .left(let left):
                return .leftOp(left: String(Double(left)! / 100), op: .equal)
            //输入百分号之后，再直接输入数字，按理说应该处理的，这里没处理，所以还是能直接输入数字
            case .leftOp(left: let left, op: let op):
                if op == .equal {
                    return .leftOp(left: String(Double(left)! / 100), op: .equal)
                } else {
                    return .leftOpRight(left: left, op: op, right: String(Double(left)! / 100))
                }
                
            case .leftOpRight(left: let left, op: let op, right: let right):
                return .leftOpRight(left: left, op: op, right: String(Double(right)! / 100))
            }
        case .flip:
            switch self {
            case .error:
                return .error
            case .left(let left):
                if left.hasPrefix("-") {
                    let substring = left[left.index(after: left.startIndex)...]
                    return .left(String(substring))
                } else {
                    return .left("-" + left)
                }
            case .leftOp(left: let left, op: let op):
                if left.hasPrefix("-") {
                    let substring = left[left.index(after: left.startIndex)...]
                    return .leftOpRight(left: left, op: op, right: String(substring))
                } else {
                    return .leftOpRight(left: left, op: op, right: "-" + left)
                }
            case .leftOpRight(left: let left, op: let op, right: let right):
                if right.hasPrefix("-") {
                    let substring = right[right.index(after: right.startIndex)...]
                    return .leftOpRight(left: left, op: op, right: String(substring))
                } else {
                    return .leftOpRight(left: left, op: op, right: "-" + right)
                }
            }
        }
    }
    
}
