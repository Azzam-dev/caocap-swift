//
//  BuilderTypeCell.swift
//  caocap
//
//  Created by omar alzhrani on 06/07/1442 AH.
//  Copyright © 1442 Ficruty. All rights reserved.
//

import UIKit

class BuilderTypeCell: UICollectionViewCell {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    func configure(builder: Builder) {
        self.backgroundImage.image = builder.image
    }
    
}
