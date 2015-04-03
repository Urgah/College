//
//  handleSplitview.swift
//  Calc
//
//  Created by Eelco on 02/04/15.
//  Copyright (c) 2015 HAN ICA. All rights reserved.
//

import Foundation

class handleSplitview {
    optional func (BOOL)splitViewController:(UISplitViewController *)splitViewController {
    collapseSecondaryViewController:(UIViewController *)secondaryViewController
    ontoPrimaryViewController:(UIViewController *)primaryViewController {
    
    if ([secondaryViewController isKindOfClass:[UINavigationController class]]
    && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[DetailViewController class]]
    && ([(DetailViewController *)[(UINavigationController *)secondaryViewController topViewController] detailItem] == nil)) {
        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
        return YES;
        } else {
            return NO;
        }
    }
}