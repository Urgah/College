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
            getImg()
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView! 
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func getImg() {
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
    
    private var scrollViewDidScrollOrZoom = false
    
    private func autoScale() {
        if scrollViewDidScrollOrZoom {
            return
        }
        if let sv = scrollView {
            if imageView != nil {
                sv.zoomScale = max(sv.bounds.size.height / imageView!.image!.size.height,
                    sv.bounds.size.width / imageView!.image!.size.width)
                sv.contentOffset = CGPoint(x: (imageView.frame.size.width - sv.frame.size.width) / 2,
                    y: (imageView.frame.size.height - sv.frame.size.height) / 2)
                scrollViewDidScrollOrZoom = false
            }
        }
    }
    
    
}
