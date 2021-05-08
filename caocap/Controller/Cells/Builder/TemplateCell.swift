//
//  TemplateCell.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 30/04/2021.
//  Copyright © 2021 Ficruty. All rights reserved.
//

import UIKit
import WebKit

class TemplateCell: UITableViewCell {

    @IBOutlet weak var selectedEffectView: UIView!
    @IBOutlet weak var webView: WKWebView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectedEffectView.isHidden = !selected 
    }

    func configure(template: Template) {
        var templateCode = ""
        switch template.type {
        case .blog:
            let title = "<h1>\(template.content["title"] ?? "")</h1>"
            let description = "<p>\(template.content["description"] ?? "")</p>"
            templateCode = """
            <!DOCTYPE html><html><head><meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
            <meta name="viewport" content="width=device-width, initial-scale=1.0"><meta charset="utf-8"><title>CAOCAP</title><link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" integrity="sha384-JcKb8q3iqJ61gNV9KGb8thSsNjpSL0n8PARn9HuZOnIxN0hoP+VmmDGMN5t9UJ0Z" crossorigin="anonymous"></head><body>\(title)\(description)</body></html>
            """
        default:
            print(template.type.rawValue)
        }
        
        self.webView.loadHTMLString(templateCode , baseURL: nil)
    }
    
}
