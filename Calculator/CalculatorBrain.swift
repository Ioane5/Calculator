//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Ioane Sharvadze on 11/17/15.
//  Copyright © 2015 Ioane Sharvadze. All rights reserved.
//

import Foundation


class CalculatorBrain : CustomStringConvertible{
    
    
    private var opStack = [Op]()
    
    private var knownOps = [String:Op]()
    private var reverseOps = [String]()
    
    var variableValues = [String:Double]()
    
    private enum Op : CustomStringConvertible{
        case Operand(Double)
        case UnaryOperation(String,Double -> Double)
        case BinaryOperation(String,(Double,Double)->Double)
        case Constant(String,Double)
        case Variable(String)
        
        var description : String{
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol,_):
                    return symbol
                case .BinaryOperation(let symbol,_):
                    return symbol
                case .Constant(let constantName,_):
                    return constantName
                case .Variable(let symbol):
                    return symbol
                }
            }
        }
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
        reverseOps.append("÷")
        reverseOps.append("−")
    }
    
    private func evaluateDescription(ops : [Op]) -> (result: String, remainingOps:[Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            
            var description : String
            switch op {
            case .UnaryOperation:
                let descriptionEval = evaluateDescription(remainingOps)
                description = "\(op)(\(descriptionEval.result))"
                remainingOps = descriptionEval.remainingOps
                break
            case .BinaryOperation:
                let descriptionEval1 = evaluateDescription(remainingOps)
                let descriptionEval2 = evaluateDescription(descriptionEval1.remainingOps)
                description = "\(descriptionEval2.result)\(op)\(descriptionEval1.result)"
                remainingOps = descriptionEval2.remainingOps
            case .Operand:
                fallthrough
            case .Constant:
                fallthrough
            case .Variable:
                description = "\(op)"
                break
            }
            return (description,remainingOps)
            
        }
        return ("?",ops)
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
            case .Variable(let varName):
                if let varValue = variableValues[varName] {
                    return (varValue,remainingOps)
                }
            }
        }
        return (nil,ops)
    }
    
    func clearAll() {
        opStack.removeAll()
        variableValues.removeAll()
    }
    
    func evaluate() ->Double? {
        let (result,_) = evaluate(opStack)
        return result
    }
    
    func pushOperand(operand:Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func pushOperand(symbol: String) -> Double? {
        opStack.append(.Variable(symbol))
        return evaluate()
    }
    
    func performOperation(symbol:String) -> Double? {
        if let op = knownOps[symbol] {
            opStack.append(op)
        }
        return evaluate()
    }
    
    var description : String{
        get {
            var history = [String]()
            var remainingOps = opStack
            while true {
                let evaluated = evaluateDescription(remainingOps)
                history.append(evaluated.result)
                remainingOps = evaluated.remainingOps
                if remainingOps.isEmpty {
                    break
                }
            }
            return history.joinWithSeparator(",")
        }
    
    }
    
}