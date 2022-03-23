//
//  Caocap.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 05/04/1440 AH.
//  Copyright © 1440 Ficruty. All rights reserved.
//

import UIKit

enum CaocapType: String {
    case template
    case code
    case block
}

class Caocap {
    private var _key: String
    private var _imageURL: String?
    private var _color: Int
    private var _name: String
    private var _bio: String
    private var _isPublished: Bool
    private var _owners: [String]
    private var _type: CaocapType
    private var _link: String?
    private var _code: [String: String]?
    private var _templates: [Template]?
    private var _blocks: [String: String]? //TODO: this should be of type Block
    
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
    var type: CaocapType {
        return _type
    }
    var link: String? {
        return _link
    }
    var code: [String: String]? {
        return _code
    }
    
    var templates: [Template]? {
        return _templates
    }
    
    var blocks: [String: String]? {
        return _blocks
    }
    
    init(key: String, dictionary: [String: Any]) {
        self._key = key
        self._imageURL = dictionary["imageURL"] as? String
        self._color = dictionary["color"] as? Int ?? 3
        self._name = dictionary["name"] as? String ?? "loading..."
        self._bio = dictionary["bio"] as? String ?? ""
        self._isPublished = dictionary["published"] as? Bool ?? false
        self._owners = dictionary["owners"] as? [String] ?? [""]
        
        let type = dictionary["type"] as? String ?? ""
        switch type {
        case "code":
            _type = .code
            self._code = dictionary["code"] as? [String: String] ?? ["html":"<h1> failed to load.. </h1>", "js":"", "css":""]
        case "template":
            _type = .template
            self._templates = dictionary["templates"] as? [Template] ?? [Template(key: "blog", dictionary: ["title" : "failed to load templates", "description" : "this is the blog description"])]
        case "block":
            _type = .block
            self._blocks = dictionary["block"] as? [String : String] ?? ["logic":"put somthing here","art": "the ui shuold be here"]
        default:
            _type = .code
            self._code = ["html":"<h1> failed to load.. </h1>", "js":"", "css":""]
        }
        
        
    }
    
}

