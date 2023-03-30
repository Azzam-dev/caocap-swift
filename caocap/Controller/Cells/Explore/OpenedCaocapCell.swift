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
protocol OpenedCaocapCellDelegate: AnyObject {
    func loadCaocapVC(for cell: OpenedCaocapCell, with vc: CaocapVC, on view: UIView)
    func shareBTNpressed(cell: OpenedCaocapCell, didTappedShow button: UIButton)
    func moreBTNpressed(cell: OpenedCaocapCell, didTappedShow button: UIButton)
    func roomBTNpressed(cell: OpenedCaocapCell, didTappedShow button: UIButton)
}

class OpenedCaocapCell: UICollectionViewCell {
    
    //Define delegate variable
    weak var delegate: OpenedCaocapCellDelegate?
    
    @IBOutlet weak var loadingIcon: UIImageView!
    @IBOutlet weak var caocapView: DesignableView!
    var caocapVC: CaocapVC?
    
    
    @IBOutlet weak var caocapName: UILabel!
    @IBOutlet weak var caocapIMG: DesignableImage!
    @IBOutlet weak var caocapIMGview: DesignableView!
    @IBOutlet weak var caocapDescription: UILabel!
    
    let colorArray = [#colorLiteral(red: 1, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.6391159892, blue: 0, alpha: 1), #colorLiteral(red: 0.3846503198, green: 1, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0.6544699669, blue: 1, alpha: 1), #colorLiteral(red: 0.8861780167, green: 0, blue: 1, alpha: 1), #colorLiteral(red: 0.9175696969, green: 0.9176983237, blue: 0.9175290465, alpha: 1)]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UIView.appearance().semanticContentAttribute = .forceLeftToRight
        
    }
    
    var caocapKey = ""
    var caocapIsOrbited = false
    
    func configureCell(caocap: Caocap) {
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
        
        let storyboard = UIStoryboard(name: "Builder", bundle: nil)
        guard let caocapVC = storyboard.instantiateViewController(withIdentifier: "caocapVC") as? CaocapVC else { return }
        caocapVC.openedCaocap = caocap
        
        delegate?.loadCaocapVC(for: self, with: caocapVC, on: caocapView)
    }
    
    
    @IBAction func shareBTN(_ sender: Any) {
        let button = sender as! UIButton
        delegate?.shareBTNpressed(cell: self, didTappedShow: button)
    }
    
    
    @IBAction func roomBTN(_ sender: Any) {
        let button = sender as! UIButton
        delegate?.roomBTNpressed(cell: self, didTappedShow: button)
    }
    
    
    @IBAction func moreBTN(_ sender: Any) {
        let button = sender as! UIButton
        self.delegate?.moreBTNpressed(cell: self, didTappedShow: button)
    }
    
    let currentLang = Locale.current.languageCode

    @IBOutlet weak var orbitsNum: UILabel!
    @IBOutlet weak var orbitBTN_background: DesignableView!
    @IBOutlet weak var orbitBTN: UIButton!
    @IBAction func orbitBTN(_ sender: Any) {
        if caocapIsOrbited {
            caocapIsOrbited = false
            orbitBTN_background.backgroundColor = #colorLiteral(red: 0, green: 0.6544699669, blue: 1, alpha: 0)
            DataService.instance.addAndRemoveFromOrbit(caocapKey: caocapKey, remove: true)
            orbitsNum.text = "ADD TO ORBIT".localized
        } else {
            caocapIsOrbited = true
            orbitBTN_background.backgroundColor = #colorLiteral(red: 0, green: 0.6544699669, blue: 1, alpha: 1)
            DataService.instance.addAndRemoveFromOrbit(caocapKey: caocapKey, remove: false)
            orbitsNum.text = "Added".localized
        }
    }
    
}
