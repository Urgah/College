//
//  GraphViewController.swift
//  Calc
//
//  Created by Eelco on 03/04/15.
//  Copyright (c) 2015 HAN ICA. All rights reserved.
//

import UIKit


class GraphViewController: UIViewController, GraphData {
    @IBOutlet weak var graphView: GraphView! {
        didSet {
            graphView.addGestureRecognizer(UIPinchGestureRecognizer(target: graphView, action: "zoom:"))
            graphView.addGestureRecognizer(UIPanGestureRecognizer(target: graphView, action: "move:"))
            var tap = UITapGestureRecognizer(target: graphView, action: "center:")
            tap.numberOfTapsRequired = 2
            graphView.addGestureRecognizer(tap)
        }
    }
    
    var points: [CGPoint] = [CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 0)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        graphView.graphData = self
    }
    
    func getData(sender: GraphView) -> [CGPoint] {
        return points
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
