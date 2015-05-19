//
//  FirstViewController.swift
//  BreakoutGame
//
//  Created by Eelco on 18/05/15.
//  Copyright (c) 2015 Eelco. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    @IBOutlet weak var gameView: UIView!

    let BallSize: CGFloat = 40.0
    let PaddleSize = CGSize(width: 80.0, height: 20.0)
    let PaddleCornerRadius: CGFloat = 5.0
    let PaddleColor = UIColor.redColor()
    
    let breakout = BreakOutBehaviour()
    lazy var animator: UIDynamicAnimator = { UIDynamicAnimator(referenceView: self.gameView) }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animator.addBehavior(breakout)
        gameView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "pushBall:"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var rect = gameView.bounds
        rect.size.height *= 2
        
        breakout.addBarrier(UIBezierPath(rect: rect), named: "box")
        
        for ball in breakout.balls {
            if !CGRectContainsRect(gameView.bounds, ball.frame) {
                placeBall(ball)
                animator.updateItemUsingCurrentState(ball)
            }
        }
    }
    
    // ball
    func placeBall(ball: UIView) {
        var center = CGPoint(0,0)
        ball.center = center
    }
    
    func pushBall(gesture: UITapGestureRecognizer) {
        if gesture.state == .Ended {
            if breakout.balls.count == 0 {
                let ball = createBall()
                placeBall(ball)
                breakout.addBall(ball)
            }
            breakout.pushBall(breakout.balls.last!)
        }
    }
    
    func createBall() -> UIView {
        let ball = UIView(frame: CGRect(origin: CGPoint.zeroPoint, size: CGSize(width: BallSize, height: BallSize)))
        ball.backgroundColor = UIColor.blackColor()
        ball.layer.cornerRadius = BallSize / 2.0
        ball.layer.borderColor = UIColor.blackColor().CGColor
        ball.layer.borderWidth = 2.0
        ball.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        ball.layer.shadowOpacity = 0.5
        return ball
    }
}

