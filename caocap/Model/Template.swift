//
//  Template.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 30/04/2021.
//  Copyright © 2021 Ficruty. All rights reserved.
//

import UIKit

enum TemplateType: String, CaseIterable{
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
    
    func build() -> String {
        switch type {
        case .blog:
            let title = "<h1>\(content["title"] ?? "")</h1>"
            let description = "<p>\(content["description"] ?? "")</p>"
            return """
            <!DOCTYPE html><html><head><meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
            <meta name="viewport" content="width=device-width, initial-scale=1.0"><meta charset="utf-8"><title>CAOCAP</title><link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" integrity="sha384-JcKb8q3iqJ61gNV9KGb8thSsNjpSL0n8PARn9HuZOnIxN0hoP+VmmDGMN5t9UJ0Z" crossorigin="anonymous"></head><body>\(title)\(description)</body></html>
            """
        }
    }
}

