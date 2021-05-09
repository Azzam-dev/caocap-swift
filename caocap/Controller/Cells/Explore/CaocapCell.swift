//
//  CaocapCell.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 02/04/1440 AH.
//  Copyright © 1440 Ficruty. All rights reserved.
//

import UIKit
import WebKit


/* Declare a Delegate Protocol method */
protocol CaocapCellDelegate {
    func moreBTNpressed(caocapKey: String)
}

class CaocapCell: UICollectionViewCell, WKNavigationDelegate {

    var caocapCellDelegate: CaocapCellDelegate?
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var loadingIcon: UIImageView!
    @IBOutlet weak var theView: DesignableView!
    @IBOutlet weak var caocapName: UILabel!
    @IBOutlet weak var caocapIMG: UIImageView!
    
    var caocapKey = ""
    
    func configure(caocap: Caocap ,released: Bool) {
        caocapKey = caocap.key
        
        //this stops the image and the Url from duplicating
        caocapIMG.image = nil
        webView.isHidden = true
        webView.stopLoading()
        
        loadingAnimation()
        webView.navigationDelegate = self
        caocapName.text = caocap.name
        
        if released {
            theView.isHidden = false
            caocapIMG.isHidden = true
            caocapIMG.image = nil
            loadCaocap(caocap)
        } else {
            theView.isHidden = true
            caocapIMG.isHidden = false
            webView.stopLoading()
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
        webView.isHidden = false
    }

    func loadingAnimation(){
        let maskView = UIImageView()
        maskView.image = UIImage(named: "Loading SVG")
        maskView.frame = loadingIcon.bounds
        maskView.contentMode = .scaleAspectFit
        loadingIcon.mask = maskView
        let pulse = Pulsing(numberOfPulses: 25, radius: loadingIcon.frame.width * 1.5 , position: CGPoint(x: 0, y: 0))
        pulse.animationDuration = 0.8
        pulse.backgroundColor = #colorLiteral(red: 0.2156862745, green: 0.2549019608, blue: 0.3019607843, alpha: 1)
        loadingIcon.layer.insertSublayer(pulse, at:  0)
    }
    
    fileprivate func loadCaocap(_ caocap: Caocap) {
        switch caocap.type {
        case .code:
            let caocapCode = """
            <!DOCTYPE html><html><head><meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
            <meta name="viewport" content="width=device-width, initial-scale=1.0"><meta charset="utf-8"><title>CAOCAP</title><link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" integrity="sha384-JcKb8q3iqJ61gNV9KGb8thSsNjpSL0n8PARn9HuZOnIxN0hoP+VmmDGMN5t9UJ0Z" crossorigin="anonymous"><style>\(caocap.code!["css"] ?? "")</style></head><body>\(caocap.code!["html"] ?? "" )<script>\(caocap.code!["js"] ?? "")</script></body></html>
            """
            
            webView.loadHTMLString(caocapCode , baseURL: nil)
            
        case .link:
            let caocapURL = URL(string: caocap.link!)!
            var urlRequest = URLRequest(url: caocapURL)
            urlRequest.cachePolicy = .returnCacheDataElseLoad
            webView.load(urlRequest)
            
        default:
            print("unexpected caocap type")
        }
        
    }
    
    @IBAction func moreBTN(_ sender: Any) {
        caocapCellDelegate?.moreBTNpressed(caocapKey: caocapKey)
    }
    
}
