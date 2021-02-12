//
//  TestLabVC.swift
//  caocap
//
//  Created by omar alzhrani on 15/09/1441 AH.
//  Copyright © 1441 Ficruty. All rights reserved.
//

import UIKit
import WebKit
import Firebase

class TestLabVC: UIViewController, WKNavigationDelegate, UITextViewDelegate {
    
    @IBOutlet weak var theView: DesignableView!
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var toolsViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var gestureRecognizerView: UIView!
    
    var caocapCode = ""
    var openedCaocap = Caocap(key: "", dictionary: ["":""])
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCaocapData()
        
        //This hides the webView until the download finishes
        self.webView.isHidden = true
        self.webView.navigationDelegate = self
        
        addPulse()
        gestureRecognizerSetup()
    }
    
    
    func getCaocapData() {
        // we are useing the observe method to make the changes in real-time and to allow "Multi device changes"
        DataService.instance.REF_CAOCAPS.child(openedCaocap.key).observe(.value) { (caocapSnapshot) in
            let caocapSnapshot = caocapSnapshot.value as? [String : AnyObject] ?? [:]
            self.caocapNameTF.text = caocapSnapshot["name"] as? String ?? ""
            //self.publishingSwitch.isOn = caocapSnapshot["published"] as? Bool ?? false
            let code = caocapSnapshot["code"] as? [String: String] ?? ["html":"<h1> failed to load.. </h1>", "js":"", "css":""]
            
            self.caocapCode = """
            <!DOCTYPE html><html><head><meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
            <meta name="viewport" content="width=device-width, initial-scale=1.0"><meta charset="utf-8"><title>CAOCAP</title><link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" integrity="sha384-JcKb8q3iqJ61gNV9KGb8thSsNjpSL0n8PARn9HuZOnIxN0hoP+VmmDGMN5t9UJ0Z" crossorigin="anonymous"><style></style></head><body><script></script></body></html>
            """
//            self.codeTextView.text = self.caocapCode
            
            self.loudCaocap()
        }
    }
    
    
    func loudCaocap() {
        self.webView.loadHTMLString(caocapCode, baseURL: nil)
    }
    
    var startTest = true
    
    @IBOutlet weak var hotReloudBTN: UIButton!
    @IBAction func hotReloudBTN(_ sender: Any) {
        loudCaocap()
        startTest.toggle()
        if startTest {
            hotReloudBTN.setImage(#imageLiteral(resourceName: "icons8-hot_reload-1"), for: .normal)
        } else {
            hotReloudBTN.setImage(#imageLiteral(resourceName: "icons8-hot_reload"), for: .normal)
        }
    }
    
    
    @IBAction func saveBTN(_ sender: Any) {
        // save the code in /caocap-x/commit/[UID]/[virsionNum]
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
                    toolsViewAnimation(135)
                } else {
                    toolsViewAnimation(350)
                }
            case .down:
                if self.toolsViewHeightConstraint.constant == 135 {
                    toolsViewAnimation(75)
                } else {
                    toolsViewAnimation(135)
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
    
    
    //-----Settings-----
    
    @IBOutlet weak var caocapNameTF: UITextField!
    @IBOutlet weak var publishingSwitch: UISwitch!
    
    @IBAction func caocapNameTFDidEndEditing(_ sender: Any) {
        if caocapNameTF.text != "" {
            DataService.instance.REF_CAOCAPS.child(openedCaocap.key).updateChildValues(["name": caocapNameTF.text!])
        }
    }
    
    
    @IBAction func publishingSwitchValueDidChange(_ sender: Any) {
        if publishingSwitch.isOn {
            DataService.instance.REF_CAOCAPS.child(openedCaocap.key).updateChildValues(["published": true])
        } else {
            DataService.instance.REF_CAOCAPS.child(openedCaocap.key).updateChildValues(["published": false])
        }
    }
    
}
