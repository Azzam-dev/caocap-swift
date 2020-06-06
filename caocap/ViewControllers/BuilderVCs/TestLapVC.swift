//
//  TestLapVC.swift
//  caocap
//
//  Created by omar alzhrani on 15/09/1441 AH.
//  Copyright © 1441 Ficruty. All rights reserved.
//

import UIKit
import WebKit
import Firebase

class TestLapVC: UIViewController, WKNavigationDelegate, UITextViewDelegate {
    
    @IBOutlet weak var theView: DesignableView!
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var htmlTextView: UITextView!
    @IBOutlet weak var jsTextView: UITextView!
    @IBOutlet weak var cssTextView: UITextView!
    
    @IBOutlet weak var toolsViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var gestureRecognizerView: UIView!
    
    var caocapCode = ""
    var openedCaocap: Caocap?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getMyLastCaocapData()
        
        //This hides the webView until the download finishes
        self.webView.isHidden = true
        self.webView.navigationDelegate = self
        
        addPulse()
        
        gestureRecognizerSetup()
    }
    
    
    func getMyLastCaocapData() {
        DataService.instance.getCurrentUserCaocaps { (returnedCaocapsArray) in
            self.openedCaocap = returnedCaocapsArray.last
            self.htmlTextView.text = self.openedCaocap!.code["html"]
            self.jsTextView.text = self.openedCaocap!.code["js"]
            self.cssTextView.text = self.openedCaocap!.code["css"]
            self.caocapCode = """
            <!DOCTYPE html><html><head><meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
            <meta name="viewport" content="width=device-width, initial-scale=1.0"><meta charset="utf-8"><title>CAOCAP</title><style>\(self.cssTextView.text!)</style></head><body>\(self.htmlTextView.text!)<script>\(self.jsTextView.text!)</script></body></html>
            """
            self.startTestBTN(nil)
        }
    }
    
    @IBOutlet var topNavBTNs: [UIButton]!
    @IBAction func topNavBTNs(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            showTextView(html: true)
            topNavBTNs[1].setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
            topNavBTNs[2].setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        case 1:
            showTextView(js: true)
            topNavBTNs[0].setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
            topNavBTNs[2].setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        case 2:
            showTextView(css: true)
            topNavBTNs[0].setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
            topNavBTNs[1].setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        default:
            print("some bad shit happened 😅")
        }
        sender.setTitleColor(#colorLiteral(red: 0, green: 0.6544699669, blue: 1, alpha: 1), for: .normal)
    }
    
    func showTextView(html: Bool = false, js: Bool = false, css: Bool = false) {
        htmlTextView.isHidden = !html
        jsTextView.isHidden = !js
        cssTextView.isHidden = !css
    }
    
    @IBAction func startTestBTN(_ sender: Any?) {
        self.webView.loadHTMLString(caocapCode, baseURL: nil)
    }
    
    @IBAction func hotReloudBTN(_ sender: Any) {
        
    }
    
    @IBAction func stopTestBTN(_ sender: Any) {
    }
    
    @IBAction func saveBTN(_ sender: Any) {
        // save the code in /caocap-x/commit/[UID]/[virsionNum]
    }
    
    @IBAction func launchCaocapBTN(_ sender: Any) {
        // save the code in /caocap-x/caocap/[UID]/code
        DataService.instance.launchCaocap(caocapKey: openedCaocap!.key, code: ["html": htmlTextView.text , "js": jsTextView.text, "css": cssTextView.text])
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
    
    func textViewDidChange(_ textView: UITextView) {
            caocapCode = """
            <!DOCTYPE html><html><head><meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
            <meta name="viewport" content="width=device-width, initial-scale=1.0"><meta charset="utf-8"><title>CAOCAP</title><style>\(cssTextView.text!)</style></head><body>\(htmlTextView.text!)<script>\(jsTextView.text!)</script></body></html>
            """
    }
    
}

