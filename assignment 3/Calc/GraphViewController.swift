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
    var points: [Double] = [1,0]
    override func viewDidLoad() {
        graphView.setGraphPoints(points)
        super.viewDidLoad()
    }

   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
