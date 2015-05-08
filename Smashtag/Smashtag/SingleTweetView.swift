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
    @IBOutlet weak var tweetImageView: UIImageView!


    var tweetText: TweetTableViewCell? {
        didSet {
            updateUI()
        }
    }
    
    var imageUrl: NSURL? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        tweetImageView?.image = nil
        if let url = imageUrl {
            dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)) {
                let imageData = NSData(contentsOfURL: url)
                dispatch_async(dispatch_get_main_queue()) {
                    if url == self.imageUrl {
                        if imageData != nil {
                            self.tweetImageView?.image = UIImage(data: imageData!)
                        } else {
                            self.tweetImageView?.image = nil
                        }
                    }
                }
            }
        }
    }
    
    
}
