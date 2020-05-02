//
//  designCollectionViewCell.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 01/05/2020.
//  Copyright © 2020 Ficruty. All rights reserved.
//

import UIKit

class designCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var theIcon: UIImageView!
    
    func configureCell(icon: UIImage) {
        theIcon.image = icon
    }
}
