//
//  CaocapVC.swift
//  caocap
//
//  Created by CAOCAP inc on 22/08/1443 AH.
//  Copyright © 1443 Ficruty. All rights reserved.
//

import UIKit
import WebKit
import ReSwift

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
        
        let caocap = GravityService(atom: Atom(type: .h1, attributes: nil, children: nil))

        webView.loadHTMLString(caocap.htmlCode, baseURL: nil)

    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.isHidden = false
    }
    
}

extension CaocapVC: StoreSubscriber {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(self)
    }
    
    func newState(state: AppState) {
        if openedCaocap == nil {
            openedCaocap = state.openedCaocap
            load(caocap: openedCaocap!)
        }
        
    }
    
}
