//
//  Template.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 30/04/2021.
//  Copyright © 2021 Ficruty. All rights reserved.
//

import UIKit



class Template {
    private var _key: String
    private var _dictionary: [String: Any]
    
    var key: String {
        return _key
    }
    
    var dictionary: [String: Any] {
        return _dictionary
    }
    
    var iconURL: String {
        return dictionary["icon"] as? String ?? ""
    }
    
    var code: String {
        return dictionary["code"] as? String ?? ""
    }
    
    
    init(key: String, dictionary: [String: Any]) {
        self._key = key
        self._dictionary = dictionary
    }
    
    
}

