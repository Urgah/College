//
//  SecondViewController.swift
//  BreakoutGame
//
//  Created by Eelco on 18/05/15.
//  Copyright (c) 2015 Eelco. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var saveSettingsButton: UIButton!
    @IBOutlet weak var saveUiSwitch: UISwitch!
    var automaticSave: Bool = false
    @IBAction func uiSwitchChanged(sender: UISwitch) {
        automaticSave = sender.on
        saveSettingsButton.hidden = automaticSave

        settings?.saveInstant = automaticSave
        settings?.setSettings()
    }
    
    @IBOutlet weak var rowLabel: UILabel!
    @IBOutlet weak var rowSlider: UISlider!
    @IBAction func rowSliderSet(sender: UISlider) {
        settings?.rows = CGFloat(round(sender.value))
        var rowSliderNumb = Int(round(rowSlider.value))
        
        rowLabel.text = "Rows: \(rowSliderNumb)"
        if automaticSave {
            saveSettings()
        }
    }
    

    @IBOutlet weak var columnLabel: UILabel!
    @IBOutlet weak var columnSlider: UISlider!
    @IBAction func columnSliderSet(sender: UISlider) {
        settings?.columns = CGFloat(round(sender.value))
        var columnSliderNumb = Int(round(columnSlider.value))
        
        columnLabel.text = "Columns: \(columnSliderNumb)"
        if automaticSave {
            saveSettings()
        }
    }
    
    func saveSettings() {
        settings?.setSettings()
        var gameView = self.tabBarController?.viewControllers?[0] as! UIViewController
        gameView.viewDidLoad()
    }
    
    @IBAction func saveSettingsAndResetGame(sender: UIButton) {
        saveSettings()
    }
    
    
    @IBOutlet weak var paddleSlider: UISlider!
    @IBOutlet weak var paddleLabel: UILabel!
    @IBAction func paddleSliderSet(sender: UISlider) {
        settings?.paddleSize = CGFloat(round(sender.value))
        var paddleSliderNumb = Int(round(sender.value))
        
        paddleLabel.text = "Paddle width: \(paddleSliderNumb)"
        
        if automaticSave {
            saveSettings()
        }
    }
    
    @IBOutlet weak var speedSlider: UISlider!
    @IBOutlet weak var speedLabel: UILabel!
    @IBAction func speedSliderSet(sender: UISlider) {
        settings?.speed = CGFloat(round(sender.value))
        var speedSliderNumb = Int(round(sender.value))
        
        speedLabel.text = "Speed: \(speedSliderNumb)"
        
        if automaticSave {
            saveSettings()
        }
    }

    @IBOutlet weak var changeDifficulty: UISegmentedControl!

    var lifes = 3
    @IBAction func difficultySet(sender: UISegmentedControl)
    {
        switch sender.selectedSegmentIndex {
        case 0: lifes = 5
        case 1: lifes = 3
        case 2: lifes = 1
        default: lifes = 3
        }
        
        settings?.lifes = lifes
        
        if automaticSave {
            saveSettings()
        }
    }
    
    var settings: Settings?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        settings = Settings()
        
        rowSlider.value = Float(settings!.rows)
        rowLabel.text = "Rows: \(settings!.rows)"
        
        columnLabel.text = "Column: \(settings!.columns)"
        columnSlider.value = Float(settings!.columns)
        
        paddleLabel.text = "Paddle width: \(settings!.paddleSize)"
        paddleSlider.value = Float(settings!.paddleSize)
        
        speedLabel.text = "Speed: \(settings!.speed)"
        speedSlider.value = Float(settings!.speed)
        
        var selectedSegment = settings?.lifes
        var difficulty: Int = 0
        switch selectedSegment! {
        case 5: difficulty = 0
        case 3: difficulty = 1
        case 1: difficulty = 2
        default: difficulty = 1
        }
        
        changeDifficulty.selectedSegmentIndex = difficulty
        saveUiSwitch.on = settings!.saveInstant
        automaticSave = settings!.saveInstant
        saveSettingsButton.hidden = settings!.saveInstant
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

