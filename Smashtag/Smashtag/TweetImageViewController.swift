//
//  TweetImageViewController.swift
//  Smashtag
//
//  Created by Eelco on 08/05/15.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import UIKit

class TweetImageViewController: UIViewController, UIScrollViewDelegate {
    var imageUrl: NSURL? {
        didSet {
            getImg()
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView! 
    
    
    var imageSize = CGSizeMake(0,0)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = imageView.frame.size
    
        //zooming photo
        imageSize = imageView.frame.size
        scrollView.delegate = self
        scrollView.addSubview(imageView)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.maximumZoomScale = 5.0
        scrollView.contentSize = imageSize
        let widthScale = scrollView.bounds.size.width / imageSize.width
        let heightScale = scrollView.bounds.size.height / imageSize.height
        scrollView.minimumZoomScale = min(widthScale, heightScale)
        scrollView.setZoomScale(max(widthScale, heightScale), animated: true )
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
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
}

