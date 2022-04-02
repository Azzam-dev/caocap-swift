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
        
        self.webView.navigationDelegate = self
        
        if let openedCaocap = openedCaocap {
            load(caocap: openedCaocap)
        }
        // Do any additional setup after loading the view.
    }

    func load(caocap: Caocap) {
        let caocapCode = """
                     <!DOCTYPE html>
                     <html lang="en">
                       <head>
                         <meta charset="UTF-8" />
                         <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                         <title>Checkbox</title>
                         <script type="module" src="https://cdn.jsdelivr.net/npm/@ionic/core/dist/ionic/ionic.esm.js"></script>
                         <script nomodule src="https://cdn.jsdelivr.net/npm/@ionic/core/dist/ionic/ionic.js"></script>
                         <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@ionic/core/css/ionic.bundle.css" />
                         <style>
                           :root {
                             --ion-safe-area-top: 20px;
                             --ion-safe-area-bottom: 22px;
                           }
                         </style>
                       </head>
                       <body>
                         <ion-app>
                           <ion-header translucent>
                             <ion-toolbar>
                               <ion-title>Checkbox</ion-title>
                             </ion-toolbar>
                           </ion-header>
                           <ion-content fullscreen>
                             <ion-list>
                               <ion-list-header>Characters</ion-list-header>
                               <ion-item>
                                 <ion-label>Jon Snow</ion-label>
                                 <ion-checkbox color="primary" checked slot="start"></ion-checkbox>
                               </ion-item>
                               <ion-item>
                                 <ion-checkbox color="dark" checked slot="start"></ion-checkbox>
                                 <ion-label>Daenerys Targaryen</ion-label>
                               </ion-item>
                               <ion-item>
                                 <ion-checkbox disabled slot="start"></ion-checkbox>
                                 <ion-label>Arya Stark</ion-label>
                               </ion-item>
                               <ion-item>
                                 <ion-checkbox color="secondary" slot="start"></ion-checkbox>
                                 <ion-label>Tyrion Lannister</ion-label>
                               </ion-item>
                               <ion-item>
                                 <ion-checkbox color="danger" checked slot="start"></ion-checkbox>
                                 <ion-label>Sansa Stark</ion-label>
                               </ion-item>
                               <ion-item>
                                 <ion-checkbox color="primary" slot="start"></ion-checkbox>
                                 <ion-label>Khal Drogo</ion-label>
                               </ion-item>
                               <ion-item>
                                 <ion-checkbox color="tertiary" checked slot="start"></ion-checkbox>
                                 <ion-label>Cersei Lannister</ion-label>
                               </ion-item>
                               <ion-item>
                                 <ion-checkbox color="medium" checked slot="start"></ion-checkbox>
                                 <ion-label>Stannis Baratheon</ion-label>
                               </ion-item>
                               <ion-item>
                                 <ion-checkbox color="primary" disabled slot="start"></ion-checkbox>
                                 <ion-label>Petyr Baelish</ion-label>
                               </ion-item>
                               <ion-item>
                                 <ion-checkbox color="dark" checked slot="start"></ion-checkbox>
                                 <ion-label>Hodor</ion-label>
                               </ion-item>
                               <ion-item>
                                 <ion-checkbox color="secondary" checked slot="start"></ion-checkbox>
                                 <ion-label>Catelyn Stark</ion-label>
                               </ion-item>
                               <ion-item>
                                 <ion-checkbox color="primary" slot="start"></ion-checkbox>
                                 <ion-label>Bronn</ion-label>
                               </ion-item>
                             </ion-list>
                           </ion-content>
                         </ion-app>
                       </body>
                     </html>
                     """

        webView.loadHTMLString(caocapCode , baseURL: nil)
//        store.dispatch(LoudCaocapVCAction(caocapVC: self))
//        DataService.instance.getCaocap(withKey: caocap.key) { liveCaocap in
            
//            LuaService(script: )
//TODO: - update Caocap work every frame
//TODO: - redraw Caocap work every frame
//        }
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
        if openedCaocap ==  nil { // MARK: - fixed duplicate execution
            openedCaocap = state.openedCaocap
            load(caocap: openedCaocap!)
        }
        
    }
    
}

