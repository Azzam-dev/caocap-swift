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
    private var _isPublished: Bool
    private var _owners: [String]
    private var _atom: String
    private var _logic: String
    
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
    var isPublished: Bool {
        return _isPublished
    }
    var owners: [String] {
        return _owners
    }
    
    var atom: Atom {
        //TODO: string -> Atom
        
        return Atom(type: .view, attributes: [(key: .color,value: "red")], children: [Atom]())
    }
    
    var logic: Logic {
        //TODO: string -> Logic


        return Logic(type: .event, attributes: [(key: .script, value: "")], children: [Logic]())
    }
    
    init(key: String, dictionary: [String: Any]) {
        self._key = key
        self._imageURL = dictionary["imageURL"] as? String
        self._color = dictionary["color"] as? Int ?? 3
        self._name = dictionary["name"] as? String ?? "loading..."
        self._bio = dictionary["bio"] as? String ?? ""
        self._isPublished = dictionary["published"] as? Bool ?? false
        self._owners = dictionary["owners"] as? [String] ?? [""]
        
        self._atom = dictionary["atom"] as? String ?? ""
        self._logic = dictionary["logic"] as? String ?? ""
        
        
    }
    
}

