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
    func moreBTNpressed(caocapKey: String)
}

class CaocapCell: UICollectionViewCell {

    var caocapCellDelegate: CaocapCellDelegate?
    
    @IBOutlet weak var loadingIcon: UIImageView!
    @IBOutlet weak var theView: DesignableView!
    @IBOutlet weak var caocapName: UILabel!
    
    var caocapKey = ""
    
    func configure(caocap: Caocap ,released: Bool) {
        caocapKey = caocap.key
        
        loadingAnimation(image: loadingIcon)
        caocapName.text = caocap.name
        
        loadCaocap(caocap)
    }
    
    fileprivate func loadCaocap(_ caocap: Caocap) {
        //TODO: - loadCaocap
    }
    
    @IBAction func moreBTN(_ sender: Any) {
        caocapCellDelegate?.moreBTNpressed(caocapKey: caocapKey)
    }
    
}
