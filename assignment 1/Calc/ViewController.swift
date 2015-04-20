//
//  ViewController.swift
//  Calc
//
//  Created by Mad Eelco on 10/02/15.
//  Copyright (c) 2015 HAN ICA. All rights reserved.
//

import UIKit

class ViewController : UIViewController
{
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var displayOperand: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    
    @IBAction func appendDigit(sender: UIButton){
        let digit = sender.currentTitle!
        
        //make sure we  don't place 2 dots
        if display.text?.rangeOfString(".") != nil && sender.currentTitle == "." {
            return
        }
        
        //add number to 2nd display
        displayOperand.text? += " \(sender.currentTitle!)"
        
        //add number to main display
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        
        displayOperand.text? += " \(operation)"
        
        switch operation {
        case "×": performOperation {$0 * $1}
            // its not allowed to divide by 0. There should be a math error
        case "÷": performOperation {
            if $0 == 0 {
                return 0
            }
            
            return $1 / $0
        }
        case "+": performOperation {$0 + $1}
        case "−": performOperation {$1 - $0}
        case "√": performOperation2 { sqrt($0) }
        case "π": performOperation2 {$0 * M_PI}
            //in rad
        case "sin": performOperation2 { sin($0) }
        case "cos": performOperation2 { cos($0) }
        default: break
        }
    }
    
    @IBAction func clearLastDigit() {
        display.text = display.text?.substringToIndex(display.text!.endIndex.predecessor())
    }
    
    @IBAction func clearDisplay() {
        userIsInTheMiddleOfTypingANumber = false
        display.text = "0"
        operandStack.removeAll(keepCapacity: false)
        displayOperand.text = ""
    }
    
    func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    func performOperation2(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    var operandStack = Array<Double>()
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
        println("OperandStack = \(operandStack)")
    }
    
    var displayValue: Double {
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
}

