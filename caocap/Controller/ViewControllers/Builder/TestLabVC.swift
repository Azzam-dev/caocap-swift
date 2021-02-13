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

class TestLabVC: UIViewController, WKNavigationDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var theView: DesignableView!
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var toolsViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var gestureRecognizerView: UIView!
    
    var openedCaocapKey: String?
    var openedCaocapType: CaocapType?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: hide the caocapLinkTF if the caocap is not of type link
        
        addPulse()
        getCaocapData()
        gestureRecognizerSetup()
        
        //This hides the webView until the download finishes
        self.webView.isHidden = true
        self.webView.navigationDelegate = self
    }
    
    
    func getCaocapData() {
        // we are useing the observe method to make the changes in real-time and to allow "Multi device changes"
        guard let caocapKey = openedCaocapKey, let caocapType = openedCaocapType else { return }
        if caocapType == .link { caocapLinkTF.isHidden = false }
        DataService.instance.REF_CAOCAPS.child(caocapKey).observe(.value) { (caocapSnapshot) in
            guard let caocapSnapshot = caocapSnapshot.value as? [String : Any] else { return }
            let caocap = Caocap(key: caocapKey, dictionary: caocapSnapshot)
            self.caocapNameTF.text = caocap.name
            self.colorBTNpressed(self.colorBTNs[caocap.color])
            
            if let url = URL(string: caocap.imageURL ?? "" ) {
                ImageService.getImage(withURL: url) { (returnedImage) in
                    self.caocapIMG.image = returnedImage
                }
            }
            
            self.publishedStatus = caocap.isPublished
            if self.publishedStatus {
                self.publishingSwitchBTN.backgroundColor = #colorLiteral(red: 0, green: 0.6544699669, blue: 1, alpha: 1)
                self.publishingSwitchBTN.borderWidth = 0
                self.publishingSwitchBTN.setTitle("Published", for: .normal)
                self.publishingSwitchBTN.setTitleColor(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), for: .normal)
            } else {
                self.publishingSwitchBTN.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                self.publishingSwitchBTN.borderWidth = 2
                self.publishingSwitchBTN.setTitle("Publish", for: .normal)
                self.publishingSwitchBTN.setTitleColor(#colorLiteral(red: 0, green: 0.6544699669, blue: 1, alpha: 1), for: .normal)
            }
            
            
            self.loadCaocap(caocap)
        }
    }
    
    
    private func loadCaocap(_ caocap: Caocap) {
        switch caocap.type {
        case .code:
            let caocapCode = """
            <!DOCTYPE html><html><head><meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
            <meta name="viewport" content="width=device-width, initial-scale=1.0"><meta charset="utf-8"><title>CAOCAP</title><link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" integrity="sha384-JcKb8q3iqJ61gNV9KGb8thSsNjpSL0n8PARn9HuZOnIxN0hoP+VmmDGMN5t9UJ0Z" crossorigin="anonymous"><style>\(caocap.code!["css"] ?? "")</style></head><body>\(caocap.code!["html"] ?? "" )<script>\(caocap.code!["js"] ?? "")</script></body></html>
            """
            
            self.webView.loadHTMLString(caocapCode , baseURL: nil)
            
        case .link:
            caocapLinkTF.text = caocap.link
            let caocapURL = URL(string: caocap.link!)!
            var urlRequest = URLRequest(url: caocapURL)
            urlRequest.cachePolicy = .returnCacheDataElseLoad
            self.webView.load(urlRequest)
            
        default:
            print("unexpected caocap type")
        }
        
    }
    
    
    func gestureRecognizerSetup() {
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        upSwipe.direction = .up
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        downSwipe.direction = .down
        
        gestureRecognizerView.addGestureRecognizer(upSwipe)
        gestureRecognizerView.addGestureRecognizer(downSwipe)
        caocapIMG.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeImage)))
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
    
    @IBOutlet weak var caocapIMG: DesignableImage!
    @IBOutlet weak var caocapIMGview: DesignableView!
    @IBOutlet weak var caocapNameTF: UITextField!
    @IBOutlet weak var caocapLinkTF: UITextField!
    @IBOutlet weak var publishingSwitchBTN: UIButton!
    
    var publishedStatus = false
    var colorSelectedIndex = 3
    let colorArray = [#colorLiteral(red: 1, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.6391159892, blue: 0, alpha: 1), #colorLiteral(red: 0.3846503198, green: 1, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0.6544699669, blue: 1, alpha: 1), #colorLiteral(red: 0.8861780167, green: 0, blue: 1, alpha: 1), #colorLiteral(red: 0.9175696969, green: 0.9176983237, blue: 0.9175290465, alpha: 1)]
    
    @IBOutlet var constraintsArray: [NSLayoutConstraint]!
    @IBOutlet var colorBTNs: [UIButton]!
    @IBAction func colorBTNpressed(_ sender: UIButton) {
        guard let caocapKey = openedCaocapKey else { return }
        let previousColorIndex = colorSelectedIndex
        colorSelectedIndex = sender.tag
        print(caocapKey)
        DataService.instance.REF_CAOCAPS.child(caocapKey).updateChildValues(["color": colorSelectedIndex])
        let previousConstraint = constraintsArray[previousColorIndex]
        let selectedConstraint = constraintsArray[colorSelectedIndex]
        
        UIView.animate(withDuration: 0.3 , animations: {
            previousConstraint.constant = 15
            selectedConstraint.constant = 20
            self.caocapIMGview.borderColor = self.colorArray[self.colorSelectedIndex]
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func changeImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageFromPicker: UIImage?
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker {
            caocapIMG.image = selectedImage
            uploudNewCaocapImage()
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func uploudNewCaocapImage() {
        guard let caocapKey = openedCaocapKey else { return }
        let imageNameUID = NSUUID().uuidString
        let storageRef = DataService.instance.REF_CAOCAP_IMAGES.child("\(imageNameUID).jpg")
        if let uploadData = self.caocapIMG.image?.jpegData(compressionQuality: 0.2) {
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil { print(error!) }
                storageRef.downloadURL(completion: { url, error in
                    if error != nil { print(error!) } else {
                        guard let imageURL = url?.absoluteString else { return }
                        DataService.instance.REF_CAOCAPS.child(caocapKey).updateChildValues(["imageURL": imageURL])
                    }
                })
            })
        }
    }
    
    @IBAction func didPressPublishingSwitchBTN(_ sender: Any) {
        guard let caocapKey = openedCaocapKey else { return }
        publishedStatus.toggle()
        if publishedStatus {
            publishingSwitchBTN.backgroundColor = #colorLiteral(red: 0, green: 0.6544699669, blue: 1, alpha: 1)
            publishingSwitchBTN.borderWidth = 0
            DataService.instance.REF_CAOCAPS.child(caocapKey).updateChildValues(["published": true])
        } else {
            publishingSwitchBTN.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            publishingSwitchBTN.borderWidth = 2
            DataService.instance.REF_CAOCAPS.child(caocapKey).updateChildValues(["published": false])
        }
    }
    
    @IBAction func caocapNameTFDidEndEditing(_ sender: Any) {
        if caocapNameTF.text != "" {
            guard let caocapKey = openedCaocapKey else { return }
            DataService.instance.REF_CAOCAPS.child(caocapKey).updateChildValues(["name": caocapNameTF.text!])
        }
    }
    
    @IBAction func caocapLinkTFDidEndEditing(_ sender: Any) {
        guard let key = openedCaocapKey else { return }
        guard let text = caocapLinkTF.text else { return }
        DataService.instance.REF_CAOCAPS.child(key).updateChildValues(["link": text])
    }
    
}
