//
//  caocapCell.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 02/04/1440 AH.
//  Copyright © 1440 Ficruty. All rights reserved.
//

import UIKit
import WebKit

class caocapCell: UICollectionViewCell, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var theView: DesignableView!
    @IBOutlet weak var caocapName: UILabel!
    @IBOutlet weak var caocapIMG: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureCell(caocap: Caocap ,released: Bool) {
        
        let caocapURL = URL(string: caocap.website)
        let defaultValue = URL(string: "https://caocap.app")!
        var urlRequest = URLRequest(url: caocapURL ?? defaultValue)
        urlRequest.cachePolicy = .returnCacheDataElseLoad
        
        //this stops the image and the Url from duplicating
        self.caocapIMG.image = nil
        self.webView.stopLoading()
        
        
        //This hides the webView until the download finishes
        self.webView.isHidden = true
        
        //start the Circle Animation
        addPulse()

        self.webView.navigationDelegate = self
        self.caocapName.text = caocap.name
        
        
        if released {
            self.theView.isHidden = false
            self.caocapIMG.isHidden = true
            self.caocapIMG.image = nil
            self.webView.load(urlRequest)
        } else {
            self.theView.isHidden = true
            self.caocapIMG.isHidden = false
            self.webView.stopLoading()
            //this gets the caocap UIimage from the url
            if let imageURL = URL(string: caocap.imageURL ?? "" ) {
                ImageService.getImage(withURL: imageURL) { (returnedImage) in
                    self.caocapIMG.image = returnedImage
                }
            }
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
        pulse.backgroundColor = #colorLiteral(red: 0.1921568627, green: 0.2235294118, blue: 0.262745098, alpha: 0.5)
        
        self.theView.layer.insertSublayer(pulse, at:  0)
        
    }
    
}
