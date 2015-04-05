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
    var points: [Double] = [0, 1, 2, 3, 4, 5]
    override func viewDidLoad() {
        super.viewDidLoad()
        graphView.setGraphPoints(points)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
