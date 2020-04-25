//
//  Caocap.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 05/04/1440 AH.
//  Copyright © 1440 Ficruty. All rights reserved.
//

import UIKit

class Caocap {
    private var _key: String
    private var _imageURL: String?
    private var _color: Int
    private var _name: String
    private var _bio: String
    private var _website: String
    private var _owners: [String]
    
    var key: String {
        return _key
    }
    var imageURL: String? {
        return _imageURL
    }
    var color: Int {
        return _color
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
    var owners: [String] {
        return _owners
    }
    
    init(key: String, dictionary: [String: Any]) {
        self._key = key
        self._imageURL = dictionary["imageURL"] as? String
        self._color = dictionary["color"] as? Int ?? 3
        self._name = dictionary["name"] as? String ?? "loading..."
        self._bio = dictionary["bio"] as? String ?? ""
        self._website = dictionary["website"] as? String ?? ""
        self._owners = dictionary["owners"] as? [String] ?? [""]
    }
    
}

