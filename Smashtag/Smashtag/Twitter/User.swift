//
//  User.swift
//  Twitter
//
//  Created by CS193p Instructor.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//  Modified by J.A. Korten, HAN University of Applied Sciences
//  13-4-2015

import Foundation

// container to hold data about a Twitter user

public struct User: Printable
{
    // JK: Should be changed: var's are a solution to Swift 1.2 incompatibiliy (let <-> init) but ugly programming practice.
    public var screenName: String = ""
    public var name: String = ""
    public var profileImageURL: NSURL? = nil
    public var verified: Bool = false
    public var id: String! = ""
    
    public var description: String { var v = verified ? " ✅" : ""; return "@\(screenName) (\(name))\(v)" }

    // MARK: - Private Implementation

    init?(data: NSDictionary?) {
        var name = data?.valueForKeyPath(TwitterKey.Name) as? String
        var screenName = data?.valueForKeyPath(TwitterKey.ScreenName) as? String
        if name != nil && screenName != nil {
            self.name = name!
            self.screenName = screenName!
            self.id = data?.valueForKeyPath(TwitterKey.ID) as? String
            if let verified = data?.valueForKeyPath(TwitterKey.Verified)?.boolValue {
                self.verified = verified
            }
            if let urlString = data?.valueForKeyPath(TwitterKey.ProfileImageURL) as? String {
                self.profileImageURL = NSURL(string: urlString)
            }
        } else {
            return nil
        }
         self.verified = false
    }
    
    var asPropertyList: AnyObject {
        var dictionary = Dictionary<String,String>()
        dictionary[TwitterKey.Name] = self.name
        dictionary[TwitterKey.ScreenName] = self.screenName
        dictionary[TwitterKey.ID] = self.id
        dictionary[TwitterKey.Verified] = verified ? "YES" : "NO"
        dictionary[TwitterKey.ProfileImageURL] = profileImageURL?.absoluteString
        return dictionary
    }

    
    init() {
        screenName = "Unknown"
        name = "Unknown"
        profileImageURL = NSURL()
        verified = false
        id = ""
    }
    
    struct TwitterKey {
        static let Name = "name"
        static let ScreenName = "screen_name"
        static let ID = "id_str"
        static let Verified = "verified"
        static let ProfileImageURL = "profile_image_url"
    }
}
