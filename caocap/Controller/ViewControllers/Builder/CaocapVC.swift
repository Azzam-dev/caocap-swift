//
//  CaocapVC.swift
//  caocap
//
//  Created by CAOCAP inc on 22/08/1443 AH.
//  Copyright © 1443 Ficruty. All rights reserved.
//

import UIKit
import WebKit

class CaocapVC: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    var openedCaocap: Caocap?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.isHidden = true
        webView.stopLoading()
        self.webView.navigationDelegate = self
        
        if let openedCaocap = openedCaocap {
            load(caocap: openedCaocap)
        }
    }

    func load(caocap: Caocap) {
        DataService.instance.getCaocap(withKey: caocap.key) { liveCaocap in
            
        }
        
        let caocapCode = Bundle.main.path(forResource: "hextris/index", ofType: "html")
        let url = URL(fileURLWithPath: caocapCode!)
        let request = URLRequest(url: url)

        webView.load(request)

    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.isHidden = false
    }
    
}

