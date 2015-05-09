//
//  RecentSearches.swift
//  Smashtag
//
//  Created by Eelco on 09/05/15.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import Foundation

class RecentSearches {
    

    let key = "RecentSearches"
    let maxSeaches = 100
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    var recentTwitterSearches: [String] {
        get { return defaults.objectForKey(key) as? [String] ?? [] }
        set { defaults.setObject(newValue, forKey: key) }
    }
    
    func add(tweetSearch: String) {
        for var i = 0; i < recentTwitterSearches.count; i++ {
            if tweetSearch == recentTwitterSearches[i] {
                recentTwitterSearches.removeAtIndex(i)
                break
            }
        }
        
        if recentTwitterSearches.count == maxSeaches {
            recentTwitterSearches.removeAtIndex(99)
        }
        
        recentTwitterSearches.insert(tweetSearch, atIndex: 0)
    }
}