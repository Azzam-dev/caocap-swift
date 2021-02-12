//
//  blockCollectionViewCell.swift
//  caocap
//
//  Created by omar alzhrani on 12/09/1441 AH.
//  Copyright © 1441 Ficruty. All rights reserved.
//

import UIKit

class blockCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var blockIcon: UIImageView!
    
    func configureCell(icon: UIImage) {
        blockIcon.image = icon
    }
}
