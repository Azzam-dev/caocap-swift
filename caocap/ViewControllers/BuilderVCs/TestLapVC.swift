//
//  TestLapVC.swift
//  caocap
//
//  Created by omar alzhrani on 15/09/1441 AH.
//  Copyright © 1441 Ficruty. All rights reserved.
//

import UIKit
import WebKit

class TestLapVC: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var theView: DesignableView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var terminalTextView: UITextView!
    @IBOutlet weak var toolsViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var gestureRecognizerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //This hides the webView until the download finishes
        self.webView.isHidden = true
        self.webView.navigationDelegate = self
        let testLabURL = URL(string: "https://react-vgwivj.stackblitz.io/")
        let defaultValue = URL(string: "https://ficruty.wixsite.com/caocap")!
        var urlRequest = URLRequest(url: testLabURL ?? defaultValue)
        urlRequest.cachePolicy = .returnCacheDataElseLoad
        
        
        addPulse()
        
        gestureRecognizerSetup()
    }
    
    @IBAction func startTestBTN(_ sender: Any) {
        guard let path = Bundle.main.path(forResource: "Style", ofType: "css") else { return }
        let cssString = try! String(contentsOfFile: path).trimmingCharacters(in: .whitespacesAndNewlines)
        let jsString = "var style = document.createElement('style'); style.innerHTML = '\(cssString)'; document.head.appendChild(style);"
        self.webView.evaluateJavaScript(<#T##javaScriptString: String##String#>, completionHandler: <#T##((Any?, Error?) -> Void)?##((Any?, Error?) -> Void)?##(Any?, Error?) -> Void#>)
    }
    
    @IBAction func hotReloudBTN(_ sender: Any) {
        
    }
    
    @IBAction func stopTestBTN(_ sender: Any) {
    }
    
    @IBAction func saveTextBTN(_ sender: Any) {
    }
    
    @IBAction func launchCaocapBTN(_ sender: Any) {
        
    }
    
    
    func gestureRecognizerSetup() {
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        upSwipe.direction = .up
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        downSwipe.direction = .down
        
        gestureRecognizerView.addGestureRecognizer(upSwipe)
        gestureRecognizerView.addGestureRecognizer(downSwipe)
        
        
    }
    
    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            switch sender.direction {
            case .up:
                if self.toolsViewHeightConstraint.constant == 75 {
                    toolsViewAnimation(120)
                } else {
                    toolsViewAnimation(300)
                }
            case .down:
                if self.toolsViewHeightConstraint.constant == 120 {
                    toolsViewAnimation(75)
                } else {
                    toolsViewAnimation(120)
                }
            default:
                break
            }
        }
    }
    func toolsViewAnimation(_ hight: Int) {
           UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 3, options: .curveLinear, animations: {
               self.toolsViewHeightConstraint.constant = CGFloat(hight)
               self.view.layoutIfNeeded()
           })
       }
    
    //This shows the webView after the download finishes
       func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
           self.webView.isHidden = false
       }

       //Circle Animation
       func addPulse(){
           let pulse = Pulsing(numberOfPulses: 10, radius: theView.frame.width , position: theView.center)
           pulse.animationDuration = 0.8
           pulse.backgroundColor = #colorLiteral(red: 0.188285023, green: 0.2415923178, blue: 1, alpha: 0.8345194777)
           
           self.theView.layer.insertSublayer(pulse, at:  0)
           
       }
    
}
