//
//  Chat.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 27/02/1440 AH.
//  Copyright © 1440 Ficruty. All rights reserved.
//

import Foundation

enum ChatType: String {
    case contact
    case group
    case room
}

class Chat {
    private var _key: String
    private var _imageURL: String?
    private var _color: Int
    private var _name: String
    private var _bio: String
    private var _members: [String]
    private var _messages: [String]
    private var _type: String
    
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
    var key: String {
        return _key
    }
    var members: [String] {
        return _members
    }
    var messages: [String] {
        return _messages
    }
    var type: ChatType? {
        return ChatType(rawValue: _type)
    }
    
  
    init(key: String, dictionary: [String: Any]) {
        self._key = key
        self._imageURL = dictionary["imageURL"] as? String
        self._color = dictionary["color"] as? Int ?? 3
        self._name = dictionary["name"] as? String ?? ""
        self._bio = dictionary["bio"] as? String ?? ""
        self._members = dictionary["members"] as? [String] ?? [""]
        self._messages = dictionary["messages"] as? [String] ?? [""]
        self._type = dictionary["type"] as? String ?? ""
        
    }
    
}
