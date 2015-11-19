//
//  GraphViewController.swift
//  Calculator
//
//  Created by Ioane Sharvadze on 11/19/15.
//  Copyright © 2015 Ioane Sharvadze. All rights reserved.
//

import UIKit


class GraphViewController: UIViewController , GraphDataSource {
    
    @IBOutlet private weak var graphView: GraphView! {
        didSet {
            graphView.dataSource = self
        }
    }
    @IBAction func ActionTap(gesture: UITapGestureRecognizer) {
        let doubleTapLocation = gesture.locationInView(graphView)
        graphView.origin = doubleTapLocation
    }
    
    @IBAction func ActionPinch(gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .Ended: fallthrough
        case .Changed:
            graphView.scale *= gesture.scale
            gesture.scale = 1
            break
        default: break
        }
    }
    
    @IBAction func ActionPan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Ended: fallthrough
        case .Changed:
            let translation = gesture.translationInView(graphView)
            graphView.origin?.x += translation.x
            graphView.origin?.y += translation.y
            gesture.setTranslation(CGPointZero, inView: graphView)
            break
        default: break
        }
    }
    
    var graphDescription : String? {
        didSet {
            title = graphDescription ?? "Graph it!"
        }
    }
    var graphFunction : (Double-> Double?)? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        graphView?.setNeedsDisplay()
    }
    
    func yForX(x: Double) -> Double? {
        return graphFunction?(x)
    }
    
}