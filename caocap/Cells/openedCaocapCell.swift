//
//  openedCaocapCell.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 14/08/1440 AH.
//  Copyright © 1440 Ficruty. All rights reserved.
//

import UIKit
import WebKit
import Firebase

/* Declare a Delegate Protocol method */
protocol openedCaocapCellDelegate: class {
    func shareBTNpressed(cell: openedCaocapCell, didTappedshow button: UIButton)
    func moreBTNpressed(cell: openedCaocapCell, didTappedshow button: UIButton)
    func roomBTNpressed(cell: openedCaocapCell, didTappedshow button: UIButton)
}

class openedCaocapCell: UICollectionViewCell, WKNavigationDelegate {
    
    //Define delegate variable
    weak var cellDelegate: openedCaocapCellDelegate?
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var theView: DesignableView!
    @IBOutlet weak var caocapName: UILabel!
    @IBOutlet weak var caocapBackgroundIMG: UIImageView!
    @IBOutlet weak var caocapIMG: DesignableImage!
    @IBOutlet weak var caocapIMGview: DesignableView!
    @IBOutlet weak var caocapDescription: UILabel!
    
    let colorArray = [#colorLiteral(red: 1, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.6391159892, blue: 0, alpha: 1), #colorLiteral(red: 0.3846503198, green: 1, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0.6544699669, blue: 1, alpha: 1), #colorLiteral(red: 0.8861780167, green: 0, blue: 1, alpha: 1), #colorLiteral(red: 0.9175696969, green: 0.9176983237, blue: 0.9175290465, alpha: 1)]
    
    var isReleased = Bool()
    override func awakeFromNib() {
        super.awakeFromNib()
        
        DataService.instance.REF_RELEASED.observe(DataEventType.value, with: { snap in
            self.isReleased = snap.value! as! Bool
            if self.isReleased {
                self.theView.isHidden = false
                self.caocapBackgroundIMG.isHidden = true
            } else {
                self.theView.isHidden = true
                self.caocapBackgroundIMG.isHidden = false
            }
        })
    }
    
    var caocapKey = ""
    var caocapIsOrbited = false
    func configureCell(caocap: Caocap ,released: Bool) {
        caocapKey = caocap.key
        isReleased = released
        let caocapURL = URL(string: caocap.website)
        let defaultValue = URL(string: "https://ficruty.wixsite.com/caocap")!
        var urlRequest = URLRequest(url: caocapURL ?? defaultValue)
        urlRequest.cachePolicy = .returnCacheDataElseLoad
        
        
        
        //this stops the image and the Url from duplicating
        self.caocapIMG.image = nil
        self.webView.stopLoading()
        
        
        //This hides the webView until the download finishes
        self.webView.isHidden = true
        
        //start the Circle Animation
        addPulse()
        
        
        checkOrbiteStatus()
        
        self.webView.navigationDelegate = self
        self.caocapName.text = caocap.name
        self.caocapIMGview.borderColor = colorArray[caocap.color]
        
        //this gets the caocap UIimage from the url
        if let imageURL = URL(string: caocap.imageURL ?? "" ) {
            ImageService.getImage(withURL: imageURL) { (returnedImage) in
                self.caocapIMG.image = returnedImage
            }
        }
        
        if isReleased {
            self.theView.isHidden = false
            self.caocapBackgroundIMG.isHidden = true
            self.caocapBackgroundIMG.image = nil
            self.webView.load(urlRequest)
        } else {
            self.theView.isHidden = true
            self.caocapBackgroundIMG.isHidden = false
            self.webView.stopLoading()
            self.caocapBackgroundIMG.image = caocapIMG.image
        }
    }
    
    //This shows the webView after the download finishes
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.webView.isHidden = false
    }
    
    //Circle Animation
    func addPulse(){
        let pulse = Pulsing(numberOfPulses: 10, radius: theView.frame.width , position: theView.center)
        pulse.animationDuration = 0.8
        pulse.backgroundColor = #colorLiteral(red: 0.2902041078, green: 0.2901904881, blue: 0.2902008593, alpha: 0.5)
        
        self.theView.layer.insertSublayer(pulse, at:  0)
        
    }
    
    func checkOrbiteStatus() {
        if let userUID = Auth.auth().currentUser?.uid {
            DataService.instance.REF_USERS.child(userUID).child("orbiting").child(caocapKey).child("key").observeSingleEvent(of: .value) { (key) in
                if key.exists() {
                    self.caocapIsOrbited = true
                    self.orbitBTN_background.backgroundColor = #colorLiteral(red: 0, green: 0.6544699669, blue: 1, alpha: 1)
                } else {
                    self.caocapIsOrbited = false
                    self.orbitBTN_background.backgroundColor = #colorLiteral(red: 0, green: 0.6544699669, blue: 1, alpha: 0)
                }
            }
        }
    }
    
    @IBAction func shareBTN(_ sender: Any) {
        let button = sender as! UIButton
        self.cellDelegate?.shareBTNpressed(cell: self, didTappedshow: button)
    }
    
    
    @IBAction func roomBTN(_ sender: Any) {
        let button = sender as! UIButton
        self.cellDelegate?.roomBTNpressed(cell: self, didTappedshow: button)
    }
    
    
    @IBAction func moreBTN(_ sender: Any) {
        let button = sender as! UIButton
        self.cellDelegate?.moreBTNpressed(cell: self, didTappedshow: button)
    }
    
    
    @IBOutlet weak var orbitsNum: UILabel!
    @IBOutlet weak var orbitBTN_background: DesignableView!
    @IBOutlet weak var orbitBTN: UIButton!
    @IBAction func orbitBTN(_ sender: Any) {
        if caocapIsOrbited {
            caocapIsOrbited = false
            orbitBTN_background.backgroundColor = #colorLiteral(red: 0, green: 0.6544699669, blue: 1, alpha: 0)
            DataService.instance.addAndReomveFromOrbit(caocapKey: caocapKey, remove: true)
        } else {
            caocapIsOrbited = true
            print(caocapKey)
            orbitBTN_background.backgroundColor = #colorLiteral(red: 0, green: 0.6544699669, blue: 1, alpha: 1)
            DataService.instance.addAndReomveFromOrbit(caocapKey: caocapKey, remove: false)
        }
    }
    
}
