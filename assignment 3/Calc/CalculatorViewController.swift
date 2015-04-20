//
//  ViewController.swift
//  Calc
//
//  Created by Mad Eelco on 10/02/15.
//  Copyright (c) 2015 HAN ICA. All rights reserved.
//

import UIKit

class CalculatorViewController : UIViewController
{
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var displayOperand: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    
    var graphView = GraphView()
    var brain = CalculatorBrain()
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as? UIViewController
        if let nc = destination as? UINavigationController {
            destination = nc.visibleViewController
        }
        if let gvc = destination as? GraphViewController {
            gvc.title = displayOperand.text!
            gvc.points = brain.setGraphViewPoints()
        }
    }

    
    @IBAction func appendDigit(sender: UIButton){
        let digit = sender.currentTitle!
        
        //make sure we  don't place 2 dots
        if display.text?.rangeOfString(".") != nil && sender.currentTitle == "." {
            return
        }
        
        //add number to main display
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func setVariable(sender: UIButton) {
        var temp = ["x": (display.text! as NSString).doubleValue]
        brain.variableValues = temp
        display.text = "\(brain.evaluate()!)"
        userIsInTheMiddleOfTypingANumber = false
    }
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            }
            else {
                displayValue = 0
            }
            
            brain.setSecondDisplay()
            displayOperand.text? = brain.description
        }
    }
    
    @IBAction func clearLastDigit() {
        display.text = display.text?.substringToIndex(display.text!.endIndex.predecessor())
    }
    
    @IBAction func clearDisplay() {
        userIsInTheMiddleOfTypingANumber = false
        brain.clearStack()
        displayOperand.text = " "
        displayValue = nil
    }
    
    var operandStack = Array<Double>()
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if displayValue == nil {
            brain.pushOperand(display.text!)
        } else if let result = brain.pushOperand(displayValue!) {
            displayValue = result
        } else {
            displayValue = nil
        }
        
        displayOperand.text? += " \(display.text!)"
    }
    
    var displayValue: Double? {
        get {
            brain.displayText = display.text
            
            //contains a var. return nil because we dont want a result
            if display.text!.rangeOfString("M") != nil  {
                return nil
            }
            
            if display.text == "π" {
                display.text? = "\(M_PI)"
            }
            
            
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            if newValue == nil {
                display.text = "0"
            }
            else {
                display.text = "\(newValue!)"
            }
            
            userIsInTheMiddleOfTypingANumber = false
        }
    }
}

