//
//  Block.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 02/10/2020.
//  Copyright © 2020 Ficruty. All rights reserved.
//

import UIKit

class Block {
    private var _name: String
    private var _image: UIImage
    private var _bio: String
    private var _htmlCode: [String]
    private var _cssCode: [String]
    private var _jsCode: [String]
    
    var name: String {
        return _name
    }
    
    var image: UIImage {
        return _image
    }
    
    var bio: String {
        return _bio
    }
    var htmlCode: [String] {
        return _htmlCode
    }
    var cssCode: [String] {
        return _cssCode
    }
    var jsCode: [String] {
        return _jsCode
    }
    
    init(name: String, image: UIImage, bio: String , htmlCode: [String], cssCode: [String] = [] , jsCode: [String] = []) {
        self._name = name
        self._image = image
        self._bio = bio
        self._htmlCode = htmlCode
        self._cssCode = cssCode
        self._jsCode = jsCode
    }
    
}

