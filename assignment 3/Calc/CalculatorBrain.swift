//
//  CalculatorBrain.swift
//  Calc
//
//  Created by Eelco on 24/02/15.
//  Copyright (c) 2015 HAN ICA. All rights reserved.
//

import Foundation

class CalculatorBrain {
    private var opStack = [Op]()
    var displayText: String?
    
    private enum Op: Printable {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        case Variable(String)
        
        var description: String {
            get {
                switch self {
                    case .Operand(let operand):
                        return "\(operand)"
                    case .BinaryOperation(let symbol, _):
                        return symbol
                    case .UnaryOperation(let symbol, _):
                        return symbol
                    case .Variable(let variable):
                        return variable
                }
            }
        }
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    
    var variableValues: Dictionary<String,Double>?
    func pushOperand(variable: String) -> Double? {
        opStack.append(Op.Variable(variable))
        return evaluate()
    }
    
    private var knownOps = [String:Op]()
    
    init() {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        
        learnOp(Op.BinaryOperation("×", *))
        learnOp(Op.BinaryOperation("÷") { $1 / $0 })
        learnOp(Op.BinaryOperation("−") { $1 - $0 })
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.UnaryOperation("√", sqrt))
        learnOp(Op.UnaryOperation("cos", cos))
        learnOp(Op.UnaryOperation("sin", sin))
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            
            switch op {
            case .Operand(let operand):
                return(operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                        return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            case .Variable(let variable):
                return(variableValues?["x"], remainingOps)
            }
            
        }
        
        return (nil, ops)
    }
    
    //check if there is a variable in the opstack
    private func checkOpstack() -> Bool {
        for item in opStack {
            var tempItem = "\(item)"
            if tempItem == "M" {
                return true
            }
        }
        
        return false
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        println("\(opStack) = \(result) with \(remainder) left over")
        
        if variableValues == nil && checkOpstack(){
            return nil
        }
        return result
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        
        return evaluate()
    }
    
    func clearStack() {
        opStack.removeAll(keepCapacity: true)
        variableValues?.removeAll(keepCapacity: true)
    }
    
    var description: String { get { return secondDisplayText } }
    
    private var secondDisplayText: String = ""
    func setSecondDisplay() {
        var tempStack = opStack
        var tempSecondDisplayText = ""
        var numberStack: [String] = []
      
        for stackItem in tempStack {
            var item = "\(stackItem)"
            if item == "3.14159265358979" { item = "π" }
        
            switch item {
                case "cos", "sin", "√":
                    if numberStack.count < 1 {
                        tempSecondDisplayText = "\(item)(\(tempSecondDisplayText))"
                    }
                    else {
                        tempSecondDisplayText += "\(item)(\(numberStack.removeLast()))"
                    }
                case "+", "−":
                    if numberStack.count < 2 {
                        tempSecondDisplayText = checkDisplay(tempSecondDisplayText)
                        if checkNumberstack(numberStack.count) {
                            tempSecondDisplayText = "\(tempSecondDisplayText)\(item)\(numberStack.removeLast())" }
                    }
                    else {
                        tempSecondDisplayText += seperateOperations(tempSecondDisplayText)
                        tempSecondDisplayText += "\(numberStack.removeLast())\(item)\(numberStack.removeLast())"
                    }
                case "×":
                    if numberStack.count < 2 {
                        tempSecondDisplayText = checkDisplay(tempSecondDisplayText)
                        if checkNumberstack(numberStack.count) {
                            tempSecondDisplayText = "\(numberStack.removeLast())\(item)(\(tempSecondDisplayText))"
                        }
                    }
                    else {
                        tempSecondDisplayText += seperateOperations(tempSecondDisplayText)
                        tempSecondDisplayText += "\(numberStack.removeLast())\(item)\(numberStack.removeLast())"
                    }
                case "÷":
                if numberStack.count < 2 {
                    tempSecondDisplayText = checkDisplay(tempSecondDisplayText)
                    if checkNumberstack(numberStack.count) {
                        tempSecondDisplayText = "(\(tempSecondDisplayText))\(item)\(numberStack.removeLast())"
                    }
                }
                else {
                    var lastNumber = numberStack.removeLast()
                    var firstNumber = numberStack.removeLast()
                    tempSecondDisplayText += seperateOperations(tempSecondDisplayText)
                    tempSecondDisplayText += "\(firstNumber)\(item)\(lastNumber)"
                }
                default:
                    numberStack.append(item)
            }
        }

        secondDisplayText = tempSecondDisplayText
    }
    
    //Func to check if there are enough numbers
    private func checkDisplay(display: String) -> String {
        if display == "" {
            return "?"
        }
        
        return display
    }
    
    //Function to check if there are enough numbers to perform the operation
    private func checkNumberstack(number: Int) -> Bool {
        if number < 1 { return false }
        return true
    }
    
    private func seperateOperations (displayText: String) -> String {
        if displayText == "" {
            return ""
        }
        
        return ", "
    }
}