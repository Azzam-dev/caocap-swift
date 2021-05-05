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
    @IBOutlet weak var titleLabel: UILabel!
    
    
    var builder: Builder?
    func configure(builder: Builder) {
        self.builder = builder
        self.backgroundImage.image = builder.image
        self.titleLabel.text = builder.title
    }
}
