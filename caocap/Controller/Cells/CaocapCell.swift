//
//  CaocapCell.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 02/04/1440 AH.
//  Copyright © 1440 Ficruty. All rights reserved.
//

import UIKit


/* Declare a Delegate Protocol method */
protocol CaocapCellDelegate {
    func loadCaocapVC(with vc: CaocapVC, on view: UIView)
    func moreBTNpressed(key: String, name: String, isOrbiting: Bool)
    
}

class CaocapCell: UICollectionViewCell {

    var caocapCellDelegate: CaocapCellDelegate?
    
    @IBOutlet weak var loadingIcon: UIImageView!
    @IBOutlet weak var caocapView: DesignableView!
    
    @IBOutlet weak var caocapName: UILabel!
    
    var caocapKey = ""
    var isOrbiting = false
    
    func configure(caocap: Caocap) {
        caocapView.subviews.forEach({ $0.removeFromSuperview() })
        caocapKey = caocap.key
        
        loadingAnimation(image: loadingIcon)
        caocapName.text = caocap.name
        
        let storyboard = UIStoryboard(name: "Builder", bundle: nil)
        guard let caocapVC = storyboard.instantiateViewController(withIdentifier: "caocapVC") as? CaocapVC else { return }
        caocapVC.openedCaocap = caocap
        
        caocapCellDelegate?.loadCaocapVC(with: caocapVC, on: caocapView)
    }
    
    @IBAction func moreBTN(_ sender: Any) {
        caocapCellDelegate?.moreBTNpressed(key: caocapKey, name: caocapName.text ?? "", isOrbiting: isOrbiting)
    }
    
}
