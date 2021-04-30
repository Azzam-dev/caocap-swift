//
//  Template.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 30/04/2021.
//  Copyright © 2021 Ficruty. All rights reserved.
//

import Foundation

enum TemplateType: String {
    case blog
}

class Template {
    private var _type: TemplateType
    private var _content: [String: String]
    
    var type: TemplateType {
        return _type
    }
    
    var content: [String: String] {
        return _content
    }
    
    init(type: TemplateType, content: [String: String]) {
        self._type = type
        self._content = content
    }
}
