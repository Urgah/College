//
//  RecentTwitterController.swift
//  Smashtag
//
//  Created by Eelco on 09/05/15.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import UIKit    

class RecentTwitterController: UITableViewController {
    var recentTwitterIdentifier = "RecentTwitterSearch"
    
    var recentSearches: [String] = RecentSearches().recentTwitterSearches
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearches.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RecentTwitterCell", forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = recentSearches[indexPath.row]
        
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == recentTwitterIdentifier {
                if let ttvc = segue.destinationViewController as? TweetTableViewController {
                    if let cell = sender as? UITableViewCell {
                        ttvc.searchText = cell.textLabel?.text
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        println("henk")
        tableView.reloadData()
    }
}
