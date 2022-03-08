//
//  MenuCell.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 08/01/1441 AH.
//  Copyright © 1441 Ficruty. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    
    weak var viewController: UIViewController?
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemlabel: UILabel!
    
    func configure(menuItem: MenuItem) {
        itemlabel.text = menuItem.label.rawValue.localized
        self.itemImage.image = menuItem.image
    }
}
