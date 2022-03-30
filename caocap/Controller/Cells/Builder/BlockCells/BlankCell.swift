//
//  BlankCell.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 30/04/2021.
//  Copyright © 2021 Ficruty. All rights reserved.
//

import UIKit

class BlankCell: UITableViewCell {

    @IBOutlet weak var selectedEffectView: UIView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectedEffectView.isHidden = !selected 
    }

    func configure(block: Block) {
        backgroundColor = UIColor(hex: block.styles["backgroundColor"]?.value as? String ?? "#000000ff")
    }
    
}
