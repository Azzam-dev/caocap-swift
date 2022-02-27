//
//  OpenedCaocapCell.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 14/08/1440 AH.
//  Copyright © 1440 Ficruty. All rights reserved.
//

import UIKit
import WebKit
import Firebase

/* Declare a Delegate Protocol method */
protocol OpenedCaocapCellDelegate: class {
    func shareBTNpressed(cell: OpenedCaocapCell, didTappedshow button: UIButton)
    func moreBTNpressed(cell: OpenedCaocapCell, didTappedshow button: UIButton)
    func roomBTNpressed(cell: OpenedCaocapCell, didTappedshow button: UIButton)
}

class OpenedCaocapCell: UICollectionViewCell, WKNavigationDelegate {
    
    //Define delegate variable
    weak var delegate: OpenedCaocapCellDelegate?
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var loadingIcon: UIImageView!
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
        
        UIView.appearance().semanticContentAttribute = .forceLeftToRight

        
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
        
        //this stops the image and the Url from duplicating
        self.caocapIMG.image = nil
        self.webView.stopLoading()
        
        loadingAnimation(image: loadingIcon)
        
        DataService.instance.checkOrbiteStatus(caocapKey: caocapKey) { status in
            if status {
                self.caocapIsOrbited = true
                self.orbitBTN_background.backgroundColor = #colorLiteral(red: 0, green: 0.6544699669, blue: 1, alpha: 1)
            } else {
                self.caocapIsOrbited = false
                self.orbitBTN_background.backgroundColor = #colorLiteral(red: 0, green: 0.6544699669, blue: 1, alpha: 0)
            }
        }
        
        self.webView.navigationDelegate = self
        self.caocapName.text = caocap.name
        if case 0...5 = caocap.color {
            self.caocapIMGview.borderColor = colorArray[caocap.color]
        } else {
            self.caocapIMGview.borderColor = colorArray[3]
        }
        
        if let imageURL = URL(string: caocap.imageURL ?? "" ) {
            caocapIMG.af.setImage(withURL: imageURL)
        }
        
        if isReleased {
            self.theView.isHidden = false
            self.caocapBackgroundIMG.isHidden = true
            self.caocapBackgroundIMG.image = nil
            loadCaocap(caocap)
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
    
    private func loadCaocap(_ caocap: Caocap) {
        switch caocap.type {
        case .code:
            let caocapCode = """
            <!DOCTYPE html><html><head><meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
            <meta name="viewport" content="width=device-width, initial-scale=1.0"><meta charset="utf-8"><title>CAOCAP</title><link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" integrity="sha384-JcKb8q3iqJ61gNV9KGb8thSsNjpSL0n8PARn9HuZOnIxN0hoP+VmmDGMN5t9UJ0Z" crossorigin="anonymous"><style>\(caocap.code!["css"] ?? "")</style></head><body>\(caocap.code!["html"] ?? "" )<script>\(caocap.code!["js"] ?? "")</script></body></html>
            """
            
            self.webView.loadHTMLString(caocapCode , baseURL: nil)
            
        case .link:
            let caocapURL = URL(string: caocap.link!)!
            var urlRequest = URLRequest(url: caocapURL)
            urlRequest.cachePolicy = .returnCacheDataElseLoad
            self.webView.load(urlRequest)
            
        default:
            print("unexpected caocap type")
        }
        
    }
    
    @IBAction func shareBTN(_ sender: Any) {
        let button = sender as! UIButton
        self.delegate?.shareBTNpressed(cell: self, didTappedshow: button)
    }
    
    
    @IBAction func roomBTN(_ sender: Any) {
        let button = sender as! UIButton
        self.delegate?.roomBTNpressed(cell: self, didTappedshow: button)
    }
    
    
    @IBAction func moreBTN(_ sender: Any) {
        let button = sender as! UIButton
        self.delegate?.moreBTNpressed(cell: self, didTappedshow: button)
    }
    
    let currentLang = Locale.current.languageCode

    @IBOutlet weak var orbitsNum: UILabel!
    @IBOutlet weak var orbitBTN_background: DesignableView!
    @IBOutlet weak var orbitBTN: UIButton!
    @IBAction func orbitBTN(_ sender: Any) {
        if caocapIsOrbited {
            caocapIsOrbited = false
            orbitBTN_background.backgroundColor = #colorLiteral(red: 0, green: 0.6544699669, blue: 1, alpha: 0)
            DataService.instance.addAndReomveFromOrbit(caocapKey: caocapKey, remove: true)
            orbitsNum.text = "ADD TO ORBIT".localized()
        } else {
            caocapIsOrbited = true
            orbitBTN_background.backgroundColor = #colorLiteral(red: 0, green: 0.6544699669, blue: 1, alpha: 1)
            DataService.instance.addAndReomveFromOrbit(caocapKey: caocapKey, remove: false)
            orbitsNum.text = "Added".localized()
        }
    }
    
}
