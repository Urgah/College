//
//  GraphView.swift
//  Calc
//
//  Created by Eelco on 03/04/15.
//  Copyright (c) 2015 HAN ICA. All rights reserved.
//

import UIKit

protocol GraphData: class {
    func getData(sender:GraphView) -> [CGPoint]
}

@IBDesignable
class GraphView: UIView {
    //var graphPoints: [CGPoint] = []
    weak var graphData: GraphData?
    
    @IBInspectable
    var scale: CGFloat = 50 { didSet { setNeedsDisplay() }}
    var origin: CGPoint = CGPoint(x: 0, y:0)
    var originSet: Bool = false
    var centerGraph: CGPoint = CGPoint(){
        didSet {
            setNeedsDisplay()
            if(!originSet) {
                origin = centerGraph
                originSet = true
            }
        }
    }
    
    var graphHeigth: CGFloat = 0
    
    func turnY(pointY: CGFloat) -> CGFloat {
        return self.graphHeigth - pointY
    }
    
    func getPointX(column: CGFloat) -> CGFloat {
        var pointX: CGFloat = centerGraph.x + scale * column
        return pointX
    }
    
    func getPointY(y: CGFloat) -> CGFloat {
        var pointY: CGFloat = centerGraph.y + y * scale
        //turn graph
        pointY = turnY(pointY)
        return pointY
    }

    override func drawRect(rect: CGRect) {
        for view in self.subviews {
            view.removeFromSuperview()
        }
        
        self.graphHeigth = rect.maxX
        drawAxis(rect)
        println("drawRect")
        
        //Draw the line graph
        UIColor.blackColor().setFill()
        UIColor.blackColor().setStroke()
        
        if var graphPoints = graphData?.getData(self) {
            //Set up the points line
            var graphPath = UIBezierPath()
            var point = CGPoint(x: getPointX(graphPoints[0].x), y: getPointY(graphPoints[0].y))
        
            //Go to start of line
            graphPath.moveToPoint(point)
        
            //Add (x,y) points
            for i in 1..<graphPoints.count {
                let pointY: CGFloat = getPointY(CGFloat(graphPoints[i].y))
                let nextPoint: CGPoint = CGPoint(x: getPointX(graphPoints[i].x), y: pointY)
            
                graphPath.addLineToPoint(nextPoint)
            }
        
            graphPath.stroke()
        }
    }

    //Draw axis from here
    func drawAxis(rect: CGRect) {
        var graphPath = UIBezierPath()
        UIColor.blueColor().setFill()
        UIColor.blueColor().setStroke()
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        if(!originSet) {
            centerGraph = CGPoint(x: screenWidth/2, y: rect.midX)
        }
        
        //xmin tot xmax
        graphPath.moveToPoint(CGPoint(x: 0, y: turnY(centerGraph.y)))
        graphPath.addLineToPoint(CGPoint(x: screenWidth, y: turnY(centerGraph.y)))
        //ymin tot ymax
        graphPath.moveToPoint(CGPoint(x: centerGraph.x, y: 0))
        graphPath.addLineToPoint(CGPoint(x: centerGraph.x, y: screenHeight))

        graphPath.stroke()
        
        drawAxisPoints(rect)
    }
    
    func drawAxisPoints(rect: CGRect) {
        //Draw x axis
        for i in -50..<50 {
            if (i==0 || i % 2 == 0) {
                continue
            }
            
            createLabelForAxis(CGPoint(x: centerGraph.x + scale*CGFloat(i), y: turnY(centerGraph.y + CGFloat(10))), number: i)
        }
        
        //Draw y axis
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        for i in -50..<50 {
            if (i == 0 || i % 2 == 0) {
                continue
            }

            createLabelForAxis(CGPoint(x: centerGraph.x + CGFloat(10), y: turnY(centerGraph.y + scale*CGFloat(i))), number: i)
        }
    }
    
    func createLabelForAxis(point: CGPoint, number: Int) {
        var label = UILabel(frame: CGRectMake(point.x, point.y, scale*2, scale*2))
        label.text = "\(number)"
        label.center = point
        label.textAlignment = NSTextAlignment.Center
        self.addSubview(label)
    }
    
    func zoom(gesture: UIPinchGestureRecognizer) {
        println("zoom")
        if gesture.state == .Changed {
            scale *= gesture.scale
            gesture.scale = 1.0
        }
    }
    
    func move(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
            case .Ended: fallthrough
            case .Changed:
                println("pan")
                let translation = gesture.translationInView(self)
                centerGraph.x += translation.x
                // - because when you move up you want the x-axis to go down to have the same behaviour as in the browser
                centerGraph.y -= translation.y
                gesture.setTranslation(CGPointZero, inView: self)
            default: break
        }
    }
    
    func center(gesture: UITapGestureRecognizer) {
            println("double tab")
        if gesture.state == .Ended {
            var clickedPoint = gesture.locationInView(self)
            var newPoint = CGPoint(x: clickedPoint.x, y: turnY(clickedPoint.y))
            centerGraph = newPoint
        }
    }
}