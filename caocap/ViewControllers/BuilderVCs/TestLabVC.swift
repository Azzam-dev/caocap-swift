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
    
    @IBOutlet weak var versionsTableView: UITableView!
    @IBOutlet weak var codeScrollView: UIScrollView!
    @IBOutlet weak var settingsScrollView: UIScrollView!
    
    @IBOutlet weak var htmlTextView: UITextView!
    @IBOutlet weak var jsTextView: UITextView!
    @IBOutlet weak var cssTextView: UITextView!
    
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
            self.publishingSwitch.isOn = caocapSnapshot["published"] as? Bool ?? false
            let code = caocapSnapshot["code"] as? [String: String] ?? ["html":"<h1> failed to load.. </h1>", "js":"", "css":""]
            
            self.htmlTextView.text = code["html"]
            self.jsTextView.text = code["js"]
            self.cssTextView.text = code["css"]
            self.caocapCode = """
            <!DOCTYPE html><html><head><meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
            <meta name="viewport" content="width=device-width, initial-scale=1.0"><meta charset="utf-8"><title>CAOCAP</title><link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" integrity="sha384-JcKb8q3iqJ61gNV9KGb8thSsNjpSL0n8PARn9HuZOnIxN0hoP+VmmDGMN5t9UJ0Z" crossorigin="anonymous"><style>\(self.cssTextView.text!)</style></head><body>\(self.htmlTextView.text!)<script>\(self.jsTextView.text!)</script></body></html>
            """
//            self.codeTextView.text = self.caocapCode
            
            self.loudCaocap()
        }
    }
    
    @IBOutlet var topNavBTNs: [UIButton]!
    @IBAction func topNavBTNs(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            present(versionsView: true)
            topNavBTNs[1].setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
            topNavBTNs[2].setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        case 1:
            present(codeView: true)
            topNavBTNs[0].setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
            topNavBTNs[2].setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        case 2:
            present(settingsView: true)
            topNavBTNs[0].setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
            topNavBTNs[1].setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        default:
            print("some bad shit happened 😅")
        }
        sender.setTitleColor(#colorLiteral(red: 0, green: 0.6544699669, blue: 1, alpha: 1), for: .normal)
    }
    
    func present(versionsView: Bool = false, codeView: Bool = false, settingsView: Bool = false) {
        versionsTableView.isHidden = !versionsView
        codeScrollView.isHidden = !codeView
        settingsScrollView.isHidden = !settingsView
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
    
    @IBOutlet weak var launchCaocapBTN: UIButton!
    @IBAction func launchCaocapBTN(_ sender: Any) {
        // save the code in /caocap-x/caocap/[UID]/code
        
        DataService.instance.launchCaocap(caocapKey: openedCaocap.key, code: ["html": htmlTextView.text , "js": jsTextView.text, "css": cssTextView.text])
            launchCaocapBTN.setImage(#imageLiteral(resourceName: "icons8-launch-1"), for: .normal)
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
        launchCaocapBTN.setImage(#imageLiteral(resourceName: "icons8-launch"), for: .normal)
        caocapCode = """
        <!DOCTYPE html><html><head><meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
        <meta name="viewport" content="width=device-width, initial-scale=1.0"><meta charset="utf-8"><title>CAOCAP</title><link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" integrity="sha384-JcKb8q3iqJ61gNV9KGb8thSsNjpSL0n8PARn9HuZOnIxN0hoP+VmmDGMN5t9UJ0Z" crossorigin="anonymous"><style>\(cssTextView.text!)</style></head><body>\(htmlTextView.text!)<script>\(jsTextView.text!)</script></body></html>
        """
        if startTest { loudCaocap() }
        
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
