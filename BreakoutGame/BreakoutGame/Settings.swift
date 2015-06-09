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
    var lifes: Int = 3
    var saveInstant: Bool = false
    
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    init() {
        getSettings()
    }
    
    func getSettings() {
        if let rows = (defaults.objectForKey("rows") as? CGFloat) {
            self.rows = rows
        }
        
        if let columns = (defaults.objectForKey("columns") as? CGFloat) {
            self.columns = columns
        }
        
        
        if let speed = (defaults.objectForKey("speed") as? CGFloat) {
            self.speed = speed
        }
        
        if let paddleSize = (defaults.objectForKey("paddleSize") as? CGFloat) {
            self.paddleSize = paddleSize
        }
        
        if let lifes = (defaults.objectForKey("lifes") as? Int) {
            self.lifes = lifes
        }
        
        if let saveInstant = (defaults.objectForKey("saveInstant") as? Bool) {
            self.saveInstant = saveInstant
        }
    }
 
    func setSettings() {
        defaults.setObject(self.rows, forKey: "rows")
        defaults.setObject(self.columns, forKey: "columns")
        defaults.setObject(self.speed, forKey: "speed")
        defaults.setObject(self.paddleSize, forKey: "paddleSize")
        defaults.setObject(self.lifes, forKey: "lifes")
        defaults.setObject(self.saveInstant, forKey: "saveInstant")
    }
}
