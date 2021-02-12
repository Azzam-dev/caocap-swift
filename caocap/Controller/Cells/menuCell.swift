//
//  menuCell.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 08/01/1441 AH.
//  Copyright © 1441 Ficruty. All rights reserved.
//

import UIKit

class menuCell: UITableViewCell {
    
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemlabel: UILabel!
    
    func configureCell(image: UIImage , label: String ) {
        self.itemImage.image = image
        self.itemlabel.text = label
        
    }
    
    
    
}
