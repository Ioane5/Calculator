//
//  ViewController.swift
//  Calculator
//
//  Created by Ioane Sharvadze on 10/29/15.
//  Copyright © 2015 Ioane Sharvadze. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    
    var isUserInMiddleOfNumberTyping = false;
    
    var brain = CalculatorBrain()
    
    var displayValue: Double? {
        get {
            return NSNumberFormatter().numberFromString(display.text!)?.doubleValue
        }
        set {
            if newValue != nil{
                display.text = "\(brain)=\(newValue!)"
            } else {
                display.text = "\(brain)= ?"
            }
            isUserInMiddleOfNumberTyping = false
        }
    }
    
    @IBAction func setM() {
        if displayValue != nil {
            brain.variableValues["M"] = displayValue!
        }
        isUserInMiddleOfNumberTyping = false
    }
    
    @IBAction func useM() {
        if isUserInMiddleOfNumberTyping {
            enter()
        }
        brain.pushOperand("M")
    }
    
    @IBAction func ChangeSign() {
        if displayValue != nil && displayValue != 0{
            displayValue = -displayValue!
            isUserInMiddleOfNumberTyping = true
        }
    }
    
    @IBAction func AppendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if isUserInMiddleOfNumberTyping {
            display.text = display.text! + digit
        } else {
            display.text = digit
        }
        isUserInMiddleOfNumberTyping = true
        if display.text == "0" {
            isUserInMiddleOfNumberTyping = false
        }
    }
    
    
    @IBAction func enter() {
        if !isUserInMiddleOfNumberTyping {
            displayValue = brain.evaluate()
        } else {
            if displayValue != nil {
                displayValue = brain.pushOperand(displayValue!)
            }
        }
        isUserInMiddleOfNumberTyping = false
        print("brain : \(brain)")
    }
    
    @IBAction func AppendDot() {
        let currentStr = display.text;
        let index = display.text?.rangeOfString(".")
        if index == nil {
            display.text = currentStr! + "."
            isUserInMiddleOfNumberTyping = true
        }
    }
    
    @IBAction func ClearAll() {
        isUserInMiddleOfNumberTyping = false
        display.text = "0"
        brain.clearAll()
    }
    
    @IBAction func ClearLast() {
        if !isUserInMiddleOfNumberTyping {
            return
        }
        if display.text?.characters.count <= 1 {
            display.text = "0"
            isUserInMiddleOfNumberTyping = false
        } else {
            display.text = String(display.text!.characters.dropLast())
        }
    }
    
    @IBAction func Operate(sender: UIButton) {
        if isUserInMiddleOfNumberTyping {
            enter()
        }
        if let operation = sender.currentTitle {
            displayValue = brain.performOperation(operation)
        }
        print("brain : \(brain)")
    }
    
    
    func memEvaluator(mValue : Double) -> Double? {
        let variableValueCopy = brain.variableValues
        brain.variableValues["M"] = mValue
        let ans = brain.evaluate()
        // return old varialeValues
        brain.variableValues = variableValueCopy
        return ans
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination : UIViewController? = segue.destinationViewController as UIViewController
        if let navCon = destination as? UINavigationController{
            destination = navCon.visibleViewController
        }
        if let gvc = destination as? GraphViewController {
            if let segueIdentifier = segue.identifier {
                switch segueIdentifier {
                case "Show graph":
                    gvc.graphFunction = memEvaluator
                    gvc.graphDescription = brain.description.componentsSeparatedByString(",").last
                    break
                default:
                    gvc.graphFunction = nil
                    gvc.graphDescription = nil
                    break
                }
            }
        }
        
    }
}

