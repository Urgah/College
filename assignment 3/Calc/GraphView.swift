//
//  GraphView.swift
//  Calc
//
//  Created by Eelco on 03/04/15.
//  Copyright (c) 2015 HAN ICA. All rights reserved.
//

import UIKit


@IBDesignable
class GraphView: UIView {
    
    var graphPoints: [CGFloat] = []
    
    override func drawRect(rect: CGRect) {
        let margin: CGFloat = 20
        //Calc x
        var columnXPoint = { (column: Int) -> CGFloat in
            let spacer = (rect.width - margin * 2 - 4) / CGFloat((self.graphPoints.count))
            var x: CGFloat = CGFloat(column) * spacer
            x += margin + 2
            return x
        }
        
        //Calx y
        let topBorder: CGFloat = 50
        let bottomBorder: CGFloat = 60
        let graphHeigth = rect.height - topBorder - bottomBorder
        let maxValue = maxElement(graphPoints)
        
        var columnYPoint = { (graphPoint:CGFloat) -> CGFloat in
            var y:CGFloat = CGFloat(graphPoint) / CGFloat(maxValue) * graphHeigth
            y = graphHeigth + topBorder - y //Flip the graph
            return y
        }
        
        //Draw the line graph
        UIColor.blackColor().setFill()
        UIColor.blackColor().setStroke()
        
        //Set up the points line
        var graphPath = UIBezierPath()
        
        var point = CGPointMake(CGFloat(columnXPoint(0)), columnYPoint(graphPoints[0]))
        //Go to start of line
        graphPath.moveToPoint(point)
        
        //Add (x,y) points 
        for i in 1..<graphPoints.count {
            var pointY: CGFloat = columnYPoint(graphPoints[i])
            
            let nextPoint: CGPoint = CGPointMake(columnXPoint(i), pointY)

            graphPath.addLineToPoint(nextPoint)
        }
        
        graphPath.stroke()
    }
    
    func setGraphPoints(graphList: [Double]) {
        var internGraphPoints: [CGFloat] = []
        for i in 0..<graphList.count {
            internGraphPoints.append(CGFloat(graphList[i]))
        }
        
        self.graphPoints = internGraphPoints;
    }
}
