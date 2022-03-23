//
//  OpenedCaocapCell.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 14/08/1440 AH.
//  Copyright © 1440 Ficruty. All rights reserved.
//

import UIKit
import Firebase

/* Declare a Delegate Protocol method */
protocol OpenedCaocapCellDelegate: class {
    func shareBTNpressed(cell: OpenedCaocapCell, didTappedshow button: UIButton)
    func moreBTNpressed(cell: OpenedCaocapCell, didTappedshow button: UIButton)
    func roomBTNpressed(cell: OpenedCaocapCell, didTappedshow button: UIButton)
}

class OpenedCaocapCell: UICollectionViewCell {
    
    //Define delegate variable
    weak var delegate: OpenedCaocapCellDelegate?
    
    @IBOutlet weak var loadingIcon: UIImageView!
    @IBOutlet weak var theView: DesignableView!
    @IBOutlet weak var caocapName: UILabel!
    @IBOutlet weak var caocapIMG: DesignableImage!
    @IBOutlet weak var caocapIMGview: DesignableView!
    @IBOutlet weak var caocapDescription: UILabel!
    
    let colorArray = [#colorLiteral(red: 1, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.6391159892, blue: 0, alpha: 1), #colorLiteral(red: 0.3846503198, green: 1, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0.6544699669, blue: 1, alpha: 1), #colorLiteral(red: 0.8861780167, green: 0, blue: 1, alpha: 1), #colorLiteral(red: 0.9175696969, green: 0.9176983237, blue: 0.9175290465, alpha: 1)]
    
    var isReleased = Bool()
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UIView.appearance().semanticContentAttribute = .forceLeftToRight
        
    }
    
    var caocapKey = ""
    var caocapIsOrbited = false
    
    func configureCell(caocap: Caocap ,released: Bool) {
        caocapKey = caocap.key
        
        //this stops the image from duplicating
        self.caocapIMG.image = nil
        
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
        
        self.caocapName.text = caocap.name
        if case 0...5 = caocap.color {
            self.caocapIMGview.borderColor = colorArray[caocap.color]
        } else {
            self.caocapIMGview.borderColor = colorArray[3]
        }
        
        if let imageURL = URL(string: caocap.imageURL ?? "" ) {
            caocapIMG.af.setImage(withURL: imageURL)
        }
        
        loadCaocap(caocap)
    }
    
    
    private func loadCaocap(_ caocap: Caocap) {
        //TODO: - loadCaocap
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
            orbitsNum.text = "ADD TO ORBIT".localized
        } else {
            caocapIsOrbited = true
            orbitBTN_background.backgroundColor = #colorLiteral(red: 0, green: 0.6544699669, blue: 1, alpha: 1)
            DataService.instance.addAndReomveFromOrbit(caocapKey: caocapKey, remove: false)
            orbitsNum.text = "Added".localized
        }
    }
    
}
