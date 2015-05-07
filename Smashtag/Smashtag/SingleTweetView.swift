//
//  SingleTweetView.swift
//  Smashtag
//
//  Created by Eelco on 07/05/15.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import UIKit

class SingleTweetView: UITableViewCell {
    
    
    @IBOutlet weak var tweetTextLabel: UILabel!
    var tweetCell: TweetTableViewCell? {
        didSet {
            updateUI()
        }
    }
    
    
    func updateUI() {
//        println(tweetCell?.tweet?.text)
        println(tweetTextLabel.text)
        tweetTextLabel.text = tweetCell?.tweet?.text
        println(tweetTextLabel.text)
        //tweetCell?.tweet?.urls
    }
    
    
}
