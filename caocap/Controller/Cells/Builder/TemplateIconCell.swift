//
//  TemplateIconCell.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 05/05/2021.
//  Copyright © 2021 Ficruty. All rights reserved.
//

import UIKit

class TemplateIconCell: UICollectionViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    func configure(template: Template) {
        titleLabel.text = template.key
        
        if let iconURL = URL(string: template.iconURL ) {
            ImageService.getImage(withURL: iconURL) { returnedImage in
                self.icon.image = returnedImage?.withRenderingMode(.alwaysTemplate)
            }
        }
    }
    
}
