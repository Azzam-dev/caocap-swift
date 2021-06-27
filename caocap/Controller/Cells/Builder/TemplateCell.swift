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
        var code = template.code
        self.webView.loadHTMLString(code , baseURL: nil)
    }
    
}
