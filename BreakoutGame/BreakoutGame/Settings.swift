//
//  Settings.swift
//  BreakoutGame
//
//  Created by Eelco on 19/05/15.
//  Copyright (c) 2015 Eelco. All rights reserved.
//

import UIKit

class Settings {
    var rows: CGFloat = 3
    var columns: CGFloat = 5
    var speed: CGFloat = 100
    var paddleSize: CGFloat = 80
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    init() {
        getSettings()
    }
    
    func getSettings() {
        self.rows = (defaults.objectForKey("rows") as? CGFloat)!
        self.columns = (defaults.objectForKey("columns") as? CGFloat)!
        self.speed = (defaults.objectForKey("speed") as? CGFloat)!
        self.paddleSize = (defaults.objectForKey("paddleSize") as? CGFloat)!
    }
 
    func setSettings() {
        defaults.setObject(self.rows, forKey: "rows")
        defaults.setObject(self.columns, forKey: "columns")
        defaults.setObject(self.speed, forKey: "speed")
        defaults.setObject(self.paddleSize, forKey: "paddleSize")
    }
}
