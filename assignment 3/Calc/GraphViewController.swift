//
//  GraphViewController.swift
//  Calc
//
//  Created by Eelco on 03/04/15.
//  Copyright (c) 2015 HAN ICA. All rights reserved.
//

import UIKit


class GraphViewController: UIViewController {
    @IBOutlet weak var graphView: GraphView!
    var points: [CGPoint] = [CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 1), CGPoint(x: 2, y: 2), CGPoint(x: 3, y: 3)]
    override func viewDidLoad() {
        super.viewDidLoad()
        graphView.setGraphPoints(points)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
