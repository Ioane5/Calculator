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