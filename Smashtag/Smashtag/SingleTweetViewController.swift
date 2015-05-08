//
//  SingleTweetViewController.swift
//  Smashtag
//
//  Created by Eelco on 04/05/15.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//
import UIKit

class SingleTweetViewController: UITableViewController {

    var tweet: Tweet? {
        didSet {
            title = tweet?.user.screenName
            if let media = tweet?.media {
                //task 4
                if media.count > 0 {
                mentions.append(Mentions(title: "Images",
                    data: media.map { MentionItem.Image($0.url, $0.aspectRatio) }))
                }
            }
            if let urls = tweet?.urls {
                if urls.count > 0 {
                    mentions.append(Mentions(title: "URLs",
                        data: urls.map { MentionItem.Keyword($0.keyword) }))
                }
            }
            if let hashtags = tweet?.hashtags {
                if hashtags.count > 0 {
                    mentions.append(Mentions(title: "Hashtags",
                        data: hashtags.map { MentionItem.Keyword($0.keyword) }))
                }
            }
            if let users = tweet?.userMentions {
                if users.count > 0 {
                    mentions.append(Mentions(title: "Users",
                        data: users.map { MentionItem.Keyword($0.keyword) }))
                }
            }
        }
    }
    
    var mentions: [Mentions] = []
    struct Mentions: Printable
    {
        var title: String
        var data: [MentionItem]
        var description: String { return "\(title): \(data)" }
    }
    
    enum MentionItem: Printable
    {
        case Keyword(String)
        case Image(NSURL, Double)
        var description: String {
            switch self {
            case .Keyword(let keyword): return keyword
            case .Image(let url, _): return url.path!
            }
        }
    }

    let textCellIdentifier = "Tweet"
    let imageCellIdentifier = "Image"
    let mentionCellIdentier = "searchTwitter"
    let imageViewCellIdentifier = "imageClicked"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Task 2
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return mentions.count
    }
    
    //Task 2
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mentions[section].data.count
    }
    
    //Task 2
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let mention = mentions[indexPath.section].data[indexPath.row]
        switch mention {
        case .Keyword(let tweetText):
            let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! SingleTweetView
            cell.tweetTextLabel.text = tweetText
            return cell
        case .Image(let url, let ratio):
            let cell = tableView.dequeueReusableCellWithIdentifier(imageCellIdentifier, forIndexPath: indexPath) as! SingleTweetView
            cell.imageUrl = url
            return cell
        }
    }
    
    //Task 2
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let mention = mentions[indexPath.section].data[indexPath.row]
        switch mention {
        case .Image(_, let ratio):
            return tableView.bounds.size.width / CGFloat(ratio)
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    //Task 2
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    //Task 3
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        return mentions[section].title
    }
    
    //task 5
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == mentionCellIdentier {
                if let ttvc = segue.destinationViewController as? TweetTableViewController {
                    if let cell = sender as? SingleTweetView {
                        ttvc.searchText = cell.tweetTextLabel.text
                    }
                }
            } //task 7
            else if identifier == imageViewCellIdentifier {
                if let ivc = segue.destinationViewController as? TweetImageViewController {
                    if let cell = sender as? SingleTweetView {
                        ivc.title = title
                        ivc.imageUrl = cell.imageUrl
                    }
                }
            }
        }

    }
    
    //task 6
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if identifier == mentionCellIdentier {
            if let cell = sender as? SingleTweetView {
                if let url = cell.tweetTextLabel.text {
                    if url.hasPrefix("http") {
                        var nsUrl: NSURL = NSURL(string: url)!
                        UIApplication.sharedApplication().openURL(nsUrl)
                        return false
                    }
                }
            }
        }
        
        return true
    }

 }
