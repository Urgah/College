//
//  TweetImageViewController.swift
//  Smashtag
//
//  Created by Eelco on 08/05/15.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import UIKit

class TweetImageViewController: UIViewController {
    var imageUrl: NSURL? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        println("\(imageUrl)")
    }
    
    func updateUI() {
        imageView?.image = nil
        if let url = imageUrl {
            dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)) {
                let imageData = NSData(contentsOfURL: url)
                dispatch_async(dispatch_get_main_queue()) {
                    if url == self.imageUrl {
                        if imageData != nil {
                            self.imageView?.image = UIImage(data: imageData!)
                        } else {
                            self.imageView?.image = nil
                        }
                    }
                }
            }
        }
    }
}
