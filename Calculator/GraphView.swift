//
//  GraphView.swift
//  Calculator
//
//  Created by Ioane Sharvadze on 11/19/15.
//  Copyright © 2015 Ioane Sharvadze. All rights reserved.
//

import UIKit


@IBDesignable
class GraphView: UIView {
    
    
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
        axesDrawer.drawAxesInRect(rect, origin: origin ?? defaultOrigin, pointsPerUnit: scale)
    }
    
}
