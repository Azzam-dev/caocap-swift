//
//  Users.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 13/03/1440 AH.
//  Copyright © 1440 Ficruty. All rights reserved.
//

import UIKit

class Users {
    private var _uid: String
    private var _imageURL: String?
    private var _color: Int
    private var _username: String
    private var _name: String
    private var _bio: String
    private var _website: String
    private var _email: String
    private var _phoneNumber: String
    private var _caocaps: [String]
    private var _followers: [String]
    private var _following: [String]
    
    var uid: String {
        return _uid
    }
    var imageURL: String? {
        return _imageURL
    }
    var color: Int {
        return _color
    }
    var username: String {
        return _username
    }
    var name: String {
        return _name
    }
    var bio: String {
        return _bio
    }
    var website: String {
        return _website
    }
    var email: String {
        return _email
    }
    var phoneNumber: String {
        return _phoneNumber
    }
    var caocaps: [String] {
        return _caocaps
    }
    var followers: [String] {
        return _followers
    }
    var following: [String] {
        return _following
    }
    
    
    init(uid: String, dictionary: [String: Any]) {
        self._uid = uid
        self._imageURL = dictionary["imageURL"] as? String
        self._color = dictionary["color"] as? Int ?? 3
        self._username = dictionary["username"] as? String ?? "username"
        self._name = dictionary["name"] as? String ?? dictionary["username"] as? String ?? "user name"
        self._bio = dictionary["bio"] as? String ?? ""
        self._website = dictionary["website"] as? String ?? ""
        self._email = dictionary["email"] as? String ?? ""
        self._phoneNumber = dictionary["phoneNumber"] as? String ?? ""
        self._caocaps = dictionary["caocaps"] as? [String] ?? [""]
        self._followers = dictionary["followers"] as? [String] ?? [""]
        self._following = dictionary["following"] as? [String] ?? [""]
    }
    
}
