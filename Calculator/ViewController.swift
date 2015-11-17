//
//  ViewController.swift
//  Calculator
//
//  Created by Ioane Sharvadze on 10/29/15.
//  Copyright © 2015 Ioane Sharvadze. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    
    var isUserInMiddleOfNumberTyping = false;
    
    var brain = CalculatorBrain()
    
    var displayValue: Double? {
        get {
            return NSNumberFormatter().numberFromString(display.text!)?.doubleValue
        }
        set {
            if newValue != nil{
                display.text = "\(newValue!)"
            } else {
                display.text = " "
            }
            
            isUserInMiddleOfNumberTyping = false
        }
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
    }
    
    
    @IBAction func enter() {
        isUserInMiddleOfNumberTyping = false
        if displayValue != nil{
            displayValue = brain.pushOperand(displayValue!)
        }
        print("brain : \(brain)")
    }
    
    @IBAction func AppendDot() {
        let currentStr = display.text;
        let index = display.text?.rangeOfString(".")
        if index == nil{
            display.text = currentStr! + "."
        }
    }
    
    @IBAction func ClearAll() {
        isUserInMiddleOfNumberTyping = false
        display.text = "0"
        brain.clearAll()
    }
    
    @IBAction func ClearLast() {
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
}
