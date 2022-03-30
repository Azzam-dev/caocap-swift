//
//  TitleBlockCell.swift
//  caocap
//
//  Created by CAOCAP inc on 27/08/1443 AH.
//  Copyright © 1443 Ficruty. All rights reserved.
//

import UIKit

class TitleBlockCell: BlankCell  {

    @IBOutlet weak var title: UILabel!
    override func configure(block: Block) {
        super.configure(block: block)
        title.text = block.styles["title"]?.value as? String
    }

}
