//
//  CaocapIconCell.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 22/07/1440 AH.
//  Copyright © 1440 Ficruty. All rights reserved.
//

import UIKit

class CaocapIconCell: UICollectionViewCell {
    
    @IBOutlet weak var caocapIMG: DesignableImage!
    @IBOutlet weak var caocapIMGview: DesignableView!
    @IBOutlet weak var caocapnameLBL: UILabel!
    
    let colorArray = [#colorLiteral(red: 1, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.6391159892, blue: 0, alpha: 1), #colorLiteral(red: 0.3846503198, green: 1, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0.6544699669, blue: 1, alpha: 1), #colorLiteral(red: 0.8861780167, green: 0, blue: 1, alpha: 1), #colorLiteral(red: 0.9175696969, green: 0.9176983237, blue: 0.9175290465, alpha: 1)]
    
    func configureCell(caocapIMG image: UIImage, caocapColor color: Int, caocapName name: String) {
        
        self.caocapIMG.image = image
        if case 0...5 = color {
            self.caocapIMGview.borderColor = colorArray[color]
        } else {
            self.caocapIMGview.borderColor = colorArray[3]
        }
        self.caocapnameLBL.text = name
        
        
    }
}
