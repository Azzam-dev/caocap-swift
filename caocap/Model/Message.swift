//
//  Message.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 12/04/1440 AH.
//  Copyright © 1440 Ficruty. All rights reserved.
//

import UIKit

class Message {
    private var _key: String
    private var _senderUid: String
    private var _imageURL: String?
    private var _color: Int
    private var _username: String
    private var _time: String
    private var _message: String
    
    var key: String {
        return _key
    }
    var senderUid: String {
        return _senderUid
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
    var time: String {
        return _time
    }
    var message: String {
        return _message
    }
    
    
    init(key: String, dictionary: [String: Any]) {
        self._key = key
        self._senderUid = dictionary["senderUid"] as? String ?? ""
        self._imageURL = dictionary["imageURL"] as? String
        self._color = dictionary["color"] as? Int ?? 3
        self._username = dictionary["username"] as? String ?? "username"
        self._time = dictionary["time"] as? String ?? "??"
        self._message = dictionary["message"] as? String ?? ""
    }
    
}
