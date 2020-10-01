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
    
    var caocapKey = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureCell(caocap: Caocap ,released: Bool) {

        caocapKey = caocap.key
        let caocapCode = """
        <!DOCTYPE html><html><head><meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
        <meta name="viewport" content="width=device-width, initial-scale=1.0"><meta charset="utf-8"><title>CAOCAP</title><link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" integrity="sha384-JcKb8q3iqJ61gNV9KGb8thSsNjpSL0n8PARn9HuZOnIxN0hoP+VmmDGMN5t9UJ0Z" crossorigin="anonymous"><style>\(caocap.code["css"] ?? "")</style></head><body>\(caocap.code["html"] ?? "" )<script>\(caocap.code["js"] ?? "")</script></body></html>
        """
        
        self.webView.loadHTMLString(caocapCode , baseURL: nil)
        
        //this stops the image and the Url from duplicating
        self.caocapIMG.image = nil
        
        //start the Circle Animation
        addPulse()

        self.webView.navigationDelegate = self
        self.caocapName.text = caocap.name
        
        
        if released {
            self.theView.isHidden = false
            self.caocapIMG.isHidden = true
            self.caocapIMG.image = nil
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
    
    @IBAction func moreBTN(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("moreBTNpressed"), object: nil)
    }
    
}
