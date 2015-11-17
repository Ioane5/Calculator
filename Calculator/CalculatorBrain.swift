//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Ioane Sharvadze on 11/17/15.
//  Copyright © 2015 Ioane Sharvadze. All rights reserved.
//

import Foundation


class CalculatorBrain {
    
    
    private var opStack = [Op]()
    
    private var knownOps = [String:Op]()
    
    private enum Op{
        case Operand(Double)
        case UnaryOperation(String,Double -> Double)
        case BinaryOperation(String,(Double,Double)->Double)
        case Constant(String,Double)
    }
    
    
    init() {
        knownOps["×"] = Op.BinaryOperation("×",*)
        knownOps["÷"] = Op.BinaryOperation("÷") {$1/$0}
        knownOps["+"] = Op.BinaryOperation("+",+)
        knownOps["−"] = Op.BinaryOperation("−") {$1-$0}
        knownOps["sin"] = Op.UnaryOperation("sin",sin)
        knownOps["cos"] = Op.UnaryOperation("cos",cos)
        knownOps["√"] = Op.UnaryOperation("√",sqrt)
        knownOps["π"] = Op.Constant("π",M_PI)
    }
    
    
    private  func evaluate(ops : [Op]) -> (result: Double?,remainingOps:[Op ]) {
        
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            
            switch op {
            case .Operand(let operand):
                return (operand,remainingOps)
            case .UnaryOperation(_,let operation):
                let operationEvalution = evaluate(remainingOps)
                if let operand = operationEvalution.result {
                    return (operation(operand),operationEvalution.remainingOps)
                }
                
            case .BinaryOperation(_,let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result{
                        return (operation(operand1,operand2),op2Evaluation.remainingOps)
                    }
                }
            case .Constant(_, let constant):
                return (constant,remainingOps)
            }
        }
        return (nil,ops)
    }
    
    func clearAll() {
        opStack.removeAll()
    }
    
    func evaluate() ->Double? {
        let (result,_) = evaluate(opStack)
        return result
    }
    
    func pushOperand(operand:Double) -> Double?{
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol:String) -> Double?{
        print("opstack \(opStack) --- \(knownOps)")
        if let op = knownOps[symbol] {
            opStack.append(op)
        }
        return evaluate()
    }
    
}