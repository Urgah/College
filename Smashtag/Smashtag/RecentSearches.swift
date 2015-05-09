//
//  RecentSearches.swift
//  Smashtag
//
//  Created by Eelco on 09/05/15.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import Foundation

class RecentSearches {
    

    let key = "RecentSearches.RecentTwitterSearches"
    let maxSeaches = 100
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    var recentTwitterSearches: [String] {
        get { return defaults.objectForKey(key) as? [String] ?? [] }
        set { defaults.setObject(newValue, forKey: key) }
    }
    
    func add(tweetSearch: String) {
        recentTwitterSearches.append(tweetSearch)
        println(recentTwitterSearches)
    }
}