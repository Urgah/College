//
//  BreakOutBehaviour.swift
//  BreakoutGame
//
//  Created by Eelco on 18/05/15.
//  Copyright (c) 2015 Eelco. All rights reserved.
//

import UIKit

class BreakOutBehaviour: UIDynamicBehavior {
    
    private let gravity = UIGravityBehavior()
    
    var collisionDelegate: UICollisionBehaviorDelegate? {
        get { return collider.collisionDelegate }
        set { collider.collisionDelegate = newValue }
    }
    
    private lazy var collider: UICollisionBehavior = {
        let lazilyCreatedCollider = UICollisionBehavior()
        lazilyCreatedCollider.action = {
            for ball in self.balls {
                if !CGRectIntersectsRect(self.dynamicAnimator!.referenceView!.bounds, ball.frame) {
                    self.removeBall(ball)
                }
            }
        }
        return lazilyCreatedCollider
        }()
    
    private lazy var ballBehavior: UIDynamicItemBehavior = {
        let lazilyCreatedBallBehavior = UIDynamicItemBehavior()
        lazilyCreatedBallBehavior.allowsRotation = false
        lazilyCreatedBallBehavior.elasticity = 1.0
        lazilyCreatedBallBehavior.friction = 0.0
        lazilyCreatedBallBehavior.resistance = 0.0
        return lazilyCreatedBallBehavior
        }()
    
    override init() {
        super.init()
        addChildBehavior(gravity)
        addChildBehavior(collider)
        addChildBehavior(ballBehavior)
    }
    
    var balls:[UIView] {
        get {
            return collider.items.filter{$0 is UIView}.map{$0 as! UIView}
        }
    }
    
    var speed:CGFloat = 1.0
    
    func addBall(ball: UIView) {
        dynamicAnimator?.referenceView?.addSubview(ball)
        collider.addItem(ball)
        ballBehavior.addItem(ball)
        
        GameViewController.ballPushed = true
    }
    
    func removeBall(ball: UIView) {
        collider.removeItem(ball)
        ballBehavior.removeItem(ball)
        ball.removeFromSuperview()
        
        GameViewController.ballPushed = false
    }
    
    func pushBall(ball: UIView) {
        let push = UIPushBehavior(items: [ball], mode: .Instantaneous)
        var settings = Settings()
        push.magnitude = settings.speed/100
        
        push.angle = CGFloat(Double(arc4random()) * M_PI * 2 / Double(UINT32_MAX))
        push.action = { [weak push] in
            if !push!.active {
                self.removeChildBehavior(push!)
            }
        }
        addChildBehavior(push)
    }
    
    func addBarrier(path: UIBezierPath, named name: NSCopying) {
        removeBarrier(name)
        collider.addBoundaryWithIdentifier(name, forPath: path)
    }
    
    func removeBarrier(name: NSCopying) {
        collider.removeBoundaryWithIdentifier(name)
    }
    
    func addBrick(brick: UIView) {
        println("brick")
        gravity.addItem(brick)
    }
    
    func removeBrick(brick: UIView) {
        gravity.removeItem(brick)
    }
}
