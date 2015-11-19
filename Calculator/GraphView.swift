//
//  GraphView.swift
//  Calculator
//
//  Created by Ioane Sharvadze on 11/19/15.
//  Copyright © 2015 Ioane Sharvadze. All rights reserved.
//

import UIKit


protocol GraphDataSource: class {
    func yForX(x:Double) -> Double?
}

@IBDesignable
class GraphView: UIView {
    
    weak var dataSource : GraphDataSource?
    
    @IBInspectable
    var lineWidth: CGFloat = 2.0 { didSet {setNeedsDisplay()}}
    
    
    @IBInspectable
    var graphPrecision : Int = 100 {didSet {setNeedsDisplay()}}
    
    @IBInspectable
    var color : UIColor = UIColor.redColor() {
        didSet {
            axesDrawer.color = color
            setNeedsDisplay()
        }
    }
    
    var defaultOrigin : CGPoint {
        return convertPoint(center,fromView: superview);
    }
    
    var axesDrawer = AxesDrawer()
    
    @IBInspectable
    var scale: CGFloat = 10.0 {
        didSet {
            axesDrawer.contentScaleFactor = contentScaleFactor
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var origin : CGPoint? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        if origin == nil {
            origin = defaultOrigin
        }
        axesDrawer.drawAxesInRect(rect, origin: origin!, pointsPerUnit: scale)
        
        if dataSource == nil {
            return
        }
        
        func getYFromX(xPoint : CGFloat) -> CGFloat? {
            let x = Double((xPoint-origin!.x)/scale)
            if let y = dataSource!.yForX(x) {
                return CGFloat(-y*Double(scale))+origin!.y
            }
            return nil
        }
        
        
        let incr = bounds.size.width / CGFloat(graphPrecision)
        let path = UIBezierPath()
        
        var currPoint = CGPoint(x: 0, y: getYFromX(0) ?? 0)

        while currPoint.x < bounds.size.width{
            path.moveToPoint(currPoint)
            currPoint.x += incr
            if let y = getYFromX(currPoint.x) {
                currPoint.y = y
            } else {
                continue
            }
            path.addLineToPoint(currPoint)
        }
        path.lineWidth = lineWidth
        color.set()
        path.stroke()
    }
    
}
