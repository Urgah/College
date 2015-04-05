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
    
    @IBInspectable
    var scale: CGFloat = 50 { didSet { setNeedsDisplay() }}
    var centerGraph: CGPoint = CGPoint(){ didSet { setNeedsDisplay() } }
    
    func getPointX(column: CGFloat) -> CGFloat {
        var pointX: CGFloat = centerGraph.x + scale * column
        return pointX
    }
    
    func getPointY(y: CGFloat, graphHeigth: CGFloat) -> CGFloat {
        var pointY: CGFloat = centerGraph.y + y * scale
        println("\(pointY)")
        pointY = graphHeigth - pointY
        println("\(pointY)")
        return pointY
    }


    
    override func drawRect(rect: CGRect) {
        drawAxis(rect)
        var graphHeigth: CGFloat = rect.maxX
        
        //Draw the line graph
        UIColor.blackColor().setFill()
        UIColor.blackColor().setStroke()
        
        //Set up the points line
        var graphPath = UIBezierPath()
        
        var point = CGPointMake(CGFloat(getPointX(0)), getPointY(CGFloat(graphPoints[0]), graphHeigth: graphHeigth))
        //Go to start of line
        graphPath.moveToPoint(point)
        
        //Add (x,y) points 
        for i in 1..<graphPoints.count {
            var pointY: CGFloat = getPointY(CGFloat(graphPoints[i]), graphHeigth: graphHeigth)
            
            let nextPoint: CGPoint = CGPointMake(getPointX(CGFloat(i)), pointY)

            graphPath.addLineToPoint(nextPoint)
        }
        
        graphPath.stroke()
        self.setNeedsDisplay()
    }
    
    func setGraphPoints(graphList: [Double]) {
        var internGraphPoints: [CGFloat] = []
        for i in 0..<graphList.count {
            internGraphPoints.append(CGFloat(graphList[i]))
        }
        
        self.graphPoints = internGraphPoints;
    }
    
    
    //Draw axis from here
    func drawAxis(rect: CGRect) {
        var graphPath = UIBezierPath()
        UIColor.blueColor().setFill()
        UIColor.blueColor().setStroke()
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        //xmin tot xmax
        graphPath.moveToPoint(CGPoint(x: 0, y: rect.midX))
        graphPath.addLineToPoint(CGPoint(x: screenWidth, y: rect.midX))
        //ymin tot ymax
        graphPath.moveToPoint(CGPoint(x: screenWidth/2, y: 0))
        graphPath.addLineToPoint(CGPoint(x: screenWidth/2, y: screenHeight))
        graphPath.stroke()
        
        centerGraph = CGPoint(x: screenWidth/2, y: rect.midX)
        drawAxisPoints(rect)
    }
    
    func drawAxisPoints(rect: CGRect) {
        //Draw x axis
        for i in -7..<7 {
            if (i==0) {
                continue
            }
            
            createLabelForAxis(CGPoint(x: centerGraph.x + scale*CGFloat(i), y: rect.midX + CGFloat(10)), number: i)
        }
        
        //Draw y axis
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        for i in -7..<7 {
            if (i==0) {
                continue
            }
            
            createLabelForAxis(CGPoint(x: screenSize.width/2 + CGFloat(10), y: centerGraph.y + scale*CGFloat(i)), number: i * -1)
        }
        
    }
    
    func createLabelForAxis(point: CGPoint, number: Int) {
        var label = UILabel(frame: CGRectMake(point.x, point.y, scale, scale))
        label.text = "\(number)"
        label.center = point
        label.textAlignment = NSTextAlignment.Center
        self.addSubview(label)
    }
    
}
