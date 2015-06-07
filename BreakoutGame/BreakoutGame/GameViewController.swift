//
//  FirstViewController.swift
//  BreakoutGame
//
//  Created by Eelco on 18/05/15.
//  Copyright (c) 2015 Eelco. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UICollisionBehaviorDelegate {
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var lifesLeftLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var settings: Settings?
    var firstLoad = true
    var lifes: Int = 0
    var score: Int = 0

    let BallSize: CGFloat = 40.0
    var PaddleSize = CGSize(width: 80.0, height: 20.0)
    var difficulty: UInt32 = 0
    
    let breakout = BreakOutBehaviour()
    lazy var animator: UIDynamicAnimator = { UIDynamicAnimator(referenceView: self.gameView) }()
    
    static var ballPushed = false
    
    func reload() {
        self.gameView.setNeedsDisplay()
        paddle!.removeFromSuperview()
        removeAllBricks()
        
        if let ball = breakout.balls.first {
            breakout.removeBall(ball)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !firstLoad{
            reload()
        }
        
        settings = Settings()
        PaddleSize.width = settings!.paddleSize
        
        setLives(settings!.lifes)
        score = 0
        scoreLabel.text = "Score: \(score)"
        paddle = createPaddle()
        
        animator.addBehavior(breakout)
        gameView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "pushBall:"))
        createBricks()
        placeBricks()
        
        breakout.collisionDelegate = self
        
        gameView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "panPaddle:"))
        
        self.firstLoad = false
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
        
        if !CGRectContainsRect(gameView.bounds, paddle!.frame) {
            resetPaddle()
        }
        
        placePaddle(CGPoint(x: 0, y: 0))
        placeBricks()
    }
    
    // ball
    func placeBall(ball: UIView) {
        var center = paddle!.center
        center.y -= self.PaddleSize.height / 2 + self.PaddleSize.height
        ball.center = center
    }
    
    func pushBall(gesture: UITapGestureRecognizer) {
        if GameViewController.ballPushed == true {
            breakout.changeBallAngle(breakout.balls.last!)
            return
        }
        
        if gesture.state == .Ended {
            lifes--
            lifesLeftLabel.text = "Lives: \(lifes)"
            if lifes == 0 {
                gameLost()
                return
            }
            
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

    // paddle
    var paddle: UIView?
    func createPaddle() -> UIView {
        let paddle = UIView(frame: CGRect(origin: CGPoint(x: -1, y: -1), size: self.PaddleSize))
        paddle.backgroundColor = UIColor.blueColor()
        paddle.layer.cornerRadius = 10
        paddle.layer.borderColor = UIColor.blackColor().CGColor
        paddle.layer.borderWidth = 2.0
        paddle.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        paddle.layer.shadowOpacity = 0.5
        
        self.gameView.addSubview(paddle)
        return paddle
    }
    
    func resetPaddle() {
        paddle!.center = CGPoint(x: gameView.bounds.midX, y: gameView.bounds.maxY - paddle!.bounds.height - 100)
        addPaddleBarrier()
    }
    
    func addPaddleBarrier() {
        breakout.addBarrier(UIBezierPath(roundedRect: paddle!.frame, cornerRadius: 10), named: "Paddle")
    }
    
    func panPaddle(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Ended: fallthrough
        case .Changed:
            placePaddle(gesture.translationInView(gameView))
            gesture.setTranslation(CGPointZero, inView: gameView)
        default: break
        }
    }
    
    func placePaddle(translation: CGPoint) {
        var origin = paddle!.frame.origin
        origin.x = max(min(origin.x + translation.x, gameView.bounds.maxX - self.PaddleSize.width), 0.0)
        origin.y = gameView.bounds.maxY - paddle!.bounds.height - 100
        paddle!.frame.origin = origin
        addPaddleBarrier()
    }
    
    //bricks
    var bricks: [Brick]? = []
    
    func placeBricks() {
        //for (index, brick) in bricks {
        if let bricksLength = bricks?.count {
            for i in 0..<bricksLength {
                if var brick = bricks?[i] {
                    if !brick.isDestroyed() {
                        brick.view.frame.origin.x = brick.relativeFrame.origin.x * gameView.bounds.width
                        brick.view.frame.origin.y = brick.relativeFrame.origin.y * gameView.bounds.height
                        brick.view.frame.size.width = brick.relativeFrame.width * gameView.bounds.width
                        brick.view.frame.size.height = brick.relativeFrame.height * gameView.bounds.height
                        brick.view.frame = CGRectInset(brick.view.frame, self.BrickSpacing, self.BrickSpacing)
                        breakout.addBarrier(UIBezierPath(roundedRect: brick.view.frame, cornerRadius: self.BrickCornerRadius), named: i)
                    }
                }
            }
        }
    }
    
    let BrickTopSpacing: CGFloat = 0.05
    let BrickSpacing: CGFloat = 5.0
    let BrickCornerRadius: CGFloat = 5
    
    func setColor(randomNumber: Int) -> UIColor {
        switch(randomNumber){
        case 1: return UIColor.greenColor()
        case 2: return UIColor.yellowColor()
        case 3: return UIColor.orangeColor()
        case 4: return UIColor.redColor()
        case 5: return UIColor.blackColor()
        default: return UIColor.greenColor()
        }
    }

    func createBricks() {
        let deltaX = 1 / CGFloat(settings!.columns)
        let deltaY = 0.2 / CGFloat(settings!.rows)
        var frame = CGRect(origin: CGPointZero, size: CGSize(width: deltaX, height: deltaY))
        var index = 0
        
        bricks! = []
        for row in 0..<Int(settings!.rows) {
            for column in 0..<Int(settings!.columns) {
                
                let randomNumber =  Int(arc4random_uniform(difficulty)) + 1
                var color: UIColor = setColor(randomNumber)
                
                frame.origin.x = deltaX * CGFloat(column)
                frame.origin.y = deltaY * CGFloat(row) + self.BrickTopSpacing
                let brick = UIView(frame: frame)
                brick.backgroundColor = color
                brick.layer.cornerRadius = self.BrickCornerRadius
                brick.layer.borderColor = UIColor.blackColor().CGColor
                brick.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
                brick.layer.shadowOpacity = 0.1
                
                gameView.addSubview(brick)
            
                var newBrick = Brick(relativeFrame: frame, view: brick, hitsLeft: randomNumber, index: index)
                bricks!.append(newBrick)
                
                index++
            }
        }
        
        totalBricks = index
    }
    
    static var lastHitIndex: Int = -1
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying, atPoint p: CGPoint) {
        if let index = identifier as? Int {
            //We dont want double collision
            if index == GameViewController.lastHitIndex {
                return
            }
            GameViewController.lastHitIndex = index
            destroyBrickAtIndex(index)
        }
        else {
            //Reset the index when there is collision with no brick
            GameViewController.lastHitIndex = -1
        }
    }
    
    func removeAllBricks() {
        for i in 0..<bricks!.count {
            breakout.removeBarrier(i)
            bricks![i].setToDestroy()
            bricks![i].view.removeFromSuperview()
        }
    }
    
    private func destroyBrickAtIndex(index: Int) {
        if let brick = bricks?[index] {
            score++
            self.scoreLabel.text = "Score: \(self.score)"
            if brick.hit() {
                breakout.removeBarrier(index)
                UIView.transitionWithView(brick.view, duration: 0.2, options: .TransitionFlipFromBottom, animations: {},completion: { (success) -> Void in
                    UIView.animateWithDuration(1.0, animations: {
                            brick.view.alpha = 0.0
                            }, completion: { (success) -> Void in
                                brick.view.removeFromSuperview()
                                self.totalBricks--
                                self.checkGameWon()
                        })
                })
            }
            else {
                brick.view.backgroundColor = setColor(brick.hitsLeft)
            }
        }
    }
    
    var totalBricks: Int = 0
    func checkGameWon() {
        if totalBricks == 0 {
            let gameWonAlert = UIAlertController(title: "Game Won", message: "You won the game", preferredStyle: UIAlertControllerStyle.Alert)
                
            gameWonAlert.addAction(UIAlertAction(title: "Play again", style: .Default) { action -> Void in
                self.viewDidLoad()
            })
            self.presentViewController(gameWonAlert, animated: true, completion: nil)
        }
    }
    
    func gameLost() {
        let gameLostAlert = UIAlertController(title: "Game lost", message: "You lost the game", preferredStyle: UIAlertControllerStyle.Alert)
        gameLostAlert.addAction(UIAlertAction(title: "Play again", style: .Default) { action -> Void in
            self.viewDidLoad()
            })
        
        self.presentViewController(gameLostAlert, animated: true, completion: nil)
    }
    
    func setLives(settingLifes: Int) {
        switch settingLifes {
        case 1: difficulty = UInt32(5)
        case 3: difficulty = UInt32(3)
        case 5: difficulty = UInt32(1)
        default: difficulty = UInt32(3)
        }
        
        lifes = settingLifes + 1

        lifesLeftLabel.text = "Lives: \(lifes - 1)"
    }
}

