//
//  Brick.swift
//  BreakoutGame
//
//  Created by Eelco on 22/05/15.
//  Copyright (c) 2015 Eelco. All rights reserved.
//

import UIKit

class Brick {
    var relativeFrame: CGRect
    var view: UIView
    var hitsLeft: Int
    var index: Int
    
    init(relativeFrame: CGRect, view: UIView, hitsLeft: Int, index: Int) {
        self.relativeFrame = relativeFrame
        self.view = view
        self.hitsLeft = hitsLeft
        self.index = index
    }
    
    func hit() {
        self.hitsLeft--
    }
}
